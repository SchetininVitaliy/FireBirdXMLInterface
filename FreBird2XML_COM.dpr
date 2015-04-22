library FreBird2XML_COM;

uses
  ComServ,
  FireBird2XML_COM_TLB in 'FireBird2XML_COM_TLB.pas',
  SQLTable_COM in 'SQLTable_COM.pas' {SQLTable: CoClass};

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
