@echo off
echo === Kotlin Hamiltonian Cycle Benchmark ===
echo.

echo [1] Compiling 11.kt ...
call kotlinc.bat 11.kt -include-runtime -d 11.jar

echo.
echo [2] Running benchmarks...

for %%f in (g12.txt g13.txt g14.txt) do (
    echo ---- %%f ----
    java -jar 11.jar %%f
)

echo.
echo Done.
