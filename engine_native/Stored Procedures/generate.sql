CREATE proc [engine_native].[generate]
as
exec template.generate_object @template_object_name = '[template].[engine_native.minimax]'
							, @object_full_name = '[engine_native].[minimax]'
							, @is_native_compiled = 0
							, @max_recursion_depth = 4