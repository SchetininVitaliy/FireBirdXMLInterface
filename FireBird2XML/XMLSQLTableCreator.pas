unit XMLSQLTableCreator;

interface
  uses
    SQLTableCreator,
    SQLTable,
    XMLDoc,
    XMLIntf,
    xmldom,
    Classes,
    Variants,
    SysUtils, Dialogs;
type
//------------------------------------------------------------------------------
  TXMLSQLTableCreator = class(TSQLTableCreator)
    fXMLDocument: IXMLDocument;

    procedure CreateTableFromXML(fileName:string; var table:TSQLTable);
    procedure CreateXMLFromTable(fileName:string; table:TSQLTable);
    constructor Create();
    destructor Destroy;
  end;
//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------
  constructor TXMLSQLTableCreator.Create();
  begin
      fXMLDocument := TXMLDocument.Create(nil);
  end;
//------------------------------------------------------------------------------
  destructor TXMLSQLTableCreator.Destroy;
  begin

  end;
//------------------------------------------------------------------------------
  procedure TXMLSQLTableCreator.CreateTableFromXML(fileName:string; var table:TSQLTable);
  var
    i_col, i_row, i_pk_col:integer;
    tableNode: IXMLNode;
    tableColsNode: IXMLNode;
    tableColNode: IXMLNode;
    tableRowNodes: IXMLNodeList;
    tableRowNode: IXMLNode;
    tableConstainNode: IXMLNode;
    tablePrimaryKeyNode: IXMLNode;
    row: TStringList;
  begin
      try
        fXMLDocument.LoadFromFile(fileName);
      except
        on E:Exception do
        begin
          ShowMessage(PChar(E.Message));
          Halt;
        end;
      end;
      //todo - ��������� ����������
     //������������� ������� �������
     tableNode :=  fXMLDocument.DocumentElement;
     table.SetName(tableNode.Attributes['TABLE_NAME']);
     table.SetDescription(tableNode.Attributes['TABLE_DESCR']);
     tableColsNode := tableNode.ChildNodes['TABLE_COLUMNES'];
     //�������� ������� �������
     for i_col := 0 to tableColsNode.ChildNodes.Count -1 do
     begin
         tableColNode :=  tableColsNode.ChildNodes[i_col];
         table.AddColumn(tableColNode.Attributes['ATTR_NAME'],
                          tableColNode.Attributes['ATTR_DESCR'],
                          tableColNode.Attributes['ATTR_TYPE'],
                          tableColNode.Attributes['ATTR_LEN'],
                          tableColNode.Attributes['ATTR_DEFAULT'],
                          StrToBool(tableColNode.Attributes['ATTR_NOTNULL']));
     end;
     //���������� ���������� �����
     tableConstainNode := tableNode.ChildNodes['TABLE_CONSTR'];
     tablePrimaryKeyNode := tableConstainNode.ChildNodes['PRIMARY_KEY'];
     for i_pk_col := 0 to tablePrimaryKeyNode.ChildNodes.Count-1 do
     begin
        table.AddPrimaryKeyColumn(VarToStr(tablePrimaryKeyNode.ChildNodes[i_pk_col].Attributes['ATTR_NAME']));
     end;

     //���������� ����� � �������
     tableRowNodes :=  tableNode.ChildNodes;
     for i_row := 0 to tableRowNodes.Count-1 do
     begin
      if (tableRowNodes[i_row].NodeName = 'TABLE_ROW') then
      begin
        row := TStringList.Create;
        tableRowNode := tableRowNodes[i_row];
        for i_col := 0 to tableRowNode.ChildNodes.Count-1 do
        begin
            row.Add(VarToStr(tableRowNode.ChildNodes[i_col].Attributes['ATTR_VALUE']));
        end;
        table.AddRow(row);
        row.Destroy;
      end;
     end;

  end;
