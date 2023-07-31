create   proc [H2]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'H2', @to = @to