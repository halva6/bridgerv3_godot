# bridgerv3_godot
A game in which you have to skillfully try to get from one side to the other by building bridges without being cut off by your opponent.

## Rough summary of the game
The game is a board game. The board is square-shaped. The goal of the game is to build a connection of bridges from one side to the opposite side. You do this by linking your so-called "piers" together until you have a complete, long connection. The piers are placed side by side and stacked in a square formation. The opponent’s piers are slightly offset—they must try to connect their own two sides of the square. Therefore, you must skillfully block the opponent and prevent them from linking their two sides while simultaneously working to connect your own.

Depending on preference, there is a wide selection of different board sizes, allowing for quicker games as well.

The game features a multiplayer mode where you can play against friends, for example, and a single-player mode where you play against the computer. The computer's algorithm is based on the MCTS (Monte Carlo Tree Search) algorithm. The current issue is that the computer still requires a fairly long computation time to play at a level comparable to a human. The difficulty can be adjusted via the MCTS time setting, which determines how long the computer should calculate—the longer it computes, the more precise the results. In other words, the more time the computer has to calculate, the harder it becomes for the human player.

Since the calculation depends on time, results may vary from device to device and user to user. Some devices can perform more calculations in the same time, for example, due to having a better CPU. The number of calculations can be viewed in the game. At the bottom of the screen, you’ll see "Visits," which indicates how many possibilities the computer has calculated. The higher the number, the more challenging it becomes for the human player.

