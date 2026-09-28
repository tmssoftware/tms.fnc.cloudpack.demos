unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCloudBase, VCL.TMSFNCCloudSendGrid, VCL.TMSFNCUtils;

type
  TForm1 = class(TForm)
    From: TEdit;
    Subject: TEdit;
    Recipient: TEdit;
    APIKey: TEdit;
    content: TMemo;
    Send: TButton;
    TMSFNCCloudSendGrid1: TTMSFNCCloudSendGrid;
    procedure TMSFNCCloudSendGrid1SendSuccess(Sender: TObject);
    procedure TMSFNCCloudSendGrid1Error(Sender: TObject; AErrorMessage: string);
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
  p: TTMSFNCCloudSendGridRecipient;
  c: TTMSFNCCloudSendGridContent;
begin
  TMSFNCCloudSendGrid1.APIKey := APIKey.Text;
  TMSFNCCloudSendGrid1.Template.From.Email := From.Text;
  p := TTMSFNCCloudSendGridRecipient.Create;
  p.Email := Recipient.Text;
  TMSFNCCloudSendGrid1.Template.RecipientsList.Clear;
  TMSFNCCloudSendGrid1.Template.RecipientsList.Add(p);
  TMSFNCCloudSendGrid1.Template.Subject := Subject.Text;
  TMSFNCCloudSendGrid1.Template.Content.clear;
  c:= TTMSFNCCloudSendGridContent.Create;
  c.ContentType := 'text/html';
  c.Value := Content.Text;
  TMSFNCCloudSendGrid1.Template.Content.Add(c);

  TMSFNCCloudSendGrid1.SendMail;


end;

procedure TForm1.TMSFNCCloudSendGrid1Error(Sender: TObject;
  AErrorMessage: string);
begin
     TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm1.TMSFNCCloudSendGrid1SendSuccess(Sender: TObject);
begin
  TTMSFNCUtils.Message('Mail sent successfully!');
end;

end.
