@echo off
chcp 65001 > null
REM replace with your connection data
sqlcmd -S . -d t-chess -q "set xact_abort on; exec play;" -c ";"
