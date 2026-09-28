unit UIPLocalizationDemo;

interface

uses
  WEBLib.TMSFNCCloudBase, System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, WEBLib.StdCtrls, Vcl.Controls, Vcl.StdCtrls,
  WEBLib.TMSFNCCloudIPLocalization,  WEBLib.TMSFNCUtils, VCL.TMSFNCCustomComponent, WEBLib.ExtCtrls,
  VCL.TMSFNCCloudIPLocalization;

type
  TForm2 = class(TWebForm)
    GeneralPanel: TWebPanel;
    LCity: TWebLabel;
    Label3: TWebLabel;
    LRegion: TWebLabel;
    Label2: TWebLabel;
    LCountry: TWebLabel;
    Label4: TWebLabel;
    LContinent: TWebLabel;
    Label5: TWebLabel;
    LLongitude: TWebLabel;
    Label6: TWebLabel;
    LLatitude: TWebLabel;
    LProxy: TWebLabel;
    ImgFlag: TWebImageControl;
    ASPanel: TWebPanel;
    Label8: TWebLabel;
    LASName: TWebLabel;
    Label10: TWebLabel;
    LASN: TWebLabel;
    LISP: TWebLabel;
    Label11: TWebLabel;
    LConType: TWebLabel;
    Label9: TWebLabel;
    TimeZonePanel: TWebPanel;
    Label12: TWebLabel;
    LTimeZone: TWebLabel;
    Label14: TWebLabel;
    LGMTOffset: TWebLabel;
    Label16: TWebLabel;
    LTime: TWebLabel;
    Label18: TWebLabel;
    LDST: TWebLabel;
    Edit1: TWebEdit;
    RadioButton1: TWebRadioButton;
    RadioButton2: TWebRadioButton;
    RadioButton3: TWebRadioButton;
    Edit2: TWebEdit;
    Button1: TWebButton;
    ComboBox1: TWebComboBox;
    ScrollBox1: TWebScrollBox;
    Label1: TWebLabel;
    Label13: TWebLabel;
    Label15: TWebLabel;
    TMSFNCCloudIPLocalization1: TTMSFNCCloudIPLocalization;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DoGetIP(Sender: TObject; AIP: TTMSFNCCloudIPLocalizationIP; AError: Boolean; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure SetProperties;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurIdx: integer;
  end;


var
  Form2: TForm2;

implementation

{$R *.dfm}


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
  if (ComboBox1.ItemIndex >= 0) and (ComboBox1.ItemIndex <> CurIdx) then
  begin
    SetProperties;
  end;
  CurIdx := ComboBox1.ItemIndex;
end;

procedure TForm2.DoGetIP(Sender: TObject; AIP: TTMSFNCCloudIPLocalizationIP; AError: Boolean; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  if AError then
    Button1.Caption := 'Error retrieving IP'
  else
    Button1.Caption := 'IP Added';

  ComboBox1.Items.Clear;

  for I := 0 to TMSFNCCloudIPLocalization1.IPs.Count - 1 do
  begin
    ComboBox1.Items.AddObject(TMSFNCCloudIPLocalization1.IPs[I].IPAddress, TMSFNCCloudIPLocalization1.IPs[I]);
  end;

  ComboBox1.ItemIndex := CurIdx;

  if ComboBox1.Items.Count > 0 then
    ComboBox1.Enabled := True;
  
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  TMSFNCCloudIPLocalization1 := TTMSFNCCloudIPLocalization.Create(Self);
  TMSFNCCloudIPLocalization1.OnGetIP := DoGetIP;
  CurIdx := -1;
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

  LCity.Caption := ip.City + ' (' + ip.PostalCode +')';
  LRegion.Caption := ip.Region;
  LCountry.Caption := ip.Country;
  LContinent.Caption := ip.ContinentName;
  LLongitude.Caption := FloatToStr(ip.Longitude);
  LLatitude.Caption := FloatToStr(ip.Latitude);

  ImgFlag.URL := ip.Flag.ImageUrl;

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