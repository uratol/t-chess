# T-CHESS
![Screenshot in PowerShell](/screenshot.png)

Chess application written in pure T-SQL language. (Microsoft SQL Server 2022)

Visual Studio SSDT project.


The goal of the project is to demonstrate T-SQL features, in particular:
  - The native optimized tables and natively compiled objects
  - Tree traversal with minimax algorhytm and alpha-beta pruning
  - Code generation
  - Console rendering
  - TDD approach, based on the self-developed test framework

**Requirements:**

 - Windows 10 or above
 - Microsoft SQL Server 2022
 - Python and Stockfish (only if you use Stockfish engine)

**How to install:**


 - Open project in Visual Studio 2022 with SSDT plugin installed.
 - Double click the file "db.publish.xml"
 - Select the target server and database and click Publish.
 - Change the file "t-chess.bat" with your database credentials
 - Open the PowerShell console and set the font NSimSun or another supports unicode chess symbols.
 - Run "t-chess.bat"
 - You will see the starting chess board and a command promt. 

**How to install Stockfish engine:**

 - Instal Python environment https://www.python.org/downloads/. 
 - Install Stockfish engine https://stockfishchess.org/download/windows/
 - Run SQL:
	exec [deployment].[install_stockfish] @path_to_exe = '{your stockfish executable location}'

**How to play:**

 - Enter the square coordinates, the space and target square, i.e. "e2 e4" and press enter. 
 - Then press ";" to send command to SQL server.
	 - You can enter only the starting square, i.e. "e2". In this case you will se the allowable moves for the selected piece. 
 - Wait for computer to make its move and do it again.
 - Also the next command are available:
	- play
		- Starts new game when the current is finished. Redraw the game if it is inprogress.
	 - resign
		 - Finish the game
	 - export
		 - Get the current position as [FEN](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) notation (You can use https://lichess.org/editor)
	 - import *'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'*
		 - Set specified FEN position to the board
     - play new
		- Starts new game

 - To use stockfish engine put
	engine stockfish
 - To switch back to t-sql engine put
	engine native


**Limitations:**
 - en-passant is not supported
 - 50 moves rule is not supported
 - castling is supported, except the empty squre under attack and rook/king previous move checking.
