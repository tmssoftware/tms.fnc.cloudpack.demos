unit UTMSFNCCloudWhatsAppDemo;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Vcl.Controls, Vcl.StdCtrls,
  WEBLib.StdCtrls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCustomControl, VCL.TMSFNCCustomScrollControl,
   WEBLib.ExtCtrls,
  VCL.TMSFNCCloudBase, VCL.TMSFNCEdit, WEBLib.WebCtrls, VCL.TMSFNCCloudWhatsApp,
  VCL.TMSFNCCloudOAuth, WEBLib.Chatbox;

type
  TForm1 = class(TWebForm)
    Token: TWebEdit;
    SendText: TWebButton;
    MessageBody: TWebMemo;
    ID: TWebEdit;
    Number: TWebEdit;
    SendImage: TWebButton;
    TMSFNCCloudWhatsApp1: TTMSFNCCloudWhatsApp;
    WebFilePicker1: TWebFilePicker;
    procedure SendTextClick(Sender: TObject);
    procedure SendImageClick(Sender: TObject);
    procedure WebFilePicker1GetFileAsStream(Sender: TObject;
      AFileIndex: Integer; AStream: TStream);
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

{ TForm1 }

procedure TForm1.SendImageClick(Sender: TObject);
begin
  TMSFNCCloudWhatsApp1.PhoneNumberID := ID.Text;
  TMSFNCCloudWhatsApp1.Authentication.Key := Token.Text;


  if WebFilePicker1.Files.Count > 0 then
  begin
    WebFilePicker1.Files[0].GetFileAsStream;
  end;
end;

procedure TForm1.SendTextClick(Sender: TObject);
begin
  TMSFNCCloudWhatsApp1.PhoneNumberID := ID.Text;
  TMSFNCCloudWhatsApp1.Authentication.Key := Token.Text;

  TMSFNCCloudWhatsApp1.SendTextMessage(Number.Text, MessageBody.Text);
end;

procedure TForm1.TMSFNCCloudWhatsApp1Error(Sender: TObject;
  AErrorMessage: string);
begin
   TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm1.WebFilePicker1GetFileAsStream(Sender: TObject;
  AFileIndex: Integer; AStream: TStream);
begin
TMSFNCCloudWhatsApp1.SendImage(Number.Text, AStream, WebFilePicker1.Files[0].Name);
end;

procedure TForm1.TMSFNCCloudWhatsApp1SendSuccess(Sender: TObject;
  AMessage: TTMSFNCCloudWhatsAppMessage);
begin
   TTMSFNCUtils.Message(AMessage.ID + ' has been sent successfully!');
end;



end.