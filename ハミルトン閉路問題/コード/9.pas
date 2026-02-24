{$mode objfpc}
program nine;

uses
  SysUtils, DateUtils;

var
  adj: array of array of Integer;
  visited: array of Boolean;
  counter: Int64;
  n: Integer;

procedure dfs(v: Integer);
var
  i: Integer;
begin
  visited[v] := True;
  Inc(counter);

  for i := 0 to n - 1 do
    if (adj[v][i] = 1) and (not visited[i]) then
      dfs(i);

  visited[v] := False;
end;

var
  filename: string;
  f: TextFile;
  line: string;
  i, j: Integer;
  startTime, endTime: TDateTime;
  ms: Double;
  values: array of Integer;

begin
  if ParamCount < 1 then
  begin
    Writeln('Usage: 9 <graphfile>');
    Halt;
  end;

  filename := ParamStr(1);

  AssignFile(f, filename);
  Reset(f);

  { 1. 行数を数える }
  n := 0;
  while not EOF(f) do
  begin
    Readln(f, line);
    Inc(n);
  end;
  Reset(f);

  { 2. 配列確保 }
  SetLength(adj, n, n);
  SetLength(visited, n);
  SetLength(values, n);

  { 3. 行単位で読み込む }
  for i := 0 to n - 1 do
  begin
    Readln(f, line);
    { 行を整数にパース }
    for j := 0 to n - 1 do
      values[j] := 0;

    { Pascal は split が弱いので、StrToInt + Scan }
    for j := 0 to n - 1 do
      adj[i][j] := StrToInt(Trim(Copy(line, 1 + j * 2, 2)));
  end;

  CloseFile(f);

  { 4. DFS 実行 }
  counter := 0;
  for i := 0 to n - 1 do visited[i] := False;

  startTime := Now;
  dfs(0);
  endTime := Now;

  ms := MilliSecondsBetween(endTime, startTime);

  { 5. 出力 }
  Writeln('file = ', filename);
  Writeln('N = ', n);
  Writeln('counter = ', counter);
  Writeln(Format('time = %.4f ms', [ms]));
end.
