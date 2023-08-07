CREATE proc [deployment].[install_stockfish]
 @path_to_exe nvarchar(max)
as

--exec sys.sp_configure 'show advanced options', 1;

--reconfigure;

--exec sys.sp_configure 'xp_cmdshell', 1;

--reconfigure with override;

merge engine.instance as t
	using (
		select *
		from (values
				('stockfish', 0, 1, 0, 0
				, json_object('path': @path_to_exe)	
				)
			) as v(id, use_for_rules, use_for_ai, default_for_rules, default_for_ai, settings)
	) as s on s.id = t.id
	when not matched then
		insert(id, use_for_rules, use_for_ai, default_for_rules, default_for_ai, settings)
		values(s.id, s.use_for_rules, s.use_for_ai, s.default_for_rules, s.default_for_ai, s.settings)
	when matched then
		update set settings = s.settings
;
		
		
exec sys.sp_configure 
     @configname = 'show advanced options'
    ,@configvalue = 1

reconfigure with override;
 
exec sys.sp_configure 
     @configname = 'external scripts enabled'
    ,@configvalue = 1            

reconfigure with override;