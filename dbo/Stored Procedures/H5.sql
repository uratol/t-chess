create   proc [H5]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'H5', @to = @to