unit SQLTable_COM;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, FireBird2XML_COM_TLB, StdVcl;

type
  TSQLTable = class(TTypedComObject, ISQLTable)
  protected
  end;

implementation

uses ComServ;

initialization
  TTypedComObjectFactory.Create(ComServer, TSQLTable, Class_SQLTable,
    ciMultiInstance, tmApartment);
end.
