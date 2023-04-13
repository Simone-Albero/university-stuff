# Particle Swarm Optimization:
# L'algoritmo tenta iterativamente di trovare la soluzione ottima di un problema partendo da una popolazione di soluzioni candidate
#  dette "particelle". Le particelle si muovono nello spazio delle soluzione in accordo con la loro posizione e velocità. 
# Il movimento di ogni particella è influenzato dal proprio ottimo locale ma anche dall'ottimo globale trovatop dalle altre particelle.
# Al termine dell'algoritmo lo sciame si sposta verso le soluzione ottima.

# Il PSO è un algoritmo metaeuristico in quanto fa poche ipotesi riguardo il problema di partenza e può cercare la soluzione ottima in 
# un vasto spazio delle soluzioni. Tuttavia l'agoritmo non garantisce la convergenza, dunque potrebbe non trovare la soluzione ottima.
import numpy as np

# alpine n.2
def objective(particle):
    x1 = particle[0]
    x2 = particle[1]
    return -(np.sqrt(np.abs(x1)) * np.sin(x1) * np.sqrt(np.abs(x2)) * np.sin(x2))

def swarmInit(lower_bound, upper_bound, swarm_size):
    swarm_positions = np.random.rand(swarm_size, 2) #couple (x,y) position 
    return lower_bound + swarm_positions * (upper_bound - lower_bound)


def PSOAlgorithm(swarm, objective, max_iter, cognitive_costant, social_costant, inertia, lower_bound, upper_bound):
    particles_positions = swarm.copy()
    particles_bests_position = swarm.copy()
    particles_best_vals = np.empty()

    ub_velocity = np.abs(upper_bound - lower_bound)
    lb_velocity = -ub_velocity

    for i in range(len(swarm)):
        particles_best_vals[i] = objective(swarm[i])
    
    particles_vals = particles_best_vals.copy()
    
    min_index = np.argmin(particles_best_vals)
    global_best_val = particles_best_vals[min_index].copy()
    global_best_position = particles_bests_position[min_index].copy()

    #random swarm velocities
    particle_velocities = lb_velocity + np.random.rand(len(swarm), 2) * (ub_velocity - lb_velocity)

    for _ in range(max_iter):
        # generating random value about local and global best
        pb_rands = np.random.uniform(size=(len(swarm), 2)) 
        gb_rands = np.random.uniform(size=(len(swarm), 2)) 

        # updating swarm velocities
        particle_velocities = inertia * particle_velocities + cognitive_costant * pb_rands * (particles_bests_position - particles_positions) \
            + social_costant * gb_rands * (global_best_position - particles_positions)
        
        # updating positions
        particles_positions = particles_positions + particle_velocities

        # moving out of bound particles to the edge
        lower_mask = particles_positions < lower_bound
        upper_mask = particles_positions > upper_bound
        particles_positions = particles_positions * (~np.logical_or(lower_mask, upper_mask)) + lower_bound * lower_mask + upper_bound * upper_mask

        # updating current particles evaluetions
        for i in range(len(swarm)):
            particles_vals[i] = objective(particles_positions[i])

        #updating particles locals bests
        lb_mask = particles_vals < particles_best_vals
        particles_bests_position[lb_mask, :] = particles_positions[lb_mask, :].copy()
        particles_best_vals[lb_mask] = particles_vals[lb_mask]

        # compare swarm best position with global best position
        min_index = np.argmin(particles_best_vals)
        if(global_best_val < particles_best_vals[min_index]):
            global_best_val = particles_best_vals[min_index].copy()
            global_best_position = particles_bests_position[min_index].copy()

    return [global_best_position, global_best_val]


if __name__ == "__main__":
    lb = [0,0]
    ub = [10,10]
    swarm = swarmInit(lb, ub , 20)
    PSOAlgorithm(swarm, lambda particle: objective(particle), 100, 0.5, 0.5, 0.4, lb, ub) 
    
    
