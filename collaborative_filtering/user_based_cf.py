import progressbar as pb
import numpy as np
import pandas as pd
import random
import time
import os
import timeit

def getCoRatedItems(df, user_x, user_y):
    ratings_x = df[df['userId'] == user_x]
    ratings_y = df[df['userId'] == user_y]

    return pd.merge(ratings_x, ratings_y, on='movieId', how='inner')

def pearsonSimilarity(df, user_x, user_y):
    corated_items = getCoRatedItems(df, user_x, user_y)
    if corated_items.empty: return 0

    co_ratings_x, co_ratings_y = corated_items['rating_x'], corated_items['rating_y']
    ratings_x, ratings_y = df[df['userId'] == user_x]['rating'], df[df['userId'] == user_y]['rating']
    mean_x, mean_y = np.mean(ratings_x), np.mean(ratings_y)

    den = np.sqrt(np.sum(np.square(co_ratings_x - mean_x))) * np.sqrt(np.sum(np.square(co_ratings_y - mean_y)))
    
    if den == 0: return 0

    PENALITY_TH = 10
    penality_factor = 1 if corated_items.shape[0] >= PENALITY_TH else corated_items.shape[0] / PENALITY_TH
    return penality_factor * np.sum((co_ratings_x - mean_x) * (co_ratings_y - mean_y)) / den

def cosineSimilarity(df, user_x, user_y):
    corated_items = getCoRatedItems(df, user_x, user_y)
    if corated_items.empty: return 0

    co_ratings_x, co_ratings_y = corated_items['rating_x'], corated_items['rating_y']
 
    num = np.dot(co_ratings_x, co_ratings_y)
    den = np.linalg.norm(co_ratings_x) * np.linalg.norm(co_ratings_y)

    if den == 0: return 0
    return num / den

def jaccardSimilarity(df, user_x, user_y):
    corated_items = getCoRatedItems(df, user_x, user_y)
    if corated_items.empty: return 0

    ratings_x, ratings_y = set(df[df['userId'] == user_x]['rating']), set(df[df['userId'] == user_y]['rating'])

    intersection = corated_items.shape[0]
    union = len(ratings_x.union(ratings_y)) 

    if union == 0: return 0
    return intersection / union

def euclideanDistance(df, user_x, user_y):
    corated_items = getCoRatedItems(df, user_x, user_y)
    if corated_items.empty: return 0

    co_ratings_x, co_ratings_y = corated_items['rating_x'], corated_items['rating_y']

    return 1 / (1 + np.sqrt(np.sum(np.square(co_ratings_x - co_ratings_y))))

def manhattanDistance(df, user_x, user_y):
    corated_items = getCoRatedItems(df, user_x, user_y)
    if corated_items.empty: return 0

    co_ratings_x, co_ratings_y = corated_items['rating_x'], corated_items['rating_y']

    return 1 / (1 + np.sum(np.abs(co_ratings_x - co_ratings_y)))

