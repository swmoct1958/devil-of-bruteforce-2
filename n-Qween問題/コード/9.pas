program NQueensPascal;

{$mode objfpc}{$H+}

uses
  SysUtils, DateUtils;

var
  N: Integer;
  Count: Int64;

procedure DFS(row, cols, d1, d2: Integer);
var
  mask, avail, p, cols2, d12, d22: Integer;
begin
  if row = N then
  begin
    Inc(Count);
    Exit;
  end;

  mask := (1 shl N) - 1;
  avail := mask and not (cols or d1 or d2);

  while avail <> 0 do
  begin
    p := avail and -avail;
    avail := avail xor p;
    cols2 := cols or p;
    d12 := (d1 or p) shl 1;
    d22 := (d2 or p) shr 1;
    DFS(row + 1, cols2, d12, d22);
  end;
end;

var
  startTime, endTime: TDateTime;
begin
  if ParamCount >= 1 then
    N := StrToIntDef(ParamStr(1), 14)
  else
    N := 14;

  Count := 0;

  startTime := Now;
  DFS(0, 0, 0, 0);
  endTime := Now;

  WriteLn('N=', N, ' Count=', Count,
          ' Time=', FormatFloat('0.000000', (endTime - startTime) * 86400), ' sec');
end.
