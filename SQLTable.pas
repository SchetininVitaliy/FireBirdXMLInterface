unit SQLTable;

interface
uses
  Classes,
  SysUtils,
  Generics.Collections;

type
  TSQLTableForeignKey = record

  end;

  TSQLTableColumn = class
    fName:string;
    fDescription:string;
    fContent: TStringList;
    fType:string;
    function RowCount():integer;
    constructor Create(cName:string; cDescription:string; cType:string);
    destructor  Destroy;
  end;

  TSQLTable = class
    fTableName:string;
    fTableDescription:string;
    fContentRepresentation: TList;
    fPrimatyKey:TList<integer>;
    procedure AddColumn(cName:string; cDescription:string; cType:string);
    procedure AddRow(row:TStringList);
    procedure AddPrimaryKeyColumn(strColumn:string);
    procedure Print();
    function ColumnCount():integer;
    function RowCount():integer;
    function PrimaryKeyColCount():integer;
    function GetPrimaryKeyCol(i_col:integer):string;
    function GetColumnID(strColumn:string):integer;
    function GetColumnName(id:integer):string;
    function GetColumnDescription(id:integer):string;
    function GetColumnType(id:integer):string;
    function GetContent(i_row:integer; i_col:integer):string;
    procedure GetRow(i_row:integer; var row:TStringList);
    constructor Create;
    destructor Destroy;
  end;


implementation
   constructor TSQLTable.Create;
   begin
       fContentRepresentation :=   TList.Create;
       fPrimatyKey := TList<integer>.Create;
   end;

   destructor TSQLTable.Destroy;
   begin

   end;

   function TSQLTable.ColumnCount():integer;
   begin
     Result:=fContentRepresentation.Count;
   end;

   function TSQLTable.RowCount():integer;
   var
    column:TSQLTableColumn;
   begin
    if (fContentRepresentation <> nil) then
    begin
      column := fContentRepresentation.First;
      Result := column.RowCount();
    end
    else
    begin
      Result := 0;
    end;
   end;

   function TSQLTable.PrimaryKeyColCount():integer;
   begin
       Result := fPrimatyKey.Count;
   end;

   function TSQLTable.GetPrimaryKeyCol(i_col:integer):string;
   begin
    Result :=  GetColumnName(fPrimatyKey[i_col]);
   end;

   function TSQLTable.GetColumnID(strColumn:string):integer;
   var
    i_col:integer;
    column: TSQLTableColumn;
   begin
      Result:=-1;
      for i_col := 0 to ColumnCount()-1 do
      begin
        column := fContentRepresentation[i_col];
        if (column.fName = strColumn) then
          Result:= i_col;
      end;
   end;

   function TSQLTable.GetColumnName(id:integer):string;
   var
    column:TSQLTableColumn;
   begin
      column := fContentRepresentation[id];
      Result:= column.fName;
   end;

   function TSQLTable.GetColumnDescription(id:integer):string;
   var
    column:TSQLTableColumn;
   begin
      column := fContentRepresentation[id];
      Result:= column.fDescription;
   end;

   function TSQLTable.GetColumnType(id:integer):string;
   var
    column:TSQLTableColumn;
   begin
      column := fContentRepresentation[id];
      Result:= column.fType;
   end;

   function TSQLTable.GetContent(i_row:integer; i_col:integer):string;
   var
      column:TSQLTableColumn;
   begin
      column:=fContentRepresentation[i_col];
      Result:=column.fContent[i_row];
   end;

   procedure TSQLTable.AddColumn(cName:string; cDescription:string; cType:string);
   var newColumn:TSQLTableColumn;
   begin
      newColumn := TSQLTableColumn.Create(cName,cDescription,cType);
      fContentRepresentation.Add(newColumn);
   end;

   procedure TSQLTable.AddRow(row:TStringList);
   var
    i_col:integer;
    column:TSQLTableColumn;
   begin
      if (row.Count <> ColumnCount()) then
        raise Exception.Create('���������� ����� � ����� �� ����� �� ����������� ���������� � ����������');

      for i_col := 0 to ColumnCount()-1 do
      begin
         column := fContentRepresentation[i_col];
         column.fContent.Add(row[i_col]);
      end;
   end;

   procedure TSQLTable.AddPrimaryKeyColumn(strColumn:string);
   var
    colID:integer;
   begin
      colID:=GetColumnID(strColumn);
      if colID = -1 then
        raise Exception.Create('�� ������� �������� ��������� ����. ����� ������ �� ����������!');
      fPrimatyKey.Add(colID);
   end;

   procedure TSQLTable.Print();
   var
    i_col, i_row:integer;
    column: TSQLTableColumn;
   begin
      for i_col := 0 to ColumnCount()-1 do
      begin
        column := fContentRepresentation[i_col];
        Write(column.fName);
        Write('   ');
      end;
      WriteLn;

      for i_row := 0 to RowCount()-1 do
      begin
        for i_col := 0 to ColumnCount()-1 do
        begin
            column := fContentrepresentation[i_col];
            Write(column.fContent[i_row]);
            Write('   ');
        end;
        Writeln;
      end;
   end;

   procedure TSQLTable.GetRow(i_row:integer; var row:TStringList);
   var
    i_col: Integer;
    column: TSQLTableColumn;
   begin
      for i_col := 0 to ColumnCount()-1 do
      begin
         column := fContentRepresentation[i_col];
         row.Add(column.fContent[i_row]);
      end;
   end;
 ////////////////////////////////////////////////////////////
   constructor TSQLTableColumn.Create(cName:string; cDescription:string; cType:string);
   begin
      fName := cName;
      fDescription:= cDescription;
      fType := cType;
      fContent := TStringList.Create;
   end;

   destructor TSQLTableColumn.Destroy;
   begin

   end;

   function TSQLTableColumn.RowCount():integer;
   begin
     Result :=  fContent.Count;
   end;
end.