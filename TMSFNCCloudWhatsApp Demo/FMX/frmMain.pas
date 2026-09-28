unit frmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCCloudBase,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudOAuth, FMX.TMSFNCCloudWhatsApp, FMX.TMSFNCUtils,
  FMX.Edit, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    TMSFNCCloudWhatsApp1: TTMSFNCCloudWhatsApp;
    OpenDialog1: TOpenDialog;
    Token: TEdit;
    ID: TEdit;
    recipient: TEdit;
    TextMessage: TMemo;
    SendText: TButton;
    SendImage: TButton;
    procedure SendTextClick(Sender: TObject);
    procedure TMSFNCCloudWhatsApp1Error(Sender: TObject; AErrorMessage: string);
    procedure SendImageClick(Sender: TObject);
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

{$R *.fmx}

procedure TForm1.SendTextClick(Sender: TObject);
begin
  TMSFNCCloudWhatsApp1.PhoneNumberID := ID.Text;
  TMSFNCCloudWhatsApp1.Authentication.Key := Token.Text;
  TMSFNCCloudWhatsApp1.SendTextMessage(recipient.Text, TextMessage.Text, True);
end;

procedure TForm1.SendImageClick(Sender: TObject);
begin
  TMSFNCCloudWhatsApp1.PhoneNumberID := ID.Text;
  TMSFNCCloudWhatsApp1.Authentication.Key := Token.Text;

  if OpenDialog1.Execute then
  begin
    TMSFNCCloudWhatsApp1.SendImage(recipient.Text, OpenDialog1.Files[0]);
  end;
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
