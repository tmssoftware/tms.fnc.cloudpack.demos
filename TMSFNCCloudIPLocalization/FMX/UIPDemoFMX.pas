unit UIPDemoFMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.Controls.Presentation,
  FMX.TMSFNCCloudIPLocalization, FMX.TMSFNCCloudBase, FMX.ListBox, FMX.TMSFNCcustomControl,
  FMX.Objects, FMX.TMSFNCCustomComponent, FMX.TMSFNCTypes;

type
  TForm2 = class(TForm)
    RadioButton1: TRadioButton;
    Edit1: TEdit;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button1: TButton;
    Edit2: TEdit;
    VertScrollBox1: TVertScrollBox;
    GeneralPanel: TPanel;
    ComboBox1: TComboBox;
    Label1: TLabel;
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
    TMSFNCCloudIPLocalization1: TTMSFNCCloudIPLocalization;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DoGetIP(Sender: TObject; AIP: TTMSFNCCloudIPLocalizationIP; AError: Boolean; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoGetFlagImage(Sender: TObject; ARequestResult: TTMSFNCCloudBaseRequestResult; AIP: TTMSFNCCloudIPLocalizationIP; AFlagImageStream: TMemoryStream);
    procedure SetProperties;
    procedure ComboBox1Click(Sender: TObject);
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

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
var
  ip: TTMSFNCCloudIPLocalizationIP;
begin
  TMSFNCCloudIPLocalization1.APIKey := Edit1.Text;
  Button1.Text := 'Requesting IP';
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
  if ComboBox1.ItemIndex >= 0 then
  begin
    SetProperties;
  end;
end;

procedure TForm2.ComboBox1Click(Sender: TObject);
begin
  if (ComboBox1.ItemIndex >= 0) and (ComboBox1.ItemIndex <> CurIdx) then
  begin
    SetProperties;
  end;
  CurIdx := ComboBox1.ItemIndex;
end;

procedure TForm2.DoGetFlagImage(Sender: TObject; ARequestResult: TTMSFNCCloudBaseRequestResult;  AIP: TTMSFNCCloudIPLocalizationIP; AFlagImageStream: TMemoryStream);
var
  fncb: TTMSFNCBitmap;
begin
  if (ComboBox1.ItemIndex >= 0) and ((ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TTMSFNCCloudIPLocalizationIP).IPAddress = AIP.IPAddress)  then
  begin
    fncb := TTMSFNCBitmap.Create;
    try
      AFlagImageStream.Position := 0;
      fncb.LoadFromStream(AFlagImageStream);
      if fncb.HasSVG then
        ImgFlag.Bitmap.Assign(fncb.SVG.GenerateBitmap(60, ImgFlag.Height))
      else
        ImgFlag.Bitmap.LoadFromStream(AFlagImageStream);
    finally
      fncb.Free;
    end;
  end;
end;

procedure TForm2.DoGetIP(Sender: TObject; AIP: TTMSFNCCloudIPLocalizationIP; AError: Boolean; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  if AError then
  begin
    Button1.Text := 'Error retrieving IP';
    Exit;
  end
  else
    Button1.Text := 'IP Added';
  ComboBox1.Items.Clear;

  for I := 0 to TMSFNCCloudIPLocalization1.IPs.Count - 1 do
  begin
    ComboBox1.Items.AddObject(TMSFNCCloudIPLocalization1.IPs[I].IPAddress, TMSFNCCloudIPLocalization1.IPs[I]);
  end;

  ComboBox1.ItemIndex := CurIdx;

  if (ComboBox1.Items.Count > 0) then
    ComboBox1.Enabled := True;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  TMSFNCCloudIPLocalization1 := TTMSFNCCloudIPLocalization.Create(Self);
  TMSFNCCloudIPLocalization1.OnGetIP := DoGetIP;
  TMSFNCCloudIPLocalization1.OnGetFlagImage := DoGetFlagImage;
end;

procedure TForm2.RadioButton1Click(Sender: TObject);
begin
  TMSFNCCloudIPLocalization1.Service := ipsAbstractAPI;
end;

procedure TForm2.RadioButton2Click(Sender: TObject);
begin
  TMSFNCCloudIPLocalization1.Service := ipsIPData;
end;

procedure TForm2.RadioButton3Click(Sender: TObject);
begin
  TMSFNCCloudIPLocalization1.Service := ipsIPStack;
end;

procedure TForm2.SetProperties;
var
  ip: TTMSFNCCloudIPLocalizationIP;
begin
  ip := (ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TTMSFNCCloudIPLocalizationIP);

  LCity.Text := ip.City + ' (' + ip.PostalCode +')';
  LRegion.Text := ip.Region;
  LCountry.Text := ip.Country;
  LContinent.Text := ip.ContinentName;
  LLongitude.Text := FloatToStr(ip.Longitude);
  LLatitude.Text := FloatToStr(ip.Latitude);

  if Assigned(ip.Flag.FlagImageStream) and (ip.Flag.FlagImageStream.Size > 0) then
  begin
    ip.Flag.FlagImageStream.Position := 0;
    ImgFlag.Bitmap.LoadFromStream(ip.Flag.FlagImageStream);
  end
  else
    ImgFlag.Bitmap := nil;

  if ip.IsVPN then
  begin
    LProxy.Visible := True;
    GeneralPanel.Height := LProxy.Position.Y + LProxy.Height + 5;
  end
  else
  begin
    LProxy.Visible := False;
    GeneralPanel.Height := LLatitude.Position.Y + LLatitude.Height + 5;
  end;

  if ip.TimeZone.Name <> '' then
  begin
    LTimeZone.Text := ip.TimeZone.Name + ' (' + ip.TimeZone.Abbreviation +')';
    LGMTOffset.Text := FloatToStr(ip.TimeZone.GMTOffset);
    LTime.Text := TimeToStr(ip.TimeZone.CurrentTime);

    if ip.TimeZone.IsDaylightSavingsTime then
      LDST.Text := 'Yes'
    else
      LDST.Text := 'No';

    TimeZonePanel.Height := LDST.Position.Y + LDST.Height + 5;
  end
  else
    TimeZonePanel.Height := 0;

  if ip.AutonomousSystem.Organization <> '' then
  begin
    LASName.Text := ip.AutonomousSystem.Organization;
    LASN.Text := ip.AutonomousSystem.ASN;
    LISP.Text := ip.AutonomousSystem.InternetServiceProvider;
    LConType.Text := ip.AutonomousSystem.ConnectionType;

    ASPanel.Height := LConType.Position.Y + LConType.Height + 5;
  end
  else
    ASPanel.Height := 0;
end;

end.
