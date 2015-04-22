unit FireBird2XML_COM_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 22.04.2015 9:40:36 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Users\vitaliy\Documents\FireBirdXMLInterface\FireBird2XML_COM (1)
// LIBID: {05DBB025-AFA6-42C1-BB12-9B965225536D}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  FireBird2XML_COMMajorVersion = 1;
  FireBird2XML_COMMinorVersion = 0;

  LIBID_FireBird2XML_COM: TGUID = '{05DBB025-AFA6-42C1-BB12-9B965225536D}';

  IID_ISQLTable: TGUID = '{DD6FBA89-AFE5-4EEC-BCBC-8011200E764B}';
  CLASS_SQLTable: TGUID = '{E30AACF1-5F7C-49AB-A628-524561191A88}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  ISQLTable = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  SQLTable = ISQLTable;


// *********************************************************************//
// Interface: ISQLTable
// Flags:     (256) OleAutomation
// GUID:      {DD6FBA89-AFE5-4EEC-BCBC-8011200E764B}
// *********************************************************************//
  ISQLTable = interface(IUnknown)
    ['{DD6FBA89-AFE5-4EEC-BCBC-8011200E764B}']
  end;

// *********************************************************************//
// The Class CoSQLTable provides a Create and CreateRemote method to
// create instances of the default interface ISQLTable exposed by
// the CoClass SQLTable. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoSQLTable = class
    class function Create: ISQLTable;
    class function CreateRemote(const MachineName: string): ISQLTable;
  end;

implementation

uses System.Win.ComObj;

class function CoSQLTable.Create: ISQLTable;
begin
  Result := CreateComObject(CLASS_SQLTable) as ISQLTable;
end;

class function CoSQLTable.CreateRemote(const MachineName: string): ISQLTable;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SQLTable) as ISQLTable;
end;

end.

