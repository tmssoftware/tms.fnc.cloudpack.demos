unit uaitoolsets;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, VCL.TMSFNCCustomComponent, VCL.TMSFNCCloudBase,
  VCL.TMSFNCCloudAI, VCL.TMSFNCCloudAIToolSets;

type
  TForm1 = class(TForm)
    TMSFNCCloudAI1: TTMSFNCCloudAI;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    Memo2: TMemo;
    fs: TTMSFNCCloudAIFileSystem;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCCloudAI1Executed(Sender: TObject;
      AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
      AHttpResult: string);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.IOUtils;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ProgressBar1.State := pbsNormal;

  TMSFNCCloudAI1.Request.ConnectTimeout := 300000;
  TMSFNCCloudAI1.Request.ReadTimeout := 300000;

  TMSFNCCloudAI1.Context.Text := Memo1.Lines.Text;
  TMSFNCCloudAI1.Execute();
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  i: integer;
begin
  i := integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  TMSFNCCloudAI1.Service := TTMSFNCCloudAIService(i);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := true;

  TMSFNCCloudAI1.Logging := true;
  TMSFNCCloudAI1.LogFileName := '.\..\..\aitoolsets.log';

  TMSFNCCloudAI1.APIKeys.LoadFromFile('.\..\..\aikeys.cfg','tmssoftware.com');

  ComboBox1.ItemIndex := -1;
  ComboBox1.Items.Assign(TMSFNCCLoudAI1.GetServices(false, false));
  ComboBox1.ItemIndex := 0;
  ComboBox1Change(Self);

  //Define the model that you downloaded to llama.cpp
  //TMSFNCCloudAI1.Settings.LlamaCppModel := '';

  //Note: You might need to increase the timeout depending the speed you can
  //      run local models with your machine
  //TMSFNCCloudAI1.Request.ConnectTimeout := 500000;
  //TMSFNCCloudAI1.Request.ReadTimeout := 500000;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  fs.Free;
end;

procedure TForm1.TMSFNCCloudAI1Executed(Sender: TObject;
  AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
  AHttpResult: string);
begin
  ProgressBar1.State := pbsPaused;
  if AHttpStatusCode div 100 = 2 then
  begin
    Memo2.Lines.Text := AResponse.Content.Text;
  end
  else
    Memo2.Lines.Text := 'HTTP Status code: '+ AHttpStatusCode.ToString +' : ' + AHttpResult;
end;

end.
