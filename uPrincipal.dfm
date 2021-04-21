object frmPrincipal: TfrmPrincipal
  Left = 271
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Web Service - SmartFarma'
  ClientHeight = 179
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 17
    Top = 8
    Width = 88
    Height = 13
    Caption = 'Porta Configurada'
  end
  object Label2: TLabel
    Left = 17
    Top = 50
    Width = 18
    Height = 13
    Caption = 'Link'
  end
  object ButtonStart: TButton
    Left = 17
    Top = 104
    Width = 120
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 157
    Top = 104
    Width = 120
    Height = 25
    Caption = 'Parar'
    TabOrder = 1
    OnClick = ButtonStopClick
  end
  object ButtonOpenBrowser: TButton
    Left = 17
    Top = 136
    Width = 120
    Height = 25
    Caption = 'Abrir Browser'
    TabOrder = 2
    OnClick = ButtonOpenBrowserClick
  end
  object btConfig: TButton
    Left = 157
    Top = 136
    Width = 120
    Height = 25
    Caption = 'Configura'#231#245'es'
    TabOrder = 3
    OnClick = btConfigClick
  end
  object ckDemonstracao: TCheckBox
    Left = 168
    Top = 22
    Width = 106
    Height = 31
    Caption = 'Habilitar Demonstra'#231#227'o'
    TabOrder = 4
    Visible = False
    WordWrap = True
  end
  object XMLMemo: TMemo
    Left = 8
    Top = 182
    Width = 257
    Height = 217
    Lines.Strings = (
      'XMLMemo')
    ScrollBars = ssVertical
    TabOrder = 5
    Visible = False
  end
  object edPorta: TPanel
    Left = 16
    Top = 24
    Width = 100
    Height = 24
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderWidth = 2
    BorderStyle = bsSingle
    Caption = '8080'
    Color = clWhite
    ParentBackground = False
    TabOrder = 6
  end
  object edLink: TPanel
    Left = 16
    Top = 65
    Width = 260
    Height = 24
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderWidth = 2
    BorderStyle = bsSingle
    Caption = 'http://localhost:%s'
    Color = clWhite
    ParentBackground = False
    TabOrder = 7
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 193
    Top = 8
  end
end
