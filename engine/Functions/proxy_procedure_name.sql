CREATE function [engine].[proxy_procedure_name](@action nvarchar(64))
returns nvarchar(128)
as
begin
	declare @is_ai bit = iif(@action = 'ai_make_move', 1, 0)
		, @engine varchar(16)

	select @engine = id
	from engine.instance
	where (@is_ai = 1 and default_for_ai = 1)
		or (@is_ai = 0 and default_for_rules = 1)

	return concat(quotename(concat('engine_', @engine)), '.', quotename(@action))
end