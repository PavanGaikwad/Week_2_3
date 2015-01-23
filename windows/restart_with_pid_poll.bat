@echo off
REM starting a local ruby process
REM set START_COMMAND="ruby C:\Users\Administrator\Desktop\start_process.rb"
set PID=1
echo "STARTING PROCESS.."

REM START %START_COMMAND%

:loop

echo %PID%

REM check if the process is running.

tasklist /FI "PID eq %PID%" 2>NUL | find /I /N "%PID%">NUL


if "%ERRORLEVEL%" == "0" (echo "process is running."
) else (echo "process is not running. attempting to start."

for /F "usebackq tokens=2 delims==; " %%a in (
`wmic process call create "ruby C:\Users\Administrator\Desktop\start_process.rb" ^| find "ProcessId"`) do set PID=%%a

echo "started!"
)

sleep 10
goto loop