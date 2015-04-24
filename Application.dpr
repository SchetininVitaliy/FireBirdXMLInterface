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
  // XML -> DB
  xmlCreator := TXMLSQLTableCreator.Create();
  sqlTable:=TSQLTable.Create;
  xmlCreator.CreateTableFromXML('table1.xml',sqlTable);
  sqlTable.Print();
  dbCreator := TDBSQLTableCreator.Create('C:\Users\vitaliy\Documents\TEST.FDB',
                                          'SYSDBA',
                                          'masterkey',
                                          'utf8');
  dbCreator.CreateDBTableFromTable('table1', sqlTable);
  sqlTable.Destroy;
  dbCreator.Destroy;
  xmlCreator.Destroy;


  //DB->XML
  dbCreator := TDBSQLTableCreator.Create('C:\Users\vitaliy\Documents\TEST.FDB',
                                          'SYSDBA',
                                          'masterkey',
                                          'utf8');

  sqlTable:=TSQLTable.Create;
  dbCreator.CreateTableFromDB('table1',sqlTable);
  sqlTable.Print;
  xmlCreator := TXMLSQLTableCreator.Create();
  xmlCreator.CreateXMLFromTable('table2.xml',sqlTable);

  xmlCreator.Destroy;
  dbCreator.Destroy;
  sqlTable.Destroy;
end.
