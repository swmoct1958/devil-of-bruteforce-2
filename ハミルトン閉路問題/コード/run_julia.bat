@echo off
echo === Julia Hamiltonian Cycle Benchmark ===
echo.

for %%f in (g12.txt g13.txt g14.txt) do (
    echo ---- %%f ----
    julia 12.jl %%f
)

echo.
echo Done.
