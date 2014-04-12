program NewtonRaphson;

uses
  Vcl.Forms,
  NewtonRaphsonUnit1 in 'NewtonRaphsonUnit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
