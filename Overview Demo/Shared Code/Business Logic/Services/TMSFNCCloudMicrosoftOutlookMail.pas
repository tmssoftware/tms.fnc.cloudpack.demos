unit TMSFNCCloudMicrosoftOutlookMail;

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
  Classes, SysUtils, Generics.Collections, VCL.Forms, VCL.StdCtrls, VCL.ComCtrls, UITypes,VCL.TMSFNCCloudOAuth , VCL.TMSFNCCloudBase,
  CloudServices, VCL.TMSFNCCloudMicrosoftOutlookMail, VCL.TMSFNCCustomControl, VCL.TMSFNCWebBrowser,
  VCL.TMSFNCUtils, Dialogs, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudMicrosoftOutlookMail, FMX.TMSFNCCustomControl,
  FMX.Memo, FMX.Edit, FMX.ListBox, FMX.TMSFNCWebBrowser, FMX.Dialogs, FMX.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudMicrosoftOutlookMail, LCLTMSFNCCustomControl,
  LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCloudMicrosoftOutlookMail,
  WEBLib.TMSFNCCustomControl, WEBLib.ExtCtrls, WEBLib.TMSFNCCloudDemoListBox;
  {$ENDIF}

type
  TTMSFNCCloudMicrosoftOutlookMailService = class(TTMSFNCCloudService)
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
    class procedure DoGetMailsResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoSendMessageResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class function OutlookMail: TTMSFNCCloudMicrosoftOutlookMail;
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudMicrosoftOutlookMailService }

class procedure TTMSFNCCloudMicrosoftOutlookMailService.DoGetMails(
  Sender: TObject);
begin
  FGetMailsButton.Enabled := False;
  StartLoading;
  OutlookMail.GetMails;
end;

class procedure TTMSFNCCloudMicrosoftOutlookMailService.DoGetMailsResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
  m: TTMSFNCCloudMicrosoftOutlookMailItem;
begin
  FGetMailsButton.Enabled := True;
  StopLoading;
  if Assigned(FListBox) then
  begin
    FListBox.Items.Clear;
    for I := 0 to OutlookMail.Mails.Count - 1 do
    begin
      m := OutlookMail.Mails[I];
      FListBox.AddItem('From: ' + m.FromName + '<br>' + 'Subject: '+ m.Subject, '', m);
    end;
  end;
end;

class procedure TTMSFNCCloudMicrosoftOutlookMailService.DoSelectMail(
  Sender: TObject);
var
  m: TTMSFNCCloudMicrosoftOutlookMailItem;
  s: string;
begin
  if FListBox.ItemIndex <>  -1 then
  begin
    m := TTMSFNCCloudMicrosoftOutlookMailItem(FListBox.Items[FListBox.ItemIndex].DataObject);
    s := m.Body;

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

class procedure TTMSFNCCloudMicrosoftOutlookMailService.DoSendMail(
  Sender: TObject);
var
  m: TTMSFNCCloudMicrosoftOutlookMailItem;
begin
  StartLoading;
  FSendButton.Enabled := False;

  m := OutlookMail.Mails.Add;
  m.Subject := FSubjectEdit.Text;
  m.RecipientEmails.Add(FToEdit.Text);

  if TTMSFNCUtils.IsHTML(FBodyMemo.Text) then
    m.MailType := mtHTML
  else
    m.MailType := mtPlainText;

  m.Body := FBodyMemo.Text;

  OutlookMail.SendMessage(m);
end;

class procedure TTMSFNCCloudMicrosoftOutlookMailService.DoSendMessageResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  FSendButton.Enabled := True;
  StopLoading;
  ShowMessage('Mail Sent!');
end;

class function TTMSFNCCloudMicrosoftOutlookMailService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudMicrosoftOutlookMail;
end;

class function TTMSFNCCloudMicrosoftOutlookMailService.GetDescription: string;
begin
  Result := 'Free Outlook email and calendar. Everything you need to be your most productive and connected self – at home, on the go, and everywhere in between.';
end;

class function TTMSFNCCloudMicrosoftOutlookMailService.GetTitle: string;
begin
  Result := 'Microsoft Outlook Mail';
end;

class procedure TTMSFNCCloudMicrosoftOutlookMailService.InitContent(AContent,
  ADetailContent: TTMSFNCCustomControl);
var
  lbl: TLabel;
begin
  inherited;
  OutlookMail.OnGetMails := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetMailsResult;
  OutlookMail.OnSendMessage := {$IFDEF LCLWEBLIB}@{$ENDIF}DoSendMessageResult;

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
  SetControlPosition(FViewer, 10, 40);
  FViewer.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];

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
  SetControlPosition(FToEdit, 10 + lbl.Width + 5, 350);
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
  SetControlPosition(FSubjectEdit, 10 + lbl.Width + 5, 380);
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
  SetControlPosition(FBodyMemo, 10 + lbl.Width + 5, 410);
  FBodyMemo.Height := 70;
  FBodyMemo.Anchors := [TAnchorKind.akLeft, TAnchorKind.akRight, TAnchorKind.akBottom];
  FBodyMemo.Text := 'Enter message body here...';

  FSendButton := TButton.Create(ADetailContent);
  FSendButton.Parent := ADetailContent;
  FSendButton.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoSendMail;
  SetControlPosition(FSendButton, 10 + lbl.Width + 5, 490);
  SetButtonText(FSendButton, 'Send');
  FSendButton.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  ClearStyledSettings(FSendButton);
end;

class function TTMSFNCCloudMicrosoftOutlookMailService.OutlookMail: TTMSFNCCloudMicrosoftOutlookMail;
begin
  Result := Service as TTMSFNCCloudMicrosoftOutlookmail;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudMicrosoftOutlookMailService);
end;

end.
