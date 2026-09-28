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

unit Uaimaps;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase, FMX.TMSFNCCloudAI,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCMapsCommonTypes, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo, FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser,
  FMX.TMSFNCMaps, System.JSON, FMX.ListBox, FMX.Memo.Types;

type
  TForm1 = class(TForm)
    TMSFNCMaps1: TTMSFNCMaps;
    Panel1: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    TMSFNCCloudAI1: TTMSFNCCloudAI;
    Memo2: TMemo;
    ComboBox1: TComboBox;
    AniIndicator1: TAniIndicator;
    procedure TMSFNCCloudAI1Tools1Execute(Sender: TObject; Args: TJSONObject;
      var Result: string);
    procedure TMSFNCCloudAI1Tools0Execute(Sender: TObject; Args: TJSONObject;
      var Result: string);
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCCloudAI1Executed(Sender: TObject;
      AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
      AHttpResult: string);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    function GetWeather(City: string): string;
    { Private declarations }
  public
    { Public declarations }
    procedure TMSFNCCloudAI1ToolsArrayExecute(Sender: TObject; Args: TJSONObject;
      var Result: string);

    procedure TMSFNCCloudAI1ToolsWeatherExecute(Sender: TObject; Args: TJSONObject;
      var Result: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

function TForm1.GetWeather(City: string): string;
var
  cb: TTMSFNCCloudBase;
  lat,lon: string;
  temp,wind: double;
  res: string;

begin
  res := '';

  cb := TTMSFNCCloudBase.Create;
  cb.Request.Host := 'https://nominatim.openstreetmap.org';
  cb.Request.Path := '/search?q='+city+'&format=jsonv2&limit=1';

  cb.ExecuteRequest(procedure(const ARequestResult: TTMSFNCCloudBaseRequestResult)
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

        cb := TTMSFNCCloudBase.Create;
        cb.Request.Host := 'https://api.open-meteo.com';
        cb.Request.Path := '/v1/forecast?latitude='+lat+'&longitude='+lon+'&current=temperature_2m,wind_speed_10m';

        cb.ExecuteRequest(procedure(const ARequestResult: TTMSFNCCloudBaseRequestResult)
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
              //res := 'The temperature is ' + temp.ToString+'°C and the wind '+wind.ToString+'km/h';
              res := '{"temperature":'+temp.ToString+',"wind":'+wind.ToString+'}';
            end;

            end, nil, false);
          end;

    end, nil, false);


  Result := res;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo2.Lines.Clear;
  TMSFNCMaps1.ClearMarkers;
  TMSFNCMaps1.ClearLabels;

  TMSFNCCloudAI1.Logging := true;
  TMSFNCCloudAI1.LogFileName := '.\..\..\aimaps.log';

  AniIndicator1.Enabled := true;
  Button1.Enabled := false;

  TMSFNCCloudAI1.Context.Clear;
  TMSFNCCloudAI1.Context.Add(memo1.Lines.Text);
  TMSFNCCloudAI1.Execute;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  i: integer;
begin
  i := integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  TMSFNCCloudAI1.Service := TTMSFNCCloudAIService(i);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  t: TTMSFNCCloudAITool;
  ap,p: TTMSFNCCloudAIParameter;

begin
  TMSFNCCloudAI1.APIKeys.LoadFromFile('.\..\..\aikeys.cfg','tmssoftware.com');
  TMSFNCCloudAI1.Request.ReadTimeout := 200000;

  //Define the model that you downloaded to llama.cpp
  //TMSFNCCloudAI1.Settings.LlamaCppModel := '';

  //Note: You might need to increase the timeout depending the speed you can
  //      run local models with your machine
  //TMSFNCCloudAI1.Request.ConnectTimeout := 600000;
  //TMSFNCCloudAI1.Request.ReadTimeout := 600000;

  ComboBox1.ItemIndex := -1;
  ComboBox1.Items.Assign(TMSFNCCLoudAI1.GetServices(true));
  ComboBox1.ItemIndex := 0;
  ComboBox1Change(ComboBox1);

  t := TMSFNCCloudAI1.Tools.Add;
  t.Name := 'addweather';
  t.Description := 'add a label with weather info on the map';

  p := t.Parameters.Add;
  p.&Type := ptArray;
  p.Name := 'labels';
  p.Description := 'label array';
  p.ArrayType := ptObject;
  ap := p.ArrayProperties.Add;
  ap.Name := 'lon';
  ap.Description := 'the longitude';
  ap.&Type := ptNumber;
  ap := p.ArrayProperties.Add;
  ap.Name := 'lat';
  ap.Description := 'the latitude';
  ap.&Type := ptNumber;
  ap := p.ArrayProperties.Add;
  ap.Name := 'weather';
  ap.Description := 'the weather for the label';
  ap.&Type := ptString;

  t.OnExecute := TMSFNCCloudAI1ToolsArrayExecute;

  t := TMSFNCCloudAI1.Tools.Add;
  t.Name := 'getweather';
  t.Description := 'Get the weather for the specified city';

  p := t.Parameters.Add;
  p.&Type := ptString;
  p.Name := 'city';

  t.OnExecute := TMSFNCCloudAI1ToolsWeatherExecute;
end;

procedure TForm1.TMSFNCCloudAI1Executed(Sender: TObject;
  AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
  AHttpResult: string);
begin
  AniIndicator1.Enabled := false;
  Button1.Enabled := true;

  if AHttpStatusCode = 200 then
    Memo2.Lines.Add(aresponse.Content.Text)
  else
    ShowMessage('HTTP error code: '+AHttpStatusCode.ToString+#13#13+ AHttpResult);
end;

procedure TForm1.TMSFNCCloudAI1Tools0Execute(Sender: TObject; Args: TJSONObject;
  var Result: string);
begin
  TMSFNCMaps1.ClearMarkers;
end;

procedure TForm1.TMSFNCCloudAI1Tools1Execute(Sender: TObject; Args: TJSONObject;
  var Result: string);
var
  lon,lat: double;
  title: string;
  rec: TTMSFNCMapsCoordinateRec;
begin
  lon := args.GetValue<double>('lon');
  lat := args.GetValue<double>('lat');
  title := args.GetValue<string>('title');

  rec.Longitude := lon;
  rec.Latitude := lat;

  tmsfncmaps1.AddMarker(rec, title);
end;

procedure TForm1.TMSFNCCloudAI1ToolsArrayExecute(Sender: TObject;
  Args: TJSONObject; var Result: string);
var
  ja: TJSONArray;
  jo: TJSONObject;
  i: integer;
  lon,lat: double;
  title: string;
  rec: TTMSFNCMapsCoordinateRec;

begin
  ja := TJSONArray(args.GetValue('labels'));

  for i := 0 to ja.Count - 1 do
  begin
    jo := TJSONObject(ja.Items[i]);

    lon := jo.GetValue<double>('lon');
    lat := jo.GetValue<double>('lat');
    title := jo.GetValue<string>('weather');
    rec.Longitude := lon;
    rec.Latitude := lat;
    tmsfncmaps1.AddLabel(rec, title, gcRed, gcYellow);
  end;
end;

procedure TForm1.TMSFNCCloudAI1ToolsWeatherExecute(Sender: TObject;
  Args: TJSONObject; var Result: string);
var
  city: string;
begin
  city := Args.GetValue<string>('city');
  Result := GetWeather(city);

  memo2.Lines.Add(city+'='+result);
end;

end.
