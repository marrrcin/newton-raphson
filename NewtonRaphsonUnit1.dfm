object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 
    'Program do rozwi'#261'zywania r'#243'wnania nieliniowego metod'#261' Newtona-Ra' +
    'phsona'
  ClientHeight = 700
  ClientWidth = 882
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 169
    Height = 700
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 53
      Width = 97
      Height = 13
      Caption = 'Wybierz arytmetyk'#281
    end
    object RadioButton2: TRadioButton
      Left = 24
      Top = 95
      Width = 129
      Height = 17
      Caption = 'przedzia'#322'owa (liczby)'
      TabOrder = 0
      OnClick = RadioButtonClick
    end
    object RadioButton1: TRadioButton
      Left = 24
      Top = 72
      Width = 113
      Height = 17
      Caption = 'zmiennopozycyjna'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = RadioButtonClick
    end
    object RadioButton3: TRadioButton
      Left = 24
      Top = 118
      Width = 113
      Height = 17
      Caption = 'przedzia'#322'owa'
      TabOrder = 2
      OnClick = RadioButtonClick
    end
  end
  object Panel2: TPanel
    Left = 169
    Top = 0
    Width = 713
    Height = 700
    Align = alClient
    AutoSize = True
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 711
      Height = 208
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      Caption = '(arytmetyka zmiennopozycyjna) '
      Color = clBtnFace
      Ctl3D = True
      Padding.Left = 10
      Padding.Top = 10
      Padding.Right = 10
      Padding.Bottom = 10
      ParentBackground = False
      ParentColor = False
      ParentCtl3D = False
      TabOrder = 0
      object Label2: TLabel
        Left = 96
        Top = 29
        Width = 185
        Height = 13
        Caption = 'Pocz'#261'tkowe przybli'#380'enie pierwsiastka :'
      end
      object Label3: TLabel
        Left = 96
        Top = 57
        Width = 139
        Height = 13
        Caption = 'Plik DLL z funkcjami f,df,d2f :'
      end
      object Label4: TLabel
        Left = 96
        Top = 112
        Width = 129
        Height = 13
        Caption = 'Maksymalna liczba iteracji :'
      end
      object dllErrorTextBox: TLabel
        Left = 453
        Top = 56
        Width = 213
        Height = 13
        Caption = 'B'#322#261'd! Plik nie zawiera funkcji f, df, d2f !'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Label10: TLabel
        Left = 96
        Top = 136
        Width = 197
        Height = 13
        Caption = 'B'#322#261'd wzgl'#281'dny wyznaczania pierwiastka :'
      end
      object labelSemiColon1: TLabel
        Left = 421
        Top = 31
        Width = 4
        Height = 13
        Caption = ';'
        Visible = False
      end
      object startApproximationTextBox: TEdit
        Left = 299
        Top = 26
        Width = 116
        Height = 21
        TabOrder = 0
      end
      object Button2: TButton
        Left = 299
        Top = 161
        Width = 116
        Height = 25
        Caption = 'oblicz'
        TabOrder = 4
        OnClick = Button2Click
      end
      object Button1: TButton
        Left = 421
        Top = 53
        Width = 26
        Height = 21
        Caption = '...'
        TabOrder = 1
        OnClick = Button1Click
      end
      object epsilonTextBox: TEdit
        Left = 299
        Top = 134
        Width = 116
        Height = 21
        TabOrder = 3
      end
      object fileTextBox: TEdit
        Left = 299
        Top = 53
        Width = 116
        Height = 21
        TabOrder = 5
      end
      object maxIterationsTextBox: TEdit
        Left = 299
        Top = 107
        Width = 116
        Height = 21
        TabOrder = 2
      end
      object Button3: TButton
        Left = 421
        Top = 134
        Width = 26
        Height = 21
        Caption = 'e-16'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = Button3Click
      end
      object d2fNameTextBox: TEdit
        Left = 399
        Top = 80
        Width = 44
        Height = 21
        Enabled = False
        TabOrder = 7
        Text = 'd2f'
      end
      object dfNameTextBox: TEdit
        Left = 349
        Top = 80
        Width = 44
        Height = 21
        Enabled = False
        TabOrder = 8
        Text = 'df'
      end
      object fNameTextBox: TEdit
        Left = 299
        Top = 80
        Width = 44
        Height = 21
        Enabled = False
        TabOrder = 9
        Text = 'f'
      end
      object namesCheckBox: TCheckBox
        Left = 96
        Top = 82
        Width = 162
        Height = 17
        Caption = 'inne nazwy funkcji w DLL :'
        TabOrder = 10
        OnClick = namesCheckBoxClick
      end
      object startApproximationRightTextBox: TEdit
        Left = 429
        Top = 26
        Width = 84
        Height = 21
        TabOrder = 11
        Visible = False
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 209
      Width = 711
      Height = 490
      Align = alClient
      Caption = ' Wyniki '
      TabOrder = 1
      ExplicitLeft = 6
      ExplicitTop = 212
      object Label5: TLabel
        Left = 96
        Top = 30
        Width = 162
        Height = 13
        Caption = 'Przybli'#380'ona warto'#347#263' pierwiastka : '
      end
      object Label6: TLabel
        Left = 96
        Top = 57
        Width = 180
        Height = 13
        Caption = 'Warto'#347#263' funkcji dla tego pierwiastka :'
      end
      object Label7: TLabel
        Left = 96
        Top = 84
        Width = 134
        Height = 13
        Caption = 'Liczba wykonanych iteracji :'
      end
      object Label8: TLabel
        Left = 96
        Top = 111
        Width = 127
        Height = 13
        Caption = 'Status ko'#324'cowy oblicze'#324' : '
      end
      object statusLabel: TLabel
        Left = 299
        Top = 108
        Width = 159
        Height = 13
        Caption = 'najpierw dokonaj oblicze'#324' ...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object resultTextBox: TEdit
        Left = 299
        Top = 27
        Width = 190
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object iterationsTextBox: TEdit
        Left = 299
        Top = 81
        Width = 190
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object functionValueTextBox: TEdit
        Left = 299
        Top = 54
        Width = 190
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Biblioteki DLL|*.dll;*.DLL;|Wszystkie pliki|*.*;'
    Left = 800
    Top = 144
  end
end
