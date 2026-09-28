unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCloudBase, VCL.TMSFNCCloudMailChimp.Transactions, VCL.TMSFNCUtils;

type
  TForm1 = class(TForm)
    content: TMemo;
    Send: TButton;
    Subject: TEdit;
    Recipient: TEdit;
    From: TEdit;
    APIKey: TEdit;
    SubAccountID: TEdit;
    TMSFNCCloudMailChimpTransactions1: TTMSFNCCloudMailChimpTransactions;
    procedure TMSFNCCloudMailChimpTransactions1Error(Sender: TObject;
      AErrorMessage: string);
    procedure TMSFNCCloudMailChimpTransactions1SendSuccessful(Sender: TObject);
    procedure SendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.SendClick(Sender: TObject);
var
  m: TTMSFNCCloudMailChimpMessage;
  t: TTMSFNCCLoudMailChimpRecipient;
begin
  TMSFNCCloudMailChimpTransactions1.APIKey := APIKey.Text;
  m := TTMSFNCCloudMailChimpMessage.Create;
  m.HTML := Content.Text;
  m.Subject := Subject.Text;
  m.FromEmail := From.Text;
  t := TTMSFNCCloudMailChimpRecipient.Create;
  t.Email := Recipient.Text;
  m.SendTo.Clear;
  m.SendTo.Add(t);
  m.SubAccount := SubAccountID.Text;
  TMSFNCCloudMailChimpTransactions1.SendMail(m);
end;

procedure TForm1.TMSFNCCloudMailChimpTransactions1Error(Sender: TObject;
  AErrorMessage: string);
begin
  TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm1.TMSFNCCloudMailChimpTransactions1SendSuccessful(
  Sender: TObject);
begin
  TTMSFNCUtils.Message('Mail sent successfully!');
end;

end.
