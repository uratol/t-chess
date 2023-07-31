create   proc [D3]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'D3', @to = @to