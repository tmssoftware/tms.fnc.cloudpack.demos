object Form2: TForm2
  Width = 704
  Height = 837
  Caption = 'Cloud logger Demo'
  OnCreate = WebFormCreate
  object Label1: TWebLabel
    Left = 168
    Top = 10
    Width = 28
    Height = 13
    Caption = 'Email:'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Label2: TWebLabel
    Left = 168
    Top = 41
    Width = 75
    Height = 13
    Caption = 'Account Token:'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Label3: TWebLabel
    Left = 168
    Top = 72
    Width = 75
    Height = 13
    Caption = 'Account Token:'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Label4: TWebLabel
    Left = 440
    Top = 10
    Width = 50
    Height = 13
    Caption = 'Password:'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Label5: TWebLabel
    Left = 376
    Top = 183
    Width = 46
    Height = 13
    Caption = 'Message:'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Label6: TWebLabel
    Left = 379
    Top = 251
    Width = 29
    Height = 13
    Caption = 'Level:'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object SIdLbl: TWebLabel
    Left = 376
    Top = 415
    Width = 209
    Height = 13
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object SLvlLbl: TWebLabel
    Left = 608
    Top = 415
    Width = 73
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object STitleLbl: TWebLabel
    Left = 376
    Top = 434
    Width = 305
    Height = 15
    Alignment = taCenter
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Label7: TWebLabel
    Left = 376
    Top = 467
    Width = 25
    Height = 13
    Caption = 'First:'
    HeightPercent = 100.000000000000000000
    Visible = False
    WidthPercent = 100.000000000000000000
  end
  object SFirstLbl: TWebLabel
    Left = 392
    Top = 483
    Width = 129
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Label9: TWebLabel
    Left = 536
    Top = 467
    Width = 24
    Height = 13
    Caption = 'Last:'
    HeightPercent = 100.000000000000000000
    Visible = False
    WidthPercent = 100.000000000000000000
  end
  object SLastLbl: TWebLabel
    Left = 552
    Top = 483
    Width = 129
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Label11: TWebLabel
    Left = 376
    Top = 512
    Width = 35
    Height = 13
    Caption = 'Status:'
    HeightPercent = 100.000000000000000000
    Visible = False
    WidthPercent = 100.000000000000000000
  end
  object SStatusLbl: TWebLabel
    Left = 379
    Top = 531
    Width = 142
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Label13: TWebLabel
    Left = 536
    Top = 512
    Width = 91
    Height = 13
    Caption = 'Total Occurrences:'
    HeightPercent = 100.000000000000000000
    Visible = False
    WidthPercent = 100.000000000000000000
  end
  object STotOccLbl: TWebLabel
    Left = 552
    Top = 531
    Width = 129
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object EIdLbl: TWebLabel
    Left = 379
    Top = 648
    Width = 209
    Height = 13
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object ELvlLbl: TWebLabel
    Left = 611
    Top = 648
    Width = 73
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object ETitleLbl: TWebLabel
    Left = 379
    Top = 667
    Width = 305
    Height = 15
    Alignment = taCenter
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object EIPLbl: TWebLabel
    Left = 379
    Top = 772
    Width = 145
    Height = 13
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object EDateLbl: TWebLabel
    Left = 539
    Top = 772
    Width = 145
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object ESrcLbl: TWebLabel
    Left = 379
    Top = 804
    Width = 302
    Height = 13
    Alignment = taCenter
    AutoSize = False
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object RadioExc: TWebRadioButton
    Left = 24
    Top = 10
    Width = 113
    Height = 17
    Caption = 'Exceptionless'
    Checked = True
    Color = clNone
    HeightPercent = 100.000000000000000000
    TabStop = True
    WidthPercent = 100.000000000000000000
    OnClick = RadioExcClick
  end
  object RadioSentry: TWebRadioButton
    Left = 24
    Top = 40
    Width = 113
    Height = 17
    Caption = 'Sentry'
    Checked = False
    ChildOrder = 1
    Color = clNone
    HeightPercent = 100.000000000000000000
    TabOrder = 1
    WidthPercent = 100.000000000000000000
    OnClick = RadioSentryClick
  end
  object RadioRollbar: TWebRadioButton
    Left = 24
    Top = 70
    Width = 113
    Height = 17
    Caption = 'Rollbar'
    Checked = False
    ChildOrder = 2
    Color = clNone
    HeightPercent = 100.000000000000000000
    TabOrder = 2
    WidthPercent = 100.000000000000000000
    OnClick = RadioRollbarClick
  end
  object ExcMail: TWebEdit
    Left = 264
    Top = 7
    Width = 161
    Height = 21
    HeightPercent = 100.000000000000000000
    TabOrder = 3
    WidthPercent = 100.000000000000000000
  end
  object ExcPassword: TWebEdit
    Left = 520
    Top = 7
    Width = 161
    Height = 21
    HeightPercent = 100.000000000000000000
    PasswordChar = '*'
    TabOrder = 4
    WidthPercent = 100.000000000000000000
  end
  object SentryToken: TWebEdit
    Left = 264
    Top = 38
    Width = 417
    Height = 21
    HeightPercent = 100.000000000000000000
    TabOrder = 5
    WidthPercent = 100.000000000000000000
  end
  object RollBarToken: TWebEdit
    Left = 264
    Top = 65
    Width = 417
    Height = 21
    HeightPercent = 100.000000000000000000
    TabOrder = 6
    WidthPercent = 100.000000000000000000
  end
  object Button1: TWebButton
    Left = 24
    Top = 152
    Width = 89
    Height = 25
    Caption = 'Get Projects'
    Enabled = False
    HeightPercent = 100.000000000000000000
    TabOrder = 7
    WidthPercent = 100.000000000000000000
    OnClick = Button1Click
  end
  object Button2: TWebButton
    Left = 24
    Top = 617
    Width = 89
    Height = 25
    Caption = 'Get Events'
    Enabled = False
    HeightPercent = 100.000000000000000000
    TabOrder = 8
    WidthPercent = 100.000000000000000000
    OnClick = Button2Click
  end
  object Button3: TWebButton
    Left = 24
    Top = 112
    Width = 89
    Height = 25
    Caption = 'Connect'
    HeightPercent = 100.000000000000000000
    TabOrder = 9
    WidthPercent = 100.000000000000000000
    OnClick = Button3Click
  end
  object Button4: TWebButton
    Left = 536
    Top = 296
    Width = 145
    Height = 25
    Caption = 'Log Message'
    Enabled = False
    HeightPercent = 100.000000000000000000
    TabOrder = 10
    WidthPercent = 100.000000000000000000
    OnClick = Button4Click
  end
  object Button5: TWebButton
    Left = 24
    Top = 384
    Width = 89
    Height = 25
    Caption = 'Get Stacks'
    Enabled = False
    HeightPercent = 100.000000000000000000
    TabOrder = 11
    WidthPercent = 100.000000000000000000
    OnClick = Button5Click
  end
  object Button6: TWebButton
    Left = 536
    Top = 335
    Width = 145
    Height = 25
    Caption = 'Log Exception'
    Enabled = False
    HeightPercent = 100.000000000000000000
    TabOrder = 12
    WidthPercent = 100.000000000000000000
    OnClick = Button6Click
  end
  object ListBox1: TWebListBox
    Left = 24
    Top = 183
    Width = 321
    Height = 178
    HeightPercent = 100.000000000000000000
    ItemHeight = 13
    ItemIndex = -1
    TabOrder = 13
    WidthPercent = 100.000000000000000000
    OnClick = ListBox1Click
  end
  object ListBox2: TWebListBox
    Left = 24
    Top = 415
    Width = 321
    Height = 178
    HeightPercent = 100.000000000000000000
    ItemHeight = 13
    ItemIndex = -1
    TabOrder = 14
    WidthPercent = 100.000000000000000000
    OnClick = ListBox2Click
  end
  object ListBox3: TWebListBox
    Left = 24
    Top = 648
    Width = 321
    Height = 178
    HeightPercent = 100.000000000000000000
    ItemHeight = 13
    ItemIndex = -1
    TabOrder = 15
    WidthPercent = 100.000000000000000000
    OnClick = ListBox3Click
  end
  object MsgEdit: TWebEdit
    Left = 376
    Top = 202
    Width = 305
    Height = 21
    HeightPercent = 100.000000000000000000
    TabOrder = 16
    Text = 'Test Message WEB Core'
    WidthPercent = 100.000000000000000000
  end
  object ComboBox1: TWebComboBox
    Left = 536
    Top = 248
    Width = 145
    Height = 21
    HeightPercent = 100.000000000000000000
    TabOrder = 17
    Text = 'Info'
    WidthPercent = 100.000000000000000000
    ItemIndex = 1
    Items.Strings = (
      'Debug'
      'Info'
      'Warning'
      'Fatal')
  end
  object Button7: TWebButton
    Left = 376
    Top = 335
    Width = 145
    Height = 25
    Caption = 'Log Exception'
    Enabled = False
    HeightPercent = 100.000000000000000000
    TabOrder = 18
    WidthPercent = 100.000000000000000000
    OnClick = Button7Click
  end
  object EMsgMemo: TWebMemo
    Left = 376
    Top = 696
    Width = 305
    Height = 62
    AutoSize = False
    HeightPercent = 100.000000000000000000
    SelLength = 0
    SelStart = 0
    TabOrder = 19
    Visible = False
    WidthPercent = 100.000000000000000000
  end
  object l: TTMSFNCCloudLogger
    Left = 655
    Top = 111
    Width = 26
    Height = 26
    Visible = True
    Service = lsExceptionless
    OnConnected = DoConnected
    OnGetAllEvents = DoGetAllEvents
    OnGetAllProjects = DoGetAllProjects
    OnGetAllStacks = DoGetAllStacks
  end
end
