create proc render.disable
as
exec sys.sp_set_session_context @key = N'render'
							  , @value = 0