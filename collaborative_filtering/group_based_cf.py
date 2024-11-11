import progressbar as pb
import pandas as pd
import numpy as np
import os

from user_based_cf import Recommender
from user_based_cf import pearsonSimilarity

def getSimUser(df, user, k = 1, sim_th = 0.7):
    candidates = []
    for candidate in df['userId'].unique():
        sim = pearsonSimilarity(df, candidate, user)
        if sim < sim_th or candidate == user: continue

        if k == 1: return candidate

        candidates.append(candidate)
        if len(candidates) == k: return candidates
    
    return None

def getDissUser(df, user, k = 1, diss_th = -0.7):
    candidates = []
    for candidate in df['userId'].unique():
        sim = pearsonSimilarity(df, candidate, user)
        if sim > diss_th or candidate == user: continue

        if k == 1: return candidate

        candidates.append(candidate)
        if len(candidates) == k: return candidates
    
    return None

class GroupRecommender:

    def __init__(self):
        self.rec = Recommender()
        self.pred_cache = {}
        self.curr_items = None

    def getRecommendedItems(self, df, user):
        return self.rec.getRecommendedItems(df, user)
    
    def individualRecommendations(self, df, users):
        items = set()
        for user in users:
            u_items = self.rec.getRecommendedItems(df, user)
            items.update([x[0] for x in u_items])

        self.curr_items = items
        return items

    def itemToUserRating(self, df, item, user):
        if (user, item) in self.pred_cache: return self.pred_cache[(user, item)]
        rating = df[(df['userId'] == user) & (df['movieId'] == item)]['rating']

        if rating.empty:
            rating = self.rec.recursivePred(df, user, item)
        else:
            rating = rating.values[0]

        self.pred_cache[(user, item)] = rating
        return rating

    def itemsToUserScore(self, df, items, user):
        items_to_score = {}

        for item in items:
            items_to_score[item] = self.itemToUserRating(df, item, user)
        
        items_to_score = sorted(items_to_score.items(), key=lambda x: x[1])
        items_to_score = {key_value[0]: posizione for posizione, key_value in enumerate(items_to_score, 1)}
        
        return  items_to_score

    def topRatings(self, df, items, user, k=10):
        ratings = []
        
        for item in items:
            ratings.append(self.itemToUserRating(df, item, user))
        
        return sorted(ratings, reverse=True)[:k]

    def getAverageScore(self, df, item, users):
        sum = 0
        for user in users:
            rating = self.itemToUserRating(df, item, user)         
            sum += rating
                
        return sum / len(users)

    def groupAveragePred(self, df, users, k=10):
        item_to_pred = []
        if self.curr_items == None:
            items = self.individualRecommendations(df, users)
        else:
            items = self.curr_items

        for item in items:
            item_to_pred.append((item, self.getAverageScore(df, item, users)))

        return sorted(item_to_pred, key=lambda x: x[1], reverse=True)[:k]

    def getLeastScore(self, df, item, users):
        min_score = np.inf
        for user in users:
            rating = self.itemToUserRating(df, item, user)
                    
            if rating < min_score:
                min_score = rating
        
        return min_score

    def groupLeastMiseryPred(self, df, users, k=10):
        item_to_pred = []
        if self.curr_items == None:
            items = self.individualRecommendations(df, users)
        else:
            items = self.curr_items

        for item in items:        
            item_to_pred.append((item, self.getLeastScore(df, item, users)))

        return sorted(item_to_pred, key=lambda x: x[1], reverse=True)[:k]

    def getSatisfaction(self, df, group_items, user):
        den = np.sum(self.topRatings(df, self.curr_items, user, len(group_items)))
        
        num = 0
        for item in group_items:
            u_rating = self.itemToUserRating(df, item, user)
            num += u_rating
        
        return num / den

    def sequentialRecommendations(self, df, users, k=10):
        items = [x[0] for x in self.groupAveragePred(df, users, len(self.curr_items))]

        candidate_set = [items.pop(0)]

        for _ in range(k-1):
            min = np.inf
            best_item = None

            for item in items:
                satisfaction = 0
                tmp_set = candidate_set.copy()
                tmp_set.append(item)
                
                for i in range(0, len(users)):
                    for j in range(i+1, len(users)):
                        satisfaction += abs(self.getSatisfaction(df, tmp_set, users[i]) - self.getSatisfaction(df, tmp_set, users[j]))

                if satisfaction < min:
                    min = satisfaction
                    best_item = item

            items.remove(best_item)
            candidate_set.append(best_item)
        
        return candidate_set

    def customRecommendations(self, df, users, k=10):
        items = [x[0] for x in self.groupAveragePred(df, users, int(len(self.curr_items)/2))]
        
        users_scores = {}
        for user in users:
            for item in items:
                users_scores[(user, item)] = self.itemToUserRating(df, item, user)

        items_score = []
        for item in items:
            disagreement, global_rating = 1, 0

            for user in users:
                global_rating += users_scores[(user, item)]

            for i in range(0, len(users)):
                for j in range(i+1, len(users)):
                    disagreement += abs(users_scores[(users[i],item)] - users_scores[(users[j],item)])

            score = disagreement / global_rating
            items_score.append((item, score))

        return sorted(items_score, key=lambda x: x[1])[:k]

def main():
    df_path = os.path.join(os.getcwd(), 'group_recommendations', 'dataset', 'ratings.csv')
    df = pd.read_csv(df_path)
    
    users = [17]
    users += getSimUser(df, users[0], 3, 0.5)
    diss = getDissUser(df, users[0])
    users.append(diss)

    print(users)

    
    recc = GroupRecommender()
    headers = ['pred_fun',  'user1_sat', 'user2_sat', 'user3_sat', 'user4_sat', 'user5_sat']
    stats = pd.DataFrame(columns=headers)

    recommended_items = [x[0] for x in recc.groupAveragePred(df, users, 5)]
    new_row = ['groupAveragePred']
    for user in users:
        new_row.append(recc.getSatisfaction(df, recommended_items, user))
    stats.loc[len(stats)] = new_row

    recommended_items = [x[0] for x in recc.groupLeastMiseryPred(df, users, 5)]
    new_row = ['groupLeastMiseryPred']    
    for user in users:
        new_row.append(recc.getSatisfaction(df, recommended_items, user))
    stats.loc[len(stats)] = new_row

    recommended_items = [x[0] for x in recc.customRecommendations(df, users, 5)]
    new_row = ['customRecommendations']    
    for user in users:
        new_row.append(recc.getSatisfaction(df, recommended_items, user))
    stats.loc[len(stats)] = new_row

    recommended_items = recc.sequentialRecommendations(df, users, 5)
    new_row = ['sequentialRecommendations']    
    for user in users:
        new_row.append(recc.getSatisfaction(df, recommended_items, user))
    stats.loc[len(stats)] = new_row

    print(stats)
    stats.to_csv('group_sat.csv', index=False)

if __name__ == "__main__":
    main()