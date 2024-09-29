@echo off
SET ADF=spt-boink.adf

cranker-0.66_win.exe -f myprogram -o Boink

del %ADF%
xdftool %ADF% create
xdftool %ADF% format "Boink"
xdftool %ADF% boot install boot1x
xdftool %ADF% makedir s
xdftool %ADF% write startup-sequence s
xdftool %ADF% write Boink
xdftool %ADF% write spt-boink.nfo

REM Copy to local emu directory for easy testing

REM copy %ADF% D:\Emu\Amiga\03_Demos\
REM copy Boink D:\Emu\Amiga\X_Transfer\Boink

exit
