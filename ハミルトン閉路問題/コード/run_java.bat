@echo off
echo === Java Hamiltonian Cycle Benchmark ===
echo.

echo [1] Compiling six.java ...
javac six.java

echo.
echo [2] Running benchmarks...

for %%f in (g12.txt g13.txt g14.txt) do (
    echo ---- %%f ----
    java six %%f
)

echo.
echo Done.
