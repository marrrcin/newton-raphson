unit NewtonRaphsonUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTExtendedX87, Vcl.StdCtrls,
  Vcl.ExtCtrls,IntervalArithmetic32and64, Vcl.Buttons ;

type Extended = TExtendedX87;
type fx = function (x: Extended) : Extended;
type ifx = function (x: interval) : interval;
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
    intervalPanel: TPanel;
    resultRightTextBox: TEdit;
    functionValueRightTextBox: TEdit;
    Label9: TLabel;
    Label11: TLabel;
    SpeedButton1: TSpeedButton;
    Button4: TButton;
    procedure RadioButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckDllFile();
    procedure LoadAndCheckDllFunction(dllHandler:THandle;functionName:String);
    procedure LoadAndCheckDllIntervalFunction(dllHandler:THandle;functionName:String);
    procedure WriteResults(result:Extended;fResultValue:Extended;iterations:Integer;status:Integer);
    procedure WriteResultsInterval(result:interval;fResultValue:interval;iterations:Integer;status:Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SwitchInputPanel();
    procedure namesCheckBoxClick(Sender: TObject);
    procedure SwitchFunctionNames(CustomNamesSelected:Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
  radioButtons : Array[1..3] of TRadioButton;
  dllFilePath : String;
  functionNames : Array[1..3] of String;
  groupBoxLabel : String;
  intervalResult : interval;

    { Public declarations }
  end;



{ wazne! przy obliczaniu w arytmecyte przedzia³owej, w wyniku nale¿y podaæ
  szerokoœæ przedziau (int width z bilbioteki IntervalArithmetic }

var
  Form1: TForm1;

implementation
{$R *.dfm}
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
         else
         begin
           NewtonRaphson:=0;
         end;
end;


function iabs(int : interval):interval;
var
	absA,absB : Extended;
begin
  absA:=abs(int.a);
  absB:=abs(int.b);

	if(absA>absB) then
	begin
		iabs.a:=absB;
		iabs.b:=absA;
	end
	else
	begin
		iabs.a:=absA;
		iabs.b:=absB;
	end;

  if(int.a<=0) and (int.b>=0) then
    iabs.a:=0;

end;

function iabs2(x : interval) : interval;
begin
  if (x.a <= 0) and (x.b >= 0) then
  begin
    iabs2.a := 0;
    iabs2.b := x.b
  end
  else if x.b < 0 then
  begin
    iabs2.a := -x.b;
    iabs2.b := -x.a;
  end
  else
    iabs2.a := x.a;
    iabs2.b := x.b;

end;

function imax(var int1,int2:interval):interval;
begin
	if(int1.a<=int2.a) and (int1.b<=int2.b) then
		imax:=int2
	else
		imax:=int1;

end;

function isqrt(int : interval):interval;
begin
  isqrt.a:=sqrt(int.a);
  isqrt.b:=sqrt(int.b);
end;

function isIntervalGreater(int1,int2 : interval):Boolean;
var tmp : interval;
begin
	if(int1.a>int2.a) and (int1.b>int2.b) then
    isIntervalGreater:=True
  else
    isIntervalGreater:=False;
end;

function isIntervalSmaller(int1,int2 : interval):Boolean;
var tmp:interval;
begin
  if(int1.a<int2.a) and (int1.b<int2.b) then
    isIntervalSmaller:=True
  else
    isIntervalSmaller:=False;
end;

function containsZero(const int : interval): Boolean;
begin
  if(int.a<0) and (int.b>0) then
    containsZero:=True
  else if(int.a=0) or (int.b=0) then
    containsZero:=True
  else
    containsZero:=False;
end;

function NewtonRaphsonInterval(var x : interval;
							   f,df,d2f : ifx;
							   mit : Integer;
							   eps : Extended;
                 var ifatx:interval;
							   var it,st : Integer) : interval;


var fAtX,dfAtX,d2fAtX,p,tmp1,tmp2,two,xh,w,v,x1,x2 : interval;
null : Integer;
begin
	if mit<1 then
		st:=1
		else
		begin
			st:=3;
			it:=0;
			two.a:=2;
			two.b:=2;
			repeat
				it:=it+1;

				//wartosci funkcji i pochodnych w punkcie (interwale) x

        fAtX:=f(x);
        dfAtX:=df(x);
        d2fAtX:=d2f(x);

				//liczba pod pierwiastkiem wzoru (licznik)
				tmp1:=imul(dfAtX,dfAtX);
				tmp2:=imul(fAtX,d2fAtX);
				tmp2:=imul(two,tmp2);
				p:=isub(tmp1,tmp2);

				//do sprawdzenia  , pierwotnie : (p.a<0) or (p.b<0)
        //amarciniak : wystarczy sprawdzic prawy koniec
				if (p.b<0) then
					st:=4
				else
				if containsZero(d2fAtX) then
					st:=2
				else
				begin
					xh:=x;
					w:=iabs(xh);

          //na pewno? czy napisac?
					p:=isqrt(p);

					//tmp1:=isub(dfAtX,p);
					//tmp1:=idiv(tmp1,d2fAtX);
					//x1:=isub(x,tmp1);
          x1:=isub(x,idiv(isub(dfAtX,p),d2fAtX));


 					//tmp2:=iadd(dfAtX,p);
					//tmp2:=idiv(tmp2,d2fAtX);
					//x2:=isub(x,tmp2);
          x2:=isub(x,idiv(iadd(dfAtX,p),d2fAtX));

					//znowu do sprawdzenia
					tmp1:=isub(x1,xh);
					tmp1:=iabs(tmp1);

					tmp2:=isub(x2,xh);
					tmp2:=iabs(tmp2);

					if isIntervalGreater(tmp2,tmp1) then
						x:=x1
					else
						x:=x2;

					v:=iabs(x);
					if isIntervalSmaller(v,w) then
						v:=w;

					//and czy or?
					if (v.a=0) or (v.b=0) then
						st:=0
					else
						begin

							tmp1:=isub(x,xh);
							tmp2:=iabs(tmp1);
							tmp1:=idiv(iabs(tmp2),v);
							//tmp2.a:=eps;
							//tmp2.b:=eps;

              if(tmp1.a<=eps) and (tmp1.b<=eps) then
                st:=0;

							//if isIntervalGreater(tmp2,tmp1) then
							 //	st:=0
						end;


				end
			until(it=mit) or (st<>3)
		end;

	if (st=0) or (st=3) then
	begin
    ifatx:=f(x);
 		NewtonRaphsonInterval:=x;
	end
  else
  begin
    NewtonRaphsonInterval.a:=0;
    NewtonRaphsonInterval.b:=0;
  end;
end;




procedure TForm1.Button1Click(Sender: TObject);
begin
  if(OpenDialog.Execute()) then
    begin
       dllFilePath:=OpenDialog.FileName;
    end;
    fileTextBox.Text:=dllFilePath;
    CheckDllFile;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  radioButtons[1]:=RadioButton1;
  radioButtons[2]:=RadioButton2;
  radioButtons[3]:=RadioButton3;
  SwitchFunctionNames(false);
  dllFilePath:='';
  intervalResult.a:=0;
  intervalResult.b:=0;

  groupBoxLabel:=' Dane do obliczeñ ';
  SwitchInputPanel;

  Form1.Height:=450;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var int : interval;
begin
    ShowMessage(FloatToStr(int_width(intervalResult)));
end;

procedure TForm1.SwitchFunctionNames(CustomNamesSelected: Boolean);
begin
  if(CustomNamesSelected) then
  begin
    functionNames[1]:=fNameTextBox.Text;
    functionNames[2]:=dfNameTextBox.Text;
    functionNames[3]:=d2fNameTextBox.Text;
  end
  else
  begin
    functionNames[1]:='f';
    functionNames[2]:='df';
    functionNames[3]:='d2f';
  end;
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
    if(Form1.radioButtons[1].Checked) then
      GroupBox1.Caption:=groupBoxLabel+'(arytmetyka zmiennoprzecinkowa)'
    else
      GroupBox1.Caption:=groupBoxLabel+'(artymetyka przedzia³owa)';

    fullInterval:=radioButtons[3].Checked;
    startApproximationRightTextBox.Visible:=fullInterval;
    labelSemiColon1.Visible:=fullInterval;
    intervalPanel.Visible:=fullInterval or radioButtons[2].Checked;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  dllHandler : THandle;
  fileName : PWideChar;
  functionName : PWideChar;
  x : Extended;
  ix : interval;
  functions : Array [1..3] of fx;
  ifunctions : Array [1..3] of ifx;
  f,df,d2f : fx;
  //ifunc,idf,id2f:ifx;
  result : Extended;
  maxIterations : Integer;
  epsilon : Extended;
  doneIterations : Integer;
  fResultValue : Extended;
  ifResultValue : interval;
  status : Integer;
  iresult : interval;
  ileft : String;
  iright : String;
  i: Integer;
begin
  if(dllErrorTextBox.Visible=True) then
    Exit;

  try
    fileName:=Addr(dllFilePath[1]);
    dllHandler:=LoadLibrary(fileName);
    SwitchFunctionNames(namesCheckBox.Checked);

    //wczytanie funkcji z dll
    for i := 1 to 3 do
    begin
        functionName:=Addr(functionNames[i][1]);
        if(radioButtons[1].Checked) then
          @functions[i]:=GetProcAddress(dllHandler,functionName)
        else
          @ifunctions[i]:=GetProcAddress(dllHandler,functionName);
    end;

    maxIterations:=StrToInt(maxIterationsTextBox.Text);
    epsilon:=StrToFloat(epsilonTextBox.Text);


    if(radioButtons[1].Checked) then
    begin
       x:=StrToFloat(startApproximationTextBox.Text); //pewnie trzeba bedzie zamienic!!!!!!
       result:=NewtonRaphson(x,functions[1],functions[2],functions[3],maxIterations,epsilon,fResultValue,doneIterations,status);
       WriteResults(result,fResultValue,doneIterations,status);
    end
    else
    begin
      ix.a:=left_read(startApproximationTextBox.Text);
      if(radioButtons[2].Checked) then
        startApproximationRightTextBox.Text:=startApproximationTextBox.Text;
      ix.b:=right_read(startApproximationRightTextBox.Text);
      iresult:=NewtonRaphsonInterval(ix,ifunctions[1],ifunctions[2],ifunctions[3],maxIterations,epsilon,ifResultValue,doneIterations,status);
      intervalResult:=iresult;
      try
         WriteResultsInterval(iresult,ifResultValue,doneIterations,status);
      except
         statusLabel.Caption:=IntToStr(status);
      end;

    end;


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
end;



procedure TForm1.Button4Click(Sender: TObject);
var
  pk,my,tmp : interval;
  c : integer;
begin
  Val(startApproximationTextBox.Text,tmp.a,c);
  Val(startApproximationRightTextBox.Text,tmp.b,c);
  pk:=iabs2(tmp);
  my:=iabs(tmp);
  ShowMessage('My : '+FloatToStr(my.a)+';'+FloatToStr(my.b)+'\nPK : '+FloatToStr(pk.a)+';'+FloatToStr(pk.b));
end;

function GetStatus(status:Integer):String;
begin
  if(status=0) then
    GetStatus:='OK (0)'
  else if(status=1) then
    GetStatus:='Za malo iteracji (1)'
  else if(status=2) then
    GetStatus:='Druga pochodna miala wartosc 0 dla pewnego x (2)'
  else if(status=3) then
    GetStatus:='Nie uzyskano podanej dokladnosci w zadanej liczbie krokow (3)'
  else
    GetStatus:='Proba wyciagniecia pierwiastka z liczby ujemnej (4)';
end;

procedure TForm1.WriteResults(result:Extended;fResultValue:Extended;iterations:Integer;status:Integer);
begin
  resultTextBox.Text:=FloatToStr(result);
  functionValueTextBox.Text:=FloatToStr(fResultValue);
  iterationsTextBox.Text:=FloatToStr(iterations);
  statusLabel.Caption:=GetStatus(status);
end;

procedure TForm1.WriteResultsInterval(result:interval;fResultValue:interval;iterations:Integer;status:Integer);
var
  left,right,fLeft,fRight:String;
begin
  iends_to_strings(result,left,right);
  iends_to_strings(fResultValue,fLeft,fRight);

  resultTextBox.Text:=left;
  resultRightTextBox.Text:=right;
  functionValueTextBox.Text:=fLeft;
  functionValueRightTextBox.Text:=fRight;
  iterationsTextBox.Text:=FloatToStr(iterations);
  statusLabel.Caption:=GetStatus(status);
end;

procedure TForm1.namesCheckBoxClick(Sender: TObject);
var
  checked : Boolean;
begin
  checked:=namesCheckBox.Checked;
  fNameTextBox.Enabled:=checked;
  dfNameTextBox.Enabled:=checked;
  d2fNameTextBox.Enabled:=checked;

  SwitchFunctionNames(checked);

end;



procedure TForm1.CheckDllFile;
var
  dllHandler : THandle;
  fileName : PWideChar;
begin
  if(dllFilePath='') then
  begin
    dllErrorTextBox.Visible:=True;
    Exit;
  end;

  SwitchFunctionNames(namesCheckBox.Checked);

  try
    fileName:=Addr(dllFilePath[1]);
    dllHandler:=LoadLibrary(fileName);

    try
      if radioButtons[1].Checked then
      begin
        LoadAndCheckDllFunction(dllHandler,functionNames[1]);
        LoadAndCheckDllFunction(dllHandler,functionNames[2]);
        LoadAndCheckDllFunction(dllHandler,functionNames[3]);
      end
      else
      begin
        LoadAndCheckDllIntervalFunction(dllHandler,functionNames[1]);
        LoadAndCheckDllIntervalFunction(dllHandler,functionNames[2]);
        LoadAndCheckDllIntervalFunction(dllHandler,functionNames[3]);
      end;
      dllErrorTextBox.Visible:=False;
    except
      on Ex : Exception do
      begin
        dllErrorTextBox.Caption:='B³¹d! Plik nie zawiera funkcji '+Ex.Message;
        dllErrorTextBox.Visible:=True;
      end;
    end;
  finally
    FreeLibrary(dllHandler);
  end;


end;

procedure TForm1.LoadAndCheckDllFunction(dllHandler:THandle;functionName:String);
var
  dllFunction : fx;
  name : PWideChar;
begin
    name := Addr(functionName[1]);
    @dllFunction:=GetProcAddress(dllHandler,name);
    if(@dllFunction=nil) then raise Exception.Create(functionName);
end;

procedure TForm1.LoadAndCheckDllIntervalFunction(dllHandler:THandle;functionName:String);
var
dllFunction : ifx;
name : PWideChar;
begin
    name := Addr(functionName[1]);
    @dllFunction:=GetProcAddress(dllHandler,name);
    if(@dllFunction=nil) then raise Exception.Create(functionName);
end;

end.
