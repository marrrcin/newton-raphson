unit NewtonRaphsonUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTExtendedX87, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type Extended = TExtendedX87;
type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    startApproximationTextBox: TEdit;
    fileTextBox: TEdit;
    maxIterationsTextBox: TEdit;
    epsilonTextBox: TEdit;
    Button1: TButton;
    OpenDialog: TOpenDialog;
    Button2: TButton;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    resultTextBox: TEdit;
    functionValueTextBox: TEdit;
    iterationsTextBox: TEdit;
    Label9: TLabel;
    procedure RadioButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
  radioButtons : Array[1..3] of TRadioButton;
  dllFilePath : String;
    { Public declarations }
  end;


type
  fx = function (x: Extended) : Extended;
var
  Form1: TForm1;

implementation

function f (x : Extended) : Extended;
var z : Extended;
begin
  z:=x*x;
  f:=z*(z-5)+4
end;
function df (x : Extended) : Extended;
begin
  df:=4*x*(x*x-2.5)
end;
function d2f (x : Extended) : Extended;
begin
  d2f:=12*x*x-10
end;

function NewtonRaphson (var x     : Extended;
                        f,df,d2f  : fx;
                        mit       : Integer;
                        eps       : Extended;
                        var fatx  : Extended;
                        var it,st : Integer) : Extended;
var dfatx,d2fatx,p,v,w,xh,x1,x2 : Extended;
begin
  if mit<1
    then st:=1
    else begin
           st:=3;
           it:=0;
           repeat
             it:=it+1;
             fatx:=f(x);
             dfatx:=df(x);
             d2fatx:=d2f(x);
             p:=dfatx*dfatx-2*fatx*d2fatx;
             if p<0
               then st:=4
               else if d2fatx=0
                      then st:=2
                      else begin
                             xh:=x;
                             w:=abs(xh);
                             p:=sqrt(p);
                             x1:=x-(dfatx-p)/d2fatx;
                             x2:=x-(dfatx+p)/d2fatx;
                             if abs(x2-xh)>abs(x1-xh)
                               then x:=x1
                               else x:=x2;
                             v:=abs(x);
                             if v<w
                               then v:=w;
                             if v=0
                               then st:=0
                               else if abs(x-xh)/v<=eps
                                      then st:=0
                           end
           until (it=mit) or (st<>3)
         end;
  if (st=0) or (st=3)
    then begin
           NewtonRaphson:=x;
           fatx:=f(x)
         end
end;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if(OpenDialog.Execute()) then
    begin
       dllFilePath:=OpenDialog.FileName;
    end;
    fileTextBox.Text:=dllFilePath;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  radioButtons[1]:=RadioButton1;
  radioButtons[2]:=RadioButton2;
  radioButtons[3]:=RadioButton3;
  dllFilePath:='';
end;


procedure TForm1.RadioButtonClick(Sender: TObject);
var
  i: Integer;
begin
     for i := 1 to 3 do
      begin
      if(Form1.radioButtons[i]=(Sender as TRadioButton)) then
        Continue
        else
          Form1.radioButtons[i].Checked:=False;
      end;
end;


end.
