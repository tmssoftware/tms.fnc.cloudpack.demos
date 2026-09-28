object Form2: TForm2
  Width = 817
  Height = 501
  OnCreate = WebFormCreate
  object Label5: TLabel
    Left = 336
    Top = 91
    Width = 95
    Height = 13
    Caption = 'Selected Language:'
  end
  object Label6: TLabel
    Left = 536
    Top = 371
    Width = 98
    Height = 13
    Caption = 'Detected Language:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 817
    Height = 73
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 38
      Width = 42
      Height = 13
      Caption = 'API Key:'
    end
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 39
      Height = 13
      Caption = 'Service:'
    end
    object ComboBox1: TComboBox
      Left = 112
      Top = 8
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Google'
      OnChange = ComboBox1Change
      Items.Strings = (
        'Google'
        'Microsoft')
    end
    object Edit1: TEdit
      Left = 112
      Top = 37
      Width = 273
      Height = 21
      TabOrder = 1
      OnChange = Edit1Change
    end
  end
  object TMSFNCCloudTranslation1: TTMSFNCCloudTranslation
    Left = 248
    Top = 8
    Width = 26
    Height = 26
    Visible = True
    OnGetSupportedLanguages = TMSFNCCloudTranslation1GetSupportedLanguages
  end
  object Button1: TButton
    Left = 8
    Top = 88
    Width = 217
    Height = 22
    Caption = 'Retrieve Supported Languages'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 120
    Width = 217
    Height = 345
    ItemHeight = 13
    TabOrder = 3
    OnClick = ListBox1Click
  end
  object Button2: TButton
    Left = 248
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Translate'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 248
    Top = 120
    Width = 273
    Height = 113
    Lines.Strings = (
      'Hello World!'
      'This is a new line'
      'Translating text is easy.')
    TabOrder = 10
  end
  object Memo2: TMemo
    Left = 536
    Top = 120
    Width = 273
    Height = 113
    TabOrder = 8
  end
  object Button3: TButton
    Left = 248
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Translate'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Edit3: TEdit
    Left = 248
    Top = 288
    Width = 273
    Height = 21
    TabOrder = 7
    Text = 'Type in your own words'
  end
  object Edit4: TEdit
    Left = 536
    Top = 288
    Width = 273
    Height = 21
    TabOrder = 9
  end
  object Button4: TButton
    Left = 248
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Detect'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Edit5: TEdit
    Left = 248
    Top = 368
    Width = 273
    Height = 21
    TabOrder = 11
    Text = 'Type in your own words'
  end
end
