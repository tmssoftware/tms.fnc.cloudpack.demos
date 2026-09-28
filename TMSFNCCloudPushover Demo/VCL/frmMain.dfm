object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TTMSFNCCloudPushover Demo'
  ClientHeight = 529
  ClientWidth = 668
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  PixelsPerInch = 96
  DesignSize = (
    668
    529)
  TextHeight = 15
  object APIKey: TEdit
    Left = 8
    Top = 8
    Width = 652
    Height = 23
    Hint = 'API Key'
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    TextHint = 'API key'
    ExplicitWidth = 912
  end
  object UserKey: TEdit
    Left = 8
    Top = 37
    Width = 652
    Height = 23
    Hint = 'User / Group'
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    TextHint = 'User / Group'
    ExplicitWidth = 912
  end
  object Content: TMemo
    Left = 8
    Top = 66
    Width = 652
    Height = 351
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Hello World!'
      ''
      'Welcome to the Pushover Demo.')
    TabOrder = 2
    ExplicitWidth = 912
  end
  object Push: TButton
    Left = 8
    Top = 423
    Width = 652
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Push Notification'
    TabOrder = 3
    OnClick = PushClick
    ExplicitWidth = 912
  end
  object TMSFNCCloudPushOver1: TTMSFNCCloudPushOver
    Left = 8
    Top = 471
    Width = 39
    Height = 39
    Visible = True
    OnPushError = TMSFNCCloudPushOver1PushError
    OnPushSucces = TMSFNCCloudPushOver1PushSucces
  end
end
