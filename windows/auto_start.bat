@echo off
:loop
START /WAIT ruby start_process.rb
goto loop