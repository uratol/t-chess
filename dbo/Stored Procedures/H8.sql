create   proc [H8]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'H8', @to = @to