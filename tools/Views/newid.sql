create view [tools].[newid]
as
-- Workaround for error 443 : Invalid use of a side-effecting operator 'newid' within a function.
select newid() as [newid]