# PowerGrid-DE-Analisys
This repository provides implementations of Differential Evolution (DE) algorithms tailored for power grid contingency analysis. Included are DE implementations, case studies focused on power systems, and evaluations that underscore DE's effectiveness in optimizing resilience and tackling critical contingencies within power grids.

# obs

 os arquivos cfb.jl e de.jl são dependentes. O arquivo de.jl depende das funções definidas no arquivo cfb.jl para realizar cálculos de betweenness centrality e executar a evolução diferencial. As funções em cfb.jl são essenciais para a leitura do grafo, cálculo da centralidade e execução das mutações e cruzamentos necessários na evolução diferencial.

 # Differential Evolution (DE)

Differential Evolution (DE) is a heuristic optimization method used to solve continuous and multidimensional optimization problems. DE is an evolutionary search technique based on populations and inspired by natural evolutionary processes. Here is a detailed explanation of its functioning:

## Basic Principles

### Initial Population
DE starts with an initial population of candidate vectors (solutions), which are randomly generated within the specified bounds for each problem variable.

### Mutation
For each candidate vector (called target vector), a mutant vector is created. This is done by combining three distinct vectors from the population, randomly selected:

\[ \mathbf{v}_i(t) = \mathbf{x}_{r1}(t) + F \cdot (\mathbf{x}_{r2}(t) - \mathbf{x}_{r3}(t)) \]

where \(\mathbf{v}_i(t)\) is the mutant vector, \(\mathbf{x}_{r1}(t)\), \(\mathbf{x}_{r2}(t)\), and \(\mathbf{x}_{r3}(t)\) are distinct random vectors from the population, and \(F\) is a scaling factor that controls the amplification of differences.

### Recombination (Crossover)
Each target vector is combined with its mutant vector to form a trial vector (or offspring vector). The recombination is controlled by a crossover parameter \(CR\):

\[ u_{i,j}(t) = \begin{cases} 
v_{i,j}(t) & \text{if rand(0,1)} \leq CR \text{ or } j = j_{\text{rand}} \\
x_{i,j}(t) & \text{otherwise}
\end{cases} \]

where \(u_{i,j}(t)\) is the trial vector, \(v_{i,j}(t)\) is the mutant vector, \(x_{i,j}(t)\) is the target vector, and \(j_{\text{rand}}\) is a random index ensuring that at least one component comes from the mutant vector.

### Selection
DE uses a binary tournament selection scheme. The trial vector is compared with the target vector, and the vector with the better fitness (lower objective function value) is selected for the next generation:

\[ \mathbf{x}_i(t+1) = \begin{cases} 
\mathbf{u}_i(t) & \text{if } f(\mathbf{u}_i(t)) \leq f(\mathbf{x}_i(t)) \\
\mathbf{x}_i(t) & \text{otherwise}
\end{cases} \]

## Parameters of Differential Evolution
- **Population Size (NP):** Number of vectors in the population.
- **Scaling Factor (F):** Typically between 0 and 1, controlling the amplification of vector differences during mutation.
- **Crossover Rate (CR):** Between 0 and 1, determining the probability of components from the mutant vector being included in the trial vector.

## Advantages and Disadvantages
**Advantages:**
- Simple implementation.
- Ability to escape local minima due to the global nature of the search.
- Good performance on nonlinear and multimodal problems.

**Disadvantages:**
- Sensitivity to the choice of parameters \(F\) and \(CR\).
- Can be computationally expensive for high-dimensional problems due to the population size needed for good coverage of the search space.

## Applications
DE is used in various fields, including mathematical function optimization, engineering, neural networks, system control, and many other areas where optimization is needed.

## Example
Consider a simple optimization problem to minimize the Rastrigin function:

\[ f(\mathbf{x}) = 10n + \sum_{i=1}^n \left[ x_i^2 - 10 \cos(2\pi x_i) \right] \]

**Steps:**
1. **Initialization:** Randomly generate a population of vectors within the limits, e.g., \([-5.12, 5.12]\) for each \(x_i\).
2. **Mutation:** Create mutant vectors by combining three random vectors from the population.
3. **Recombination:** Form trial vectors by combining target and mutant vectors.
4. **Selection:** Choose the best vectors for the next generation based on the objective function.

Repeat these steps until a stopping criterion is met, such as a maximum number of generations or satisfactory convergence in the objective function.
