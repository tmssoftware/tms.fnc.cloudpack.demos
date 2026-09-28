object Form5: TForm5
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'Show list of available LLM models'
  ClientHeight = 664
  ClientWidth = 938
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 32
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 938
    Height = 62
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    TabOrder = 0
    object ComboBox1: TComboBox
      Left = 10
      Top = 12
      Width = 244
      Height = 40
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Style = csDropDownList
      TabOrder = 0
      OnChange = ComboBox1Change
    end
    object Button1: TButton
      Left = 280
      Top = 13
      Width = 193
      Height = 38
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Show models'
      TabOrder = 1
      OnClick = Button1Click
    end
    object TMSFNCCloudAI1: TTMSFNCCloudAI
      Left = 780
      Top = 18
      Width = 26
      Height = 26
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Visible = True
      Service = aiOpenAI
      Settings.GeminiModel = 'gemini-1.5-flash-latest'
      Settings.OpenAIModel = 'gpt-4o'
      Settings.OpenAISoundModel = 'gpt-4o-mini-tts'
      Settings.OpenAITranscribeModel = 'whisper-1'
      Settings.GrokModel = 'grok-3'
      Settings.ClaudeModel = 'claude-3-5-sonnet-20241022'
      Settings.OllamaModel = 'llama3.2:latest'
      Settings.DeepSeekModel = 'deepseek-chat'
      Settings.PerplexityModel = 'sonar-pro'
      Settings.OllamaHost = 'localhost'
      Settings.OllamaPath = '/api/chat'
      Settings.LlamaCppHost = 'localhost'
      Settings.LlamaCppPath = '/v1/chat/completions'
      Settings.MistralModel = 'mistral-large-latest'
      Settings.MistralTranscribeModel = 'voxtral-mini-2507'
      Tools = <>
      OnGetModels = TMSFNCCloudAI1GetModels
    end
  end
  object ListBox1: TListBox
    AlignWithMargins = True
    Left = 10
    Top = 72
    Width = 918
    Height = 582
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alClient
    ItemHeight = 32
    PopupMenu = PopupMenu1
    TabOrder = 1
  end
  object PopupMenu1: TPopupMenu
    Left = 464
    Top = 336
    object Copytoclipboard1: TMenuItem
      Caption = 'Copy to clipboard'
      OnClick = Copytoclipboard1Click
    end
  end
end
