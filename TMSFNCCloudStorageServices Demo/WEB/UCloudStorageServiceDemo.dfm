object Form1: TForm1
  Width = 615
  Height = 573
  Caption = 'TMS FNC Cloud Pack - TTMSFNCCloudStorageServices Demo'
  OnCreate = WebFormCreate
  object WebPanel1: TWebPanel
    Left = 0
    Top = 137
    Width = 615
    Height = 35
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    Align = alTop
    BorderColor = clSilver
    BorderStyle = bsSingle
    object WebLabel2: TWebLabel
      Left = 17
      Top = 10
      Width = 26
      Height = 13
      Caption = 'Path:'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object lPath: TWebLabel
      Left = 49
      Top = 10
      Width = 20
      Height = 13
      Caption = 'root'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
  end
  object TMSFNCCloudDemoListBox1: TTMSFNCCloudDemoListBox
    Left = 0
    Top = 172
    Width = 265
    Height = 401
    Align = alLeft
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 1
    Items = <>
  end
  object WebPanel2: TWebPanel
    Left = 265
    Top = 172
    Width = 350
    Height = 401
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    Align = alClient
    BorderColor = clSilver
    BorderStyle = bsSingle
    ChildOrder = 2
    object WebLabel1: TWebLabel
      Left = 24
      Top = 131
      Width = 98
      Height = 13
      Caption = 'Select file to upload:'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object btRootFolder: TWebButton
      Left = 24
      Top = 16
      Width = 96
      Height = 25
      Caption = 'Root'
      ChildOrder = 4
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      OnClick = btRootFolderClick
    end
    object btOpenFolder: TWebButton
      Left = 126
      Top = 16
      Width = 96
      Height = 25
      Caption = 'Open Folder'
      ChildOrder = 4
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      OnClick = btOpenFolderClick
    end
    object btCreateFolder: TWebButton
      Left = 227
      Top = 54
      Width = 96
      Height = 25
      Caption = 'Create Folder'
      ChildOrder = 4
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      OnClick = btCreateFolderClick
    end
    object btDelete: TWebButton
      Left = 126
      Top = 94
      Width = 96
      Height = 25
      Caption = 'Delete'
      ChildOrder = 4
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      OnClick = btDeleteClick
    end
    object edCreateFolder: TWebEdit
      Left = 24
      Top = 56
      Width = 197
      Height = 22
      ChildOrder = 9
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object WebMessageDlg1: TWebMessageDlg
      Left = 24
      Top = 175
      Width = 24
      Height = 24
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      Buttons = []
      CustomButtons = <>
      DialogText.Strings = (
        'Warning'
        'Error'
        'Information'
        'Confirm'
        'Custom'
        'OK'
        'Cancel'
        'Yes'
        'No'
        'Abort'
        'Retry'
        'Ignore'
        'All'
        'Yes to All'
        'No to All'
        'Help'
        'Close')
      Opacity = 0.200000000000000000
    end
    object btDownload: TWebButton
      Left = 24
      Top = 94
      Width = 96
      Height = 25
      Caption = 'Download'
      ChildOrder = 4
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      OnClick = btDownloadClick
    end
    object WebFilePicker1: TWebFilePicker
      Left = 24
      Top = 150
      Width = 297
      Height = 19
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      ChildOrder = 8
    end
    object btUpload: TWebButton
      Left = 228
      Top = 94
      Width = 96
      Height = 25
      Caption = 'Upload'
      ChildOrder = 4
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      OnClick = btUploadClick
    end
  end
  object WebPanel3: TWebPanel
    Left = 0
    Top = 0
    Width = 615
    Height = 137
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    Align = alTop
    BorderColor = clSilver
    BorderStyle = bsSingle
    ChildOrder = 3
    object WebLabel3: TWebLabel
      Left = 16
      Top = 16
      Width = 35
      Height = 13
      Caption = 'Service'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object WebLabel5: TWebLabel
      Left = 16
      Top = 45
      Width = 41
      Height = 13
      Caption = 'Client ID'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object WebLabel6: TWebLabel
      Left = 16
      Top = 73
      Width = 31
      Height = 13
      Caption = 'Secret'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object WebLabel7: TWebLabel
      Left = 16
      Top = 101
      Width = 61
      Height = 13
      Caption = 'Callback URL'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object cbStorageService: TWebComboBox
      Left = 118
      Top = 13
      Width = 187
      Height = 21
      HeightPercent = 100.000000000000000000
      Text = 'DropBox'
      WidthPercent = 100.000000000000000000
      OnChange = cbStorageServiceChange
      ItemIndex = 1
      Items.Strings = (
        'Box'
        'DropBox'
        'Google Drive'
        'OneDrive'
        'Hubic')
    end
    object btConnect: TWebButton
      Left = 319
      Top = 11
      Width = 96
      Height = 25
      Caption = 'Connect'
      ChildOrder = 3
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      OnClick = btConnectClick
    end
    object TMSFNCCloudStorageServices1: TTMSFNCCloudStorageServices
      Left = 484
      Top = 16
      Width = 26
      Height = 26
      Visible = True
      Service = cssBox
      OnConnected = TMSFNCCloudStorageServices1Connected
      OnGetFolderList = TMSFNCCloudStorageServices1GetFolderList
      OnCreateFolder = TMSFNCCloudStorageServices1CreateFolder
      OnUploadFile = TMSFNCCloudStorageServices1UploadFile
      OnDeleteItem = TMSFNCCloudStorageServices1DeleteItem
    end
    object edClientiD: TWebEdit
      Left = 118
      Top = 42
      Width = 297
      Height = 22
      ChildOrder = 12
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object edSecret: TWebEdit
      Left = 118
      Top = 70
      Width = 297
      Height = 22
      ChildOrder = 12
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object edCallbackURL: TWebEdit
      Left = 118
      Top = 98
      Width = 297
      Height = 22
      ChildOrder = 12
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
  end
end