//------------------------------------------------------------------------------
  procedure TXMLSQLTableCreator.CreateXMLFromTable(fileName:string; table:TSQLTable);
  var
    iXml: IDOMDocument;
    iTable, iTableColumns,iTableColumn, iTableConstrain,
    iPrimaryKey, iPrimAttr,  iAttribute, iTableRow: IDOMNode;
    i_col, i_row: Integer;
    row: TStringList;
  begin
      fXMLDocument.Active := true;
      iXml := fXMLDocument.DOMDocument;
      fXMLDocument.Encoding := 'utf-8';

      //�������� ���� Table
      iTable := iXml.appendChild(iXml.createElement('TABLE'));
      iAttribute := iXml.createAttribute('TABLE_NAME');
      iAttribute.nodeValue := table.GetName;
      iTable.attributes.setNamedItem(iAttribute);
      iAttribute := iXml.createAttribute('TABLE_DESCR');
      iAttribute.nodeValue := table.GetDescription;
      iTable.attributes.setNamedItem(iAttribute);

      //�������� ���������� � ��������
      iTableColumns := iTable.appendChild(iXml.createElement('TABLE_COLUMNES'));
      for i_col := 0 to table.ColumnCount-1 do
      begin
        iTableColumn :=  iTableColumns.appendChild(iXml.createElement('TABLE_COLUMN'));
        iAttribute := iXml.createAttribute('ATTR_NAME');
        iAttribute.nodeValue := table.GetColumnName(i_col);
        iTableColumn.attributes.setNamedItem(iAttribute);
        iAttribute := iXml.createAttribute('ATTR_DESCR');
        iAttribute.nodeValue := table.GetColumnDescription(i_col);
        iTableColumn.attributes.setNamedItem(iAttribute);
        iAttribute := iXml.createAttribute('ATTR_TYPE');
        iAttribute.nodeValue := table.GetColumnType(i_col);
        iTableColumn.attributes.setNamedItem(iAttribute);
        iAttribute := iXml.createAttribute('ATTR_LEN');
        iAttribute.nodeValue := IntToStr(table.GetColumnLen(i_col));
        iTableColumn.attributes.setNamedItem(iAttribute);
        iAttribute := iXml.createAttribute('ATTR_DEFAULT');
        iAttribute.nodeValue := table.GetColumnDefault(i_col);
        iTableColumn.attributes.setNamedItem(iAttribute);
        iAttribute := iXml.createAttribute('ATTR_NOTNULL');
        iAttribute.nodeValue := IntToStr(Abs(Integer(table.GetColumnNotNull(i_col))));
        iTableColumn.attributes.setNamedItem(iAttribute);
      end;

      //�������� ���������� � �����������
      iTableConstrain:= iTable.appendChild(iXml.createElement('TABLE_CONSTR'));
      iPrimaryKey := iTableConstrain.appendChild(iXml.createElement('PRIMARY_KEY'));
      for i_col := 0 to table.PrimaryKeyColCount()-1 do
      begin
        iPrimAttr := iPrimaryKey.appendChild(iXml.createElement('PRIMARY_ATTR'));
        iAttribute := iXml.createAttribute('ATTR_NAME');
        iAttribute.nodeValue := table.GetPrimaryKeyCol(i_col);
        iPrimAttr.attributes.setNamedItem(iAttribute);
      end;

      //�������� ���������� � �������
      for i_row := 0 to table.RowCount()-1 do
      begin
        row := TStringList.Create;
        iTableRow := iTable.appendChild(iXml.createElement('TABLE_ROW'));
        table.GetRow(i_row, row);
          for i_col := 0 to table.ColumnCount()-1 do
          begin
              iTableColumn := iTableRow.appendChild(iXml.createElement('COLUMN'));
              iAttribute := iXml.createAttribute('ATTR_NAME');
              iAttribute.nodeValue := table.GetColumnName(i_col);
              iTableColumn.attributes.setNamedItem(iAttribute);
              iAttribute := iXml.createAttribute('ATTR_VALUE');
              iAttribute.nodeValue := table.GetContent(i_row,i_col);
              iTableColumn.attributes.setNamedItem(iAttribute);
          end;
        row.Destroy;
      end;


      fXMLDocument.SaveToFile(fileName);
  end;
//------------------------------------------------------------------------------
end.
