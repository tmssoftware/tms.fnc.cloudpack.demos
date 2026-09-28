unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.TMSFNCCloudWhatsApp,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCCloudBase, VCL.TMSFNCCloudOAuth,
  Vcl.ExtDlgs, VCL.TMSFNCUtils;

type
  TForm1 = class(TForm)
    Token: TEdit;
    ID: TEdit;
    Recipient: TEdit;
    TextMessageBody: TMemo;
    SendText: TButton;
    SendImage: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    TMSFNCCloudWhatsApp1: TTMSFNCCloudWhatsApp;
    procedure SendImageClick(Sender: TObject);
    procedure SendTextClick(Sender: TObject);
    procedure TMSFNCCloudWhatsApp1Error(Sender: TObject; AErrorMessage: string);
    procedure TMSFNCCloudWhatsApp1SendSuccess(Sender: TObject;
      AMessage: TTMSFNCCloudWhatsAppMessage);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.SendImageClick(Sender: TObject);
begin
  TMSFNCCloudWhatsApp1.PhoneNumberID := ID.Text;
  TMSFNCCloudWhatsApp1.Authentication.Key := Token.Text;

  if OpenPictureDialog1.Execute then
  begin
    TMSFNCCloudWhatsApp1.SendImage(recipient.Text, OpenPictureDialog1.Files[0]);
  end;
end;

procedure TForm1.SendTextClick(Sender: TObject);
begin
  TMSFNCCloudWhatsApp1.PhoneNumberID := ID.Text;
  TMSFNCCloudWhatsApp1.Authentication.Key := Token.Text;

  TMSFNCCloudWhatsApp1.SendTextMessage(Recipient.Text, TextMessageBody.Text);
end;

procedure TForm1.TMSFNCCloudWhatsApp1Error(Sender: TObject;
  AErrorMessage: string);
begin
  TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm1.TMSFNCCloudWhatsApp1SendSuccess(Sender: TObject;
  AMessage: TTMSFNCCloudWhatsAppMessage);
begin
  TTMSFNCUtils.Message(AMessage.ID + ' has been sent successfully!');
end;

end.
