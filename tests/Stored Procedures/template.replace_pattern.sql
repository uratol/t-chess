CREATE proc [tests].[template.replace_pattern]
as

	declare @source nvarchar(max) = 'foo /**T1
bar */ 
/**T2 blabla*/
x'

	select test.assert_equals('Patterns should be replaced to constant'
		, 'foo bas 
/**T2 blabla*/
x'
		, template.replace_pattern(@source, 'T1', 'bas')
		)

	select test.assert_equals('Patterns should be replaced to origin content with no braces'
	 , 'foo /**T1
bar */ 
 blabla
x'
	 , template.replace_pattern(@source, 'T2', '{origin}')
	 )