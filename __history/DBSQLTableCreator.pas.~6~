unit DBSQLTableCreator;

interface
uses
  Classes,
  SQLTableCreator,
  Data.DB,
  IBX.IBDatabase,
  IBX.IBQuery,
  IBX.IBCustomDataSet,
  SQLTable;
procedure StrUpcase(var s : string);

type
  TDBSQLTableCreator = class(TSQLTableCreator)
      fDB : TIBDatabase;

      constructor Create(dbName:string; dbUser:string; dbPass:string;
                          dbCType:string);
      destructor Destroy;

      procedure CreateTableFromDB(tableName:string; var table:TSQLTable);

      procedure CreateDBTableFromTable(tableName:string; table:TSQLTable);
  end;
implementation
   constructor TDBSQLTableCreator.Create;
   begin
      fDB :=  TIBDatabase.Create(nil);
      fDB.Params.Clear;
      fDB.LoginPrompt:=False;
      fDB.DatabaseName:=dbName;
      fDB.Params.Add('user_name='+dbUser);
      fDB.Params.Add('password='+dbPass);
      fDB.Params.Add('lc_ctype='+dbCType);
      fDB.Connected:=True;
       //todo обработка исключений
   end;

   destructor  TDBSQLTableCreator.Destroy;
   begin
      fDB.Destroy;
   end;

   procedure TDBSQLTableCreator.CreateTableFromDB(tableName:string; var table:TSQLTable);
   var
      transCols, transRows: TIBTransaction;
      ibdsCols,ibdsRows: TIBDataSet;
      i_col :integer;
      row : TStringList;
   begin
      fDB.Open();
      table.fTableName := tableName;
      //Выборка информации о колокнках таблицы
      transCols := TIBTransaction.Create(nil);
      transCols.DefaultDatabase := fDB;
      ibdsCols := TIBDataSet.Create(nil);
      ibdsCols.Database := fDB;
      ibdsCols.Transaction := transCols;
      //todo обработка исключений

      transCols.StartTransaction;

      ibdsCols.SelectSQL.Text := 'select '
                          +  'rf.rdb$field_name as column_name, '
                          +  'case f.rdb$field_type '
                          +    'when 14 then ''CHAR'' '
                          +    'when 37 then ''VARCHAR'' '
                          +    'when 8 then ''INTEGER'' '
                          +  'end as data_type, '
                          +  'f.rdb$field_length as length '
                          +  'from rdb$fields f '
                          +  'join rdb$relation_fields rf on rf.rdb$field_source = f.rdb$field_name '
                          +  'where rf.rdb$relation_name = ''' + tableName + ''' ;';
      Writeln(ibdsCols.SelectSQL.Text);
      ibdsCols.Active := true;
      //todo обрабока исключений
      //todo достать description. в том числе и для table
      while not ibdsCols.Eof do begin
         table.AddColumn(ibdsCols.FieldByName('column_name').AsString,
                          '',
                        ibdsCols.FieldByName('data_type').AsString);
         ibdsCols.Next;
      end;
      ibdsCols.Destroy;
      transCols.Destroy;

      //Выборка строк
      transRows := TIBTransaction.Create(nil);
      transRows.DefaultDatabase := fDB;
      ibdsRows := TIBDataSet.Create(nil);
      ibdsRows.Database := fDB;
      ibdsRows.Transaction := transRows;

      transRows.StartTransaction;

      ibdsRows.SelectSQL.Text := 'select * from ' + tableName + ' ;';
      ibdsRows.Active := true;
      //todo обрабока исключений
       row := TStringList.Create;
       while not ibdsRows.Eof do begin
          row.Clear;
          for i_col := 0 to ibdsRows.FieldCount - 1 do
             row.Add(ibdsRows.Fields[i_col].AsString);
          table.AddRow(row);
          ibdsRows.Next;
      end;
      ibdsRows.Destroy;
      transRows.Destroy;
      fDB.Close;
   end;

   procedure TDBSQLTableCreator.CreateDBTableFromTable(tableName:string; table:TSQLTable);
   var
    transTExist, transCreate,transInsert, transDrop: TIBTransaction;
    ibdsTExist,ibdsCreate, ibdsInsert, ibdsDrop: TIBDataSet;
    queryDrop, queryInsert: TIBQuery;
    tableExist: boolean;
    i_col: Integer;
    columnStr, rowStr:string;
    i_row: Integer;
   begin
      fDB.Open;
      StrUpcase(tableName);
      //todo разбить на методы
      //Проверка существования таблицы в базе
      transTExist := TIBTransaction.Create(nil);
      transTExist.DefaultDatabase := fDB;
      ibdsTExist := TIBDataSet.Create(nil);
      ibdsTExist.Database := fDB;
      ibdsTExist.Transaction := transTExist;

      transTExist.StartTransaction;

      ibdsTExist.SelectSQL.Text := 'select '
                          +  'rf.rdb$relation_name as table_name '
                          +  'from rdb$fields f '
                          +  'join rdb$relation_fields rf on rf.rdb$field_source = f.rdb$field_name '
                          +  'where rf.rdb$relation_name = ''' + tableName + ''' ;';
      ibdsTExist.Active:=true;

      tableExist := false;
      if ibdsTExist.RecordCount <> 0 then
        tableExist:=true;

      ibdsTExist.Destroy;
      transTExist.Destroy;

      //Если таблицы есть, то удаляем ее
      {if not tableExist then
      begin
        droptable
      end; }

      if tableExist then
      begin
        transDrop := TIBTransaction.Create(nil);
        transDrop.DefaultDatabase := fDB;
        queryDrop := TIBQuery.Create(nil);
        queryDrop.Database := fDB;
        queryDrop.Transaction := transDrop;

        transDrop.StartTransaction;
        queryDrop.SQL.Text := 'drop table '+tableName;
        queryDrop.Active := true;

        queryDrop.Destroy;
        transDrop.Destroy;
      end;
      //todo обработка исключений

      //создаем таблицу
      transCreate := TIBTransaction.Create(nil);
      transCreate.DefaultDatabase := fDB;
      ibdsCreate := TIBDataSet.Create(nil);
      ibdsCreate.Database := fDB;
      ibdsCreate.Transaction := transCreate;

      transCreate.StartTransaction;
      ibdsCreate.SelectSQL.Text := 'create table ' + tableName + ' (';
      for i_col := 0 to table.ColumnCount()-1 do
      begin
        columnStr := '';
        columnStr := columnStr + table.GetColumnName(i_col) + ' ';
        columnStr := columnStr + table.GetColumnType(i_col);
        if i_col <> table.ColumnCount()-1  then
           columnStr := columnStr + ' , ';

        ibdsCreate.SelectSQL.Text := ibdsTExist.SelectSQL.Text + columnStr;
      end;
      ibdsCreate.SelectSQL.Text := ibdsCreate.SelectSQL.Text + ');';
      Writeln(ibdsCreate.SelectSQL.Text );
      ibdsCreate.Active := true;

      ibdsCreate.Destroy;
      transCreate.Destroy;


      for i_row := 0 to table.RowCount() -1 do
      begin
        transInsert := TIBTransaction.Create(nil);
        transInsert.DefaultDatabase := fDB;
        queryInsert := TIBQuery.Create(nil);
        queryInsert.Database := fDB;
        queryInsert.Transaction := transInsert;

        transInsert.StartTransaction;
        rowStr := 'insert into ' + tableName + ' VALUES ';
         rowStr := rowStr + ' ( ';
         for i_col := 0 to table.ColumnCount()-1 do
         begin
            rowStr := rowStr + ' ''' +  table.GetContent(i_row, i_col) +  ''' ';
            if i_col <> table.ColumnCount()-1 then
              rowStr := rowStr + ' , ';
         end;
         rowStr := rowStr + ' ) ; ';
         queryInsert.SQL.Text  :=  rowStr;
         writeln(queryInsert.SQL.Text);
         queryInsert.Active := true;

          queryInsert.Destroy;
          transInsert.Destroy;
      end;


      fDB.Close;
   end;


   procedure StrUpcase(var s : string);
    var
       i : byte;
    begin
       for i := 1 to length(s) do
          s[i] := upcase(s[i]);
    end;
end.
