CREATE function render.enabled()
returns bit
as
begin
	return isnull(cast(session_context(N'render') as bit), 1)
end