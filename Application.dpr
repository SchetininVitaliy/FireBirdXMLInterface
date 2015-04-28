program Application;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  FireBird2XML_TLB in 'FireBird2XML_TLB.pas';

var
  fb2xml : IFireBird2XMLInterface;
begin
  fb2xml := CoFireBird2XMLInterface.Create;
  fb2xml.InitDB('C:\Users\vitaliy\Documents\TEST.FDB', 'SYSDBA', 'masterkey', 'WIN1251');
  fb2xml.Run('export', 'table1.xml', 'TABLE1', 'C:\Users\vitaliy\Documents\FireBirdXMLInterface\Win32\Debug\aliases.ini');
end.
