unit DBSQLTableCreator;

interface
uses
  Classes,
  SQLTableCreator,
  Data.DB,
  IBX.IBDatabase,
  IBX.IBQuery,
  IBX.IBCustomDataSet,
  SQLTable,
  SysUtils,
  Dialogs,
  Support ;
type
//------------------------------------------------------------------------------
  TDBSQLTableCreator = class(TSQLTableCreator)
    private
      fDB : TIBDatabase;
    public
      constructor Create(dbName:string; dbUser:string; dbPass:string;
                          dbCType:string);
      destructor Destroy;

      procedure CreateTableFromDB(tableName:string; var table:TSQLTable);

      procedure CreateDBTableFromTable(tableName:string; table:TSQLTable);
  end;
//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------
   constructor TDBSQLTableCreator.Create;
   begin
      fDB :=  TIBDatabase.Create(nil);
      fDB.Params.Clear;
      fDB.LoginPrompt:=False;
      fDB.DatabaseName:=dbName;
      fDB.Params.Add('user_name='+dbUser);
      fDB.Params.Add('password='+dbPass);
      fDB.Params.Add('lc_ctype='+dbCType);
      try
        fDB.Connected:=True;
      except
        on E:Exception do
        begin
          ShowMessage(PChar(E.Message));
          Halt;
        end;
      end;
       //todo обработка исключений
   end;
//------------------------------------------------------------------------------
   destructor  TDBSQLTableCreator.Destroy;
   begin
      fDB.Destroy;
   end;
