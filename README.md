# T-CHESS
![Screenshot in PowerShell](/screenshot.png)

Chess application written in pure T-SQL language. (Microsoft SQL Server 2022)

Visual Studio SSDT project.


It's include the interaction(!), rendering (!!) and AI (soon).

**Requirements:**

 - Windows 10 or above
 - Microsoft SQL Server 2022

**How ti install:**


 - Open project in Visual Studio 2022 with SSDT plugin installed.
 - Double click the file "db.publish.xml"
 - Select the target server and database and click Publish.
 - Change the file "t-chess.but" with your database credentials
 - Open the PowerShell console and set the font NSimSun or another supports unicode chess symbols.
 - Run "t-chess.bat"
 - You will see the starting chess board and a command promt. 

**How to play:**

 - Enter the square coordinates, the space and target square, i.e. "e2 e4" and press enter. 
 - Then press ";" to send command to SQL server.
	 - You can enter only the starting square, i.e. "e2". In this case you will se the allowable moves for the selected piece. 
 - Wait for computer to make its move and do it again.
 - Also the next command are available:
	- play
		- Starts new game when the current is finished.
	 - resign
		 - Finish the game
	 - export
		 - Get the current position as [FEN](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) notation (You can use https://lichess.org/editor)
	 - import *'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'*
		 - Set specified FEN position to the board