## How the Gameplay Works  
The game board consists of piers. Each player, Red and Blue, has 42 piers each.  
![Approach2](https://github.com/user-attachments/assets/8e3091a1-dd24-409b-acaa-de1cf77c1ad8)  

Green controls the two outermost columns, while Red owns the two outermost rows of the matrix.  
The goal for Green is to connect the top and bottom columns in a straight line using bridges. Red, on the other hand, aims to create a continuous connection between the two outermost rows.  

Bridges can only be placed on the white cells. These bridges are connected to the piers, forming a pathway. When one player's connection is complete, that player wins.  

In theory, it might look something like this (note: some early considerations for AI are included):  
![Rectangle](https://github.com/user-attachments/assets/86819cc5-8b2b-4b95-a01d-c8f11f4fab12)  

Now, let's discuss the game mechanics.  
The challenge lies in developing an algorithm to detect whether a player has won and another algorithm capable of playing on par with a human (while also being time-efficient). Below is a messy compilation of all considerations in a single image:  
![Approach](https://github.com/user-attachments/assets/7f9d8bdf-07e2-4e1d-a9b7-e6f3a793bba7)  

This can also be represented as a matrix:  
```
- 1 - 1 - 1 - 1 - 1 - 
2 0 2 0 2 0 2 0 2 0 2 
- 1 0 1 0 1 0 1 0 1 - 
2 0 2 0 2 0 2 0 2 0 2 
- 1 0 1 0 1 0 1 0 1 - 
2 0 2 0 2 0 2 0 2 0 2 
- 1 0 1 0 1 0 1 0 1 - 
2 0 2 0 2 0 2 0 2 0 2 
- 1 2 1 0 1 0 1 0 1 - 
2 0 2 0 2 0 2 0 2 0 2 
- 1 0 1 0 1 0 1 0 1 - 
2 2 2 2 2 0 2 0 2 0 2 
- 1 - 1 - 1 - 1 - 1 - 
```  

0 = empty cell / unoccupied field / space for bridges  
1 = Green player  
2 = Red player / AI  
– = theoretically never occupied  

---

# Monte Carlo Tree Search (MCTS)

This repository contains an implementation of the Monte Carlo Tree Search (MCTS) algorithm in GDScript for use in the Godot Engine. The MCTS algorithm is used to determine optimal moves for an AI player in a game where two players take turns placing pieces on a grid. This implementation is tailored for games where players aim to connect opposite sides of the board, but the algorithm can be adapted to other scenarios.

---

## Introduction to MCTS
Monte Carlo Tree Search is a heuristic search algorithm used in decision-making processes, particularly in games. It is suitable for games with large state spaces, as it uses random simulations to evaluate moves instead of exhaustively searching all possibilities.

The four key steps in MCTS are:
1. **Selection**: Traversing the tree to find the most promising node.
2. **Expansion**: Expanding the tree by adding a child node to the selected node.
3. **Simulation**: Running random playouts from the new node to evaluate potential outcomes.
4. **Backpropagation**: Propagating the results of the simulation back up the tree to update the nodes' statistics.

---

## How the Algorithm Works

### 1. Selection
The algorithm begins at the root node and iteratively selects child nodes based on the Upper Confidence Bounds for Trees (UCT) formula:

```gdscript
var uct_score = child.wins / float(child.visits) + sqrt(2 * log_N_parent / float(child.visits))
```
The child node with the highest UCT score is selected. Nodes with fewer visits are prioritized until they are sufficiently explored.

### 2. Expansion

If the selected node has untried moves, one of these moves is used to create a new child node. This represents adding a possible game state to the tree.

```gdscript
func expand() -> Knot:
    var move: Vector2 = untried_moves.pop_back()
    var new_state: Array = []
    for row: Array in state:
        new_state.append(row.duplicate(true))
    new_state[move.x][move.y] = next_player()
    var child_node: Knot = Knot.new(new_state, game_board_size, self, next_player())
    children.append(child_node)
    return child_node
```

### 3. Simulation

From the newly expanded node, a random game is simulated until the game ends. The result of the game (win, loss, or draw) is recorded.

```gdscript
func simulate_random_game(state: Array, player: int) -> int:
    var current_player: int = player
    while true:
        var moves: Array[Vector2] = []
        for r in range(game_board_size):
            for c in range(game_board_size):
                if state[r][c] == 0:
                    moves.append(Vector2(r, c))
        if moves.is_empty():
            break
        elif check_win(state, PLAYER_HUMAN):
            return -1
        elif check_win(state, PLAYER_AI):
            return 1
        var move: Vector2 = moves[randi() % moves.size()]
        state[move.x][move.y] = current_player
        current_player = PLAYER_HUMAN if current_player == PLAYER_AI else PLAYER_AI
    if check_win(state, PLAYER_AI):
        return 1
    elif check_win(state, PLAYER_HUMAN):
        return -1
    return 0
```

### 4. Backpropagation

The outcome of the simulation is backpropagated to update the statistics (wins and visits) of the nodes involved.

```gdscript
func backpropagate(node: Knot, result: int) -> void:
    while node != null:
        node.visits += 1
        if (node.player == PLAYER_AI and result == 1) or (node.player == PLAYER_HUMAN and result == -1):
            node.wins += 1
        node = node.parent
```

---
## Mathematical Foundations of MCTS

The key mathematical concepts underpinning MCTS involve probabilities, logarithms, and confidence bounds.

### Upper Confidence Bound (UCB1)

The UCT formula used in the selection phase is derived from the **Upper Confidence Bound 1 (UCB1)** algorithm. UCB1 is designed to solve the **multi-armed bandit problem**, where a player must decide between exploiting known rewards and exploring new options to maximize overall gain.

#### Formula:

$UCT(v) = \frac{w_i}{n_i} + C \cdot \sqrt{\frac{\ln N}{n_i}}$

Where:

* $w_i$: Number of wins for child node $i$.
* $n_i$: Number of visits to child node $i$.
* $N$: Total number of visits to the parent node.
* $C$: Exploration constant (controls exploration vs. exploitation balance, typically $\sqrt{2}$).

#### Key Components:

1. **Exploitation ($\frac{w_i}{n_i}$)**:
   Focuses on nodes with a high success rate.
2. **Exploration ($C \cdot \sqrt{\frac{\ln N}{n_i}}$)**:
   Encourages visiting less-explored nodes to gather more information.

This balance ensures that the algorithm does not get stuck in local optima and remains flexible to discover better solutions.

### Random Simulations

During the simulation phase, random playouts are used to evaluate the potential of a node. The randomness introduces an element of statistical sampling, which provides approximate evaluations of moves without needing exhaustive computation.

#### Law of Large Numbers

As the number of simulations increases, the outcomes converge to the true probabilities of winning from a given state. This ensures that MCTS becomes increasingly accurate over time.

### Logarithms in Exploration

The use of $\ln N$ (natural logarithm of the total number of visits) ensures diminishing returns for revisiting already well-explored nodes. This logarithmic scaling naturally reduces exploration of suboptimal nodes as they are visited more often.

---

## Advantages and Limitations of MCTS

### Advantages

* **Scalability**: MCTS can handle large state spaces without exhaustively exploring all possibilities.
* **Flexibility**: Works well with different types of games and environments.
* **Asymptotic Accuracy**: Given enough time, MCTS converges to the optimal strategy.

### Limitations

* **Computational Cost**: Simulations can be expensive, especially in games with complex rules.
* **Early Game Uncertainty**: Limited initial exploration may lead to suboptimal moves early in the game.
* **Heuristics Dependence**: Performance relies on efficient heuristics or rules for simulations.

---

## Code Overview

The implementation is encapsulated in the `Knots` class. The main components are:

* `Knot`: Represents a node in the MCTS tree. Contains the current game state, children, and statistics (wins and visits).
* `monte_carlo_tree_search`: The main function driving the MCTS algorithm.
* `simulate_random_game`: Performs random playouts from a given state.
* `backpropagate`: Updates the tree with results from the simulations.
* `check_win`: Determines if a player has won the game.
