create   proc [H7]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'H7', @to = @to