unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCloudBase, VCL.TMSFNCCloudPushOver, VCL.TMSFNCUtils;

type
  TForm1 = class(TForm)
    APIKey: TEdit;
    UserKey: TEdit;
    Content: TMemo;
    Push: TButton;
    TMSFNCCloudPushOver1: TTMSFNCCloudPushOver;
    procedure PushClick(Sender: TObject);
    procedure TMSFNCCloudPushOver1PushError(Sender: TObject;
      AErrorMessage: string; AErrorCode: Integer);
    procedure TMSFNCCloudPushOver1PushSucces(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.PushClick(Sender: TObject);
begin
  TMSFNCCloudPushOver1.APIKey := APIKey.Text;
  TMSFNCCloudPushOver1.PushMessage(UserKey.Text, Content.Text);
end;

procedure TForm1.TMSFNCCloudPushOver1PushError(Sender: TObject;
  AErrorMessage: string; AErrorCode: Integer);
begin
  TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm1.TMSFNCCloudPushOver1PushSucces(Sender: TObject);
begin
  TTMSFNCUtils.Message('Message has been pushed.');
end;

end.
