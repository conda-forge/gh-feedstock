:: Turn work folder into GOPATH
set GOPATH=%SRC_DR%
set PATH=%GOPATH%\bin:%PATH%

:: Change to directory with main.go
cd cmd\gh
if errorlevel 1 exit 1

:: Build
go build -v -o %PKG_NAME%.exe .
if errorlevel 1 exit 1

:: Install Binary into %SCRIPTS%
if not exist %SCRIPTS% mkdir %SCRIPTS%
if errorlevel 1 exit 1

mv %PKG_NAME% %SCRIPTS%\%PKG_NAME%
if errorlevel 1 exit 1
