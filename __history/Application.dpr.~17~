program Application;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  FireBird2XML_COM_TLB in '..\Embarcadero\Studio\16.0\Imports\FireBird2XML_COM_TLB.pas',
  XMLDoc,
  XMLIntf,
  Variants,
  Data.DB,
  IBX.IBDatabase,
  IBX.IBQuery,
  IBX.IBCustomDataSet,
  SQLTable in 'SQLTable.pas',
  SQLTableCreator in 'SQLTableCreator.pas',
  XMLSQLTableCreator in 'XMLSQLTableCreator.pas',
  DBSQLTableCreator in 'DBSQLTableCreator.pas';

var
  xmlCreator:TXMLSQLTableCreator;
  dbCreator:TDBSQLTableCreator;
  sqlTable:TSQLTable;
begin
  xmlCreator := TXMLSQLTableCreator.Create();
  sqlTable:=TSQLTable.Create;
  xmlCreator.CreateTableFromXML('table1.xml',sqlTable);
  sqlTable.Print();
  xmlCreator.Destroy;

  xmlCreator := TXMLSQLTableCreator.Create();
  xmlCreator.CreateXMLFromTable('table2.xml',sqlTable);
  xmlCreator.Destroy;
  sqlTable.Destroy;

  dbCreator := TDBSQLTableCreator.Create('C:\Users\vitaliy\Documents\TEST.FDB',
                                          'SYSDBA',
                                          'masterkey',
                                          'utf8');

  sqlTable:=TSQLTable.Create;
  dbCreator.CreateTableFromDB('NEW_TABLE',sqlTable);
  sqlTable.Print;
  dbCreator.CreateDBTableFromTable('NEW_TABLE1', sqlTable);
  sqlTable.Destroy;
end.
