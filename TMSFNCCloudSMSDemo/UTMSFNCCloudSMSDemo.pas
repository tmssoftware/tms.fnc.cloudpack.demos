unit UTMSFNCCloudSMSDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase, FMX.TMSFNCCloudSMS,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    edAPIKey: TEdit;
    Label1: TLabel;
    TMSFNCCloudSMS1: TTMSFNCCloudSMS;
    meText: TMemo;
    Label3: TLabel;
    btSend: TButton;
    edTo: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edClientID: TEdit;
    Label6: TLabel;
    edSecret: TEdit;
    cbService: TComboBox;
    Label2: TLabel;
    procedure btSendClick(Sender: TObject);
    procedure cbServiceChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCCloudSMS1SendCloudSMS(Sender: TObject;
      const ARequest: TTMSFNCCloudSMSRequest;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btSendClick(Sender: TObject);
begin
  if ((cbService.ItemIndex = 0) or (cbService.ItemIndex = 3)) and ((edClientID.Text = '') or (edSecret.text = '')) then
  begin
    ShowMessage('Fill in Client ID and Secret first');
    Exit;
  end;

  if ((cbService.ItemIndex = 1) or (cbService.ItemIndex = 2)) and (edAPIKey.Text = '') then
  begin
    ShowMessage('Fill in API Key first');
    Exit;
  end;

  if edTo.Text = '' then
  begin
    ShowMessage('Fill in a telephone number first');
    Exit;
  end;

  TMSFNCCloudSMS1.APIKey := edAPIKey.Text;
  TMSFNCCloudSMS1.ClientID := edClientID.Text;
  TMSFNCCloudSMS1.Secret := edSecret.Text;
  TMSFNCCloudSMS1.SendCloudSMS(edTo.Text, edTo.Text, meText.Text);
end;

procedure TForm1.cbServiceChange(Sender: TObject);
begin
  Init
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Init;
end;

procedure TForm1.Init;
begin
  if cbService.ItemIndex = 0 then
  begin
    TMSFNCCloudSMS1.Service := cssBulkSMS;
    edAPIKey.Enabled := False;
    edClientID.Enabled := True;
    edSecret.Enabled := True;
  end
  else if cbService.ItemIndex = 1 then
  begin
    TMSFNCCloudSMS1.Service := cssInfoBip;
    edAPIKey.Enabled := True;
    edClientID.Enabled := False;
    edSecret.Enabled := False;
  end
  else if cbService.ItemIndex = 2 then
  begin
    TMSFNCCloudSMS1.Service := cssSpryng;
    edAPIKey.Enabled := True;
    edClientID.Enabled := False;
    edSecret.Enabled := False;
  end
  else if cbService.ItemIndex = 3 then
  begin
    TMSFNCCloudSMS1.Service := cssTwilio;
    edAPIKey.Enabled := False;
    edClientID.Enabled := True;
    edSecret.Enabled := True;
  end;
end;

procedure TForm1.TMSFNCCloudSMS1SendCloudSMS(Sender: TObject;
  const ARequest: TTMSFNCCloudSMSRequest;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if ARequestResult.Success then
    ShowMessage('Message sent')
  else
    ShowMessage(ARequestResult.ResultString);
end;

end.
