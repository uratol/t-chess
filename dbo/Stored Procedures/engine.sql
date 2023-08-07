CREATE proc dbo.engine
 @arg nvarchar(64) = null
 as

 set nocount on

 declare 
   @use_for_ai bit
, @use_for_rules bit
, @message nvarchar(max) = ''


 select @use_for_ai = use_for_ai
	, @use_for_rules = use_for_rules
from engine.instance
where id = @arg

if @@rowcount = 0 begin
	if nullif(@arg, '') is not null
	set @message = 'Invalid engine name "' + @arg+ '"
'
end
else
	update engine.instance set 
		  default_for_ai = case 
							when id = @arg 
								then use_for_ai
							when @use_for_ai = 1
								then 0
								else default_for_ai
							end
		, default_for_rules = case 
							when id = @arg 
								then use_for_rules
							when @use_for_rules = 1
								then 0
								else default_for_rules
							end

select @message += string_agg(
						concat(id, ': '
							,' rules=', use_for_rules, ', '
							, 'ai=', use_for_ai, '; '
							,' default rules=', default_for_rules, ', '
							, 'default ai=', default_for_ai, '; ')
						, '
') within group(order by id)
from engine.instance

exec render.text @text = @message