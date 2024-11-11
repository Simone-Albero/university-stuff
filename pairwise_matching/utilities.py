from typing import List, Dict
import pandas as pd
from torch.utils.data import Dataset
import torch
    
class CustomDataset(Dataset):
    def __init__(self, df: pd.DataFrame, features_cols: List[str], target_col: str, embed_dict: Dict, multiplier = 1, normalize = False):
        self.embed_dict = embed_dict
        self.features = df[features_cols].values
        self.targets = df[target_col].values
        self.df = df
        self.multiplier = multiplier
        self.normalize = normalize
    
    def __len__(self):
        return len(self.df)
    
    def __getitem__(self, idx):
        id1 = self.features[idx, 0]
        id2 = self.features[idx, 1]
        
        output1 = torch.tensor(self.embed_dict[id1], dtype=torch.float32)
        output2 = torch.tensor(self.embed_dict[id2], dtype=torch.float32)

        if self.normalize:
            output1 /= torch.norm(output1)
            output2 /= torch.norm(output2)

        output1 *= self.multiplier
        output2 *= self.multiplier

        y = torch.tensor(self.targets[idx], dtype=torch.float32)

        return output1, output2, y
    

def trainLoop(model, optimizer, criterion, train_loader):
    model.train()
    total_loss = 0
    for inputs1, inputs2, labels in train_loader:
        optimizer.zero_grad()
        outputs = model(inputs1, inputs2)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
            
        total_loss += loss.item()

    total_loss /= len(train_loader)
    return total_loss

def testLoop(model, criterion, test_loader, pred_function, stats: dict = None):
    test_loss = 0.0
    correct = 0
    total = 0
    tp = 0
    fp = 0
    tn = 0
    fn = 0

    model.eval()

    with torch.no_grad():
        for inputs1, inputs2, labels in test_loader:
            outputs = model(inputs1, inputs2)
            loss = criterion(outputs, labels)
            test_loss += loss.item() * inputs1.size(0)

            predicted = pred_function(outputs)

            total += labels.size(0)
            correct += (predicted == labels).sum().item()
            tp += ((predicted == 1) & (labels == 1)).sum().item()
            fp += ((predicted == 1) & (labels == 0)).sum().item()
            tn += ((predicted == 0) & (labels == 0)).sum().item()
            fn += ((predicted == 0) & (labels == 1)).sum().item()

    avg_loss = test_loss / total
    accuracy = correct / total

    precision = tp / (tp + fp + 1e-12)
    recall = tp / (tp + fn + 1e-12)
    f1_score = 2 * (precision * recall) / (precision + recall + 1e-12)

    print(f'Test Loss: {avg_loss:.4f}, Test Accuracy: {accuracy:.4f}')
    print(f'Precision: {precision:.4f}, Recall: {recall:.4f}, F1-score: {f1_score:.4f}')
    print(f'TP: {tp}, FP: {fp}, TN: {tn}, FN: {fn}')

    if (stats is not None):
        if "f1_history" not in stats:
            stats["f1_history"] = []
        stats["f1_history"].append(f1_score)

        if ("f1_best" not in stats) or (stats["f1_best"] < f1_score):
            stats["f1_best"] = f1_score
            stats["precision_best"] = precision
            stats["recall_best"] = recall
            stats["tp_best"] = tp
            stats["fp_best"] = fp
            stats["tn_best"] = tn
            stats["fn_best"] = fn

import os
import pickle
def save_stats(name: str, stats: dict):
    directory = "stats/"
    if not os.path.exists(directory):
        os.mkdir(directory)
    with open(directory + name + '.pkl', 'wb') as f:
        pickle.dump(stats, f)