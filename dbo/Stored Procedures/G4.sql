create   proc [G4]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'G4', @to = @to