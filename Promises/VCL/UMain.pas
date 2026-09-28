unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCloudBase, VCL.TMSFNCCloudOAuth, VCL.TMSFNCCloudGoogle,
  VCL.TMSFNCCloudGoogleCalendar, Next.Core.Promises, Next.Core.Void,
  VCL.TMSFNCUtils, UHelper;

type
  TForm3 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Label3: TLabel;
    Label1: TLabel;
    ListBox2: TListBox;
    Label2: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox1Click(Sender: TObject);
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

var
  FormClosing: Boolean;

{$R *.dfm}

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  calendar.Free;
end;

procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FormClosing := True;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Edit1.Text := CLIENT_ID;
  Edit2.Text := SECRET;

  FormClosing := False;

  calendar := TTMSFNCCloudGoogleCalendarPromise.Create;
  calendar.Authentication.CallBackURL := 'http://127.0.0.1:8899';
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  if (Edit1.Text = '') or (Edit2.Text = '') then
    ShowMessage('Credentials cannot be empty!')
  else
    LoginToGoogleCalendar(Edit1.Text, Edit2.Text);
end;

procedure TForm3.ListBox1Click(Sender: TObject);
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

  Promise.New<TVoid>(procedure(AResolve: TProc<TVoid>; AReject: TProc<Exception>)
  begin
    calendar.ConnectPromise(AResolve, AReject); //connect
  end).ThenBy(function (const AResult: TVoid): IPromise<TVoid>
  begin
    Result := Promise.New<TVoid>(procedure(AResolve: TProc<TVoid>; AReject: TProc<Exception>)
    begin
      calendar.GetCalendarsPromise(AResolve, AReject); //Get all available calendars
    end)
  end)
  .Main.ThenBy<TVoid>(function (const AResult: TVoid): TVoid
  var
    I: Integer;
  begin
    //Interact with UI elements in the main thread
    if not FormClosing then
    begin
      ListBox1.Clear;
      for I := 0 to calendar.Calendars.Count - 1 do
        ListBox1.Items.AddObject(calendar.Calendars[I].Summary, calendar.Calendars[I]);

      if ListBox1.Items.Count > 0 then
      begin
        ListBox1.ItemIndex := 0;
        GetCalendarByIndex(0);
      end
      else
        ShowMessage('No calendars are available');
    end;
    Result := Void;
  end).Main.Catch(procedure (E: Exception)
  begin
    ShowMessage(E.Message);
  end);
end;

procedure TForm3.GetCalendarByIndex(AIndex: Integer);
begin
  //Create a new promise to get the items
  Promise.New<TVoid>(procedure (AResolve: TProc<TVoid>; AReject: TProc<Exception>)
  begin
    calendar.GetCalendarPromise(TTMSFNCCloudGoogleCal(ListBox1.Items.Objects[AIndex]).ID, AResolve, AReject);
  end)
  .Main.ThenBy<TVoid>(function (const AResult: TVoid): TVoid
  var
    I: Integer;
    c: TTMSFNCCloudGoogleCalendarItem;
  begin
    //Interact with UI in main thread to update the second listbox
    if not FormClosing then
    begin
      ListBox2.Clear;
      for I := 0 to calendar.Items.Count - 1 do
      begin
        c := calendar.Items[I];
        ListBox2.Items.Add(c.Summary + ' - ' + DateTimeToStr(c.StartTime));
      end;
    end;

    Result := Void;
  end).Main.Catch(procedure (E: Exception)
  begin
    ShowMessage(E.Message);
  end);
end;


end.