class Recommender:

    def __init__(self, sim_fun = pearsonSimilarity, k1 = 20, k2 = 5, lmb = 0.2, lev_th = 1, sim_th = 0.3):
        self.sim_cache = {}

        # parameter
        self.sim_fun = sim_fun
        self.k1 = k1
        self.k2 = k2
        self.lmb = lmb
        self.lev_th = lev_th
        self.sim_th = sim_th

    def getNeighbors(self, df, user, item = None, blacklist = [], k = 10):
        if user in self.sim_cache:
            candidates = self.sim_cache[user]
        else:
            candidates = pd.DataFrame({'userId': df['userId'].unique()})
            candidates = candidates[(candidates['userId'] != user)]
            candidates['sim'] = candidates['userId'].apply(lambda candidate: self.sim_fun(df, user, candidate))
            self.sim_cache[user] = candidates
        
        candidates = candidates[(~candidates['userId'].isin(blacklist))]
        if item != None: candidates = candidates[candidates['userId'].apply(lambda candidate: ((df['userId'] == candidate) & (df['movieId'] == item)).any())]

        candidates = candidates.sort_values(by='sim', key=lambda x: abs(x), ascending=False)

        return candidates.to_records(index=False).tolist()[:k]

    def customGetNeighbors(self, df, user, item, blacklist = []):
        neighbors = []

        item_based_neighbors = self.getNeighbors(df, user, item, blacklist, self.k1)
        neighbors.extend(item_based_neighbors)

        sim_based_neighbors = self.getNeighbors(df, user, None, blacklist, self.k2)
        neighbors.extend(sim_based_neighbors)
        
        return neighbors

    def neighborFactor(self, df, neighbor, sim, item):
        rating = df[(df['userId'] == neighbor) & (df['movieId'] == item)]['rating'].values[0]
        mean = df[df['userId'] == neighbor]['rating'].mean()

        return sim * (rating - mean)

    def basePred(self, df, user, item):
        neighbors = self.getNeighbors(df, user, item, [], self.k1)
        mean_u = np.mean(df[df['userId'] == user]['rating'])
        num, den = 0, 0

        neighbors = pd.DataFrame(neighbors, columns=['neighbor', 'sim'])
        if neighbors.empty: return 0
        neighbors['factor_n'] = neighbors.apply(lambda row: self.neighborFactor(df, row.iloc[0], row.iloc[1], item), axis=1)

        num = np.sum(neighbors['factor_n'])
        den = np.sum(np.abs(neighbors['sim']))

        if den == 0: return 0
        return mean_u + num / den
    
    def recursivePred(self, df, user, item, lev = 0, blacklist = []):
        if lev >= self.lev_th: return self.basePred(df, user, item)

        neighbors = self.customGetNeighbors(df, user, item, blacklist)
        mean_u = np.mean(df[df['userId'] == user]['rating'])
        num, den = 0, 0

        neighbors = [n for n in neighbors if abs(n[1]) >= self.sim_th]
        
        for neighbor, sim in neighbors:
            ratings_n = df[(df['userId'] == neighbor) & (df['movieId'] == item)]['rating']
            mean_n = np.mean(df[df['userId'] == neighbor]['rating'])

            if not ratings_n.empty:
                num += sim * (ratings_n.values[0] - mean_n)
                den += abs(sim)
            else:
                tmp = blacklist.copy()
                tmp.append(user)
                num += self.lmb * sim * (self.recursivePred(df, neighbor, item, lev+1, tmp) - mean_n)
                den += self.lmb * abs(sim)            

        if den == 0 or neighbors == []: return 0

        return mean_u + num / den
    
    def getRecommendedItems(self, df, user, k = 10, mean_shift = 0.5, max_neighbors = 20):
        u_items = set(df[df['userId'] == user]['movieId'])
        neighbors = self.getNeighbors(df, user, None, [], max_neighbors)
        
        mean = np.mean(df[df['userId'] == user]['rating'])
        pred_th = 4.5 if mean >= 4 else mean + mean_shift

        n_items = set()
        for neighbor, _ in neighbors:
            mean_n = np.mean(df[df['userId'] == user]['rating'])
            rate_th =  4.5 if mean_n >= 4 else mean_n + mean_shift
            items = set(df[(df['userId'] == neighbor) & (df['rating'] >= rate_th)]['movieId'])
            n_items.update(items)

        not_yet_rated = list(n_items - u_items)  
        random.shuffle(not_yet_rated)

        item_to_pred = []

        with pb.ProgressBar(max_value = k if pred_th != 0 else len(not_yet_rated)) as bar:
            for item in not_yet_rated:
                pred = self.recursivePred(df, user, item)

                if pred >= pred_th:
                    item_to_pred.append((item, pred))
                    bar.next()
                if pred_th != 0 and len(item_to_pred) == k:
                    break

        return sorted(item_to_pred, key=lambda x: x[1], reverse=True)[:k]

def getRandomSample(df, itemsNum = 10, usersNum = 10, seed = 1):
    np.random.seed(seed)
    samples = []
    users = np.random.choice(df['userId'].unique(), usersNum, replace=False)

    for user in users:
        uItems = list(df[df['userId'] == user]['movieId'])
        items = np.random.choice(uItems, itemsNum, replace=False)

        sample = [(user, item) for item in items]
        samples += sample
    
    return samples

def evaluatePred(df, sample, recc):
    err = []
    tot_time = 0

    with pb.ProgressBar(max_value=len(sample)) as bar:
        start_time = time.time()
        for user, item in sample:
            real_pred = df[(df['userId'] == user) & (df['movieId'] == item)]['rating'].values[0]
            generated_pred = recc.recursivePred(df, user, item)
            err.append(abs(generated_pred - real_pred))
            bar.next()
            
        end_time = time.time()
        tot_time += end_time - start_time

    return np.mean(err), np.std(err), np.max(err), tot_time/len(sample)

