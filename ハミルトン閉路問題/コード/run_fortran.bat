@echo off
echo === Fortran Hamiltonian Cycle Benchmark ===
echo.

echo [1] Compiling 8.f90 ...
gfortran -O2 8.f90 -o 8.exe

echo.
echo [2] Running benchmarks...

for %%f in (g12.txt g13.txt g14.txt) do (
    echo ---- %%f ----
    8.exe %%f
)

echo.
echo Done.
