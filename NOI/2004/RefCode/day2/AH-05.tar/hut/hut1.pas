{$R-,Q-,S-}
Const
    InFile     = 'hut.in';
    OutFile    = 'hut1.out';
    Limit      = 100;

Type
    Topt       = array[1..Limit , 1..Limit , 1..Limit] of double;
    Tfather    = array[1..Limit , 1..Limit , 1..Limit] of longint;
    Tg         = array[1..Limit , 1..Limit] of double;

Var
    opt        : Topt;
    fatherL ,
    fatherN    : Tfather;
    g          : Tg;
    k1 , k2    : double;
    m , n      : longint;

procedure init;
begin
    assign(INPUT , InFile); ReSet(INPUT);
      readln(k1 , k2 , m , n);
    Close(INPUT);
end;

function calc(K , L : double) : double;
begin
    calc := L * L * K;
end;

procedure Get_G;
var
    i , j , k ,
    target     : longint;
    tmp        : double;
begin
    for i := 1 to Limit do
      begin
          if i < n then target := i else target := n;
          g[i , 1] := calc(k1 , i) + calc(k2 , i);
          for j := 2 to target do
            begin
                g[i , j] := calc(k2 , 1) + g[i - 1 , j - 1] - calc(k1 , i - 1);
                for k := 2 to i - j + 1 do
                  begin
                      tmp := calc(k2 , k) + g[i - k , j - 1] - calc(k1 , i - k);
                      if tmp < g[i , j] then g[i , j] := tmp;
                  end;
                g[i , j] := g[i , j] + calc(k1 , i);
            end;
      end;
end;

procedure work;
var
    i , j , k ,
    x , p      : longint;
    tmp        : double;
begin
    Get_G;

    fillchar(fatherL , sizeof(fatherL) , $FF);
    fillchar(fatherN , sizeof(fatherN) , $FF);
    for i := 1 to Limit do
      for k := 1 to N do
        begin
            opt[i , 1 , k] := G[i , k];
            fatherL[i , 1 , k] := 0;
            fatherN[i , 1 , k] := 0;
        end;
    for i := 1 to Limit do
      for j := 2 to M do
        for k := j to N do
          for p := j - 1 to i - 1 do
            for x := p - i + k to k - 1 do
              if (p >= x) and (x >= 1) then
                if fatherL[p , j - 1 , x] <> -1 then
                  begin
                      tmp := opt[p , j - 1 , x] + G[i - p , k - x];
                      if (fatherL[i , j , k] = -1) or (opt[i , j , k] > tmp) then
                        begin
                            opt[i , j , k] := tmp;
                            fatherL[i , j , k] := p;
                            fatherN[i , j , k] := x;
                        end;
                  end;
end;

procedure out;
var
    newi , newk ,
    i , j , k  : longint;
begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(opt[Limit , M , N] : 0 : 1);
{      i := Limit; k := N;
      for j := M downto 1 do
        begin
            newi := fatherL[i , j , k];
            newk := fatherN[i , j , k];
            writeln(j , ': ' , i - newi , ' , ' , k - newk);
            i := newi; k := newk;
        end;      }
    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
