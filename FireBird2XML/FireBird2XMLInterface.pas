unit FireBird2XMLInterface;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, FireBird2XML_TLB, StdVcl,
  SQLTable, DBSQLTableCreator, XMLSQlTableCreator;

type
//------------------------------------------------------------------------------
  TFireBird2XMLInterface = class(TTypedComObject, IFireBird2XMLInterface)
    fDBName : string;
    fDBUser : string;
    fDBPass : string;
    fDBEncode : string;
  protected
    function Run(type_, xmlFile, tableName, aliasFile: PAnsiChar): HResult; stdcall;
    function InitDB(dbName, dbUser, dbPass, dbEncode: PAnsiChar): HResult; stdcall;
  end;
//------------------------------------------------------------------------------
implementation
uses ComServ;
//------------------------------------------------------------------------------
function TFireBird2XMLInterface.Run(type_, xmlFile, tableName, aliasFile: PAnsiChar): HResult;

var
  xmlCreator:TXMLSQLTableCreator;
  dbCreator:TDBSQLTableCreator;
  sqlTable : TSQLTable;
begin
    // XML -> DB
    if type_ = 'import' then
    begin
      xmlCreator := TXMLSQLTableCreator.Create();
      sqlTable:=TSQLTable.Create;
      xmlCreator.CreateTableFromXML(xmlFile,sqlTable);
      sqlTable.Print();
      dbCreator := TDBSQLTableCreator.Create(fDBName,
                                              fDBUser,
                                              fDBPass,
                                              fDBEncode);
      dbCreator.CreateDBTableFromTable(tableName, sqlTable);
      sqlTable.Destroy;
      dbCreator.Destroy;
      xmlCreator.Destroy;
    end;

    // DB -> XML
    if type_ = 'export' then
    begin
      dbCreator := TDBSQLTableCreator.Create(fDBName,
                                              fDBUser,
                                              fDBPass,
                                              fDBEncode);

      sqlTable:=TSQLTable.Create;
      dbCreator.CreateTableFromDB(tableName,sqlTable);
      sqlTable.Print;
      xmlCreator := TXMLSQLTableCreator.Create();
      xmlCreator.CreateXMLFromTable(xmlFile,sqlTable);

      xmlCreator.Destroy;
      dbCreator.Destroy;
      sqlTable.Destroy;
    end;
end;
//------------------------------------------------------------------------------
function TFireBird2XMLInterface.InitDB(dbName, dbUser, dbPass, dbEncode: PAnsiChar): HResult;
begin
    fDBName := dbName;
    fDBUser := dbUser;
    fDBPass := dbPass;
    fDBEncode := dbEncode;
end;
//------------------------------------------------------------------------------
initialization
  TTypedComObjectFactory.Create(ComServer, TFireBird2XMLInterface, Class_FireBird2XMLInterface,
    ciMultiInstance, tmApartment);
end.
