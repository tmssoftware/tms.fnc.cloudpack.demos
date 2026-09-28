unit frmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase,
  FMX.TMSFNCCloudMailChimp.Transactions, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCUtils;

type
  TForm5 = class(TForm)
    TMSFNCCloudMailChimpTransactions1: TTMSFNCCloudMailChimpTransactions;
    Send: TButton;
    FromEmail: TEdit;
    FromName: TEdit;
    ToEmail: TEdit;
    ToName: TEdit;
    Subject: TEdit;
    HTMLContent: TMemo;
    APIKey: TEdit;
    SubAccount: TEdit;
    procedure SendClick(Sender: TObject);
    procedure TMSFNCCloudMailChimpTransactions1Error(Sender: TObject;
      AErrorMessage: string);
    procedure TMSFNCCloudMailChimpTransactions1SendSuccessful(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

procedure TForm5.SendClick(Sender: TObject);
var
  m: TTMSFNCCloudMailChimpMessage;
  t: TTMSFNCCLoudMailChimpRecipient;
begin
  TMSFNCCloudMailChimpTransactions1.APIKey := APIKey.Text;
  m := TTMSFNCCloudMailChimpMessage.Create;
  m.HTML := HTMLContent.Text;
  m.Subject := Subject.Text;
  m.FromEmail := FromEmail.Text;
  m.FromName := FromName.Text;
  t := TTMSFNCCloudMailChimpRecipient.Create;
  t.Email := ToEmail.Text;
  t.RecipientName := ToName.Text;
  m.SendTo.Clear;
  m.SendTo.Add(t);
  m.SubAccount := SubAccount.Text;
  TMSFNCCloudMailChimpTransactions1.SendMail(m);
end;

procedure TForm5.TMSFNCCloudMailChimpTransactions1Error(Sender: TObject;
  AErrorMessage: string);
begin
  TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm5.TMSFNCCloudMailChimpTransactions1SendSuccessful(
  Sender: TObject);
begin
  TTMSFNCUtils.Message('Mail sent successfully!');
end;

end.
