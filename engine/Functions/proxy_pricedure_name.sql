CREATE function engine.proxy_pricedure_name(@action nvarchar(64))
returns nvarchar(128)
as
begin
	return concat(quotename(concat('engine_', chess.engine())), '.', quotename(@action))
end