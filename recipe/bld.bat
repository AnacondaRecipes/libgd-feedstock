:: cmd
echo "Building %PKG_NAME%."

:: Isolate the build.
mkdir Build-%PKG_NAME%
cd Build-%PKG_NAME%
if errorlevel 1 exit /b 1

:: Generate the build files. See options: https://github.com/libgd/libgd/blob/master/CMakeLists.txt
echo "Generating the build files..."
cmake .. %CMAKE_ARGS% ^
      -G"Ninja" ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_C_FLAGS="/Dssize_t=SSIZE_T /DSSIZE_MAX=MAXSSIZE_T" ^
      -DWEBP_LIBRARY=%PREFIX%\Library\lib\libwebp.lib ^
      -DWEBP_INCLUDE_DIR=%PREFIX%\Library\include ^
      -DBUILD_SHARED_LIBS=ON ^
      -DBUILD_STATIC_LIBS=OFF ^
      -DENABLE_PNG=1 ^
      -DENABLE_JPEG=1 ^
      -DENABLE_TIFF=1 ^
      -DENABLE_FREETYPE=1 ^
      -DENABLE_WEBP=1 ^
      -DENABLE_GD_FORMATS=1 ^
      -DENABLE_FONTCONFIG=1 ^
      -DVERBOSE_MAKEFILE=1 ^
      -DENABLE_LIQ=0 ^
      -DENABLE_XPM=0 ^
      -DENABLE_AVIF=0 ^
      -DENABLE_HEIF=0 ^
      -DENABLE_RAQM=0 ^
      -DENABLE_ASAN=0 ^
      -DENABLE_ICONV=0 ^
      -DBUILD_TEST=0

if errorlevel 1 exit /b 1

:: Build.
echo "Building..."
ninja
if errorlevel 1 (
  type CMakeFiles\CMakeOutput.log
  exit /b 1
)

:: Perform tests.
@REM build tests fails with add_subdirectory given source "gdmatrix" which is not an existing directory.
@REM echo "Testing..."
@REM ctest -VV --output-on-failure
@REM if errorlevel 1 exit /b 1

:: Install.
echo "Installing..."
ninja install
if errorlevel 1 exit /b 1

:: Error free exit.
echo "Error free exit!"
exit 0
