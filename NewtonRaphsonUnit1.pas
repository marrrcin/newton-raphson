unit NewtonRaphsonUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTExtendedX87, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type Extended = TExtendedX87;
type fx = function (x: Extended) : Extended;
type interval = record
                  a, b : Extended
                end;
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
    statusLabel: TLabel;
    dllErrorTextBox: TLabel;
    Label10: TLabel;
    Button3: TButton;
    startApproximationRightTextBox: TEdit;
    labelSemiColon1: TLabel;
    fNameTextBox: TEdit;
    namesCheckBox: TCheckBox;
    dfNameTextBox: TEdit;
    d2fNameTextBox: TEdit;
    procedure RadioButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckDllFile();
    procedure LoadAndCheckDllFunction(dllHandler:THandle;functionName:String);
    procedure LoadFunctionsFromDll(dllHandler:THandle;f:fx;df:fx;d2f:fx);
    procedure WriteResults(result:Extended;fResultValue:Extended;iterations:Integer;status:Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SwitchInputPanel();
    procedure namesCheckBoxClick(Sender: TObject);
    procedure switchFunctionNames(CustomNamesSelected:Boolean);
  private
    { Private declarations }
  public
  radioButtons : Array[1..3] of TRadioButton;
  dllFilePath : String;
  functionNames : Array[1..3] of PWideChar;
    { Public declarations }
  end;



{ wazne! przy obliczaniu w arytmecyte przedzia³owej, w wyniku nale¿y podaæ
  szerokoœæ przedziau (int width z bilbioteki IntervalArithmetic }

var
  Form1: TForm1;

implementation

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

             //wartoœci funkcji i pochodnych w obecnym punkcie x
             fatx:=f(x);
             dfatx:=df(x);
             d2fatx:=d2f(x);

             //liczba pod pierwiastkiem wzoru (licznik)
             p:=dfatx*dfatx-2*fatx*d2fatx;
             if p<0
               then st:=4
               else if d2fatx=0
                      then st:=2
                      else begin
                             xh:=x;
                             w:=abs(xh);
                             p:=sqrt(p);
                             x1:=x-(dfatx-p)/d2fatx; //wariant z +
                             x2:=x-(dfatx+p)/d2fatx;  //wariant z -
                             if abs(x2-xh)>abs(x1-xh) //wybranie mniejszej wartosci
                               then x:=x1
                               else x:=x2;
                             v:=abs(x);
                             if v<w           //wybranie max (x_i+1 i x_i)
                               then v:=w;
                             if v=0        //nie dzielimy przez 0
                               then st:=0
                               else if abs(x-xh)/v<=eps  //warunek stopu
                                      then st:=0
                           end
           until (it=mit) or (st<>3) //konczy jesli status byl inny niz 3 lub wyczerpano liczbe iteracji
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
    fileTextBox2.Text:=dllFilePath;
    CheckDllFile;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  radioButtons[1]:=RadioButton1;
  radioButtons[2]:=RadioButton2;
  radioButtons[3]:=RadioButton3;
  functionNames[1]:='f';
  functionNames[2]:='df';
  functionNames[3]:='d2f';
  dllFilePath:='';
  Form1.Height:=450;
end;

procedure TForm1.switchFunctionNames(CustomNamesSelected: Boolean);
begin
  //
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
      SwitchInputPanel;
end;

procedure TForm1.SwitchInputPanel;
var
    fullInterval : Boolean;
begin
  if(Form1.radioButtons[1].Checked) then //wybrano arytmetyke zmiennoprzecinkowa
  begin
    GroupBox1.Visible:=True;
    GroupBox2.Visible:=True;
    GroupBox3.Visible:=False;
    GroupBox4.Visible:=False;
  end
  else
  begin
    fullInterval:=Form1.radioButtons[3].Checked;
    GroupBox1.Visible:=False;
    GroupBox2.Visible:=False;
    GroupBox3.Visible:=True;
    GroupBox4.Visible:=True;
    startApproximationRightTextBox.Visible:=fullInterval;
    labelSemiColon1.Visible:=fullInterval;
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  dllHandler : THandle;
  fileName : PWideChar;
  x : Extended;
  f,df,d2f : fx;
  result : Extended;
  maxIterations : Integer;
  epsilon : Extended;
  doneIterations : Integer;
  fResultValue : Extended;
  status : Integer;
begin
  if(dllErrorTextBox.Visible=True) then
    Exit;

  try
    fileName:=Addr(dllFilePath[1]);
    dllHandler:=LoadLibrary(fileName);
    @f:=GetProcAddress(dllHandler,'f');
    @df:=GetProcAddress(dllHandler,'df');
    @d2f:=GetProcAddress(dllHandler,'d2f');

    x:=StrToFloat(startApproximationTextBox.Text); //pewnie trzeba bedzie zamienic!!!!!!
    maxIterations:=StrToInt(maxIterationsTextBox.Text);
    epsilon:=StrToFloat(epsilonTextBox.Text);

    result:=NewtonRaphson(x,f,df,d2f,maxIterations,epsilon,fResultValue,doneIterations,status);

    WriteResults(result,fResultValue,doneIterations,status);
  finally
    FreeLibrary(dllHandler);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  defaultValue : String;
begin
  defaultValue:='0,0000000000000001';
  epsilonTextBox.Text:=defaultValue;
  epsilonIntervalTextBox.Text:=defaultValue;
end;

procedure TForm1.WriteResults(result:Extended;fResultValue:Extended;iterations:Integer;status:Integer);
begin
  resultTextBox.Text:=FloatToStr(result);
  functionValueTextBox.Text:=FloatToStr(fResultValue);
  iterationsTextBox.Text:=FloatToStr(iterations);
  statusLabel.Caption:=IntToStr(status);
end;

procedure TForm1.namesCheckBoxClick(Sender: TObject);
var
  checked : Boolean;
begin
  checked:=namesCheckBox.Checked;
  fNameTextBox.Enabled:=checked;
  dfNameTextBox.Enabled:=checked;
  d2fNameTextBox.Enabled:=checked;


end;

procedure TForm1.CheckDllFile;
var
  dllHandler : THandle;
  fileName : PWideChar;
begin
  if(dllFilePath='') then
  begin
    dllErrorTextBox.Visible:=True;
    dllErrorTextBox2.Visible:=True;
    Exit;
  end;

  try
    fileName:=Addr(dllFilePath[1]);
    dllHandler:=LoadLibrary(fileName);

    try
      LoadAndCheckDllFunction(dllHandler,'f');
      LoadAndCheckDllFunction(dllHandler,'df');
      LoadAndCheckDllFunction(dllHandler,'d2f');
      dllErrorTextBox.Visible:=False;
      dllErrorTextBox2.Visible:=False;
    except
      dllErrorTextBox.Visible:=True;
      dllErrorTextBox2.Visible:=True;
    end;
  finally
    FreeLibrary(dllHandler);
  end;


end;

procedure TForm1.LoadAndCheckDllFunction(dllHandler:THandle;functionName:String);
var
  dllFunction : fx;
  fName : PWideChar;
begin
    fName:=Addr(functionName[1]);
    @dllFunction:=GetProcAddress(dllHandler,fName);
    if(@dllFunction=nil) then raise Exception.Create('DLL error');
end;

procedure TForm1.LoadFunctionsFromDll(dllHandler:THandle;f: fx; df: fx; d2f: fx);
begin
  @f:=GetProcAddress(dllHandler,'f');
  @df:=GetProcAddress(dllHandler,'df');
  @d2f:=GetProcAddress(dllHandler,'d2f');
end;


end.
