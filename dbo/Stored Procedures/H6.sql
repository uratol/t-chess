create   proc [H6]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'H6', @to = @to