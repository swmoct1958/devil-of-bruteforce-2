program Magic9;
{$mode objfpc}{$H+}
uses sysutils, dateutils;

const
  S = 34;

var
  board: array[0..15] of Integer;
  used: LongWord;
  total_count: Int64;
  StartTime: TDateTime;

procedure solve(pos: Integer);
var
  v: Integer;
  v12, v13, v14, v15: Integer;
begin
  if pos = 3 then begin
    v := S - (board[0] + board[1] + board[2]);
    if (v >= 1) and (v <= 16) and ((used and (1 shl v)) = 0) then begin
      board[3] := v; used := used or (1 shl v); solve(4); used := used and not (1 shl v);
    end;
    exit;
  end;
  if pos = 7 then begin
    v := S - (board[4] + board[5] + board[6]);
    if (v >= 1) and (v <= 16) and ((used and (1 shl v)) = 0) then begin
      board[7] := v; used := used or (1 shl v); solve(8); used := used and not (1 shl v);
    end;
    exit;
  end;
  if pos = 11 then begin
    v := S - (board[8] + board[9] + board[10]);
    if (v >= 1) and (v <= 16) and ((used and (1 shl v)) = 0) then begin
      board[11] := v; used := used or (1 shl v); solve(12); used := used and not (1 shl v);
    end;
    exit;
  end;
  
  if pos = 12 then begin
    v12 := S - (board[0] + board[4] + board[8]);
    if (v12 < 1) or (v12 > 16) or ((used and (1 shl v12)) <> 0) then exit;
    v13 := S - (board[1] + board[5] + board[9]);
    if (v13 < 1) or (v13 > 16) or (v13 = v12) or ((used and (1 shl v13)) <> 0) then exit;
    v14 := S - (board[2] + board[6] + board[10]);
    if (v14 < 1) or (v14 > 16) or (v14 = v12) or (v14 = v13) or ((used and (1 shl v14)) <> 0) then exit;
    v15 := S - (board[3] + board[7] + board[11]);
    if (v15 < 1) or (v15 > 16) or (v15 = v12) or (v15 = v13) or (v15 = v14) or ((used and (1 shl v15)) <> 0) then exit;

    if (v12 + v13 + v14 + v15 = S) and
       (board[0] + board[5] + board[10] + v15 = S) and
       (board[3] + board[6] + board[9] + v12 = S) then
      Inc(total_count);
    exit;
  end;

  for v := 1 to 16 do begin
    if (used and (1 shl v)) = 0 then begin
      used := used or (1 shl v);
      board[pos] := v;
      solve(pos + 1);
      used := used and not (1 shl v);
    end;
  end;
end;

begin
  total_count := 0; used := 0;
  Writeln('Pascal n=4 Search Start...');
  StartTime := Now;
  solve(0);
  Writeln('Count: ', total_count, ' (7040)');
  Writeln('Time: ', MilliSecondsBetween(Now, StartTime), ' ms');
  Writeln('Push Enter key to exit...');
  Readln; // 結果を止めるための追加
end.
