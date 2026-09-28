{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright (c) 2025                                      }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The complete source code remains property of the author and may    }
{ not be distributed, published, given or sold in any form as such.  }
{ No parts of the source code can be included in any other component }
{ or application without written authorization of the author.        }
{********************************************************************}

unit Uaitext;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase, FMX.TMSFNCCloudAI,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TMSFNCCustomControl, FMX.TMSFNCImage, FMX.ListBox,
  FMX.TMSFNCScrollControl, FMX.TMSFNCRichEditorBase, FMX.TMSFNCRichEditor,
  FMX.Memo.Types;

type
  TForm1 = class(TForm)
    Button1: TButton;
    TMSFNCCloudAI1: TTMSFNCCloudAI;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    ComboBox1: TComboBox;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    TMSFNCRichEditor1: TTMSFNCRichEditor;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TMSFNCCloudAI1Executed(Sender: TObject;
      AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
      AHttpResult: string);
    procedure ComboBox1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fname1: string;
    fname2: string;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if opendialog1.Execute then
  begin
    fname1 := opendialog1.FileName;
    memo1.Lines.LoadFromFile(fname1);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  timer1.Enabled := true;
  TMSFNCRichEditor1.Clear;
  TMSFNCCloudAI1.AddFile(fname1, aiftText);
  TMSFNCCloudAI1.Context.Clear;
  TMSFNCCloudAI1.Context.Text := 'translate the text to german';
  TMSFNCCloudAI1.Execute;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  timer1.Enabled := true;
  TMSFNCRichEditor1.Clear;
  TMSFNCCloudAI1.AddFile(fname1, aiftText);
  TMSFNCCloudAI1.Context.Clear;
  TMSFNCCloudAI1.Context.Text := 'summarize this text for me in one paragraph';
  TMSFNCCloudAI1.Execute;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  i: integer;
begin
  if ComboBox1.ItemIndex = -1 then
    Exit;

  i := integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  TMSFNCCloudAI1.Service := TTMSFNCCloudAIService(i);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCCloudAI1.Logging := true;
  TMSFNCCloudAI1.LogFileName := '.\..\..\aitext.log';
  FormatSettings.DecimalSeparator := '.';
  FormatSettings.ThousandSeparator := ',';
  TMSFNCCloudAI1.APIKeys.LoadFromFile('.\..\..\aikeys.cfg','tmssoftware.com');
  ComboBox1.ItemIndex := -1;
  ComboBox1.Items.Assign(TMSFNCCLoudAI1.GetServices(true));
  ComboBox1.ItemIndex := 0;
  ComboBox1Change(ComboBox1);

  //Define the model that you downloaded to llama.cpp
  //TMSFNCCloudAI1.Settings.LlamaCppModel := '';

  //Note: You might need to increase the timeout depending the speed you can
  //      run local models with your machine
  //TMSFNCCloudAI1.Request.ConnectTimeout := 600000;
  //TMSFNCCloudAI1.Request.ReadTimeout := 600000;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if progressbar1.Value = 100 then
    ProgressBar1.Value := 0
  else
    ProgressBar1.Value := ProgressBar1.Value + 1;
end;

procedure TForm1.TMSFNCCloudAI1Executed(Sender: TObject;
  AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
  AHttpResult: string);
begin
  TMSFNCRichEditor1.Clear;
  timer1.Enabled := false;
  ProgressBar1.Value := 0;
  if AHttpStatusCode = 200 then
    TMSFNCRichEditor1.AddMultiLineText( AResponse.Content.Text)
  else
  begin
    TMSFNCRichEditor1.AddMultiLineText( AHttpResult);
    ShowMessage('Error processing request:'+ AHttpStatusCode.ToString);
  end;
end;

end.
