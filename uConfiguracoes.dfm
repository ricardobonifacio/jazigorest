object FrConfiguracoes: TFrConfiguracoes
  Left = 0
  Top = 0
  Caption = 'Configura'#231#245'es'
  ClientHeight = 315
  ClientWidth = 222
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 39
    Width = 26
    Height = 13
    Caption = 'Porta'
  end
  object Label2: TLabel
    Left = 12
    Top = 83
    Width = 18
    Height = 13
    Caption = 'Link'
  end
  object Label3: TLabel
    Left = 12
    Top = 128
    Width = 36
    Height = 13
    Caption = 'Usu'#225'rio'
  end
  object Label4: TLabel
    Left = 12
    Top = 173
    Width = 30
    Height = 13
    Caption = 'Senha'
  end
  object Label5: TLabel
    Left = 12
    Top = 218
    Width = 40
    Height = 13
    Caption = 'Servidor'
  end
  object Label6: TLabel
    Left = 12
    Top = 263
    Width = 29
    Height = 13
    Caption = 'Banco'
  end
  object pnBotoPrin: TPanel
    Left = 0
    Top = 0
    Width = 222
    Height = 32
    Align = alTop
    TabOrder = 0
    DesignSize = (
      222
      32)
    object sbNovo: TSpeedButton
      Left = 1
      Top = 1
      Width = 30
      Height = 30
      Hint = 'Novo (F2)'
      Flat = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888888800000000008888880FFFFFFFF08888880FFFFFFFF
        08888880FFFFFFFF08888880FFFFFFFF08888880FFFFFFFF08888880FFFFFFFF
        08888880FFFF000008888880FFFF0FF088888880FFFF0F0888888880FFFF0088
        8888888000000888888888888888888888888888888888888888}
      ParentShowHint = False
      ShowHint = True
      OnClick = sbNovoClick
    end
    object sbGravar: TSpeedButton
      Left = 31
      Top = 1
      Width = 30
      Height = 30
      Hint = 'Gravar (F3)'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888880000000000008880000088888800088000008888880008800000000000
        000880000000000000088000000000000008800FFFFFFFFF0008800FFFFFFFFF
        0008800FFFFFFFFF0008800FFFFFFFFF0008800FFFFFFFFF0008800FFFFFFFFF
        0008880999999999008888888888888888888888888888888888}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = sbGravarClick
    end
    object sbFech: TSpeedButton
      Left = 166
      Top = 1
      Width = 30
      Height = 30
      Hint = 'Fechar (Esc)'
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000000000000000
        FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000FF0310020000
        0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000FF0310021002
        00000000FF7F0000000000000000000000000000000000000000FF0310021002
        100200000000FF7FFF7FFF7FFF7FFF7F00001042104210420000FF0310021002
        10020000FF7FFF7FFF7FFF7F0000000000001042104210420000FF0310021002
        10020000FF7FFF7FFF7FFF7F0000100200000000104210420000FF0300000000
        10020000FF7F0000000000000000FF0310020000104210420000FF0300000000
        10020000FF7F0000100210021002FF03FF031002000000000000FF0300000000
        10020000FF7F0000FF03FF03FF03FF03FF03FF03100200000000FF0310021002
        10020000FF7F0000000000000000FF03FF030000000010420000FF0310021002
        10020000FF7FFF7FFF7FFF7F0000FF0300000000104210420000FF0310021002
        10020000FF7FFF7FFF7FFF7F0000100200001042104210420000FF0310021002
        10020000FF7FFF7FFF7FFF7F0000000000001042104210420000000000001002
        10020000FF7FFF7FFF7FFF7FFF7FFF7F00001042104210421042104200000000
        10020000FF7FFF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000
        00000000FF7F}
      ParentShowHint = False
      ShowHint = True
      OnClick = sbFechClick
      ExplicitLeft = 164
    end
  end
  object edPorta: TEdit
    Left = 12
    Top = 56
    Width = 200
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = '8080'
  end
  object edLink: TEdit
    Left = 12
    Top = 100
    Width = 200
    Height = 21
    TabOrder = 2
    Text = 'http://localhost:%s'
  end
  object edUsuario: TEdit
    Left = 12
    Top = 145
    Width = 200
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object edSenha: TEdit
    Left = 12
    Top = 190
    Width = 200
    Height = 23
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 4
  end
  object edServidor: TEdit
    Left = 12
    Top = 235
    Width = 200
    Height = 21
    TabOrder = 5
  end
  object edBanco: TEdit
    Left = 12
    Top = 280
    Width = 200
    Height = 21
    TabOrder = 6
  end
end
