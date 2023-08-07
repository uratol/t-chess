CREATE function [engine_stockfish].[ai_make_move@python_script]
( @fen nvarchar(4000)
, @stockfish_path nvarchar(4000) -- D:\\Distrib\\stockfish\\stockfish.exe
, @movetime_millis int
)
returns nvarchar(max)
as
begin
	
return concat(
'
import chess
import chess.engine

def get_best_move(fen_position):
    board = chess.Board(fen_position)

    # Set up a Stockfish chess engine
    stockfish_path = "', replace(@stockfish_path, '\', '\\') ,'"
    stockfish = chess.engine.SimpleEngine.popen_uci(stockfish_path)

    # Get the best move using Stockfish
    result = stockfish.play(board, chess.engine.Limit(time=1.0)) 
    best_move = result.move

    # Get the evaluation of the position after the best move
    board.push(best_move)
    evaluation = 1 # stockfish.analyse(board, chess.engine.Limit(time=1.0))["score"].white().score(mate_score=1000000)

    stockfish.quit()  # Close the Stockfish engine

    return best_move.uci(), evaluation

# Call the function with the provided FEN position
best_move, evaluation = get_best_move("', @fen,'")
print(f''{{"best_move": "{best_move}", "evaluation":{evaluation} }}'')
'
	
	)	

end