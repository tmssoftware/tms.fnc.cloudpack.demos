object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMSFNCCloudWhatsApp Demo'
  ClientHeight = 371
  ClientWidth = 573
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    573
    371)
  TextHeight = 15
  object Token: TEdit
    Left = 8
    Top = 8
    Width = 557
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    TextHint = 'Access Token'
    ExplicitWidth = 527
  end
  object ID: TEdit
    Left = 8
    Top = 37
    Width = 557
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    TextHint = 'Phone number ID'
    ExplicitWidth = 527
  end
  object Recipient: TEdit
    Left = 8
    Top = 275
    Width = 557
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    TextHint = 'Recipient'
    ExplicitWidth = 537
  end
  object TextMessageBody: TMemo
    Left = 8
    Top = 66
    Width = 557
    Height = 203
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Hi,'
      ''
      'Welcome to the TTMSFNCCloudWhatsAppComponent. '
      
        'Find our other components and packs at https://www.tmssoftware.c' +
        'om/'
      '')
    TabOrder = 3
    ExplicitWidth = 537
  end
  object SendText: TButton
    Left = 8
    Top = 304
    Width = 557
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Send Text Message'
    TabOrder = 4
    OnClick = SendTextClick
    ExplicitWidth = 537
  end
  object SendImage: TButton
    Left = 8
    Top = 335
    Width = 557
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Send Image'
    TabOrder = 5
    OnClick = SendImageClick
    ExplicitWidth = 537
  end
  object TMSFNCCloudWhatsApp1: TTMSFNCCloudWhatsApp
    Left = 24
    Top = 220
    Width = 39
    Height = 39
    Visible = True
    OnError = TMSFNCCloudWhatsApp1Error
    OnSendSuccess = TMSFNCCloudWhatsApp1SendSuccess
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 28
    Top = 160
  end
end
