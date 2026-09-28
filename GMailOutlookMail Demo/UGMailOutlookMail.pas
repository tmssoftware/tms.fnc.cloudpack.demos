unit UGMailOutlookMail;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCCloudBase, FMX.TMSFNCCloudOAuth, FMX.TMSFNCCloudMicrosoft,
  FMX.TMSFNCCloudMicrosoftOutlookMail, FMX.WebBrowser, FMX.Layouts, FMX.ListBox,
  FMX.TMSFNCCloudGoogle, FMX.TMSFNCCloudGoogleGmail, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.TabControl, FMX.TMSFNCUtils;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    edClientID: TEdit;
    edSecret: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edCallback: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    TMSFNCCloudMicrosoftOutlookMail1: TTMSFNCCloudMicrosoftOutlookMail;
    btConnect: TButton;
    cbService: TComboBox;
    TMSFNCCloudGoogleGmail1: TTMSFNCCloudGoogleGmail;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Panel2: TPanel;
    Panel3: TPanel;
    Label5: TLabel;
    lbMails: TListBox;
    btRefresh: TButton;
    lbSubject: TLabel;
    WebBrowser1: TWebBrowser;
    lbFrom: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    WebBrowser2: TWebBrowser;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edTo: TEdit;
    edSubject: TEdit;
    meBody: TMemo;
    btInsertImage: TButton;
    btSend: TButton;
    Label9: TLabel;
    OpenDialog1: TOpenDialog;
    btClearImages: TButton;
    procedure TMSFNCCloudMicrosoftOutlookMail1Connected(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure TMSFNCCloudMicrosoftOutlookMail1GetMails(Sender: TObject;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure lbMailsClick(Sender: TObject);
    procedure TMSFNCCloudGoogleGmail1Connected(Sender: TObject);
    procedure TMSFNCCloudGoogleGmail1GetMailsComplete(Sender: TObject;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure btSendClick(Sender: TObject);
    procedure meBodyChangeTracking(Sender: TObject);
    procedure TMSFNCCloudGoogleGmail1SendMessage(Sender: TObject;
      const AMessage: TTMSFNCCloudGoogleGmailMessage;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudMicrosoftOutlookMail1SendMessage(Sender: TObject;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure btInsertImageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btRefreshClick(Sender: TObject);
    procedure btClearImagesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    msgGMail: TTMSFNCCloudGoogleGmailMessage;
    msgOutlook: TTMSFNCCloudMicrosoftOutlookMailItem;
    fileOutlook: TTMSFNCCloudMicrosoftOutlookMailFile;
    fileGMail: TTMSFNCCloudGoogleGmailFile;
    procedure Init;
    procedure UpdatePreview;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btClearImagesClick(Sender: TObject);
var
  I: Integer;
begin
  if cbService.ItemIndex = 0 then
  begin
    for I := 0 to TMSFNCCloudGoogleGmail1.Files.Count - 1 do
    begin
      meBody.Text := meBody.Text.Replace('<img src="cid:' + TMSFNCCloudGoogleGmail1.Files[I].ContentID + '">', '');
    end;
    TMSFNCCloudGoogleGmail1.Files.Clear;
  end
  else
  begin
    if Assigned(msgOutlook) then
    begin
      for I := 0 to msgOutlook.Files.Count - 1 do
      begin
        meBody.Text := meBody.Text.Replace('<img src="cid:' + msgOutlook.Files[I].ContentID + '">', '');
      end;
      msgOutlook.Files.Clear;
    end;
  end;
end;

procedure TForm1.btConnectClick(Sender: TObject);
begin
  lbMails.Clear;
  lbSubject.Text := 'Subject';
  lbFrom.Text := 'From';
  WebBrowser1.LoadFromStrings('', '');

  if cbService.ItemIndex = 0 then
  begin
    TMSFNCCloudGoogleGmail1.PersistTokens.Key := 'gmail';
    TMSFNCCloudGoogleGmail1.LoadTokens;

    TMSFNCCloudGoogleGmail1.Authentication.ClientID := edClientID.Text;
    TMSFNCCloudGoogleGmail1.Authentication.Secret := edSecret.Text;
    TMSFNCCloudGoogleGmail1.Authentication.CallBackURL := edCallback.Text;

    if (TMSFNCCloudGoogleGmail1.Authentication.ClientID = '')
      or (TMSFNCCloudGoogleGmail1.Authentication.Secret = '')
      or (TMSFNCCloudGoogleGmail1.Authentication.CallBackURL = '') then
    begin
      ShowMessage('Please enter your credentials before attempting to connect');
    end
    else
    begin
      TMSFNCCloudGoogleGmail1.Connect;
    end;
  end
  else
  begin
    TMSFNCCloudMicrosoftOutlookMail1.PersistTokens.Key := 'outlook';
    TMSFNCCloudMicrosoftOutlookMail1.LoadTokens;

    TMSFNCCloudMicrosoftOutlookMail1.Authentication.ClientID := edClientID.Text;
    TMSFNCCloudMicrosoftOutlookMail1.Authentication.Secret := edSecret.Text;
    TMSFNCCloudMicrosoftOutlookMail1.Authentication.CallBackURL := edCallback.Text;

    if (TMSFNCCloudMicrosoftOutlookMail1.Authentication.ClientID = '')
      or (TMSFNCCloudMicrosoftOutlookMail1.Authentication.Secret = '')
      or (TMSFNCCloudMicrosoftOutlookMail1.Authentication.CallBackURL = '') then
    begin
      ShowMessage('Please enter your credentials before attempting to connect');
    end
    else
    begin
      TMSFNCCloudMicrosoftOutlookMail1.Connect;
    end;
  end;
end;

procedure TForm1.btRefreshClick(Sender: TObject);
begin
  lbMails.Clear;
  lbSubject.Text := 'Subject';
  lbFrom.Text := 'From';
  WebBrowser1.LoadFromStrings('', '');

  if cbService.ItemIndex = 0 then
  begin
    TMSFNCCloudGoogleGmail1.Mails.Clear;
    TMSFNCCloudGoogleGmail1.PageToken := '';
    TMSFNCCloudGoogleGmail1.GetMails
  end
  else
  begin
    TMSFNCCloudMicrosoftOutlookMail1.Mails.Clear;
    TMSFNCCloudMicrosoftOutlookMail1.GetMails;
  end;
end;

procedure TForm1.btSendClick(Sender: TObject);
begin
  if edTo.Text = '' then
  begin
    ShowMessage('Please specify a recipient');
    Exit;
  end;

  if cbService.ItemIndex = 0 then
  begin
    msgGMail.ToRecipients.Clear;
    msgGMail.ToRecipients.Add(edTo.Text);
    msgGMail.Subject := edSubject.Text;
    msgGMail.Body := meBody.Text;
    msgGMail.MessageType := mtHTML;
    TMSFNCCloudGoogleGmail1.SendMailMessage(msgGMail);
  end
  else
  begin
    msgOutlook.RecipientEmails.Clear;
    msgOutlook.RecipientEmails.Add(edTo.Text);
    msgOutlook.Subject := edSubject.Text;
    msgOutlook.Body := meBody.Text;
    msgOutlook.MailType := mtHTML;
    TMSFNCCloudMicrosoftOutlookMail1.SendMailMessage(msgOutlook);
  end;
end;

procedure TForm1.btInsertImageClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if cbService.ItemIndex = 0 then
    begin
      fileGMail := TMSFNCCloudGoogleGmail1.Files.Add;
      fileGMail.&File := OpenDialog1.FileName;
      fileGMail.ContentID := 'InlineImage' + IntToStr(TMSFNCCloudGoogleGmail1.Files.Count);
      fileGMail.IsInline := True;
      meBody.Text := meBody.Text + #10#13 + '<img src="cid:' + fileGMail.ContentID + '">';
    end
    else
    begin
      fileOutlook := msgOutlook.Files.Add;
      fileOutlook.&File := OpenDialog1.FileName;
      fileOutlook.ContentID := 'InlineImage' + IntToStr(msgOutlook.Files.Count);
      fileOutlook.IsInline := True;
      meBody.Text := meBody.Text + #10#13 + '<img src="cid:' + fileOutlook.ContentID + '">';
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TabControl1.Enabled := False;
end;

procedure TForm1.Init;
begin
  TabControl1.TabIndex := 0;
  TabControl1.Enabled := True;
  WebBrowser2.LoadFromStrings(meBody.Text, '');
  if cbService.ItemIndex = 0 then
  begin
    TMSFNCCloudGoogleGmail1.Files.Clear;
    if not Assigned(msgGMail) then
      msgGMail := TTMSFNCCloudGoogleGmailMessage.Create;
  end
  else
  begin
    if not Assigned(msgOutlook) then
      msgOutlook := TTMSFNCCloudMicrosoftOutlookMailItem.Create;
    msgOutlook.Files.Clear;
  end;
end;

procedure TForm1.lbMailsClick(Sender: TObject);
begin
  if lbMails.ItemIndex >= 0 then
  begin
    if cbService.ItemIndex = 0 then
    begin
      lbSubject.Text := 'Subject: ' + TMSFNCCloudGoogleGmail1.Mails[lbMails.ItemIndex].Subject;
      lbFrom.Text := 'From: ' + TMSFNCCloudGoogleGmail1.Mails[lbMails.ItemIndex].From;
      WebBrowser1.LoadFromStrings(TMSFNCCloudGoogleGmail1.Mails[lbMails.ItemIndex].GetBodyWithInlineImages, '');
    end
    else
    begin
      lbSubject.Text := 'Subject: ' + TMSFNCCloudMicrosoftOutlookMail1.Mails[lbMails.ItemIndex].Subject;
      lbFrom.Text := 'From: ' + TMSFNCCloudMicrosoftOutlookMail1.Mails[lbMails.ItemIndex].RecipientEmails[0];
      WebBrowser1.LoadFromStrings(TMSFNCCloudMicrosoftOutlookMail1.Mails[lbMails.ItemIndex].GetBodyWithInlineImages, '');
    end;
  end;
end;

procedure TForm1.meBodyChangeTracking(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TForm1.TMSFNCCloudGoogleGmail1Connected(Sender: TObject);
begin
  TMSFNCCloudGoogleGmail1.SaveTokens;
  TMSFNCCloudGoogleGmail1.GetMails;
  Init;
end;

procedure TForm1.TMSFNCCloudGoogleGmail1GetMailsComplete(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  lbMails.Clear;
  for I := 0 to TMSFNCCloudGoogleGmail1.Mails.Count - 1 do
  begin
    lbMails.Items.Add(TMSFNCCloudGoogleGmail1.Mails[I].Subject);
  end;
end;

procedure TForm1.TMSFNCCloudGoogleGmail1SendMessage(Sender: TObject;
  const AMessage: TTMSFNCCloudGoogleGmailMessage;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if ARequestResult.Success then
  begin
    ShowMessage('Message sent with GMail');
  end
  else
  begin
    raise Exception.Create('Message failed to send with GMail. Please try again.');
  end;
end;

procedure TForm1.TMSFNCCloudMicrosoftOutlookMail1Connected(Sender: TObject);
begin
  TMSFNCCloudMicrosoftOutlookMail1.SaveTokens;
  TMSFNCCloudMicrosoftOutlookMail1.GetMails;
  Init;
end;

procedure TForm1.TMSFNCCloudMicrosoftOutlookMail1GetMails(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  lbMails.Clear;
  for I := 0 to TMSFNCCloudMicrosoftOutlookMail1.Mails.Count - 1 do
  begin
    lbMails.Items.Add(TMSFNCCloudMicrosoftOutlookMail1.Mails[I].Subject);
  end;
end;

procedure TForm1.TMSFNCCloudMicrosoftOutlookMail1SendMessage(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if ARequestResult.Success then
  begin
    ShowMessage('Message sent with Outlook Mail');
  end
  else
  begin
    raise Exception.Create('Message failed to send with Outlook Mail. Please try again.');
  end;
end;

procedure TForm1.UpdatePreview;
var
  I: integer;
  body: string;
begin
  body := meBody.Text;
  if cbService.ItemIndex = 0 then
  begin
    for I := 0 to TMSFNCCloudGoogleGmail1.Files.Count - 1 do
    begin
      if TMSFNCCloudGoogleGmail1.Files[I].IsInline then
      begin
        body := body.Replace('cid:' + TMSFNCCloudGoogleGmail1.Files[I].ContentID, TMSFNCCloudGoogleGmail1.ImageToBase64(TMSFNCCloudGoogleGmail1.Files[I].&File, False));
      end;
    end;
  end
  else
  begin
    for I := 0 to msgOutlook.Files.Count - 1 do
    begin
      if msgOutlook.Files[I].IsInline then
      begin
        body := body.Replace('cid:' + msgOutlook.Files[I].ContentID, TMSFNCCloudMicrosoftOutlookMail1.ImageToBase64(msgOutlook.Files[I].&File, False));
      end;
    end;
  end;
  WebBrowser2.LoadFromStrings(body, '');
end;

end.
