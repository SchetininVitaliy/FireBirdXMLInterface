unit SQLTable;

interface
uses SysUtils;

type
  TSQLTable = class
    constructor Create;
    destructor Destroy;
  end;

implementation
  constructor TSQLTable.Create;
  begin
    Writeln('TSQLTable.Create');
  end;

  destructor TSQLTable.Destroy;
  begin
    Writeln('TSQLTable.Destroy');
  end;
end.
