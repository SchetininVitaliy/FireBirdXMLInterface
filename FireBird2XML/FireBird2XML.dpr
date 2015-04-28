library FireBird2XML;

uses
  ComServ,
  FireBird2XML_TLB in 'FireBird2XML_TLB.pas',
  FireBird2XMLInterface in 'FireBird2XMLInterface.pas' {FireBird2XMLInterface: CoClass},
  DBSQLTableCreator in 'DBSQLTableCreator.pas',
  XMLSQLTableCreator in 'XMLSQLTableCreator.pas',
  SQLTableCreator in 'SQLTableCreator.pas',
  SQLTable in 'SQLTable.pas',
  Support in 'Support.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer,
  DllInstall;

{$R *.TLB}

{$R *.RES}

begin
end.
