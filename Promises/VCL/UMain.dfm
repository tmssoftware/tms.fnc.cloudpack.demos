object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Google Calendar with Promises'
  ClientHeight = 631
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object Label3: TLabel
    Left = 8
    Top = 105
    Width = 101
    Height = 15
    Caption = 'Available calendars'
  end
  object Label1: TLabel
    Left = 8
    Top = 352
    Width = 34
    Height = 15
    Caption = 'Events'
  end
  object Label2: TLabel
    Left = 8
    Top = 11
    Width = 42
    Height = 15
    Caption = 'ClientID'
  end
  object Label4: TLabel
    Left = 8
    Top = 43
    Width = 32
    Height = 15
    Caption = 'Secret'
  end
  object Button1: TButton
    Left = 8
    Top = 66
    Width = 337
    Height = 22
    Caption = 'Authenticate'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 130
    Width = 337
    Height = 207
    ItemHeight = 15
    TabOrder = 2
    OnClick = ListBox1Click
  end
  object ListBox2: TListBox
    Left = 8
    Top = 377
    Width = 337
    Height = 238
    ItemHeight = 15
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 68
    Top = 8
    Width = 277
    Height = 23
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 56
    Top = 37
    Width = 289
    Height = 23
    TabOrder = 4
  end
end
