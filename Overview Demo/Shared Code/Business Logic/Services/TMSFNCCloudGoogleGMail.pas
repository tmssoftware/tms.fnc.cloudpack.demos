unit TMSFNCCloudGoogleGMail;

interface

{$IFDEF LCL}
{$mode objfpc}{$H+}{$modeswitch advancedrecords}
{$ENDIF}

{$IFDEF WEBLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

{$IFDEF LCL}
{$DEFINE LCLWEBLIB}
{$ENDIF}

{$IFDEF FMX}
{$DEFINE VCLFMX}
{$ENDIF}

{$IFDEF VCL}
{$DEFINE VCLFMX}
{$ENDIF}

uses
  {$IFDEF VCL}
  Classes, SysUtils, Generics.Collections, VCL.Forms, VCL.StdCtrls, VCL.ComCtrls, VCL.TMSFNCUtils, UITypes, VCL.TMSFNCCloudOAuth, VCL.TMSFNCCloudBase,
  CloudServices, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudGoogleGMail, VCL.TMSFNCWebBrowser,
  VCL.Dialogs, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes, FMX.TMSFNCCloudOAuth, FMX.TMSFNCCloudBase, FMX.Edit, FMX.Memo, FMX.Dialogs,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCustomControl, FMX.TMSFNCCloudGoogleGMail,
  FMX.ListBox, FMX.TMSFNCWebBrowser, FMX.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls, LCLTMSFNCCloudOAuth, LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudGoogleGmail, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth, WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCloudGoogleGMail, WEBLib.ExtCtrls, WEBLib.TMSFNCCloudDemoListBox;
  {$ENDIF}

type
  TTMSFNCCloudGoogleGMailService = class(TTMSFNCCloudService)
  private
    class var FSendButton, FGetMailsButton: TButton;
    class var FListBox: TTMSFNCCloudDemoListBox;
    {$IFDEF VCLFMX}
    class var FViewer: TTMSFNCWebBrowser;
    {$ENDIF}
    {$IFDEF WEBLIB}
    class var FViewer: TWebHTMLContainer;
    {$ENDIF}
    {$IFDEF LCL}
    class var FViewer: TMemo;
    {$ENDIF}
    class var FSubjectEdit, FToEdit: TEdit;
    class var FBodyMemo: TMemo;
  protected
    class procedure DoGetMails(Sender: TObject);
    class procedure DoSendMail(Sender: TObject);
    class procedure DoSelectMail(Sender: TObject);
    class procedure DoGetMailsCompleteResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoSendMessageResult(Sender: TObject; const AMessage: TTMSFNCCloudGoogleGmailMessage; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class function GoogleGMail: TTMSFNCCloudGoogleGmail;
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGoogleGMailService }

class procedure TTMSFNCCloudGoogleGMailService.DoGetMails(Sender: TObject);
begin
  FGetMailsButton.Enabled := False;
  StartLoading;
  GoogleGMail.GetMails;
end;

class procedure TTMSFNCCloudGoogleGMailService.DoGetMailsCompleteResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
  m: TTMSFNCCloudGoogleGmailMessage;
begin
  FGetMailsButton.Enabled := True;
  StopLoading;
  if Assigned(FListBox) then
  begin
    FListBox.Items.Clear;
    for I := 0 to GoogleGMail.Mails.Count - 1 do
    begin
      m := GoogleGMail.Mails[I];
      FListBox.AddItem('From: ' + m.From + '<br>' + 'Subject: '+ m.Subject, '', m);
    end;
  end;
end;

class procedure TTMSFNCCloudGoogleGMailService.DoSelectMail(Sender: TObject);
var
  m: TTMSFNCCloudGoogleGmailMessage;
  s: string;
begin
  if FListBox.ItemIndex <>  -1 then
  begin
    m := TTMSFNCCloudGoogleGmailMessage(FListBox.Items[FListBox.ItemIndex].DataObject);
    case m.MessageType of
      mtPlainText: s := m.Body;
      mtHTML: s := m.HTMLBody;
    end;

    {$IFDEF VCLFMX}
    FViewer.LoadHTML(s);
    {$ENDIF}
    {$IFDEF WEBLIB}
    FViewer.HTML.Text := s;
    {$ENDIF}
    {$IFDEF LCL}
    FViewer.Text := s;
    {$ENDIF}
  end;
end;

class procedure TTMSFNCCloudGoogleGMailService.DoSendMail(Sender: TObject);
var
  m: TTMSFNCCloudGoogleGmailMessage;
begin
  StartLoading;
  FSendButton.Enabled := False;

  m := GoogleGMail.Mails.Add;
  m.Subject := FSubjectEdit.Text;
  m.ToRecipients.Text := FToEdit.Text;

  if TTMSFNCUtils.IsHTML(FBodyMemo.Text) then
    m.MessageType := mtHTML
  else
    m.MessageType := mtPlainText;

  m.Body := FBodyMemo.Text;

  GoogleGMail.SendMessage(m);
end;

class procedure TTMSFNCCloudGoogleGMailService.DoSendMessageResult(Sender: TObject; const AMessage: TTMSFNCCloudGoogleGmailMessage; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  FSendButton.Enabled := True;
  StopLoading;
  ShowMessage('Mail Sent!');
end;

class function TTMSFNCCloudGoogleGMailService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudGoogleGMail;
end;

class function TTMSFNCCloudGoogleGMailService.GetDescription: string;
begin
  Result := 'Gmail is email that''s intuitive, efficient, and useful. 15 GB of storage, less spam, and mobile access.';
end;

class function TTMSFNCCloudGoogleGMailService.GetTitle: string;
begin
  Result := 'Google GMail';
end;

class function TTMSFNCCloudGoogleGMailService.GoogleGMail: TTMSFNCCloudGoogleGmail;
begin
  Result := Service as TTMSFNCCloudGoogleGmail;
end;

class procedure TTMSFNCCloudGoogleGMailService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  lbl: TLabel;
begin
  inherited;
  GoogleGMail.OnGetMailsComplete := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetMailsCompleteResult;
  GoogleGMail.OnSendMessage := {$IFDEF LCLWEBLIB}@{$ENDIF}DoSendMessageResult;

  FGetMailsButton := TButton.Create(AContent);
  FGetMailsButton.Parent := AContent;
  FGetMailsButton.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetMails;
  SetControlPosition(FGetMailsButton, 10, 10);
  SetButtonText(FGetMailsButton, 'Get Mails');
  ClearStyledSettings(FGetMailsButton);

  FListBox := TTMSFNCCloudDemoListBox.Create(AContent);
  FListBox.Parent := AContent;
  FListBox.ItemHeight := 50;
  SetControlMargins(FListBox, 10, 40, 10, 10);
  SetControlAlignment(FListBox, caClient);
  FListBox.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];
  FListBox.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoSelectMail;

  {$IFDEF VCLFMX}
  FViewer := TTMSFNCWebBrowser.Create(ADetailContent);
  FViewer.DisableBackground;
  {$ENDIF}
  {$IFDEF WEBLIB}
  FViewer := TWebHTMLContainer.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF LCL}
  FViewer := TMemo.Create(ADetailContent);
  {$ENDIF}
  FViewer.Parent := ADetailContent;
  {$IFDEF VCLFMX}
  FViewer.URL := 'about:blank';
  {$ENDIF}
  FViewer.Height := 250;
  FViewer.Width := 330;
  SetControlAlignment(FViewer, caTop);
  SetControlMargins(FViewer, 10, 40, 10, 0);

  lbl := TLabel.Create(ADetailContent);
  lbl.Parent := ADetailContent;
  lbl.AutoSize := False;
  lbl.Width := 50;
  SetLabelText(lbl, 'To:');
  SetControlPosition(lbl, 10, 350);
  lbl.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  ClearStyledSettings(lbl);

  FToEdit := TEdit.Create(ADetailContent);
  FToEdit.Parent := ADetailContent;
  FToEdit.Width := 245;
  SetControlPosition(FToEdit, 55, 350);
  FToEdit.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  FToEdit.Text := 'sample@email.com';
  ClearStyledSettings(FToEdit);

  lbl := TLabel.Create(ADetailContent);
  lbl.Parent := ADetailContent;
  lbl.AutoSize := False;
  lbl.Width := 50;
  SetLabelText(lbl, 'Subject:');
  SetControlPosition(lbl, 10, 380);
  lbl.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  ClearStyledSettings(lbl);

  FSubjectEdit := TEdit.Create(ADetailContent);
  FSubjectEdit.Parent := ADetailContent;
  FSubjectEdit.Width := 245;
  SetControlPosition(FSubjectEdit, 55, 380);
  FSubjectEdit.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  FSubjectEdit.Text := 'Hello World !';
  ClearStyledSettings(FSubjectEdit);

  lbl := TLabel.Create(ADetailContent);
  lbl.Parent := ADetailContent;
  lbl.AutoSize := False;
  lbl.Width := 50;
  SetLabelText(lbl, 'Body:');
  SetControlPosition(lbl, 10, 410);
  lbl.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  ClearStyledSettings(lbl);

  FBodyMemo := TMemo.Create(ADetailContent);
  FBodyMemo.Parent := ADetailContent;
  FBodyMemo.Width := 245;
  SetControlPosition(FBodyMemo, 55, 410);
  FBodyMemo.Height := 70;
  FBodyMemo.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  FBodyMemo.Text := 'Enter message body here...';

  FSendButton := TButton.Create(ADetailContent);
  FSendButton.Parent := ADetailContent;
  FSendButton.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoSendMail;
  SetControlPosition(FSendButton, 55, 490);
  SetButtonText(FSendButton, 'Send');
  FSendButton.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  ClearStyledSettings(FSendButton);
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudGoogleGMailService);
end;

end.
