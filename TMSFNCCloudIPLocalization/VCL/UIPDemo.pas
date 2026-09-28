unit UIPDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.TMSFNCCloudIPLocalization, VCL.TMSFNCCloudBase,
  VCL.TMSFNCCustomComponent, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    GeneralPanel: TPanel;
    LCity: TLabel;
    Label3: TLabel;
    LRegion: TLabel;
    Label2: TLabel;
    LCountry: TLabel;
    Label4: TLabel;
    LContinent: TLabel;
    Label5: TLabel;
    LLongitude: TLabel;
    Label6: TLabel;
    LLatitude: TLabel;
    LProxy: TLabel;
    ImgFlag: TImage;
    ASPanel: TPanel;
    Label8: TLabel;
    LASName: TLabel;
    Label10: TLabel;
    LASN: TLabel;
    LISP: TLabel;
    Label11: TLabel;
    LConType: TLabel;
    Label9: TLabel;
    TimeZonePanel: TPanel;
    Label12: TLabel;
    LTimeZone: TLabel;
    Label14: TLabel;
    LGMTOffset: TLabel;
    Label16: TLabel;
    LTime: TLabel;
    Label18: TLabel;
    LDST: TLabel;
    Edit1: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Edit2: TEdit;
    Button1: TButton;
    ComboBox1: TComboBox;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    TMSFNCCloudIPLocalization1: TTMSFNCCloudIPLocalization;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DoGetIP(Sender: TObject; AIP: TTMSFNCCloudIPLocalizationIP; AError: Boolean; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoGetFlagImage(Sender: TObject; ARequestResult: TTMSFNCCloudBaseRequestResult; AIP: TTMSFNCCloudIPLocalizationIP; AFlagImageStream: TMemoryStream);
    procedure SetProperties;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurIP: string;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

{ TForm2 }


procedure TForm2.Button1Click(Sender: TObject);
var
  ip: TTMSFNCCloudIPLocalizationIP;
begin
  TMSFNCCloudIPLocalization1.APIKey := Edit1.Text;
  Button1.Caption := 'Requesting IP';
  if Edit2.Text <> '' then
  begin
    ip := TMSFNCCloudIPLocalization1.GetLocalizedIPByIPAddress(Edit2.Text);
    if ip <> nil then
      TMSFNCCloudIPLocalization1.GetIP(ip)
    else
      TMSFNCCloudIPLocalization1.GetIP(Edit2.Text);
  end
  else
    TMSFNCCloudIPLocalization1.GetIP;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
  if (ComboBox1.ItemIndex >= 0) and ((ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TTMSFNCCloudIPLocalizationIP).IPAddress <> CurIP) then
  begin
    SetProperties;
  end;
end;

procedure TForm2.DoGetFlagImage(Sender: TObject; ARequestResult: TTMSFNCCloudBaseRequestResult;  AIP: TTMSFNCCloudIPLocalizationIP; AFlagImageStream: TMemoryStream);
begin
  if (ComboBox1.ItemIndex >= 0) and ((ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TTMSFNCCloudIPLocalizationIP).IPAddress = AIP.IPAddress)  then
  begin
    ImgFlag.Picture.LoadFromStream(AFlagImageStream);
  end;
end;

procedure TForm2.DoGetIP(Sender: TObject; AIP: TTMSFNCCloudIPLocalizationIP; AError: Boolean; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
  idx: Integer;
begin
  if AError then
    Button1.Caption := 'Error retrieving IP'
  else
    Button1.Caption := 'IP Added';
  ComboBox1.Items.Clear;
  idx := ComboBox1.ItemIndex;

  for I := 0 to TMSFNCCloudIPLocalization1.IPs.Count - 1 do
  begin
    ComboBox1.Items.AddObject(TMSFNCCloudIPLocalization1.IPs[I].IPAddress, TMSFNCCloudIPLocalization1.IPs[I]);
  end;

  ComboBox1.ItemIndex := idx;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  TMSFNCCloudIPLocalization1 := TTMSFNCCloudIPLocalization.Create(Self);
  TMSFNCCloudIPLocalization1.OnGetIP := DoGetIP;
  TMSFNCCloudIPLocalization1.OnGetFlagImage := DoGetFlagImage;
end;

procedure TForm2.RadioButton1Click(Sender: TObject);
begin
  RadioButton2.Checked := False;
  RadioButton3.Checked := False;
  TMSFNCCloudIPLocalization1.Service := ipsAbstractAPI;
end;

procedure TForm2.RadioButton2Click(Sender: TObject);
begin
  RadioButton1.Checked := False;
  RadioButton3.Checked := False;
  TMSFNCCloudIPLocalization1.Service := ipsIPData;
end;

procedure TForm2.RadioButton3Click(Sender: TObject);
begin
  RadioButton2.Checked := False;
  RadioButton1.Checked := False;
  TMSFNCCloudIPLocalization1.Service := ipsIPStack;
end;

procedure TForm2.SetProperties;
var
  ip: TTMSFNCCloudIPLocalizationIP;
begin
  ip := (ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TTMSFNCCloudIPLocalizationIP);
  CurIP := ip.IPAddress;

  LCity.Caption := ip.City + ' (' + ip.PostalCode +')';
  LRegion.Caption := ip.Region;
  LCountry.Caption := ip.Country;
  LContinent.Caption := ip.ContinentName;
  LLongitude.Caption := FloatToStr(ip.Longitude);
  LLatitude.Caption := FloatToStr(ip.Latitude);

  if Assigned(ip.Flag.FlagImageStream) and (ip.Flag.FlagImageStream.Size > 0) then
  begin
    ip.Flag.FlagImageStream.Position := 0;
    ImgFlag.Picture.LoadFromStream(ip.Flag.FlagImageStream);
  end
  else
    ImgFlag.Picture := nil;

  if ip.IsVPN then
  begin
    LProxy.Visible := True;
    GeneralPanel.Height := LProxy.Top + LProxy.Height + 5;
  end
  else
  begin
    LProxy.Visible := False;
    GeneralPanel.Height := LLatitude.Top + LLatitude.Height + 5;
  end;

  if ip.TimeZone.Name <> '' then
  begin
    LTimeZone.Caption := ip.TimeZone.Name + ' (' + ip.TimeZone.Abbreviation +')';
    LGMTOffset.Caption := FloatToStr(ip.TimeZone.GMTOffset);
    LTime.Caption := TimeToStr(ip.TimeZone.CurrentTime);

    if ip.TimeZone.IsDaylightSavingsTime then
      LDST.Caption := 'Yes'
    else
      LDST.Caption := 'No';

    TimeZonePanel.Height := LDST.Top + LDST.Height + 5;
  end
  else
    TimeZonePanel.Height := 0;

  if ip.AutonomousSystem.Organization <> '' then
  begin
    LASName.Caption := ip.AutonomousSystem.Organization;
    LASN.Caption := ip.AutonomousSystem.ASN;
    LISP.Caption := ip.AutonomousSystem.InternetServiceProvider;
    LConType.Caption := ip.AutonomousSystem.ConnectionType;

    ASPanel.Height := LConType.Top + LConType.Height + 5;
  end
  else
    ASPanel.Height := 0;
end;


end.
