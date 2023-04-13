# Ant Colony Optimization:
# È un algoritmo iterativo basato su N agenti. Ad ogni iterazione: 
#   - Ogni Ant costruisce una soluzione visitando i vertici del grafo
#   - La scelta di un vertice è basata su un approccio stocastico funzione della quantità di feromone 
#     rilasciata nelle passate esplorazioni
#   - Alla fine di una iterazione, il feromone viene aggiornato sulla base della qualità della soluzione 
#     trovata dalla popolazione di Ant in modo da privilegiare nelle successive esplorazioni i percorsi giudicati migliori.


"""
    Args:
        distances (2D numpy.array): Matrice quadrata delle distanze. Si assume np.inf nella diagonale.
        n_ants (int): Numero di agenti per ogni iterazione
        n_best (int): Numero di agenti con migliori performance che possono rilasciare feromone
        n_iteration (int): Numero iterazioni
        decay (float): Pheromone decay (es. 0.95). Il valore del feromone viene moltiplicato per il decay.
        alpha (int or float): valore dell'esponente per il feronome (default = 1)
        beta (int or float): valore dell'esponente per la distanza (default = 1)
"""
import numpy as np

def genPath(start, distances, alpha, beta):
    path = []
    pheromone = np.ones(distances.shape) / len(distances)
    visited = set()
    visited.add(start)
    prev = start

    for _ in range(len(distances) - 1):
        move = pickMove(pheromone[prev], distances[prev], visited, alpha, beta, distances)
        path.append((prev, move))
        prev = move
        visited.add(move)
    path.append((prev, start)) # going back to where we started    
    return path

def pickMove(pheromone, dist, visited, alpha, beta, distances):
    pheromone = np.copy(pheromone)
    pheromone[list(visited)] = 0

    row = pheromone ** alpha * (( 1.0 / dist) ** beta)    
    norm_row = row / row.sum()

    indexes = range(len(distances))
    move = np.random.choice(indexes, 1, p=norm_row)[0]
    return move

def gen_path_dist(path, distances):
    total_dist = 0
    for node in path:
        total_dist += distances[node]
    return total_dist

def AntAlgorithm(distances, n_ants, n_best, max_iter, decay, alpha=1, beta=1):
    global_best = None
    global_best_value = np.inf

    for _ in range(max_iter):
        # generating ants paths
        ants_paths = []
        for i in range(n_ants):
            path = genPath(0, distances, alpha, beta)
            ants_paths.append((path, gen_path_dist(path, distances)))
