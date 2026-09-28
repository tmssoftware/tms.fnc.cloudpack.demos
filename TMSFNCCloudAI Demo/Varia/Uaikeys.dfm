object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'AI API Keys manager'
  ClientHeight = 383
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 19
    Width = 33
    Height = 13
    Caption = 'Claude'
  end
  object Label2: TLabel
    Left = 16
    Top = 59
    Width = 48
    Height = 13
    Caption = 'DeepSeek'
  end
  object Label3: TLabel
    Left = 16
    Top = 99
    Width = 31
    Height = 13
    Caption = 'Gemini'
  end
  object Label4: TLabel
    Left = 16
    Top = 139
    Width = 22
    Height = 13
    Caption = 'Grok'
  end
  object Label5: TLabel
    Left = 16
    Top = 179
    Width = 31
    Height = 13
    Caption = 'Mistral'
  end
  object Label6: TLabel
    Left = 16
    Top = 219
    Width = 37
    Height = 13
    Caption = 'OpenAI'
  end
  object Label7: TLabel
    Left = 16
    Top = 259
    Width = 48
    Height = 13
    Caption = 'Perplexity'
  end
  object Label8: TLabel
    Left = 16
    Top = 299
    Width = 59
    Height = 13
    Caption = 'OpenRouter'
  end
  object Edit1: TEdit
    Left = 120
    Top = 16
    Width = 625
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 120
    Top = 56
    Width = 625
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 120
    Top = 96
    Width = 625
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object Edit4: TEdit
    Left = 120
    Top = 136
    Width = 625
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object Edit5: TEdit
    Left = 120
    Top = 176
    Width = 625
    Height = 21
    PasswordChar = '*'
    TabOrder = 4
  end
  object Edit6: TEdit
    Left = 120
    Top = 216
    Width = 625
    Height = 21
    PasswordChar = '*'
    TabOrder = 5
  end
  object TMSFNCCloudAI1: TTMSFNCCloudAI
    Left = 488
    Top = 336
    Width = 26
    Height = 26
    Visible = True
    Service = aiOpenAI
    Settings.GeminiModel = 'gemini-1.5-flash-latest'
    Settings.OpenAIModel = 'gpt-4o'
    Settings.OpenAISoundModel = 'gpt-4o-mini-tts'
    Settings.OpenAITranscribeModel = 'whisper-1'
    Settings.GrokModel = 'grok-beta'
    Settings.ClaudeModel = 'claude-3-5-sonnet-20241022'
    Settings.OllamaModel = 'llama3.2:latest'
    Settings.DeepSeekModel = 'deepseek-chat'
    Settings.PerplexityModel = 'llama-3.1-sonar-small-128k-online'
    Settings.OllamaHost = 'localhost'
    Settings.OllamaPath = '/api/chat'
    Settings.LlamaCppHost = 'localhost'
    Settings.LlamaCppPath = '/v1/chat/completions'
    Settings.MistralModel = 'mistral-large-latest'
    Settings.MistralTranscribeModel = 'voxtral-mini-2507'
    Tools = <>
  end
  object Edit7: TEdit
    Left = 120
    Top = 256
    Width = 625
    Height = 21
    PasswordChar = '*'
    TabOrder = 8
  end
  object Button1: TButton
    Left = 589
    Top = 337
    Width = 75
    Height = 25
    Caption = '&Load'
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 670
    Top = 337
    Width = 75
    Height = 25
    Caption = '&Save'
    TabOrder = 10
    OnClick = Button2Click
  end
  object Edit8: TEdit
    Left = 120
    Top = 296
    Width = 625
    Height = 21
    PasswordChar = '*'
    TabOrder = 11
  end
end
