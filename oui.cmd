@echo off

set OUI_PATH=c:\utils
set OUI_URL_DL=https://gitlab.com/wireshark/wireshark/raw/master/manuf

:START
REM ===========================
REM before you start, make sure that the offline oui.txt data file is available.
if EXIST %OUI_PATH%\oui.txt goto SYNTAX
echo ****** Warning ******
echo %OUI_PATH%\oui.txt does not exist, downloading source data
echo *********************
goto UPDATE
REM ===========================
REM Check Syntax
REM ===========================
:SYNTAX
if /i _%1 == _ goto HELP
if /i _%1 == _help goto HELP
if /i _%1 == _-help goto HELP
if /i _%1 == _--help goto HELP
if /i _%1 == _/help goto HELP
if /i _%1 == _? goto HELP
if /i _%1 == _-? goto HELP
if /i _%1 == _/? goto HELP
if /i _%1 == _--? goto HELP
if /i _%1 == _UPDATE goto UPDATE
:OKOK
REM =============================
REM OK TO PROCEED
REM =============================
REM =============================
REM remove all delimeters
REM =============================
echo %1 | tr -d ":\-.\r\n\ " | tr '[:lower:]' '[:upper:]' | cut -c 1-6 > %temp%\ouioui.tmp
REM =============================
REM check for both OUI or Vendor matches
REM =============================
type %OUI_PATH%\oui.txt | grep -i -f %temp%\ouioui.tmp
goto ENDEND
:HELP
echo OUI Utility
echo  Syntax:
echo      OUI NN:NN:NN      Request information on a specific OUI
echo                        Input is NOT case sensitive
echo                        Acceptable delimiters include ":", "." or "-"
echo                        Address delimeters can be in any position (at the 2 or 4 byte boundaries for instance)
echo                        Address delimeters are optional, and can be partially specified
echo                        So any of 005000, 00:50:00, 0050.00, 00-50-00 and just 50 are acceptable inputs
echo     OUI Manufacturer   List all OUI's associated with a manufacturer
echo                        Partial company names are acceptable
echo                        Input is NOT case sensitive
echo     OUI update         Update the OUI listing
echo                        If there is no oui.txt, the update happens and any lookup is ignored
echo                        This update comes from Wireshark's consolidated vendor list
echo                        This list is compiled from a number of sources, and is considered a superset of the IEEE list
echo                        This is downloaded from:
echo                              https://gitlab.com/wireshark/wireshark/raw/master/manuf
echo                        The IEEE listing can be obtained from: 
echo                              http://standards-oui.ieee.org/oui/oui.csv
echo                              http://standards-oui.ieee.org/cid/cid.csv
echo                              http://standards-oui.ieee.org/iab/iab.csv
echo                              http://standards-oui.ieee.org/oui28/mam.csv
echo                              http://standards-oui.ieee.org/oui36/oui36.csv
goto ENDEND
:UPDATE
REM =============================
REM collect the updated file, then remove the colon delimeters
REM =============================
rem
md %OUI_PATH%
echo OUI:Vendor:VendorString| tr : \t > %OUI_PATH%\oui.txt
curl --insecure %OUI_URL_DL% | tr -d : | grep -v "^#" | grep -v "^$" >> %OUI_PATH%\oui.txt
goto ENDEND
:ENDEND
REM ==============================
REM Cleanup temp variable files
REM ==============================
del /q %temp%\ouioui.tmp 2>nul:
