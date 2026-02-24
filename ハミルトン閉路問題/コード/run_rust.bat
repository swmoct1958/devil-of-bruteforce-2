@echo off
echo === Rust Hamiltonian Cycle Benchmark ===
echo.

echo [1] Compiling 7.rs ...
rustc -O 7.rs -o 7.exe

echo.
echo [2] Running benchmarks...

for %%f in (g12.txt g13.txt g14.txt) do (
    echo ---- %%f ----
    7.exe %%f
)

echo.
echo Done.
