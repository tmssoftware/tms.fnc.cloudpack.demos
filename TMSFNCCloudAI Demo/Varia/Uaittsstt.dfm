object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'AI automatic voice translation'
  ClientHeight = 435
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 24
    Top = 24
    Width = 113
    Height = 105
    OnClick = PaintBox1Click
    OnPaint = PaintBox1Paint
  end
  object Label1: TLabel
    Left = 168
    Top = 24
    Width = 409
    Height = 105
    AutoSize = False
    Caption = 'AI based automatic voice translator'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -43
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 24
    Top = 155
    Width = 116
    Height = 13
    Caption = 'Result of speech to text'
  end
  object Label3: TLabel
    Left = 24
    Top = 285
    Width = 97
    Height = 13
    Caption = 'Result of translation'
  end
  object Memo1: TMemo
    Left = 24
    Top = 174
    Width = 409
    Height = 105
    TabOrder = 0
    OnChange = Memo1Change
  end
  object TMSFNCCloudAI1: TTMSFNCCloudAI
    Left = 496
    Top = 272
    Width = 26
    Height = 26
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
    Settings.MistralModel = 'mistral-large-latest'
    Tools = <>
    OnExecuted = TMSFNCCloudAI1Executed
    OnSpeechAudio = TMSFNCCloudAI1SpeechAudio
    OnTranscribeAudio = TMSFNCCloudAI1TranscribeAudio
  end
  object Memo2: TMemo
    Left = 24
    Top = 304
    Width = 409
    Height = 112
    TabOrder = 3
  end
  object ComboBox1: TComboBox
    Left = 447
    Top = 174
    Width = 145
    Height = 21
    TabOrder = 4
    Text = 'German'
    Items.Strings = (
      'French'
      'German'
      'English'
      'Italian'
      'Portuguese'
      'Spanish')
  end
  object btnTranslate: TButton
    Left = 447
    Top = 214
    Width = 145
    Height = 25
    Caption = 'Translate'
    Enabled = False
    TabOrder = 5
    OnClick = btnTranslateClick
  end
end
