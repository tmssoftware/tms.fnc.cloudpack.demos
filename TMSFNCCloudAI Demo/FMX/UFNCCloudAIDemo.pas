unit UFNCCloudAIDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TMSFNCCloudAI, FMX.Edit, FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase,
  FMX.TabControl;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    meResponse: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    cbService: TComboBox;
    btSubmit: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edGemini: TEdit;
    edClaude: TEdit;
    edGrok: TEdit;
    edOpenAI: TEdit;
    edPerplexity: TEdit;
    lbResponseCode: TLabel;
    TMSFNCCloudAI1: TTMSFNCCloudAI;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    meContext: TMemo;
    meAssistantRole: TMemo;
    meSystemRole: TMemo;
    Label3: TLabel;
    lbPromptTokens: TLabel;
    Label11: TLabel;
    lbCompletionTokens: TLabel;
    Label12: TLabel;
    lbTotalTokens: TLabel;
    Label13: TLabel;
    edMistral: TEdit;
    procedure btSubmitClick(Sender: TObject);
    procedure TMSFNCCloudAI1Executed(Sender: TObject; AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
      AHttpResult: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btSubmitClick(Sender: TObject);
var
  APIKeyCheck: Boolean;
begin
  APIKeyCheck := False;
  lbResponseCode.Text := '';
  meResponse.Lines.Text := '';

  TMSFNCCloudAI1 := TTMSFNCCloudAI.Create(Self);

  TMSFNCCloudAI1.APIKeys.Gemini := edGemini.Text;
  TMSFNCCloudAI1.APIKeys.Claude := edClaude.Text;
  TMSFNCCloudAI1.APIKeys.Grok := edGrok.Text;
  TMSFNCCloudAI1.APIKeys.OpenAI := edOpenAI.Text;
  TMSFNCCloudAI1.APIKeys.Perplexity := edPerplexity.Text;
  TMSFNCCloudAI1.APIKeys.Mistral := edMistral.Text;

  case cbService.ItemIndex of
    0:
    begin
      TMSFNCCloudAI1.Service := aiOpenAI;
      APIKeyCheck := (TMSFNCCloudAI1.APIKeys.OPenAI <> '');
    end;
    1:
    begin
      TMSFNCCloudAI1.Service := aiGrok;
      APIKeyCheck := (TMSFNCCloudAI1.APIKeys.Grok <> '');
    end;
    2:
    begin
      TMSFNCCloudAI1.Service := aiGemini;
      APIKeyCheck := (TMSFNCCloudAI1.APIKeys.Gemini <> '');
    end;
    3:
    begin
      TMSFNCCloudAI1.Service := aiClaude;
      APIKeyCheck := (TMSFNCCloudAI1.APIKeys.Claude <> '');
    end;
    4:
    begin
      TMSFNCCloudAI1.Service := aiPerplexity;
      APIKeyCheck := (TMSFNCCloudAI1.APIKeys.Perplexity <> '');
    end;
    5:
    begin
      TMSFNCCloudAI1.Service := aiOllama;
      APIKeyCheck := True;
    end;
    6:
    begin
      TMSFNCCloudAI1.Service := aiMistral;
      APIKeyCheck := (TMSFNCCloudAI1.APIKeys.Mistral <> '');
    end;
  end;

  if APIKeyCheck then
  begin
    btSubmit.Enabled := False;
    TMSFNCCloudAI1.Context.Text := meContext.Lines.Text;
    TMSFNCCloudAI1.AssistantRole.Text := meAssistantRole.Lines.Text;
    TMSFNCCloudAI1.SystemRole.Text := meSystemRole.Lines.Text;
    meResponse.Lines.Text := 'Loading ...';
    TMSFNCCloudAI1.OnExecuted := TMSFNCCloudAI1Executed;
    TMSFNCCloudAI1.Execute;
  end
  else
  begin
    ShowMessage('Please enter an API key for the selected Service.');
  end;
end;

procedure TForm1.TMSFNCCloudAI1Executed(Sender: TObject;
  AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer; AHttpResult: string);
begin
  btSubmit.Enabled := True;
  lbResponseCode.Text := AHttpStatusCode.ToString;

  if Assigned(AResponse) then
  begin
    lbPromptTokens.Text := IntToStr(AResponse.PromptTokens);
    lbCompletionTokens.Text := IntToStr(AResponse.CompletionTokens);
    lbTotalTokens.Text := IntToStr(AResponse.TotalTokens);
    meResponse.Lines.Text := AResponse.Content.Text;
  end
  else
  begin
    meResponse.Lines.Text := AHttpResult;
  end;
end;

end.
