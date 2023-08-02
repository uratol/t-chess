create proc render.enable
as
exec sys.sp_set_session_context @key = N'render'
							  , @value = null