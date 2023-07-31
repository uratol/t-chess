CREATE function [test].[fail](
@message nvarchar(max)
)
returns int
as
begin
	return cast(left(concat('Unit-test fail: ', @message), 4000) as int)
end