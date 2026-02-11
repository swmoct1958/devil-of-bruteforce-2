program MagicSquarePascal;

{$mode objfpc}{$H+}

uses
  SysUtils, DateUtils;

var
  n, magic: Integer;
  sq: array of Integer;
  used: array of Boolean;
  row, col: array of Integer;
  diag, adiag: Integer;
  count: Int64;
  startTime, endTime: TDateTime;

procedure Search(pos: Integer);
var
  r, c, v, need, maxv: Integer;
  forced: Boolean;

  procedure TryValue(v: Integer);
  begin
    r := (pos div n);
    c := (pos mod n);

    if row[r] + v > magic then Exit;
    if col[c] + v > magic then Exit;
    if (r = c) and (diag + v > magic) then Exit;
    if (r + c = n - 1) and (adiag + v > magic) then Exit;

    sq[pos] := v;
    used[v] := True;
    row[r] := row[r] + v;
    col[c] := col[c] + v;
    if r = c then diag := diag + v;
    if r + c = n - 1 then adiag := adiag + v;

    Search(pos + 1);

    used[v] := False;
    row[r] := row[r] - v;
    col[c] := col[c] - v;
    if r = c then diag := diag - v;
    if r + c = n - 1 then adiag := adiag - v;
  end;

begin
  if pos = n * n then
  begin
    Inc(count);
    Exit;
  end;

  r := pos div n;
  c := pos mod n;
  maxv := n * n;

  forced := False;
  v := -1;

  if c = n - 1 then
  begin
    need := magic - row[r];
    if (need < 1) or (need > maxv) or used[need] then Exit;
    v := need;
    forced := True;
  end
  else if r = n - 1 then
  begin
    need := magic - col[c];
    if (need < 1) or (need > maxv) or used[need] then Exit;
    v := need;
    forced := True;
  end
  else if (r = c) and (r = n - 1) then
  begin
    need := magic - diag;
    if (need < 1) or (need > maxv) or used[need] then Exit;
    v := need;
    forced := True;
  end
  else if (r + c = n - 1) and (r = n - 1) then
  begin
    need := magic - adiag;
    if (need < 1) or (need > maxv) or used[need] then Exit;
    v := need;
    forced := True;
  end;

  if forced then
    TryValue(v)
  else
    for v := 1 to maxv do
      if not used[v] then
        TryValue(v);
end;

var
  i, v: Integer;
  arg: String;

begin
  if ParamCount >= 1 then
    n := StrToIntDef(ParamStr(1), 4)
  else
    n := 4;

  magic := n * (n * n + 1) div 2;

  SetLength(sq, n * n);
  SetLength(used, n * n + 1);
  SetLength(row, n);
  SetLength(col, n);

  for i := 0 to n - 1 do
  begin
    v := i + 1;
    sq[i] := v;
    used[v] := True;
    row[0] := row[0] + v;
    col[i] := col[i] + v;
  end;

  diag := sq[0];
  adiag := sq[n - 1];
  count := 0;

  startTime := Now;
  Search(n);
  endTime := Now;

  WriteLn('N=', n, ' Count=', count,
          ' Time=', FormatFloat('0.000000', (endTime - startTime) * 86400), ' sec');
end.
