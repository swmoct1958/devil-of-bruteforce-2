@echo off
echo === C Hamiltonian Cycle Benchmark ===
echo.

echo [1] Compiling 5.c ...
gcc -Ofast 5.c -o 5.exe

echo.
echo [2] Running benchmarks...

for %%f in (g12.txt g13.txt g14.txt) do (
    echo ---- %%f ----
    5.exe %%f
)

echo.
echo Done.
