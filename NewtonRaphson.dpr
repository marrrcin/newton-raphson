program NewtonRaphson;

uses
  Vcl.Forms,
  NewtonRaphsonUnit1 in 'NewtonRaphsonUnit1.pas' {Form1},
  IntervalArithmetic32and64 in 'IntervalArithmetic32and64.pas',
  uTExtendedX87 in 'uTExtendedX87.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
