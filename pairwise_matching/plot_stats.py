import matplotlib.pyplot as plt
import numpy as np
import pickle


STATS_FOLDER = "stats/"




with open(STATS_FOLDER+"MLP_V2_bert_large.pkl", 'rb') as f:
    stats = pickle.load(f)
f1_history = stats["f1_history"]
x = np.linspace(1, len(f1_history), len(f1_history))
y = np.zeros_like(x)
for i in range(len(f1_history)):
    y[i] = f1_history[i]
plt.plot(x, y, label='MLP SNN1 Bert large', color = "tomato")

with open(STATS_FOLDER+"MLP_V2_bert_base.pkl", 'rb') as f:
    stats = pickle.load(f)
f1_history = stats["f1_history"]
x = np.linspace(1, len(f1_history), len(f1_history))
y = np.zeros_like(x)
for i in range(len(f1_history)):
    y[i] = f1_history[i]
plt.plot(x, y, label='MLP SNN1 Bert base', color = "red")

del stats["f1_history"]
print(stats)




with open(STATS_FOLDER+"MLP_V1_bert_large.pkl", 'rb') as f:
    stats = pickle.load(f)
f1_history = stats["f1_history"]
x = np.linspace(1, len(f1_history), len(f1_history))
y = np.zeros_like(x)
for i in range(len(f1_history)):
    y[i] = f1_history[i]
plt.plot(x, y, label='MLP SNN2 Bert large', color = "lightblue")

with open(STATS_FOLDER+"MLP_V1_bert_base.pkl", 'rb') as f:
    stats = pickle.load(f)
f1_history = stats["f1_history"]
x = np.linspace(1, len(f1_history), len(f1_history))
y = np.zeros_like(x)
for i in range(len(f1_history)):
    y[i] = f1_history[i]
plt.plot(x, y, label='MLP SNN2 Bert base', color = "blue")

del stats["f1_history"]
print(stats)



with open(STATS_FOLDER+"AutoEncoder_V1_bert_large.pkl", 'rb') as f:
    stats = pickle.load(f)
f1_history = stats["f1_history"]
x = np.linspace(1, len(f1_history), len(f1_history))
y = np.zeros_like(x)
for i in range(len(f1_history)):
    y[i] = f1_history[i]
plt.plot(x, y, label='AutoEncoder Bert large', color = "lightgreen")

with open(STATS_FOLDER+"AutoEncoder_V1_bert_base.pkl", 'rb') as f:
    stats = pickle.load(f)
f1_history = stats["f1_history"]
x = np.linspace(1, len(f1_history), len(f1_history))
y = np.zeros_like(x)
for i in range(len(f1_history)):
    y[i] = f1_history[i]
plt.plot(x, y, label='AutoEncoder Bert base', color = "green")

del stats["f1_history"]
print(stats)



with open(STATS_FOLDER+"AutoEncoder_V2_bert_large.pkl", 'rb') as f:
    stats = pickle.load(f)
f1_history = stats["f1_history"]
x = np.linspace(1, len(f1_history), len(f1_history))
y = np.zeros_like(x)
for i in range(len(f1_history)):
    y[i] = f1_history[i]
plt.plot(x, y, label='AutoEncoder+MLP Bert large', color = "magenta")

with open(STATS_FOLDER+"AutoEncoder_V2_bert_base.pkl", 'rb') as f:
    stats = pickle.load(f)
f1_history = stats["f1_history"]
x = np.linspace(1, len(f1_history), len(f1_history))
y = np.zeros_like(x)
for i in range(len(f1_history)):
    y[i] = f1_history[i]
plt.plot(x, y, label='AutoEncoder+MLP Bert base', color = "darkviolet")

del stats["f1_history"]
print(stats)



# plt.title("F-Measure over the Epochs")
plt.xlabel('Epoch')
plt.ylabel('F-Measure')
plt.legend()
plt.savefig('plot.svg')