unit UCloudLoggerDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.TMSFNCCloudLogger, VCL.TMSFNCCloudBase,
  VCL.TMSFNCCustomComponent;

type
  TForm2 = class(TForm)
    RadioExc: TRadioButton;
    RadioSentry: TRadioButton;
    RadioRollbar: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ExcMail: TEdit;
    ExcPassword: TEdit;
    SentryToken: TEdit;
    RollBarToken: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Label5: TLabel;
    MsgEdit: TEdit;
    ComboBox1: TComboBox;
    Button7: TButton;
    Label6: TLabel;
    SIdLbl: TLabel;
    SLvlLbl: TLabel;
    STitleLbl: TLabel;
    Label7: TLabel;
    SFirstLbl: TLabel;
    Label9: TLabel;
    SLastLbl: TLabel;
    Label11: TLabel;
    SStatusLbl: TLabel;
    Label13: TLabel;
    STotOccLbl: TLabel;
    EIdLbl: TLabel;
    ELvlLbl: TLabel;
    ETitleLbl: TLabel;
    EIPLbl: TLabel;
    EDateLbl: TLabel;
    ESrcLbl: TLabel;
    EMsgMemo: TMemo;
    l: TTMSFNCCloudLogger;
    procedure RadioRollbarClick(Sender: TObject);
    procedure RadioSentryClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure RadioExcClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure DoConnected(Sender: TObject);
    procedure DoGetAllProjects(Sender: TObject; AProjects: TTMSFNCCloudLoggerProjects; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoGetAllStacks(Sender: TObject; AProject: TTMSFNCCloudLoggerProject; AStacks: TTMSFNCCloudLoggerStacks; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoGetAllEvents(Sender: TObject; AStack: TTMSFNCCloudLoggerStack; AEvents: TTMSFNCCloudLoggerEvents; const ARequestResult: TTMSFNCCloudBaseRequestResult);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitializeExc;
    procedure InitializeSentry;
    procedure InitializeRollbar;
    procedure ClearUI;
    procedure ClearEventLabels;
    procedure ClearStackLabels;
    function GetLevel(ALevel: string): TTMSFNCCloudLoggerLogLevel;
    function LevelToString(ALevel: TTMSFNCCloudLoggerLogLevel): string;
    function StatusToString(AStatus: TTMSFNCCloudLoggerStatus): string;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  ListBox1.Items.Clear;
  l.GetAllProjects;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if ListBox2.ItemIndex >=0 then
  begin
    ListBox3.Items.Clear;
    (ListBox2.Items.Objects[ListBox2.ItemIndex] as TTMSFNCCloudLoggerStack).GetAllEvents;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  case l.Service of
    lsExceptionless: l.Connect(ExcMail.Text, ExcPassword.Text);
    lsSentry: l.Connect(SentryToken.Text);
    lsRollbar: l.Connect(RollbarToken.Text);
  end;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  l.LogMessage((ListBox1.Items.Objects[ListBox1.ItemIndex] as TTMSFNCCloudLoggerProject).ID, MsgEdit.Text , GetLevel(ComboBox1.Items[ComboBox1.ItemIndex]), 'UCloudLoggerDemo.pas');
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  if ListBox1.ItemIndex >=0 then
  begin
    ListBox2.Items.Clear;
    ListBox3.Items.Clear;
    ClearEventLabels;

    (ListBox1.Items.Objects[ListBox1.ItemIndex] as TTMSFNCCloudLoggerProject).GetAllStacks;
  end;
end;

procedure TForm2.Button6Click(Sender: TObject);
var
  j: Integer;
begin
  try
    j := 0;
    j := 13 div j;
  except
    on E: Exception do
    begin
      l.LogException((ListBox1.Items.Objects[ListBox1.ItemIndex] as TTMSFNCCloudLoggerProject).ID, e.message, e.ClassName, 'UCloudLoggerDemo.pas', 'Button6Click');
    end;
  end;
end;

procedure TForm2.Button7Click(Sender: TObject);
var
  j: integer;
begin
  try
    j := StrToInt('abs');
  except
    on E: Exception do
    begin
      l.LogException((ListBox1.Items.Objects[ListBox1.ItemIndex] as TTMSFNCCloudLoggerProject).ID, e.message, e.ClassName, 'UCloudLoggerDemo.pas', 'Button7Click');
    end;
  end;
end;

procedure TForm2.ClearEventLabels;
begin
  EMsgMemo.Visible := False;
  EIdLbl.Caption := '';
  ELvlLbl.Caption := '';
  ETitleLbl.Caption := '';
  EIPLbl.Caption := '';
  ESrcLbl.Caption := '';
  EDateLbl.Caption := '';
  EMsgMemo.Text := '';
end;

procedure TForm2.ClearStackLabels;
begin
  Label7.Visible := False;
  Label11.Visible := False;
  Label9.Visible := False;
  Label13.Visible := False;
  ClearEventLabels;
  SIdLbl.Caption := '';
  SLvlLbl.Caption := '';
  SFirstLbl.Caption := '';
  SLastLbl.Caption := '';
  STotOccLbl.Caption := '';
  STitleLbl.Caption := '';
  SStatusLbl.Caption := '';
end;

procedure TForm2.ClearUI;
begin
  ListBox1.Items.Clear;
  ListBox2.Items.Clear;
  ListBox3.Items.Clear;
  Button1.Enabled := False;
  Button2.Enabled := False;
  Button5.Enabled := False;
  Button6.Enabled := False;
  Button7.Enabled := False;
  ClearStackLabels;
end;

procedure TForm2.DoConnected(Sender: TObject);
begin
  Button3.Caption := 'Connected';
  Button1.Enabled := True;
end;

procedure TForm2.DoGetAllEvents(Sender: TObject;
  AStack: TTMSFNCCloudLoggerStack; AEvents: TTMSFNCCloudLoggerEvents;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  for I := 0 to AEvents.Count - 1 do
  begin
    ListBox3.Items.AddObject(AEvents[I].Message, AEvents[I])
  end;
end;

procedure TForm2.DoGetAllProjects(Sender: TObject;
  AProjects: TTMSFNCCloudLoggerProjects;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  for I := 0 to AProjects.Count - 1 do
  begin
    ListBox1.Items.AddObject(AProjects[I].Name + ' (' + AProjects[I].ID + ')', AProjects[I])
  end;
end;

procedure TForm2.DoGetAllStacks(Sender: TObject;
  AProject: TTMSFNCCloudLoggerProject; AStacks: TTMSFNCCloudLoggerStacks;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  for I := 0 to AStacks.Count - 1 do
  begin
    ListBox2.Items.AddObject(AStacks[I].Title, AStacks[I])
  end;
end;

function TForm2.GetLevel(ALevel: string): TTMSFNCCloudLoggerLogLevel;
begin
  if ALevel = 'Info' then
    Result := llInfo
  else if ALevel = 'Warning' then
    Result := llWarning
  else if ALevel = 'Fatal' then
    Result := llFatal
  else
    Result := llDebug;
end;

procedure TForm2.InitializeExc;
begin
  ClearUI;
  l.Service := lsExceptionless;
  l.EmailAddress := ExcMail.Text;
  l.Password := ExcPassword.Text;
end;

procedure TForm2.InitializeRollbar;
begin
  ClearUI;
  l.Service := lsRollbar;
  l.Token := RollbarToken.Text;
  Button1.Enabled := true;
end;

procedure TForm2.InitializeSentry;
begin
  ClearUI;
  l.Service := lsSentry;
  l.Token := SentryToken.Text;
  Button1.Enabled := true;
end;

function TForm2.LevelToString(ALevel: TTMSFNCCloudLoggerLogLevel): string;
begin
  case ALevel of
    llDebug: Result := 'Debug';
    llInfo: Result := 'Info';
    llWarning: Result := 'Warning';
    llError: Result := 'Error';
    llFatal: Result := 'Fatal';
    llTrace: Result := 'Trace';
    llOff: Result := 'Off';
    else
      Result := 'Unknown';
  end;
end;

procedure TForm2.ListBox1Click(Sender: TObject);
var
  b: Boolean;
begin
  b := ListBox1.ItemIndex >= 0;
  Button4.Enabled := b;
  Button5.Enabled := b;
  Button6.Enabled := b;
  Button7.Enabled := b;
end;

procedure TForm2.ListBox2Click(Sender: TObject);
var
  s: TTMSFNCCloudLoggerStack;
begin
  Button2.Enabled := ListBox2.ItemIndex >= 0;
  ClearStackLabels;
  if ListBox2.ItemIndex >= 0 then
  begin
    Label7.Visible := True;
    Label11.Visible := True;
    Label9.Visible := True;
    Label13.Visible := True;

    s := (ListBox2.Items.Objects[ListBox2.ItemIndex] as TTMSFNCCloudLoggerStack);
    SIdLbl.Caption := s.ID;
    if s.Level <> llUnknown then
      SLvlLbl.Caption := LevelToString(s.Level)
    else
      SLvlLbl.Caption := '';
    SFirstLbl.Caption := DateTimeToStr(s.FirstOccurrence);
    SLastLbl.Caption := DateTimeToStr(s.LastOccurrence);
    STotOccLbl.Caption := IntToStr(s.TotalOccurrences);
    STitleLbl.Caption := s.Title;
    SStatusLbl.Caption := StatusToString(s.Status);
  end;
end;

procedure TForm2.ListBox3Click(Sender: TObject);
var
  e: TTMSFNCCloudLoggerEvent;
begin
  ClearEventLabels;

  if ListBox3.ItemIndex >=0 then
  begin
    e := (ListBox3.Items.Objects[ListBox3.ItemIndex] as TTMSFNCCloudLoggerEvent);
    EIdLbl.Caption := e.ID;
    if e.Level <> llUnknown then
      ELvlLbl.Caption := LevelToString(e.Level)
    else
      ELvlLbl.Caption := '';

    EMsgMemo.Visible := True;

    ETitleLbl.Caption := e.Title;
    EIPLbl.Caption := e.IPAddress;
    ESrcLbl.Caption := e.Source;
    EDateLbl.Caption := DateTimeToStr(e.DateCreated);
    EMsgMemo.Text := e.Message;
  end;
end;

procedure TForm2.RadioExcClick(Sender: TObject);
begin
  if (l.Service <> lsExceptionless) then
  begin
    Button3.Caption := 'Connect';
    InitializeExc
  end
end;

procedure TForm2.RadioRollbarClick(Sender: TObject);
begin
  if (l.Service <> lsRollbar) then
  begin
    InitializeRollbar
  end;
end;

procedure TForm2.RadioSentryClick(Sender: TObject);
begin
  if (l.Service <> lsSentry) then
  begin
    InitializeSentry
  end;
end;

function TForm2.StatusToString(AStatus: TTMSFNCCloudLoggerStatus): string;
begin
  case AStatus of
    lstUnresolved: Result := 'Unresolved';
    lstResolved: Result := 'Resolved';
    lstMuted: Result := 'Muted';
    lstIgnored: Result := 'Ignored';
    lstDiscarded: Result := 'Discarded';
  end;
end;

end.
