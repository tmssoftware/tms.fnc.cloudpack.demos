object Form1: TForm1
  Width = 1620
  Height = 890
  Caption = 'TTMSFNCCloudWhatsApp Demo'
  ElementPosition = epRelative
  object Token: TWebEdit
    Left = 8
    Top = 8
    Width = 321
    Height = 49
    HeightPercent = 100.000000000000000000
    TextHint = 'Access Token'
    WidthStyle = ssPercent
    WidthPercent = 100.000000000000000000
  end
  object SendText: TWebButton
    Left = 8
    Top = 327
    Width = 321
    Height = 49
    Caption = 'Send text message'
    ChildOrder = 1
    HeightPercent = 100.000000000000000000
    WidthStyle = ssPercent
    WidthPercent = 100.000000000000000000
    OnClick = SendTextClick
  end
  object MessageBody: TWebMemo
    Left = 8
    Top = 118
    Width = 321
    Height = 148
    AutoSize = False
    HeightPercent = 100.000000000000000000
    Lines.Strings = (
      'Hi,'
      ''
      'Welcome to the '
      'TTMSFNCCloudWhatsAppComponent'
      '. '
      'Find our other components and packs '
      'at https://www.tmssoftware.com/'
      ''
      '')
    SelLength = 0
    SelStart = 128
    WidthStyle = ssPercent
    WidthPercent = 100.000000000000000000
  end
  object ID: TWebEdit
    Left = 8
    Top = 63
    Width = 321
    Height = 49
    ChildOrder = 4
    HeightPercent = 100.000000000000000000
    TextHint = 'Phone Number ID'
    WidthStyle = ssPercent
    WidthPercent = 100.000000000000000000
  end
  object Number: TWebEdit
    Left = 8
    Top = 272
    Width = 321
    Height = 49
    ChildOrder = 5
    HeightPercent = 100.000000000000000000
    TextHint = 'Phone number'
    WidthStyle = ssPercent
    WidthPercent = 100.000000000000000000
  end
  object SendImage: TWebButton
    Left = 8
    Top = 382
    Width = 321
    Height = 49
    Caption = 'Send image'
    ChildOrder = 1
    HeightPercent = 100.000000000000000000
    WidthStyle = ssPercent
    WidthPercent = 100.000000000000000000
    OnClick = SendImageClick
  end
  object TMSFNCCloudWhatsApp1: TTMSFNCCloudWhatsApp
    Left = 80
    Top = 227
    Width = 39
    Height = 39
    Visible = True
    OnError = TMSFNCCloudWhatsApp1Error
    OnSendSuccess = TMSFNCCloudWhatsApp1SendSuccess
  end
  object WebFilePicker1: TWebFilePicker
    Left = 8
    Top = 437
    Width = 321
    Height = 43
    WidthStyle = ssPercent
    ChildOrder = 8
    OnGetFileAsStream = WebFilePicker1GetFileAsStream
  end
end
