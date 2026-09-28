{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright (c) 2025 - 2026                               }
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

unit Uaiweather;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCloudBase, VCL.TMSFNCCloudAI, Vcl.ExtCtrls, Vcl.ComCtrls, System.JSON;

type
  TForm1 = class(TForm)
    Memo2: TMemo;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    TMSFNCCloudAI1: TTMSFNCCloudAI;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCCloudAI1Executed(Sender: TObject;
      AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
      AHttpResult: string);
    procedure TMSFNCCloudAI1Tools0Execute(Sender: TObject; Args: TJSONObject;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
    cloudai:   TTMSFNCCloudAI;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function GetWeather(City: string): string;
var
  cbl,cbw: TTMSFNCCloudBase;
  lat,lon: string;
  temp,wind: double;
  res: string;
  FS: TFormatSettings;

begin
  res := '';

  cbl := TTMSFNCCloudBase.Create;
  cbl.Request.Host := 'https://nominatim.openstreetmap.org';
  cbl.Request.Path := '/search?q='+city+'&format=jsonv2&limit=1';

  cbl.ExecuteRequest(procedure(const ARequestResult: TTMSFNCCloudBaseRequestResult)
    var
      lJValue: TJSONValue;
      lJObject: TJSONObject;
    begin
      lJValue := TJSONObject.ParseJSONValue(ARequestResult.ResultString);

      if (lJValue is TJSONArray) then
      begin
        lJObject := TJSONObject( (lJValue as TJSONArray).Items[0]);
        lat := lJObject.GetValue<string>('lat');
        lon := lJObject.GetValue<string>('lon');

        cbw := TTMSFNCCloudBase.Create;
        cbw.Request.Host := 'https://api.open-meteo.com';
        cbw.Request.Path := '/v1/forecast?latitude='+lat+'&longitude='+lon+'&current=temperature_2m,wind_speed_10m';

        cbw.ExecuteRequest(procedure(const ARequestResult: TTMSFNCCloudBaseRequestResult)
          var
            lJValue: TJSONValue;
            lJObject: TJSONObject;
          begin
            lJValue := TJSONObject.ParseJSONValue(ARequestResult.ResultString);

            if (lJValue is TJSONObject) then
            begin
              lJObject := (lJValue as TJSONObject);
              lJObject := TJSONObject(lJObject.GetValue('current'));
              temp := lJObject.GetValue<double>('temperature_2m');
              wind := lJObject.GetValue<double>('wind_speed_10m');

              FS := TFormatSettings.Create;
              FS.DecimalSeparator := '.';

              res := '{"temperature":'+temp.ToString(FS)+',"wind":'+wind.ToString(FS)+'}';
            end;

            lJValue.Free;
            end, nil, false);
          end;
      lJValue.Free;
    end, nil, false);

  cbl.Free;
  cbw.Free;
  Result := res;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TMSFNCCloudAI1.Context.Text := Memo1.Text;
  TMSFNCCloudAI1.Execute();
  ProgressBar1.State := pbsNormal;
  memo2.Lines.Clear;
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
  TMSFNCCloudAI1.LogFileName := '.\..\..\aiweather.log';

  TMSFNCCloudAI1.APIKeys.LoadFromFile('.\..\..\aikeys.cfg','tmssoftware.com');
  ComboBox1.Items.Assign(TMSFNCCLoudAI1.GetServices(true));
  ComboBox1.ItemIndex := 0;
  ComboBox1Change(ComboBox1);
  
  //Define the model that you downloaded to llama.cpp
  //TMSFNCCloudAI1.Settings.LlamaCppModel := '';

  TMSFNCCloudAI1.Request.ReadTimeout := 500000;
  TMSFNCCloudAI1.Request.ConnectTimeout := 500000;
end;

procedure TForm1.TMSFNCCloudAI1Executed(Sender: TObject;
  AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
  AHttpResult: string);
begin
  ProgressBar1.State := pbsPaused;
  if AHttpStatusCode = 200 then
  begin
    memo2.Text := AResponse.Content.Text;
  end
  else
    ShowMessage('HTTP error code: '+AHttpStatusCode.ToString+#13#13+ AHttpResult);
end;

procedure TForm1.TMSFNCCloudAI1Tools0Execute(Sender: TObject; Args: TJSONObject;
  var Result: string);
begin
  Result := GetWeather(Args.GetValue<string>('city'));
end;

end.
