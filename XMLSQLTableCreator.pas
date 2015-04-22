unit XMLSQLTableCreator;

interface
  uses
    SQLTableCreator,
    SQLTable,
    XMLDoc,
    XMLIntf;
type
  TXMLSQLTableCreator = class(TSQLTableCreator)
    fFileName:string;
    fXMLDocument: IXMLDocument;

    procedure CreateTable(var table:TSQLTable);
    constructor Create(fileName:string);
    destructor Destroy;
  end;
implementation

  constructor TXMLSQLTableCreator.Create(fileName:string);
  begin
      fFileName:=fileName;
      fXMLDocument := TXMLDocument.Create(nil);
      fXMLDocument.LoadFromFile(fFileName);
  end;

  destructor TXMLSQLTableCreator.Destroy;
  begin

  end;

   procedure TXMLSQLTableCreator.CreateTable(var table:TSQLTable);
   begin

   end;
end.
