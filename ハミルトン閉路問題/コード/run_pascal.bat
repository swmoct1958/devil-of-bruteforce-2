@echo off
echo === Pascal Hamiltonian Cycle Benchmark ===
echo.

echo [1] Compiling 9.pas ...
fpc -O3 9.pas

echo.
echo [2] Running benchmarks...

for %%f in (g12.txt g13.txt g14.txt) do (
    echo ---- %%f ----
    9.exe %%f
)

echo.
echo Done.
