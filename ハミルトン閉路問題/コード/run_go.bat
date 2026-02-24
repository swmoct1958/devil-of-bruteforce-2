@echo off
echo === Go Hamiltonian Cycle Benchmark ===
echo.

echo [1] Compiling 10.go ...
go build -o 10.exe 10.go

echo.
echo [2] Running benchmarks...

for %%f in (g12.txt g13.txt g14.txt) do (
    echo ---- %%f ----
    10.exe %%f
)

echo.
echo Done.
