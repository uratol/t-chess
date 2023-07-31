@echo off
chcp 65001 > null
REM replace with your connection data
sqlcmd -S .\sql2022 -d chess -q "set xact_abort on; exec play;" -c ";"
