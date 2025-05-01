# bridgerv3_godot
A game in which you have to skillfully try to get from one side to the other by building bridges without being cut off by your opponent.

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

# MatrixLogic: Code Explanation, the real algorithm behind all

## Overview

This algorithm is like a logic-based AI for a grid-based game. The game involves two players aiming to achieve specific objectives by creating connections across a grid. The code features algorithms for determining the winner, implementing AI moves using the Minimax algorithm, and utilizing Monte Carlo Tree Search (MCTS) for decision-making.

The code is written in Unity, leveraging Unity's built-in tools and C# features to simulate game logic, validate moves, and optimize AI behavior.

---

## Key Components and Their Functionality

### **1. Winner Detection**
The function `checkWinner(int[,] board, int player)` verifies if a player has achieved their objective.  
- **Player Objectives:**
  - Player 1 (Vertical): Connects the top row to the bottom row.
  - Player 2 (Horizontal): Connects the left column to the right column.
- **Algorithm:**  
  Depth-First Search (DFS) is used to explore potential paths recursively. The `DFS` method checks connected cells, ensuring the connection rules are satisfied.

```csharp
private bool DFS(int[,] board, int row, int col, int player, HashSet<(int, int)> visited)
```
- **Inputs:** Board state, current cell, player identifier, and visited cells to avoid loops.
- **Outputs:** Returns `true` if the player has successfully completed their connection.

---

### **2. Minimax Algorithm**
The `Minimax` method implements a game-tree search algorithm to evaluate moves:
- **Purpose:** Decide the optimal move for the AI by simulating potential outcomes.
- **Functionality:**
  - Evaluates board states by recursively simulating moves for both players.
  - Uses Alpha-Beta pruning to optimize performance by discarding unnecessary branches.

```csharp
public int Minimax(int[,] board, int depth, int alpha, int beta, bool maximizingPlayer)
```
- **Inputs:**  
  Board state, search depth, alpha and beta values for pruning, and the current player's turn.
- **Outputs:**  
  A score representing the desirability of the move.

---

### **3. Move Validation and Execution**
Helper functions ensure moves are valid and simulate board updates:
- `getValidMoves(int[,] board)` returns a list of unoccupied cells.
- `makeMove(int[,] board, (int, int) move, int player)` creates a new board state by applying a move.

---

### **4. Monte Carlo Tree Search (MCTS)**
The `MCTS` class implements a more advanced decision-making process for the AI:
- **Workflow:**
  1. **Selection:** Traverse the tree by selecting the best child node using Upper Confidence Bound (UCB).
  2. **Expansion:** Add a new child node by simulating an unexplored move.
  3. **Simulation:** Perform a random playthrough from the new state.
  4. **Backpropagation:** Update the win/loss statistics along the path.
- **Advantages:**  
  MCTS balances exploration (trying new moves) and exploitation (using moves with known good outcomes).

Key methods in MCTS include:
- `Select(MCTSNode node)`: Finds the most promising node for exploration.
- `Expand(MCTSNode node)`: Adds new nodes to the tree.
- `Simulate(MCTSNode node)`: Plays out a random game to estimate the outcome.
- `Backpropagate(MCTSNode node, int result)`: Updates nodes with simulation results.

---

## How It All Comes Together
1. **Game Initialization:** The game board is represented as a 2D integer array (`int[,]`), where:
   - `0`: Empty cell.
   - `1`: Player 1's move.
   - `2`: Player 2's move.
2. **Player Moves:**  
   Human players make moves, and the AI determines its moves using either Minimax or MCTS based on the configuration.
3. **Win Condition:**  
   After every move, the `checkWinner` function verifies if the game has been won.
4. **AI Decision-Making:**  
   - Minimax is used for deterministic decision-making.
   - MCTS is employed for probabilistic exploration and complex scenarios.

---

## Example Use Case
### **Checking a Winner**
```csharp
MatrixLogic logic = new MatrixLogic();
bool isPlayer1Winner = logic.checkWinner(board, 1);
```
- Evaluates if Player 1 has achieved their objective.

### **AI Move Using Minimax**
```csharp
(int, int) aiMove = logic.getBestMove(board, depth: 4);
board = logic.makeMove(board, aiMove, 2);
```
- Finds the best move for Player 2 using Minimax and updates the board.

### **AI Move Using MCTS**
```csharp
(int, int) aiMctsMove = await logic.getBestMCTSAsync(board, simulationsNumber: 1000);
board = logic.makeMove(board, aiMctsMove, 2);
```
- Executes an asynchronous MCTS-based decision-making process.

---

## Conclusion
The `MatrixLogic` class implements a robust framework for managing gameplay mechanics, winner detection, and AI decision-making in a turn-based strategy game. It demonstrates key programming principles such as recursion, graph traversal, and optimization techniques, making it well-suited for complex AI-driven games.
