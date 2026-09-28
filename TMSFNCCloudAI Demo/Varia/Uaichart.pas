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
unit Uaichart;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCCloudBase, FMX.TMSFNCCloudAI, FMX.Controls.Presentation,
  FMX.TMSFNCChart, System.JSON, FMX.ListBox, FMX.Layouts, FMX.Memo.Types;

type
  TForm3 = class(TForm)
    TMSFNCChart1: TTMSFNCChart;
    Panel1: TPanel;
    TMSFNCCloudAI1: TTMSFNCCloudAI;
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    ComboBox1: TComboBox;
    AniIndicator1: TAniIndicator;
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCCloudAI1Tools0Execute(Sender: TObject; Args: TJSONObject;
      var Result: string);
    procedure TMSFNCCloudAI1Tools1Execute(Sender: TObject; Args: TJSONObject;
      var Result: string);
    procedure TMSFNCCloudAI1Tools2Execute(Sender: TObject; Args: TJSONObject;
      var Result: string);
    procedure TMSFNCCloudAI1Tools3Execute(Sender: TObject; Args: TJSONObject;
      var Result: string);
    procedure TMSFNCCloudAI1Executed(Sender: TObject;
      AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
      AHttpResult: string);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
begin
  memo2.Lines.Text := '';
  TMSFNCChart1.BeginUpdate;
  TMSFNCChart1.Series.Clear;
  TMSFNCChart1.EndUpdate;

  TMSFNCCloudAI1.Context.Text := memo1.Lines.Text;

  AniIndicator1.Enabled := true;
  Button1.Enabled := false;

  TMSFNCChart1.BeginUpdate;
  TMSFNCCloudAI1.Execute();
end;

procedure TForm3.ComboBox1Change(Sender: TObject);
var
  i: integer;
begin
  i := integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  TMSFNCCloudAI1.Service := TTMSFNCCloudAIService(i);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  TMSFNCCloudAI1.Logging := true;
  TMSFNCCloudAI1.LogFileName := '.\..\..\aichart.log';
  TMSFNCCloudAI1.APIKeys.LoadFromFile('.\..\..\aikeys.cfg','tmssoftware.com');

  //Define the model that you downloaded to llama.cpp
  //TMSFNCCloudAI1.Settings.LlamaCppModel := '';

  //Note: You might need to increase the timeout depending the speed you can
  //      run local models with your machine
  //TMSFNCCloudAI1.Request.ConnectTimeout := 600000;

  TMSFNCCloudAI1.Request.ReadTimeout := 200000;

  ComboBox1.ItemIndex := -1;
  ComboBox1.Items.Assign(TMSFNCCLoudAI1.GetServices(true));
  ComboBox1.ItemIndex := 0;
  ComboBox1Change(ComboBox1);
end;

procedure TForm3.TMSFNCCloudAI1Executed(Sender: TObject;
  AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
  AHttpResult: string);
begin
  AniIndicator1.Enabled := false;
  Button1.Enabled := true;

  if (AHttpStatusCode div 100 = 2) then
    memo2.Lines.Add(AResponse.Content.Text)
  else
    memo2.Lines.Add('HTTP error:'+ AHttpStatusCode.ToString+ ':'+ AHttpResult);

  TMSFNCChart1.EndUpdate;
end;

procedure TForm3.TMSFNCCloudAI1Tools0Execute(Sender: TObject; Args: TJSONObject;
  var Result: string);
begin
  TMSFNCChart1.Series.Clear;
end;

procedure TForm3.TMSFNCCloudAI1Tools1Execute(Sender: TObject; Args: TJSONObject;
  var Result: string);
begin
  TMSFNCChart1.Series.Add.ChartType := ctBar;
end;

procedure TForm3.TMSFNCCloudAI1Tools2Execute(Sender: TObject; Args: TJSONObject;
  var Result: string);
begin
  TMSFNCChart1.Series.Add.ChartType := ctPie;
end;

procedure TForm3.TMSFNCCloudAI1Tools3Execute(Sender: TObject; Args: TJSONObject;
  var Result: string);
var
  pt: double;
  title: string;
  i: integer;
begin
  if TMSFNCChart1.Series.Count >  0 then
  begin
    pt := Args.GetValue<double>('value');
    title := Args.GetValue<string>('title');

    i := TMSFNCChart1.Series[0].AddPoint(pt).Index;
    TMSFNCChart1.Series[0].Points[i].Annotations.Add.Text := title;
  end;
end;

end.
