@echo off
echo === C++ Hamiltonian Cycle Benchmark ===

echo.
echo [1] Compiling 4.cpp ...
g++ -O3 -march=native -std=c++20 4.cpp -o exe
if errorlevel 1 (
    echo Compile error.
    exit /b 1
)

echo.
echo [2] Running benchmarks...

for %%F in (g10.txt g11.txt g12.txt g13.txt g14.txt) do (
    echo ---- %%F ----
    exe %%F
)

echo.
echo Done.
