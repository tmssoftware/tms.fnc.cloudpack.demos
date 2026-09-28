unit frmSendGrid;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase, FMX.TMSFNCCloudSendGrid, FMX.TMSFNCUtils;

type
  TForm5 = class(TForm)
    TMSFNCCloudSendGrid1: TTMSFNCCloudSendGrid;
    BodyMemo: TMemo;
    FromEdit: TEdit;
    SubjectButton: TEdit;
    ToEdit: TEdit;
    SendButton: TButton;
    APIKeyEdit: TEdit;
    procedure SendButtonClick(Sender: TObject);
    procedure TMSFNCCloudSendGrid1SendSuccess(Sender: TObject);
    procedure TMSFNCCloudSendGrid1Error(Sender: TObject; AErrorMessage: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

procedure TForm5.SendButtonClick(Sender: TObject);
var
  p: TTMSFNCCloudSendGridRecipient;
  c: TTMSFNCCloudSendGridContent;
begin
  TMSFNCCloudSendGrid1.APIKey := APIKeyEdit.Text;
  TMSFNCCloudSendGrid1.Template.From.Email := FromEdit.Text;
  p := TTMSFNCCloudSendGridRecipient.Create;
  p.Email := ToEdit.Text;
  TMSFNCCloudSendGrid1.Template.RecipientsList.Clear;
  TMSFNCCloudSendGrid1.Template.RecipientsList.Add(p);
  TMSFNCCloudSendGrid1.Template.Subject := SubjectButton.Text;
  TMSFNCCloudSendGrid1.Template.Content.clear;
  c:= TTMSFNCCloudSendGridContent.Create;
  c.ContentType := 'text/html';
  c.Value := BodyMemo.Text;
  TMSFNCCloudSendGrid1.Template.Content.Add(c);

  TMSFNCCloudSendGrid1.SendMail;


end;

procedure TForm5.TMSFNCCloudSendGrid1Error(Sender: TObject;
  AErrorMessage: string);
begin
     TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm5.TMSFNCCloudSendGrid1SendSuccess(Sender: TObject);
begin
  TTMSFNCUtils.Message('Mail sent successfully!');
end;

end.
