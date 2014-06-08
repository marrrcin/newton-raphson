library IntervalFunctions1;

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
  IntervalArithmetic32and64 in '..\IntervalArithmetic32and64.pas',
  uTExtendedX87 in '..\uTExtendedX87.pas';

type Extended = TExtendedX87;
function f (x : interval) : interval;
var z,tmp,tmp2,tmp3 : interval;
stat : Integer;
begin
  stat:=2;
  z:=isqr(x,stat);
  tmp.a:=5;
  tmp.b:=5;
  tmp2:=isub(z,tmp);//tmp=z*(z-5)
  tmp.a:=4;
  tmp.b:=4;
  tmp3:=imul(z,tmp2);
  f:=iadd(tmp3,tmp);
  //f:=z*(z-5)+4
end;

function df (x : interval) : interval;
var tmp,tmp2,tmp3 : interval;
stat : Integer;
begin
  tmp.a:=4;
  tmp.b:=4;
  tmp:=imul(tmp,x);//4*x
  tmp2:=isqr(x,stat);//x*x
  tmp3:=int_read('2,5');
  tmp3:=isub(tmp2,tmp3);//x*x-2.5
  df:=imul(tmp,tmp3);
  //df:=4*x*(x*x-2.5)
end;

function d2f (x : interval) : interval;
var tmp,tmp2:interval;
stat : Integer;
begin
  tmp:=int_read('12');
  tmp2:=isqr(x,stat);//x*x
  tmp:=imul(tmp,tmp2);//12*x*x
  tmp2:=int_read('10');
  d2f:=isub(tmp,tmp2);
  //d2f:=12*x*x-10
end;

exports
  f name 'f',
  df name 'df',
  d2f name 'd2f';



{$R *.res}



end.
