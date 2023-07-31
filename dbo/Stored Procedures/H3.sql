create   proc [H3]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'H3', @to = @to