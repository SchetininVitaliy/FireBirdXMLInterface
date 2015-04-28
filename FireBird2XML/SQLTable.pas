unit SQLTable;

interface
uses
  Classes,
  SysUtils,
  Generics.Collections;
type
//------------------------------------------------------------------------------
  TSQLTableColumn = class
    fName:string;
    fDescription:string;
    fContent: TStringList;
    fType:string;
    fLength : integer;
    fDefault :string;
    fNotNull : boolean;
    function RowCount():integer;
    constructor Create(cName:string; cDescription:string; cType:string; len:integer;
                    default:string; notNull:boolean);
    destructor  Destroy;
  end;
 //------------------------------------------------------------------------------
  TSQLTable = class
  private
    fTableName:string;
    fTableDescription:string;
    fContentRepresentation: TList;
    fPrimaryKey:TList<integer>;
  public
    procedure AddColumn(cName:string; cDescription:string; cType:string; len:integer;
                    default:string; notNull:boolean);
    procedure AddRow(row:TStringList);
    procedure AddPrimaryKeyColumn(strColumn:string);
    procedure Print();
    function ColumnCount():integer;
    function RowCount():integer;
    function PrimaryKeyColCount():integer;
    //Modifires
    procedure SetName( name:string);
    procedure SetDescription ( description:string);
    //Table accessors
    function GetName():string;
    function GetDescription():string;
    //Column accessors
    function GetPrimaryKeyCol(i_col:integer):string;
    function GetColumnID(strColumn:string):integer;
    function GetColumnName(id:integer):string;
    function GetColumnDescription(id:integer):string;
    function GetColumnType(id:integer):string;
    function GetColumnLen(id:integer):integer;
    function GetColumnDefault(id:integer):string;
    function GetColumnNotNull(id:integer):boolean;
    function GetContent(i_row:integer; i_col:integer):string;
    function IsPrimaryColumn(i_col:integer) : boolean;
    procedure GetRow(i_row:integer; var row:TStringList);
    constructor Create;
    destructor Destroy;
  end;
//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------
   constructor TSQLTable.Create;
   begin
       fContentRepresentation :=   TList.Create;
       fPrimaryKey := TList<integer>.Create;
   end;
//------------------------------------------------------------------------------
   destructor TSQLTable.Destroy;
   begin

   end;
//------------------------------------------------------------------------------
   function TSQLTable.IsPrimaryColumn(i_col:integer) : boolean;
   begin
      Result := false;
      if fPrimaryKey.Contains(i_col) then
         Result := true;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.ColumnCount():integer;
   begin
     Result:=fContentRepresentation.Count;
   end;
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
   procedure TSQLTable.SetName( name : string);
   begin
     fTableName := name;
   end;
//------------------------------------------------------------------------------
   procedure TSQLTable.SetDescription ( description:string);
   begin
     fTableDescription := description;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetName():string;
   begin
     Result := fTableName;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetDescription():string;
   begin
     Result := fTableDescription;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.PrimaryKeyColCount():integer;
   begin
       Result := fPrimaryKey.Count;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetPrimaryKeyCol(i_col:integer):string;
   begin
    Result :=  GetColumnName(fPrimaryKey[i_col]);
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetColumnID(strColumn:string):integer;
   var
    i_col,i:integer;
    column: TSQLTableColumn;
   begin
      Result:=-1;
      for i_col := 0 to ColumnCount()-1 do
      begin
        column := fContentRepresentation[i_col];
        if (string.Compare(column.fName,strColumn) = 0) then
          Result:= i_col;
      end;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetColumnName(id:integer):string;
   var
    column:TSQLTableColumn;
   begin
      column := fContentRepresentation[id];
      Result:= column.fName;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetColumnDescription(id:integer):string;
   var
    column:TSQLTableColumn;
   begin
      column := fContentRepresentation[id];
      Result:= column.fDescription;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetColumnType(id:integer):string;
   var
    column:TSQLTableColumn;
   begin
      column := fContentRepresentation[id];
      Result:= column.fType;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetColumnLen(id:integer):integer;
   var
    column:TSQLTableColumn;
   begin
      column := fContentRepresentation[id];
      Result:= column.fLength;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetColumnDefault(id:integer):string;
   var
    column:TSQLTableColumn;
   begin
      column := fContentRepresentation[id];
      Result:= column.fDefault;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetColumnNotNull(id:integer):boolean;
   var
    column:TSQLTableColumn;
   begin
      column := fContentRepresentation[id];
      Result:= column.fNotNull;
   end;
//------------------------------------------------------------------------------
   function TSQLTable.GetContent(i_row:integer; i_col:integer):string;
   var
      column:TSQLTableColumn;
   begin
      column:=fContentRepresentation[i_col];
      Result:=column.fContent[i_row];
   end;
//------------------------------------------------------------------------------
   procedure TSQLTable.AddColumn(cName:string; cDescription:string; cType:string; len:integer;
                          default:string; notNull:boolean);
   var newColumn:TSQLTableColumn;
   begin
      newColumn := TSQLTableColumn.Create(cName,cDescription,cType,len, default, notNull);
      fContentRepresentation.Add(newColumn);
   end;
//------------------------------------------------------------------------------
   procedure TSQLTable.AddRow(row:TStringList);
   var
    i_col:integer;
    column:TSQLTableColumn;
   begin
      if (row.Count <> ColumnCount()) then
        raise Exception.Create('Количество полей в одной из строк не соотетсвует указанному в декларации');

      for i_col := 0 to ColumnCount()-1 do
      begin
         column := fContentRepresentation[i_col];
         column.fContent.Add(row[i_col]);
      end;
   end;
//------------------------------------------------------------------------------
   procedure TSQLTable.AddPrimaryKeyColumn(strColumn:string);
   var
    colID:integer;
   begin
      colID:=GetColumnID(strColumn);
      if colID = -1 then
        raise Exception.Create('Не удалось добавить первичный ключ. Такой колонк не существует!');
      fPrimaryKey.Add(colID);
   end;
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
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
 //////////////////////////////////////////////////////////////////////////////
   constructor TSQLTableColumn.Create(cName:string; cDescription:string; cType:string; len:integer;
                                default:string; notNull:boolean);
   begin
      fName := cName;
      fDescription:= cDescription;
      fType := cType;
      fContent := TStringList.Create;
      fLength := len;
      fDefault := default;
      fNotNull := notNull;
   end;
 //------------------------------------------------------------------------------
   destructor TSQLTableColumn.Destroy;
   begin

   end;
//------------------------------------------------------------------------------
   function TSQLTableColumn.RowCount():integer;
   begin
     Result :=  fContent.Count;
   end;
//------------------------------------------------------------------------------
end.
