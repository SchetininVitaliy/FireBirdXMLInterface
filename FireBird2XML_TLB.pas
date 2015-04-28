unit FireBird2XML_TLB;

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
// File generated on 27.04.2015 10:44:37 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Users\vitaliy\Documents\FireBirdXMLInterface\FireBird2XML\Win32\Debug\FireBird2XML.dll (1)
// LIBID: {9A7B05E1-95CE-4E09-BFC3-2DC46838772A}
// LCID: 0
// Helpfile: 
// HelpString: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Hint: Parameter 'type' of IFireBird2XMLInterface.Run changed to 'type_'
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
  FireBird2XMLMajorVersion = 1;
  FireBird2XMLMinorVersion = 0;

  LIBID_FireBird2XML: TGUID = '{9A7B05E1-95CE-4E09-BFC3-2DC46838772A}';

  IID_IFireBird2XMLInterface: TGUID = '{5F06E82C-D47F-4F1D-995A-DA9AA368ABBB}';
  CLASS_FireBird2XMLInterface: TGUID = '{7AEB0AFC-0801-446C-AED5-336F71B60AC8}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFireBird2XMLInterface = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FireBird2XMLInterface = IFireBird2XMLInterface;


// *********************************************************************//
// Interface: IFireBird2XMLInterface
// Flags:     (256) OleAutomation
// GUID:      {5F06E82C-D47F-4F1D-995A-DA9AA368ABBB}
// *********************************************************************//
  IFireBird2XMLInterface = interface(IUnknown)
    ['{5F06E82C-D47F-4F1D-995A-DA9AA368ABBB}']
    function Run(type_: PAnsiChar; xmlFile: PAnsiChar; tableName: PAnsiChar; aliasFile: PAnsiChar): HResult; stdcall;
    function InitDB(dbName: PAnsiChar; dbUser: PAnsiChar; dbPass: PAnsiChar; dbEncode: PAnsiChar): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoFireBird2XMLInterface provides a Create and CreateRemote method to          
// create instances of the default interface IFireBird2XMLInterface exposed by              
// the CoClass FireBird2XMLInterface. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFireBird2XMLInterface = class
    class function Create: IFireBird2XMLInterface;
    class function CreateRemote(const MachineName: string): IFireBird2XMLInterface;
  end;

implementation

uses System.Win.ComObj;

class function CoFireBird2XMLInterface.Create: IFireBird2XMLInterface;
begin
  Result := CreateComObject(CLASS_FireBird2XMLInterface) as IFireBird2XMLInterface;
end;

class function CoFireBird2XMLInterface.CreateRemote(const MachineName: string): IFireBird2XMLInterface;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FireBird2XMLInterface) as IFireBird2XMLInterface;
end;

end.
