object Form1: TForm1
  Width = 981
  Height = 640
  OnCreate = WebFormCreate
  PixelsPerInch = 144
  object PageControl1: TWebPageControl
    Left = 0
    Top = 133
    Width = 981
    Height = 495
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TWebTabSheet
      Left = 0
      Top = 20
      Width = 981
      Height = 475
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Convert File'
      object Panel_Create: TWebPanel
        Left = 0
        Top = 0
        Width = 981
        Height = 156
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        DesignSize = (
          981
          156)
        object Label2: TWebLabel
          Left = 28
          Top = 8
          Width = 189
          Height = 28
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Select File to Convert:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          HeightPercent = 100.000000000000000000
          ParentFont = False
          WidthPercent = 100.000000000000000000
        end
        object Edit_Url: TWebEdit
          Left = 211
          Top = 54
          Width = 691
          Height = 33
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Anchors = [akLeft, akTop, akRight]
          HeightPercent = 100.000000000000000000
          WidthPercent = 100.000000000000000000
          OnChange = Edit_UrlChange
        end
        object Rad_Url: TWebRadioButton
          Left = 72
          Top = 58
          Width = 129
          Height = 26
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Url'
          Checked = True
          Color = clNone
          HeightPercent = 100.000000000000000000
          TabOrder = 3
          TabStop = True
          WidthPercent = 100.000000000000000000
          OnClick = Rad_UrlClick
        end
        object Rad_File: TWebRadioButton
          Left = 72
          Top = 101
          Width = 129
          Height = 26
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'File'
          Checked = False
          Color = clNone
          HeightPercent = 100.000000000000000000
          TabOrder = 4
          WidthPercent = 100.000000000000000000
          OnClick = Rad_FileClick
        end
        object WebFilePicker1: TWebFilePicker
          Left = 211
          Top = 97
          Width = 691
          Height = 36
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          ChildOrder = 4
          OnChange = WebFilePicker1Change
        end
      end
      object Panel1: TWebPanel
        Left = 0
        Top = 156
        Width = 981
        Height = 319
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        DesignSize = (
          981
          319)
        object Label_Output: TWebLabel
          Left = 49
          Top = 24
          Width = 123
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Output Format:'
          HeightPercent = 100.000000000000000000
          WidthPercent = 100.000000000000000000
        end
        object Label_Status: TWebLabel
          Left = 211
          Top = 263
          Width = 691
          Height = 38
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Anchors = [akLeft, akRight, akBottom]
          AutoSize = False
          Caption = '(Convert Status)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -18
          Font.Name = 'Segoe UI'
          Font.Style = []
          HeightPercent = 100.000000000000000000
          ParentFont = False
          WidthPercent = 100.000000000000000000
          ExplicitTop = 522
        end
        object Combo_Output: TWebComboBox
          Left = 211
          Top = 21
          Width = 218
          Height = 33
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          HeightPercent = 100.000000000000000000
          WidthPercent = 100.000000000000000000
          OnChange = Combo_OutputChange
          ItemIndex = -1
          Items.Strings = (
            '3g2'
            '3gp'
            '7z'
            'aac'
            'ac3'
            'ai'
            'aiff'
            'avi'
            'azw3'
            'bmp'
            'cab'
            'cdr'
            'csv'
            'djvu'
            'doc'
            'docm'
            'docx'
            'dxf'
            'emf'
            'eps'
            'epub'
            'fb2'
            'flac'
            'flv'
            'gif'
            'jpg'
            'lrf'
            'm4a'
            'm4v'
            'mkv'
            'mobi'
            'mod'
            'mov'
            'mp3'
            'mp4'
            'mpg'
            'mts'
            'odp'
            'odt'
            'ogg'
            'pdb'
            'pdf'
            'png'
            'pps'
            'ppsx'
            'ppt'
            'pptm'
            'pptx'
            'prc'
            'ps'
            'psd'
            'rar'
            'rb'
            'rm'
            'rmvb'
            'rtf'
            'svg'
            'tar'
            'tcr'
            'tiff'
            'ts'
            'txt'
            'vob'
            'wav'
            'webm'
            'webp'
            'wma'
            'wmf'
            'wmv'
            'wps'
            'xls'
            'xlsx'
            'xps'
            'zip')
        end
        object Btn_Convert: TWebButton
          Left = 211
          Top = 64
          Width = 691
          Height = 189
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'Convert'
          HeightPercent = 100.000000000000000000
          TabOrder = 1
          WidthPercent = 100.000000000000000000
          OnClick = Btn_ConvertClick
        end
      end
    end
    object TabSheet2: TWebTabSheet
      Left = 0
      Top = 20
      Width = 981
      Height = 475
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Previous Convert Jobs'
      object Panel_List: TWebPanel
        Left = 0
        Top = 0
        Width = 981
        Height = 475
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        DesignSize = (
          981
          475)
        object Label_Error: TWebLabel
          Left = 24
          Top = 419
          Width = 914
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Anchors = [akLeft, akRight, akBottom]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -18
          Font.Name = 'Segoe UI'
          Font.Style = []
          HeightPercent = 100.000000000000000000
          ParentFont = False
          WidthPercent = 100.000000000000000000
          ExplicitTop = 316
          ExplicitWidth = 878
        end
        object Btn_JobList: TWebButton
          Left = 24
          Top = 369
          Width = 702
          Height = 40
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Anchors = [akLeft, akRight, akBottom]
          Caption = 'Get Existing Convert Jobs'
          HeightPercent = 100.000000000000000000
          WidthPercent = 100.000000000000000000
          OnClick = Btn_JobListClick
        end
        object ListBox_Jobs: TTMSFNCCloudDemoListBox
          Left = 24
          Top = 22
          Width = 702
          Height = 337
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          ParentDoubleBuffered = False
          Anchors = [akLeft, akTop, akRight, akBottom]
          DoubleBuffered = True
          TabOrder = 1
          Items = <>
          ItemHeight = 60.000000000000000000
        end
        object Btn_Download: TWebButton
          Left = 769
          Top = 94
          Width = 169
          Height = 40
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Anchors = [akTop, akRight]
          Caption = 'Save Job Files'
          HeightPercent = 100.000000000000000000
          TabOrder = 2
          WidthPercent = 100.000000000000000000
          OnClick = Btn_DownloadClick
        end
        object Btn_JobDetails: TWebButton
          Left = 769
          Top = 22
          Width = 169
          Height = 40
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Anchors = [akTop, akRight]
          Caption = 'Job Details'
          HeightPercent = 100.000000000000000000
          TabOrder = 3
          WidthPercent = 100.000000000000000000
          OnClick = Btn_JobDetailsClick
        end
      end
    end
  end
  object Panel_Service: TWebPanel
    Left = 0
    Top = 0
    Width = 981
    Height = 133
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    DesignSize = (
      981
      133)
    object Label_APIKey: TWebLabel
      Left = 72
      Top = 90
      Width = 64
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'API Key:'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object Label1: TWebLabel
      Left = 28
      Top = 8
      Width = 136
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Choose Service:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      HeightPercent = 100.000000000000000000
      ParentFont = False
      WidthPercent = 100.000000000000000000
    end
    object Label_API: TWebLabel
      Left = 814
      Top = 52
      Width = 92
      Height = 25
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Anchors = [akTop, akRight]
      Caption = 'Get API Key'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsUnderline]
      HeightPercent = 100.000000000000000000
      ParentFont = False
      WidthPercent = 100.000000000000000000
      OnClick = Label_APIClick
    end
    object Rad_CloudConvert: TWebRadioButton
      Left = 72
      Top = 51
      Width = 170
      Height = 26
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'CloudConvert'
      Checked = True
      Color = clNone
      HeightPercent = 100.000000000000000000
      TabStop = True
      WidthPercent = 100.000000000000000000
      OnClick = Rad_CloudConvertClick
    end
    object Rad_ConvertIO: TWebRadioButton
      Left = 288
      Top = 51
      Width = 170
      Height = 26
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'ConvertIO'
      Checked = False
      Color = clNone
      HeightPercent = 100.000000000000000000
      TabOrder = 1
      WidthPercent = 100.000000000000000000
      OnClick = Rad_ConvertIOClick
    end
    object Edit_API: TWebEdit
      Left = 211
      Top = 87
      Width = 695
      Height = 33
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Anchors = [akLeft, akTop, akRight]
      HeightPercent = 100.000000000000000000
      TabOrder = 3
      WidthPercent = 100.000000000000000000
      OnChange = Edit_APIChange
    end
  end
  object TMSFNCCloudFileConversion1: TTMSFNCCloudFileConversion
    Left = 880
    Top = 335
    Width = 26
    Height = 26
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Visible = True
    OnConvertJobCreated = TMSFNCCloudFileConversion1ConvertJobCreated
    OnGetConvertJobDetails = TMSFNCCloudFileConversion1GetConvertJobDetails
    OnFileDownloadedToFile = TMSFNCCloudFileConversion1FileDownloadedToFile
  end
  object Timer1: TWebTimer
    Enabled = False
    Interval = 1500
    OnTimer = Timer1Timer
    Left = 52
    Top = 412
  end
end
