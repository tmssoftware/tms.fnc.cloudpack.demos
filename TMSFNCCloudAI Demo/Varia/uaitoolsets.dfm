object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'AI FileSystem ToolSet demo'
  ClientHeight = 778
  ClientWidth = 999
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TMSFNCCloudAI1: TTMSFNCCloudAI
    Left = 728
    Top = 192
    Width = 26
    Height = 26
    Visible = True
    Service = aiOpenAI
    Settings.GeminiModel = 'gemini-2.5-flash'
    Settings.OpenAIModel = 'gpt-5.4-mini-2026-03-17'
    Settings.OpenAISoundModel = 'gpt-4o-mini-tts'
    Settings.OpenAITranscribeModel = 'whisper-1'
    Settings.GrokModel = 'grok-4-1-fast-reasoning'
    Settings.ClaudeModel = 'claude-sonnet-4-6'
    Settings.OllamaModel = 'llama3.2:latest'
    Settings.DeepSeekModel = 'deepseek-chat'
    Settings.PerplexityModel = 'sonar-pro'
    Settings.OllamaHost = 'localhost'
    Settings.OllamaPath = '/api/chat'
    Settings.MistralModel = 'mistral-large-latest'
    Settings.MistralTranscribeModel = 'voxtral-mini-2507'
    Tools = <>
    OnExecuted = TMSFNCCloudAI1Executed
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 999
    Height = 145
    Align = alTop
    TabOrder = 2
    object ComboBox1: TComboBox
      Left = 16
      Top = 19
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = ComboBox1Change
    end
    object Button1: TButton
      Left = 167
      Top = 17
      Width = 75
      Height = 25
      Caption = 'Execute'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Memo1: TMemo
      Left = 248
      Top = 19
      Width = 742
      Height = 120
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        
          'List all files in the current folder with details such as file s' +
          'ize, file date and create in this folder a text file named FILEL' +
          'IST.TXT '
        'with this list of the details of the files ')
      ParentFont = False
      TabOrder = 2
    end
    object ProgressBar1: TProgressBar
      Left = 16
      Top = 64
      Width = 226
      Height = 17
      Style = pbstMarquee
      State = pbsPaused
      TabOrder = 3
    end
  end
  object Memo2: TMemo
    Left = 8
    Top = 151
    Width = 982
    Height = 609
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object fs: TTMSFNCCloudAIFileSystem
    AI = TMSFNCCloudAI1
    Tools = <
      item
        Name = 'GetFiles'
        Description = 'show files in a specific folder'
        Parameters = <
          item
            ArrayProperties = <>
            Name = 'Folder'
            Type = ptString
            Description = 'the folder in which to list all files'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Mask'
            Type = ptString
            Required = False
            Description = 'optional file mask to use to search files'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Details'
            Type = ptBoolean
            Required = False
            Description = 'when true, the file size and file modified date is returned'
            Properties = <>
          end>
      end
      item
        Name = 'GetFolders'
        Description = 'show folders in a specific folder'
        Parameters = <
          item
            ArrayProperties = <>
            Name = 'Folder'
            Type = ptString
            Description = 'the folder in which to list all folders'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Mask'
            Type = ptString
            Required = False
            Description = 'optional file mask to use to search folders'
            Properties = <>
          end>
      end
      item
        Name = 'ReadTextFile'
        Description = 'get the content of a text file'
        Parameters = <
          item
            ArrayProperties = <>
            Name = 'Filename'
            Type = ptString
            Description = 'the full path to the text file to get the content from'
            Properties = <>
          end>
      end
      item
        Name = 'WriteTextFile'
        Description = 'write content to a text file'
        Parameters = <
          item
            ArrayProperties = <>
            Name = 'Filename'
            Type = ptString
            Description = 'the full path to the file to write to'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Content'
            Type = ptString
            Description = 'the content to write as text to the file'
            Properties = <>
          end>
      end
      item
        Name = 'AppendTextFile'
        Description = 'append content to an existing text file'
        Parameters = <
          item
            ArrayProperties = <>
            Name = 'Filename'
            Type = ptString
            Description = 'the full path to the file to write to'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Content'
            Type = ptString
            Description = 'the content to append as text to the file'
            Properties = <>
          end>
      end
      item
        Name = 'CreateFolder'
        Description = 'create a new subfolder'
        Parameters = <
          item
            ArrayProperties = <>
            Name = 'Folder'
            Type = ptString
            Description = 'the name of the folder where to create the subfolder'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Foldername'
            Type = ptString
            Description = 'the name of the subfolder to create'
            Properties = <>
          end>
      end
      item
        Name = 'CopyFile'
        Description = 'copy a file to another'
        Parameters = <
          item
            ArrayProperties = <>
            Name = 'Source'
            Type = ptString
            Description = 'the full path of the file to copy'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Target'
            Type = ptString
            Description = 'the full path where to copy the file'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Overwrite'
            Type = ptBoolean
            Required = False
            Description = 
              'when this target file exists, overwrite the file when this param' +
              'eter is true'
            Properties = <>
          end>
      end
      item
        Name = 'MoveFile'
        Description = 'move a file to another'
        Parameters = <
          item
            ArrayProperties = <>
            Name = 'Source'
            Type = ptString
            Description = 'the full path of the file to move'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Target'
            Type = ptString
            Description = 'the full path where to move the file'
            Properties = <>
          end
          item
            ArrayProperties = <>
            Name = 'Overwrite'
            Type = ptBoolean
            Required = False
            Description = 
              'when this target file exists, overwrite the file when this param' +
              'eter is true'
            Properties = <>
          end>
      end>
    Left = 488
    Top = 392
  end
end
