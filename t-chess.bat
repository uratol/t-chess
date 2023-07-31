@echo off
chcp 65001 > null
sqlcmd -S .\sql2022 -d chess -q "set xact_abort on; exec play;" -c ";"
