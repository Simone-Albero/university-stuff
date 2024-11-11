import progressbar as pb
import pandas as pd
import numpy as np
import os

from group_based_cf import GroupRecommender
from group_based_cf import getSimUser
from group_based_cf import getDissUser


from user_based_cf import Recommender


class SequentialRecommender:
    def __init__(self):
        self.rec = GroupRecommender()

    def overallSatisfaction(self, df, iters_items, user):
        stats = [self.rec.getSatisfaction(df, iter_items, user) for iter_items in iters_items]
        return np.mean(stats)

    def groupSatisfaction(self, df, group_items, users):
        stats = [self.rec.getSatisfaction(df, group_items, user) for user in users]
        return np.mean(stats)

    def overallGroupSatisfaction(self, df, iters_items, users):
        stats = [self.overallSatisfaction(df, iters_items, user) for user in users]
        return np.mean(stats)
        
    def groupDisagreements(self, df, iters_items, users):
        o_sats = [self.overallSatisfaction(df, iters_items, user) for user in users]

        max_sat, min_sat = np.max(o_sats), np.min(o_sats)
        return max_sat - min_sat

    def hybridAggregationScore(self, df, item, users, alpha):
        return (1 - alpha) * self.rec.getAverageScore(df, item, users) + alpha * self.rec.getLeastScore(df, item, users)

    def sequentialHybridAggregation(self, df, users, num_iters = 3, k = 10):
        iters_items = []
        alpha = 0
        df_chunks = np.array_split(df, num_iters)
        curr_chunks = pd.DataFrame()

        for i in range(num_iters):
            curr_chunks = pd.concat([curr_chunks, df_chunks[i]])

            items = self.rec.individualRecommendations(curr_chunks, users)

            iter_scores = [(item, self. hybridAggregationScore(curr_chunks, item, users, alpha)) for item in items]
            iters_items.append([x[0] for x in sorted(iter_scores, key=lambda x: x[1], reverse=True)[:k]])
            print(iters_items)
            print(self.groupSatisfaction(curr_chunks, iters_items[i], users))
            print(self.groupDisagreements(curr_chunks, iters_items, users))

            alpha = self.groupDisagreements(df, iters_items, users)

    def customAggregationScores(self, df, items, users, alphas):
        aggregation_scores = []
        for item in items:
            global_rank = 0
            for user in users:
                global_rank += alphas[user] * self.rec.itemToUserRating(df, item, user)

            aggregation_scores.append((item, global_rank))

        return aggregation_scores

    def sequentialCustomAggregation(self, df, users, num_iters = 3, k = 10):
        iters_items = []
        df_chunks = np.array_split(df, num_iters)
        curr_chunks = pd.DataFrame()

        alphas = {}
        for user in users:
            alphas[user] = 1

        for i in range(num_iters):
            curr_chunks = pd.concat([curr_chunks, df_chunks[i]])

            items = self.rec.individualRecommendations(curr_chunks, users)
            iter_scores = self.customAggregationScores(curr_chunks, items, users, alphas)
            
            iters_items.append([x[0] for x in sorted(iter_scores, key=lambda x: x[1], reverse=True)[:k]])
            print(iters_items)
            print(self.groupSatisfaction(curr_chunks, iters_items[i], users))
            print(self.groupDisagreements(curr_chunks, iters_items, users))

            for user in users:
                alphas[user] = 1 / self.overallSatisfaction(df, iters_items, user)


def main():
    df_path = os.path.join(os.getcwd(), 'group_recommendations', 'dataset', 'ratings.csv')
    df = pd.read_csv(df_path)

    users = [1]
    users += getSimUser(df, users[0], 3, 0.5)
    users.append(getDissUser(df, users[0]))

    recc = SequentialRecommender()
    recc.sequentialCustomAggregation(df, users, 4, 4)

if __name__ == "__main__":
    main()