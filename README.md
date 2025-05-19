# T-Chess

> **Chess entirely in T-SQL — a playground for advanced SQL Server features.**

## Why this project exists

T-Chess started as a personal experiment to see how far Microsoft SQL Server 2022 can be pushed beyond its usual OLTP/analytics duties.  The result is a fully-playable chess engine, UI and test suite — all written in T-SQL.  Use it as a code lab to explore:

* In-Memory OLTP (memory-optimised tables & natively-compiled procedures)&#x20;
* AI search techniques (minimax + ?-? pruning) implemented in a set-based language
* Dynamic SQL code generation&#x20;
* Console rendering directly from the database&#x20;
* Test-Driven Development in T-SQL with a custom T-TEST framework

## Demo

![Screenshot in PowerShell](/screenshot.png)

## Quick Start

### Prerequisites

| Tool                   | Version                   | Notes                                                         |
| ---------------------- | ------------------------- | ------------------------------------------------------------- |
| Windows                | 10 or newer               | Tested on Windows 11                                          |
| **SQL Server**         | 2022 Developer/Enterprise | In-Memory OLTP feature must be enabled                        |
| **Visual Studio 2022** | + **SSDT** workload       | For one-click publish                                         |
| PowerShell             | 5.1+                      | Windows Terminal recommended                                  |
| Python 3.x             | *(optional)*              | Required only for Stockfish integration                       |
| Stockfish 16+          | *(optional)*              | Download [here](https://stockfishchess.org/download/windows/) |

### 1. Clone & publish the database

```bash
git clone https://github.com/uratol/t-chess.git
cd t-chess
```

*Open* **t-chess.sln** (or double-click **db.publish.xml**) and hit **Publish**.
The script will create the database, populate lookup tables and run the full test suite (you should see **All tests?passed**).

### 2. Configure the launcher

Edit **t-chess.bat** and provide your credentials:

```bat
set SERVER=localhost
set DB=t_chess
set USER=sa
set PASS=Pa55w0rd!
```

### 3. Run

1. Open **PowerShell** (Windows Terminal).
2. Choose a font that supports Unicode chess symbols (e.g. **NSimSun**, **DejaVu Sans Mono**).
3. Execute:

```powershell
./t-chess.bat
```

## Playing the game

| Example             | Meaning                                                                                             |
| ------------------- | --------------------------------------------------------------------------------------------------- |
| `e2 e4;`            | Move the piece from **e2** to **e4**                                                                |
| `e2;`               | Highlight all legal moves for the piece on **e2**                                                   |
| `play;`             | Start a new game (or redraw if in progress)                                                         |
| `resign;`           | Resign the current game                                                                             |
| `export;`           | Print the current position in [FEN](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) |
| `import 'FEN';`     | Load a custom FEN                                                                                   |
| `engine stockfish;` | Switch to the Stockfish engine                                                                      |
| `engine native;`    | Switch back to the built-in T-SQL engine                                                            |

> **Important:** each command must end with a new line with semicolon (`;`) so it is sent to SQL Server. i.e. you put the command then Enter then ";".  This is how "sqlcmd" works. 

## Stockfish integration (optional)

```sql
EXEC deployment.install_stockfish
     @path_to_exe = N'C:\Engines\stockfish\stockfish-windows-x64.exe';
```

## Limitations & to-dos

* En-passant capture is not yet supported.
* 3-fold repetition and 50-move draw rules are not enforced.
* Castling currently ignores "through-check" and previous-move legality.
* The console UI is Windows-only (depends on code page 437 / 65001 fonts).

Pull requests that address any of the above are more than welcome ??.

## Testing

All unit tests live in the **test** schema.  Run the full suite with:

```sql
EXEC test.run;
```

The framework demonstrates:

* Transaction wrapping for automatic rollback
* Sentinel-style exception testing
* Self-reporting results directly in SSMS / Visual Studio output

## Project layout

```
chess/            -- core tables & views
engine_native/    -- minimax + ?-? pruning implementation
engine_json/      -- slower, JSON-based search for comparison
engine_stockfish/ -- UCI bridge to an external Stockfish process
render/           -- console output helpers
tests/            -- unit tests (stored procs)
deployment/       -- install helpers & data seeds
```

## Contributing

Whether you spot a typo or want to implement en-passant, feel free to
open an Issue or a Pull Request.  Please follow the existing coding
style (`.editorconfig`) and include tests for new behaviour.

## License

Distributed under the **MIT** — see [`LICENSE.txt`](LICENSE.txt) for details.
