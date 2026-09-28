unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, JS, Web, WEBLib.Graphics, WEBLib.Forms, VCL.Graphics, VCL.Dialogs,
  Vcl.StdCtrls, WEBLib.TMSFNCCustomComponent,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth, WEBLib.TMSFNCCloudGoogle,
  WEBLib.TMSFNCCloudGoogleCalendar,
  WEBLib.TMSFNCUtils, UHelper;

type
  TForm3 = class(TWebForm)
    Button1: TWebButton;
    ListBox1: TWebListBox;
    Label3: TWebLabel;
    Label1: TWebLabel;
    ListBox2: TWebListBox;
    Label2: TWebLabel;
    Label4: TWebLabel;
    Edit1: TWebEdit;
    Edit2: TWebEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    calendar: TTMSFNCCloudGoogleCalendarPromise;
    { Public declarations }
    procedure LoginToGoogleCalendar(AClientID, ASecret: string);
    procedure GetCalendarByIndex(AIndex: Integer);
  end;

var
  Form3: TForm3;

const
  CLIENT_ID = '';
  SECRET = '';

//Instructions on getting your own clientID and secret:
//https://www.tmssoftware.com/site/cloudkey.asp#Google

implementation

{$R *.dfm}

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  calendar.Free;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Edit1.Text := CLIENT_ID;
  Edit2.Text := SECRET;

  calendar := TTMSFNCCloudGoogleCalendarPromise.Create;
  calendar.Authentication.CallBackURL := 'http://localhost:8000';
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  if (Edit1.Text = '') or (Edit2.Text = '') then
    ShowMessage('Credentials cannot be empty!')
  else
    LoginToGoogleCalendar(Edit1.Text, Edit2.Text);
end;

procedure TForm3.ListBox1Change(Sender: TObject);
begin
  if ListBox1.ItemIndex <> -1 then
    GetCalendarByIndex(ListBox1.ItemIndex)
  else
    ListBox2.Clear;
end;

procedure TForm3.LoginToGoogleCalendar(AClientID, ASecret: string);
begin
  calendar.Authentication.ClientID := AClientID;
  calendar.Authentication.Secret := ASecret;

  calendar.ConnectPromise._then(function (AValue: JSValue): JSValue
  begin
    Result := calendar.GetCalendarsPromise;
  end)._then(function (AValue: JSValue): JSValue
  var
    I: Integer;
  begin
    ListBox1.BeginUpdate;
    ListBox1.Clear;
    for I := 0 to calendar.Calendars.Count - 1 do
      ListBox1.Items.AddObject(calendar.Calendars[I].Summary, calendar.Calendars[I]);
    ListBox1.EndUpdate;

    if ListBox1.Items.Count > 0 then
    begin
      ListBox1.ItemIndex := 0;
      GetCalendarByIndex(0);
    end
    else
      ShowMessage('No calendars are available');
  end).catch(function (AValue: JSValue): JSValue
  begin
    if AValue is TJSError then
      ShowMessage(TJSError(AValue).Message);
  end);
end;

procedure TForm3.GetCalendarByIndex(AIndex: Integer);
begin
  calendar.GetCalendarPromise(TTMSFNCCloudGoogleCal(ListBox1.Items.Objects[AIndex]).ID)._then(function (AValue: JSValue): JSValue
  var
    I: Integer;
    c: TTMSFNCCloudGoogleCalendarItem;
  begin
    ListBox2.BeginUpdate;
    ListBox2.Clear;
    for I := 0 to calendar.Items.Count - 1 do
    begin
      c := calendar.Items[I];
      ListBox2.Items.Add(c.Summary + ' - ' + DateTimeToStr(c.StartTime));
    end;
    Listbox2.EndUpdate;
  end).catch(function (AValue: JSValue): JSValue
  begin
    if AValue is TJSError then
      ShowMessage(TJSError(AValue).Message);
  end);
end;


end.
