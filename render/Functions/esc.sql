CREATE function [render].[esc]
(@code nvarchar(20)
)
returns nvarchar(60)
as
begin

	return nchar(0x1b) + N'[' + @code

end