def test():
    df_path = os.path.join(os.getcwd(), 'group_recommendations', 'dataset', 'ratings.csv')
    df = pd.read_csv(df_path)

    sample = getRandomSample(df, 5, 10)

    headers = ['pred_fun', 'sim_fun', 'k1', 'k2', 'lmb', 'lev_th', 'mean_err', 'std_err', 'max_err', 'mean_time']

    # stats = pd.DataFrame(columns=headers) # Evaluating k1 on basePred
    # for k1 in np.arange(5, 35, 5):
    #     recc = Recommender(pearsonSimilarity, k1, None, None, 0)
    #     mean_err, std_err, max_err, mean_time = evaluatePred(df, sample, recc)
    #     new_row = ['basePred', 'pearsonSimilarity', k1, np.nan, np.nan, np.nan, mean_err, std_err, max_err, mean_time]
    #     stats.loc[len(stats)] = new_row

    # print(stats)
    # stats.to_csv('k1.csv', index=False)
    
    stats = pd.DataFrame(columns=headers) # Evaluating similarities on basePred
    K1, K2, LMB, LEV_TH = 20, 5, 0.1, 1
    for sim_fun in [pearsonSimilarity, cosineSimilarity, jaccardSimilarity, euclideanDistance, manhattanDistance]:
        recc = Recommender(sim_fun, K1, K2, LMB, LEV_TH) 
        mean_err, std_err, max_err, mean_time = evaluatePred(df, sample, recc)
        new_row = ['basePred', sim_fun.__name__, K1, np.nan, np.nan, np.nan, mean_err, std_err, max_err, mean_time]
        stats.loc[len(stats)] = new_row

    print(stats)
    stats.to_csv('similarities.csv', index=False)

    
    # stats = pd.DataFrame(columns=headers) # Evaluating k2 on recursivePred
    # K1, LMB, LEV_TH = 20, 0.2, 1
    # for k2 in np.arange(5, 25, 5):
    #     recc = Recommender(pearsonSimilarity, K1, k2, LMB, LEV_TH)
    #     mean_err, std_err, max_err, mean_time = evaluatePred(df, sample, recc)
    #     new_row = ['recursivePred', 'pearsonSimilarity', K1, k2, LMB, LEV_TH, mean_err, std_err, max_err, mean_time]
    #     stats.loc[len(stats)] = new_row

    # print(stats)
    # stats.to_csv('k2.csv', index=False)

    
    # stats = pd.DataFrame(columns=headers) # Evaluating lmb on recursivePred
    # K1, K2, LEV_TH = 20, 5, 1
    # for lmb in np.arange(0.1, 1.1, 0.1):
    #     recc = Recommender(pearsonSimilarity, K1, K2, lmb, LEV_TH)
    #     mean_err, std_err, max_err, mean_time = evaluatePred(df, sample, recc)
    #     new_row = ['recursivePred', 'pearsonSimilarity', K1, K2, lmb, LEV_TH, mean_err, std_err, max_err, mean_time]
    #     stats.loc[len(stats)] = new_row

    # print(stats)
    # stats.to_csv('lmb.csv', index=False)

    
    # stats = pd.DataFrame(columns=headers) # Evaluating lev_th on recursivePred
    # K1, K2, LMB= 20, 5, 0.1
    # for lev_th in np.arange(0, 3, 1):
    #     recc = Recommender(pearsonSimilarity, K1, K2, LMB, lev_th)
    #     mean_err, std_err, max_err, mean_time = evaluatePred(df, sample, recc)
    #     new_row = ['recursivePred', 'pearsonSimilarity', K1, K2, LMB, lev_th, mean_err, std_err, max_err, mean_time]
    #     stats.loc[len(stats)] = new_row

    # print(stats)
    # stats.to_csv('lev_th.csv', index=False)

    
def main():
    df_path = os.path.join(os.getcwd(), 'group_recommendations', 'dataset', 'ratings.csv')
    df = pd.read_csv(df_path)

    recc = Recommender()
    
    #users = recc.getNeighbors(df, 1)
    #users = [x[0] for x in users]
    #print(users)
    
    #for user in users:
    #    users += [x[0] for x in recc.getNeighbors(df, user)]
    #    print(len(recc.sim_cache))

    #print(recc.getRecommendedItems(df, 3))
    print(timeit.timeit(lambda: recc.getRecommendedItems(df, 3), number=1))
    

if __name__ == "__main__":
    main()
