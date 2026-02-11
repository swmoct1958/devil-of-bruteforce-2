program magic_pascal_fast;
uses sysutils;
var
  n, target, count: integer;
  board: array of integer;
  used: array of boolean;
  t1, t2: TDateTime;

procedure solve(p: integer);
var v, i, s: integer;
begin
  if p = n * n then begin
    s := 0; for i := 0 to n-1 do s := s + board[i * n + i];
    if s <> target then exit;
    s := 0; for i := 0 to n-1 do s := s + board[i * n + (n - 1 - i)];
    if s = target then inc(count);
    exit;
  end;

  for v := 1 to n * n do
    if not used[v] then begin
      board[p] := v;
      if (p + 1) mod n = 0 then begin
        s := 0; for i := 0 to n-1 do s := s + board[p - i];
        if s <> target then continue;
      end;
      if p >= n * (n - 1) then begin
        s := 0; for i := 0 to n-1 do s := s + board[(p mod n) + i * n];
        if s <> target then continue;
      end;
      used[v] := true; solve(p + 1); used[v] := false;
    end;
end;

begin
  n := 3; target := n * (n * n + 1) div 2;
  SetLength(board, n * n); SetLength(used, n * n + 1);
  count := 0; t1 := now;
  solve(0); t2 := now;
  writeln('N=', n, ' Count: ', count, ' Time: ', (t2-t1)*86400:0:4, 's');
end.