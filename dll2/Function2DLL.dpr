library Function2DLL;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  uTExtendedX87 in '..\uTExtendedX87.pas';

type fx = function (x : Extended) : Extended;
type Extended = TExtendedX87;

function f (x : Extended) : Extended; stdcall;
var s : Extended;
begin
  s:=Sin(x);
  f:=s*(s+0.5)-0.5
end;

function df (x : Extended) : Extended; stdcall;
begin
  df:=Sin(2*x)+0.5*Cos(x)
end;

function d2f (x : Extended) : Extended; stdcall;
begin
  d2f:=2*Cos(2*x)-0.5*Sin(x)
end;

exports
  f name 'function',
  df name 'derivative',
  d2f name 'second';

  {$R *.res}
end.
