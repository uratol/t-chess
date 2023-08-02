create proc [engine].[legal_moves]
  @piece_id uniqueidentifier
, @moves nvarchar(max) out -- [{col: 1, row: 2}]
as

declare @proxy_sp_name sysname = engine.proxy_pricedure_name('legal_moves')

exec @proxy_sp_name @piece_id = @piece_id, @moves = @moves out