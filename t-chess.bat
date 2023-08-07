@echo off
chcp 65001 > null
REM replace with your connection data
sqlcmd -S .\sandbox -d chess -q "set xact_abort on; exec play;" -c ";"
