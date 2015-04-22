program Application;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  FireBird2XML_COM_TLB in '..\Embarcadero\Studio\16.0\Imports\FireBird2XML_COM_TLB.pas',
  XMLDoc,
  XMLIntf,
  Variants,
  SQLTable in 'SQLTable.pas',
  SQLTableCreator in 'SQLTableCreator.pas',
  XMLSQLTableCreator in 'XMLSQLTableCreator.pas';

var
  xmlCreator:TXMLSQLTableCreator;
begin
    xmlCreator := TXMLSQLTableCreator.Create('table1.xml');

end.
