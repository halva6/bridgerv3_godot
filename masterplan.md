# the masterplan for bridges_v3
A simple collection of ideas of the programmer of this game, has no great public significance.
Since English is not my native language, I apologize for any mistakes, but this is only a sheet of the overview, nothing big.

---

### steps
-  ~~**camera movement**~~
	-   zoom in and out
	-   move left, right, up, down   

- ~~**game board**~~
  - Tilemap
	- bridges (green, red, temp)
	- piers (green, red)
	- walls (horizontal, vertical)
  - clickable tiles
	- returns the type and the position of the tile
  - the tiles are normal game objects
	- the tilemap is only for placing the tiles in a pleasant way
	- when a gameobject is placed, this happens regardless of the tilemap
- ~~**player management**~~
  - which player starts the game
  - singeplayer (computer vs human)
	- switch player between human and computer
	- starts the computer algorithm after human's turn
  - mulitplayer (human vs human)
	- which player is next
	- switch player after turn
  - checks game over (who wins?)
  - handles the matrix:
	- -1 ≙ not placeable space (e.g. walls/corners)
	- 0 ≙ placeable space
	- 1 ≙ green pier
	- 2 ≙ red pier
	- 3 ≙ green bridge
	- 4 ≙ red bridge
	- 5 ≙ temp bridge
- ~~**placement of the temporary bridges**~~
  - click on a pier
  - placing on all posible directions (in total 4) a temp bridge
	- check if it is compliant (is the pier from the current player?) → validation via a matrix
	- placing the temp bridge game object
	- update the matrix
  - if the current player clicks on a other pier
	- delete temp bridges (and delete all temp bridges in matrix)
	- replace temp bridges
	- update matrix
- ~~**placement of the bridges**~~
  - if current player clicks on temp bridges
  - delete temp bridges
  - set bridge on the same position
  - update matrix
  - finish the turn → switch the players
  - check win
- ~~**the computer algorithm for the singleplayer**~~
  - gets the current state of the matrix as input
  - returns the desired position of his bridges
  - works parallel → the human can't do anithing and loading animation
  - should work fast (max. 10 sek)
  - with human at eye level → multiple computer levels (beginner, advanced, pro, ultra pro)
- **resets moves**
  - moves are stored in a stack
	- saves the position from the last set bridge
  - click on reset button
	- pops the last entry/position from the stack
	- removes on this position the game object
---
- **UI and decorations**
  - start ui
	- choice between multiplayer and single player
	  - choice the begining color
	  - computer difficulty is adjustable
	- start button
	  - starts the game
	- setting button
	  - music setting (master volume, music and soud fx)
	  - other settings (game board size)
	  - impressum
	- fancy background
	- how often every player won
  - pause ui
	- resume
	- restart
	- back to the menu
	- settings (music and co)
  - game ui
	- shows the current player
	- thinking of the computer
	- how many turns did every player
  - win ui
	- who won?
	- time
	- number of turns
	- restart
	- back to menu
  - audio
	- music (chill music):
	  - in game music 
	  - start screen music
	- sound
	  - every click on something (button, tile, bridge)
	  - placing of a bridge
  - game decoration
	- in game background 
	  - somthing like water and animated
	  - some pixel art islands from the top
	- animated bridge placement
	- win animation (confetti)


---

## goal
A finish game. 
The goal of the game is to try to create a continuous bridge connection from one side to the other. The goal is to prevent the other player from connecting his two sides with bridges first.

---






*game obejct ≙ scene ≙ node obejct*