//------------------------------------------------------------------------------
   procedure TDBSQLTableCreator.CreateTableFromDB(tableName:string; var table:TSQLTable);
   var
      transCols, transRows, transPrKey, transTabDesc: TIBTransaction;
      ibdsCols,ibdsRows, ibdsPrKey, ibdsTabDesc: TIBDataSet;
      i_col :integer;
      row : TStringList;
   begin
      fDB.Open();
      StrUpcase(tableName);
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
                          +  'rf.rdb$DESCRIPTION as description, '
                          +  'case f.rdb$field_type '
                          +    'when 14 then ''CHAR'' '
                          +    'when 37 then ''VARCHAR'' '
                          +    'when 8 then ''INTEGER'' '
                          +  'end as data_type, '
                          +  'f.rdb$field_length as length, '
                          +  'rf.rdb$default_value as def, '
                          +  'rf.rdb$null_flag as nullFlag '
                          +  'from rdb$fields f '
                          +  'join rdb$relation_fields rf on rf.rdb$field_source = f.rdb$field_name '
                          +  'where rf.rdb$relation_name = ''' + tableName + ''' ;';
      Writeln(ibdsCols.SelectSQL.Text);
      ibdsCols.Active := true;
      //todo обрабока исключений
      while not ibdsCols.Eof do begin
         table.AddColumn(Trim(ibdsCols.FieldByName('column_name').AsString),
                        Trim(ibdsCols.FieldByName('description').AsString),
                        Trim(ibdsCols.FieldByName('data_type').AsString),
                        Round(ibdsCols.FieldByName('length').AsInteger/4),
                        Trim(ibdsCols.FieldByName('def').AsString),
                        Boolean(ibdsCols.FieldByName('nullFlag').AsInteger)
                        );
         ibdsCols.Next;
      end;
      ibdsCols.Destroy;
      transCols.Destroy;

      //Выборка описания
      transTabDesc := TIBTransaction.Create(nil);
      transTabDesc.DefaultDatabase := fDB;
      ibdsTabDesc:= TIBDataSet.Create(nil);
      ibdsTabDesc.Database := fDB;
      ibdsTabDesc.Transaction := transTabDesc;

      transTabDesc.StartTransaction;

      ibdsTabDesc.SelectSQL.Text := 'SELECT rdb$description as description ' +
                                    'FROM rdb$relations ' +
                                    'WHERE rdb$relation_name = ''' + tableName + ''' ;';
      ibdsTabDesc.Active := true;
      table.fTableDescription :=  Trim(ibdsTabDesc.FieldByName('description').AsString);

      ibdsTabDesc.Destroy;
      transTabDesc.Destroy;


      //Создание первичного ключа
      transPrKey := TIBTransaction.Create(nil);
      transPrKey.DefaultDatabase := fDB;
      ibdsPrKey := TIBDataSet.Create(nil);
      ibdsPrKey.Database := fDB;
      ibdsPrKey.Transaction := transPrKey;

      transPrKey.StartTransaction;

      ibdsPrKey.SelectSQL.Text := 'select ' +
                                    'i.rdb$index_name, ' +
                                    's.rdb$field_name as COLUMN_NAME, ' +
                                    'i.rdb$relation_name as TABLE_NAME ' +
                                  'from ' +
                                      'rdb$indices i ' +
                                      'left join rdb$index_segments s on i.rdb$index_name = s.rdb$index_name ' +
                                      'left join rdb$relation_constraints rc on rc.rdb$index_name = i.rdb$index_name ' +
                                  'where ' +
                                  'rc.rdb$constraint_type = ''PRIMARY KEY'' and i.rdb$relation_name = ''' + tableName + ''' ;';

      ibdsPrKey.Active := true;

      while not ibdsPrKey.Eof do begin
         table.AddPrimaryKeyColumn(Trim(ibdsPrKey.FieldByName('COLUMN_NAME').AsString));
         ibdsPrKey.Next;
      end;

      ibdsPrKey.Destroy;
      transPrKey.Destroy;
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
             row.Add(Trim(ibdsRows.Fields[i_col].AsString));
          table.AddRow(row);
          ibdsRows.Next;
      end;
      ibdsRows.Destroy;
      transRows.Destroy;
      fDB.Close;
   end;
//------------------------------------------------------------------------------
   procedure TDBSQLTableCreator.CreateDBTableFromTable(tableName:string; table:TSQLTable);
   var
    transTExist, transCreate,transInsert, transDrop, transColCom: TIBTransaction;
    ibdsTExist,ibdsCreate, ibdsInsert, ibdsDrop: TIBDataSet;
    queryDrop, queryInsert, queryColCom: TIBQuery;
    tableExist: boolean;
    i_col: Integer;
    columnStr, rowStr:string;
    i_row: Integer;
    bytes : TBytes;
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

        if table.GetColumnLen(i_col) = 0 then
        begin
          columnStr := columnStr + table.GetColumnType(i_col) + ' ';
        end
        else
          columnStr := columnStr + table.GetColumnType(i_col) + '(' + IntToStr(table.GetColumnLen(i_col)) + ')';

        columnStr := columnStr + ' CHARACTER SET WIN1251 ';

        if table.IsPrimaryColumn(i_col) then
           columnStr := columnStr + ' NOT NULL PRIMARY KEY ';
        if i_col <> table.ColumnCount()-1  then
           columnStr := columnStr + ' , ';

        ibdsCreate.SelectSQL.Text := ibdsTExist.SelectSQL.Text + columnStr;
      end;
      ibdsCreate.SelectSQL.Text := ibdsCreate.SelectSQL.Text + ');';
      Writeln(ibdsCreate.SelectSQL.Text );
      ibdsCreate.Active := true;

      ibdsCreate.Destroy;
      transCreate.Destroy;

      //Добавляем комментарии к колонкам
      for i_col := 0 to table.ColumnCount()-1 do
        begin
          transColCom := TIBTransaction.Create(nil);
          transColCom.DefaultDatabase := fDB;
          queryColCom := TIBQuery.Create(nil);
          queryColCom.Database := fDB;
          queryColCom.Transaction := transColCom;

          transColCom.StartTransaction;

          bytes := TEncoding.UTF8.GetBytes(table.GetColumnDescription(i_col));

          queryColCom.SQL.Text := ' COMMENT ON COLUMN ' + table.fTableName + '.' + table.GetColumnName(i_col) +
                ' IS '''
                 + table.GetColumnDescription(i_col) + ''' ;';
          Writeln(queryColCom.SQL.Text);
          queryColCom.Active := true;

          queryColCom.Destroy;
          transColCom.Destroy;
        end;

      // Добавляем комментарий к таблице
      transColCom := TIBTransaction.Create(nil);
      transColCom.DefaultDatabase := fDB;
      queryColCom := TIBQuery.Create(nil);
      queryColCom.Database := fDB;
      queryColCom.Transaction := transColCom;

      transColCom.StartTransaction;

      queryColCom.SQL.Text := ' COMMENT ON TABLE ' + table.fTableName  +
                                  ' IS ''' + table.fTableDescription + ''' ;';

      queryColCom.Active := true;

      queryColCom.Destroy;
      transColCom.Destroy;

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
//------------------------------------------------------------------------------
end.
