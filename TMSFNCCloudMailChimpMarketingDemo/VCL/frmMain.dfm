object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 488
  ClientWidth = 841
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 841
    Height = 49
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object APIKey: TEdit
      Left = 1
      Top = 1
      Width = 608
      Height = 47
      Align = alClient
      TabOrder = 0
      TextHint = 'API Key'
      ExplicitHeight = 23
    end
    object Button1: TButton
      Left = 609
      Top = 1
      Width = 231
      Height = 47
      Align = alRight
      Caption = 'Connect'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 49
    Width = 841
    Height = 439
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Lists'
      object ListsListBox: TListBox
        Left = 0
        Top = 0
        Width = 257
        Height = 409
        Align = alLeft
        ItemHeight = 15
        TabOrder = 0
        OnClick = ListsListBoxClick
      end
      object ListName: TEdit
        Left = 263
        Top = 3
        Width = 561
        Height = 23
        TabOrder = 1
        TextHint = 'Listname'
      end
      object FromNameEdit: TEdit
        Left = 263
        Top = 32
        Width = 561
        Height = 23
        TabOrder = 2
        TextHint = 'Name'
      end
      object FromEmailEdit: TEdit
        Left = 263
        Top = 61
        Width = 561
        Height = 23
        TabOrder = 3
        TextHint = 'E-mail'
      end
      object CompanyEdit: TEdit
        Left = 263
        Top = 90
        Width = 561
        Height = 23
        TabOrder = 4
        TextHint = 'Company'
      end
      object AdressEdit: TEdit
        Left = 263
        Top = 119
        Width = 561
        Height = 23
        TabOrder = 5
        TextHint = 'Adress'
      end
      object CityEdit: TEdit
        Left = 263
        Top = 148
        Width = 561
        Height = 23
        TabOrder = 6
        TextHint = 'City'
      end
      object PermissionReminderEdit: TEdit
        Left = 263
        Top = 264
        Width = 561
        Height = 23
        TabOrder = 7
        TextHint = 'Permission Reminder'
      end
      object LanguageEdit: TEdit
        Left = 263
        Top = 235
        Width = 561
        Height = 23
        TabOrder = 8
        TextHint = 'Language'
      end
      object CountryEdit: TEdit
        Left = 263
        Top = 206
        Width = 561
        Height = 23
        TabOrder = 9
        TextHint = 'Country'
      end
      object ZipEdit: TEdit
        Left = 263
        Top = 177
        Width = 561
        Height = 23
        TabOrder = 10
        TextHint = 'ZIP'
      end
      object DeleteList: TButton
        Left = 755
        Top = 325
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 11
        OnClick = DeleteListClick
      end
      object EditList: TButton
        Left = 512
        Top = 325
        Width = 75
        Height = 25
        Caption = 'Update'
        TabOrder = 12
        OnClick = EditListClick
      end
      object AddList: TButton
        Left = 263
        Top = 325
        Width = 75
        Height = 25
        Caption = 'Add'
        TabOrder = 13
        OnClick = AddListClick
      end
      object TMSFNCCloudMailChimpMarketing1: TTMSFNCCloudMailChimpMarketing
        Left = 785
        Top = 353
        Width = 39
        Height = 39
        Visible = True
        OnGetLists = TMSFNCCloudMailChimpMarketing1GetLists
        OnAddList = TMSFNCCloudMailChimpMarketing1AddList
        OnUpdateList = TMSFNCCloudMailChimpMarketing1UpdateList
        OnDeleteList = TMSFNCCloudMailChimpMarketing1DeleteList
        OnGetMembers = TMSFNCCloudMailChimpMarketing1GetMembers
        OnAddMember = TMSFNCCloudMailChimpMarketing1AddMember
        OnUpdateMember = TMSFNCCloudMailChimpMarketing1UpdateMember
        OnArchiveMember = TMSFNCCloudMailChimpMarketing1ArchiveMember
        OnDeleteMember = TMSFNCCloudMailChimpMarketing1DeleteMember
        OnGetCampaigns = TMSFNCCloudMailChimpMarketing1GetCampaigns
        OnAddCampaign = TMSFNCCloudMailChimpMarketing1AddCampaign
        OnUpdateCampaignSettings = TMSFNCCloudMailChimpMarketing1UpdateCampaignSettings
        OnDeleteCampaign = TMSFNCCloudMailChimpMarketing1DeleteCampaign
        OnSendCampaign = TMSFNCCloudMailChimpMarketing1SendCampaign
        OnGetCampaignContent = TMSFNCCloudMailChimpMarketing1GetCampaignContent
        OnSetCampaignContent = TMSFNCCloudMailChimpMarketing1SetCampaignContent
        OnError = TMSFNCCloudMailChimpMarketing1Error
      end
      object SubjectEdit: TEdit
        Left = 263
        Top = 296
        Width = 561
        Height = 23
        TabOrder = 15
        TextHint = 'Subject'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Members'
      ImageIndex = 1
      object DeleteMember: TButton
        Left = 755
        Top = 287
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 0
        OnClick = DeleteMemberClick
      end
      object AddMember: TButton
        Left = 3
        Top = 287
        Width = 75
        Height = 25
        Caption = 'Add'
        TabOrder = 1
        OnClick = AddMemberClick
      end
      object Next: TButton
        Left = 377
        Top = 3
        Width = 91
        Height = 25
        Caption = 'Next page'
        TabOrder = 2
        OnClick = NextClick
      end
      object FirstPage: TButton
        Left = 3
        Top = 3
        Width = 75
        Height = 25
        Caption = 'First Page'
        TabOrder = 3
        OnClick = FirstPageClick
      end
      object Current: TButton
        Left = 755
        Top = 3
        Width = 75
        Height = 25
        Caption = 'Current Page'
        TabOrder = 4
        OnClick = CurrentClick
      end
      object Previous: TButton
        Left = 280
        Top = 3
        Width = 91
        Height = 25
        Caption = 'Previous Page'
        TabOrder = 5
        OnClick = PreviousClick
      end
      object MembersListBox: TListBox
        Left = 3
        Top = 34
        Width = 827
        Height = 247
        ItemHeight = 15
        TabOrder = 6
      end
      object Edit1: TEdit
        Left = 3
        Top = 318
        Width = 827
        Height = 23
        TabOrder = 7
        TextHint = 'Email'
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Campaigns'
      ImageIndex = 2
      object StatusLabel: TLabel
        Left = 183
        Top = 179
        Width = 38
        Height = 15
        Caption = 'Status: '
      end
      object CampaignsListBox: TListBox
        Left = 0
        Top = 3
        Width = 177
        Height = 366
        ItemHeight = 15
        TabOrder = 0
        OnClick = CampaignsListBoxClick
      end
      object Send: TButton
        Left = -4
        Top = 375
        Width = 181
        Height = 25
        Caption = 'Send Campaign'
        TabOrder = 1
        OnClick = SendClick
      end
      object NewCampaign: TButton
        Left = 183
        Top = 3
        Width = 110
        Height = 25
        Caption = 'New Campaign'
        TabOrder = 2
        OnClick = NewCampaignClick
      end
      object AddCampaign: TButton
        Left = 299
        Top = 3
        Width = 110
        Height = 25
        Caption = 'Add Campaign'
        Enabled = False
        TabOrder = 3
        OnClick = AddCampaignClick
      end
      object UpdateCampaign: TButton
        Left = 720
        Top = 3
        Width = 110
        Height = 25
        Caption = 'Update Campaign'
        Enabled = False
        TabOrder = 4
      end
      object TitleEdit: TEdit
        Left = 183
        Top = 34
        Width = 647
        Height = 23
        TabOrder = 5
        TextHint = 'Title'
      end
      object SubjectLineEdit: TEdit
        Left = 183
        Top = 63
        Width = 647
        Height = 23
        TabOrder = 6
        TextHint = 'Subject Line'
      end
      object PreviewTextEdit: TEdit
        Left = 183
        Top = 92
        Width = 647
        Height = 23
        TabOrder = 7
        TextHint = 'Preview Text'
      end
      object FromEdit: TEdit
        Left = 183
        Top = 121
        Width = 647
        Height = 23
        TabOrder = 8
        TextHint = 'From Name'
      end
      object ReplyToEdit: TEdit
        Left = 183
        Top = 150
        Width = 647
        Height = 23
        TabOrder = 9
        TextHint = 'Reply To'
      end
      object ContentMemo: TMemo
        Left = 183
        Top = 200
        Width = 647
        Height = 169
        TabOrder = 10
      end
      object SaveContent: TButton
        Left = 183
        Top = 375
        Width = 647
        Height = 25
        Caption = 'Save Content'
        TabOrder = 11
        OnClick = SaveContentClick
      end
    end
  end
end
