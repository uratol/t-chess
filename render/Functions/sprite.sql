CREATE function [render].[sprite]
( @text nvarchar(max)
, @ansi_code nvarchar(20)
)
 returns nvarchar(max)
as
begin

	return (render.esc(@ansi_code)) 
			+ @text 
			+ render.esc('0m')

end