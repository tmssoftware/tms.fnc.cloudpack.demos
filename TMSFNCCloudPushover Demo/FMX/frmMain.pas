unit frmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase, FMX.TMSFNCCloudPushOver,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.Edit, FMX.TMSFNCUtils;

type
  TForm5 = class(TForm)
    TMSFNCCloudPushOver1: TTMSFNCCloudPushOver;
    Push: TButton;
    APIKey: TEdit;
    User: TEdit;
    MessageContent: TMemo;
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
  Form5: TForm5;

implementation

{$R *.fmx}

procedure TForm5.PushClick(Sender: TObject);
begin
  TMSFNCCloudPushOver1.APIKey := APIKey.Text;
  TMSFNCCloudPushOver1.PushMessage(User.Text, MessageContent.Text);
end;

procedure TForm5.TMSFNCCloudPushOver1PushError(Sender: TObject;
  AErrorMessage: string; AErrorCode: Integer);
begin
  TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm5.TMSFNCCloudPushOver1PushSucces(Sender: TObject);
begin
  TTMSFNCUtils.Message('Message has been pushed.');
end;

end.
