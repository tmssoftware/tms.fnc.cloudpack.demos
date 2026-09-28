unit TMSFNCCloudSlack;

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
  CloudServices, VCL.TMSFNCCloudSlack, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudDemoListBox, VCL.TMSFNCCloudImage, VCL.Imaging.PNGImage;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudSlack, FMX.TMSFNCCustomControl, FMX.Edit, FMX.Memo, FMX.TMSFNCCloudDemoListBox, FMX.TMSFNCCloudImage;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudSlack, LCLTMSFNCCustomControl, LCLTMSFNCCloudDemoListBox, LCLTMSFNCCloudImage;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth, WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCloudSlack, WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCCloudDemoListBox, WEBLib.TMSFNCCloudImage;
  {$ENDIF}

type
  TTMSFNCCloudSlackService = class(TTMSFNCCloudService)
  private
    class var unLbl: TLabel;
    class var rnLbl: TLabel;
    class var stsLbl: TLabel;
    class var emlLbl: TLabel;
    class var tmLbl: TLabel;
    class var lcLbl: TLabel;
    class var cvList: TTMSFNCCloudDemoListBox;
    class var msgList: TTMSFNCCloudDemoListBox;
    class var fileList: TTMSFNCCloudDemoListBox;
    class var rplyList: TTMSFNCCloudDemoListBox;
    class var profilePic: TTMSFNCCloudImage;
    class var nOFLbl: TLabel;
    class var numOfRepliesLabel: TLabel;
    class var nORLbl: TLabel;
    class var sndBtn: TButton;
    class var sndEdit: TEdit;
  protected
    class procedure DoGetUserInformationResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AUser: TTMSFNCCloudSlackUser; ErrorMessage: string);
    class procedure DoGetUserConversationsResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; Conversations: TTMSFNCCloudSlackConversations; AUser: TTMSFNCCloudSlackUser; ErrorMessage: string);
    class procedure DoGetConversationHistoryResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AConversation: TTMSFNCCloudSlackConversation; Messages: TTMSFNCCloudSlackMessages; ErrorMessage: string);
    class procedure DoGetAllMessageRepliesResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AMessage: TTMSFNCCloudSlackMessage; ErrorMessage: string);
    {$IFNDEF WEBLIB}
    class procedure DoGetProfilePictureResult(Sender: Tobject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AUser: TTMSFNCCloudSlackUser; AProfile: TTMSFNCCloudSlackProfile; AProfilePictureStream: TMemoryStream);
    {$ENDIF}
    class procedure DoPostMessageResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AConversation: TTMSFNCCloudSlackConversation; AMessage: TTMSFNCCloudSlackMessage; ErrorMessage: string);
    class procedure DoGetConversationHistory(Sender: TObject);
    class procedure GetMessageDetails(Sender: TObject);
    class procedure PostMessage(Sender: TObject);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function NeedTokens: Boolean; override;
    class procedure Clear; override;
    class function Slack: TTMSFNCCloudSlack;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
    class procedure SetValues(AValues: string); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudSlackService }

class procedure TTMSFNCCloudSlackService.Clear;
begin
  SetClientID('');
  SetSecret('');
  SetKey('');
  inherited;
end;

class procedure TTMSFNCCloudSlackService.DoGetConversationHistory(
  Sender: TObject);
var
  i: Integer;
  c: TTMSFNCCloudSlackConversation;
begin
  fileList.Visible := False;
  rplyList.Visible := False;
  nOFLbl.Visible := False;
  nORLbl.Visible := False;
  numOfRepliesLabel.Visible := False;

  rplyList.Items.Clear;
  fileList.Items.Clear;

  if (cvList.ItemIndex > -1) and (cvList.ItemIndex < cvList.Items.Count)  then
  begin
    msgList.Items.Clear;
    msgList.ItemIndex := -1;

    c := TTMSFNCCloudSlackConversation(cvList.Items[cvList.ItemIndex].DataObject);

    if c.Messages.Count > 0 then
    begin
      msgList.BeginUpdate;
      for I := c.Messages.Count - 1 downto 0 do
      begin
        if Slack.Users.Count > 0 then
          msgList.AddItem('<b><font color="' + c.Messages[I].User.HTMLColor + '">' + c.Messages[I].User.UserName + ':</font></b><br>' + c.Messages[i].Text, '', c.Messages[i])
        else
          msgList.AddItem('<b>' + c.Messages[i].UserID + ':</b><br>' + c.Messages[i].Text, '', c.Messages[i]);
      end;
      msgList.EndUpdate;
      {$IFDEF FMX}
      msgList.VerticalScrollBar.Value := msgList.GetVerticalScrollMax;
      {$ENDIF}
      {$IFNDEF FMX}
      msgList.VerticalScrollBar.Position := Round(msgList.GetVerticalScrollMax);
      {$ENDIF}
    end
    else
    begin
      Slack.GetConversationHistory(TTMSFNCCloudSlackConversation(cvList.Items[cvList.ItemIndex].DataObject), 50);
    end;

    sndEdit.Enabled := True;
    sndBtn.Enabled := True;
  end;
end;

class procedure TTMSFNCCloudSlackService.DoGetConversationHistoryResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AConversation: TTMSFNCCloudSlackConversation;
  Messages: TTMSFNCCloudSlackMessages; ErrorMessage: string);
var
  i: Integer;
begin
  msgList.BeginUpdate;
  for I := Messages.Count - 1 downto 0 do
  begin
    if Slack.Users.Count > 0 then
      msgList.AddItem('<b><font color="' + Messages[I].User.HTMLColor + '">' + Messages[I].User.UserName + ':</font></b><br>' + Messages[i].Text, '', Messages[i])
    else
      msgList.AddItem('<b>' + Messages[i].UserID + ':</b><br>' + Messages[i].Text, '', Messages[i]);
  end;
  msgList.EndUpdate;

  {$IFDEF FMX}
  msgList.VerticalScrollBar.Value := msgList.GetVerticalScrollMax;
  {$ENDIF}
  {$IFNDEF FMX}
  msgList.VerticalScrollBar.Position := Round(msgList.GetVerticalScrollMax);
  {$ENDIF}
end;

{$IFNDEF WEBLib}
class procedure TTMSFNCCloudSlackService.DoGetProfilePictureResult(
  Sender: Tobject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AUser: TTMSFNCCloudSlackUser; AProfile: TTMSFNCCloudSlackProfile;
  AProfilePictureStream: TMemoryStream);
begin
  if Assigned(AProfilePictureStream) then
  begin
    {$IFNDEF FMX}
    AProfilePictureStream.Position := 0;
    {$ENDIF}
    profilePic.Bitmap.LoadFromStream(AProfilePictureStream);
  end;
end;
{$ENDIF}

class procedure TTMSFNCCloudSlackService.DoGetAllMessageRepliesResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AMessage: TTMSFNCCloudSlackMessage; ErrorMessage: string);
var
  i: Integer;
begin
  rplyList.BeginUpdate;

  {$IFDEF FMX}
  SetControlPosition(rplyList, nORLbl.Position.X, numOfRepliesLabel.Position.Y);
  {$ENDIF}
  {$IFNDEF FMX}
  SetControlPosition(rplyList, nORLbl.Left, numOfRepliesLabel.Top);
 {$ENDIF}

  numOfRepliesLabel.Visible := False;
  rplyList.Visible := True;

  for I := AMessage.Replies.Count - 1 downto 0 do
  begin
    if Slack.Users.Count > 0 then
      rplyList.AddItem('<b><font color="' + Slack.Users.GetUserByID(AMessage.Replies[i].UserID).HTMLColor + '">' + Slack.Users.GetUserByID(AMessage.Replies[i].UserID).UserName + ':</font></b><br>' + AMessage.Replies[i].Text, '', AMessage.Replies[i])
    else
      rplyList.AddItem('<b>' + AMessage.Replies[i].UserID + ':</b><br>' + AMessage.Replies[i].Text, '', AMessage.Replies[i]);
  end;
  rplyList.EndUpdate;
end;

class procedure TTMSFNCCloudSlackService.DoGetUserConversationsResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  Conversations: TTMSFNCCloudSlackConversations; AUser: TTMSFNCCloudSlackUser;
  ErrorMessage: string);
var
  i: integer;
begin
  cvList.Items.Clear;
  cvList.BeginUpdate;
  for I := 0 to Conversations.Count - 1 do
    cvList.AddItem(Conversations[i].Name, '', Conversations[i]);
  cvList.EndUpdate;
  if Conversations.Count > 0 then
    cvList.ItemIndex := 0;
end;

class procedure TTMSFNCCloudSlackService.DoGetUserInformationResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AUser: TTMSFNCCloudSlackUser; ErrorMessage: string);
begin
  SetLabelText(unLbl, AUser.UserName);
  SetLabelFontColor(unLbl, AUser.Color);
  SetLabelText(rnLbl, AUser.RealName);
  SetLabelText(lcLbl, AUser.TimeZoneLabel);
  SetLabelText(stsLbl, AUser.Profile.StatusText);
  SetLabelText(emlLbl, AUser.Profile.Email);
  SetLabelText(tmLbl, DateTimeToStr(AUser.UpdateTimeStamp));

  if Assigned(AUser.Profile) then
    {$IFDEF WebLIB}
    profilePic.URL := AUser.Profile.ImageUrl;
    {$ELSE}
    AUser.Profile.DownloadProfilePicture;
    {$ENDIF}
end;

class procedure TTMSFNCCloudSlackService.DoPostMessageResult(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AConversation: TTMSFNCCloudSlackConversation;
  AMessage: TTMSFNCCloudSlackMessage; ErrorMessage: string);
begin
  if Slack.Users.Count > 0 then
    msgList.AddItem('<b><font color="' + AMessage.User.HTMLColor + '">' + AMessage.User.UserName + ':</font></b><br>' + AMessage.Text, '', AMessage)
  else
    msgList.AddItem('<b>' + AMessage.UserID + ':</b><br>' + AMessage.Text, '', AMessage);
end;

class function TTMSFNCCloudSlackService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudSlack;
end;

class function TTMSFNCCloudSlackService.GetDescription: string;
begin
  Result := 'Discover Slack';
end;

class procedure TTMSFNCCloudSlackService.GetMessageDetails(Sender: TObject);
var
  x, h: Single;
  i: integer;
  f: TTMSFNCCloudSlackFile;
  m: TTMSFNCCloudSlackMessage;
begin
  fileList.Visible := False;
  rplyList.Visible := False;
  nOFLbl.Visible := False;
  nORLbl.Visible := False;
  numOfRepliesLabel.Visible := False;

  rplyList.Items.Clear;
  fileList.Items.Clear;

  if (msgList.ItemIndex > 0) and (msgList.ItemIndex < msgList.Items.Count) then
  begin
    h := 10;
    {$IFDEF FMX}
    x := msgList.Width + msgList.Position.X + 10;
    {$ENDIF}
    {$IFNDEF FMX}
    x := msgList.Width + msgList.Left + 10;
    {$ENDIF}

    m := TTMSFNCCloudSlackMessage(msgList.Items[msgList.ItemIndex].DataObject);

    if m.Files.Count > 0  then
    begin
      SetLabelText(nOFLbl, 'Files: ');
      SetControlPosition(nOFLbl, x, h);
      nOFLbl.Visible := True;
      h:= h + 18;

      fileList.Visible := True;
      SetControlPosition(fileList, x, h);

      for i := 0 to m.Files.Count - 1 do
      begin
        f := m.Files[i];
        fileList.AddItem(f.Name + ' (Comments: ' + IntToStr(f.CommentsCount) + ')', '', f);
      end;

      h := h + fileList.Height + 20;
    end;

    if m.ReplyCount > 0  then
    begin
      SetLabelText(nORLbl, 'Replies: ');
      SetControlPosition(nORLbl, x, h);
      nORLbl.Visible := True;
      h:= h + 18;

      if (m.Replies.Count > 0) and (m.Replies[0].Text <> '') then
      begin
        rplyList.Visible := True;
        SetControlPosition(rplyList, x, h);
        rplyList.BeginUpdate;
        for I := m.Replies.Count - 1 downto 0 do
        begin
          if Slack.Users.Count > 0 then
            rplyList.AddItem('<b><font color ="'+Slack.Users.GetUserByID(m.Replies[i].UserID).HTMLColor + '">' + Slack.Users.GetUserByID(m.Replies[i].UserID).UserName + ':</font></b><br>' + m.Replies[i].Text, '', m.Replies[i])
          else
            rplyList.AddItem('<b>' + m.Replies[i].UserID + ':</b><br>' + m.Replies[i].Text, '', m.Replies[i]);
        end;
        rplyList.EndUpdate;
      end
      else
      begin
        SetLabelText(numOfRepliesLabel, IntToStr(m.ReplyCount));
        SetControlPosition(numOfRepliesLabel, x + 30, h);
        numOfRepliesLabel.Visible := True;

        Slack.GetAllMessageReplies(m);
      end;
    end;
  end;
end;

class function TTMSFNCCloudSlackService.GetTitle: string;
begin
  Result := 'Slack';
end;

class procedure TTMSFNCCloudSlackService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  tmpLabel: TLabel;
begin
  inherited;

  unLbl := TLabel.Create(AContent);
  unLbl.Parent := AContent;
  SetControlPosition(unLbl, 10, 10);
  SetLabelText(unLbl, Slack.CurrentUserName);
  ClearStyledSettings(unLbl);

  Slack.ProfileImageSize := siz192;

  profilePic := TTMSFNCCloudImage.Create(AContent);
  profilePic.Parent := AContent;
  SetControlPosition(profilePic, 10, 30);
  profilePic.Width := 200;
  profilePic.Height := 200;

  tmpLabel := TLabel.Create(AContent);
  tmpLabel.Parent := AContent;
  SetControlPosition(tmpLabel, 10, 230);
  SetLabelText(tmpLabel, 'Real Name: ');
  ClearStyledSettings(tmpLabel);

  rnLbl := TLabel.Create(AContent);
  rnLbl.Parent := AContent;
  SetControlPosition(rnLbl, 40, 248);
  ClearStyledSettings(rnLbl);

  tmpLabel := TLabel.Create(AContent);
  tmpLabel.Parent := AContent;
  SetControlPosition(tmpLabel, 10, 266);
  SetLabelText(tmpLabel, 'Time Zone: ');
  ClearStyledSettings(tmpLabel);

  lcLbl := TLabel.Create(AContent);
  lcLbl.Parent := AContent;
  SetControlPosition(lcLbl, 40, 284);
  ClearStyledSettings(lcLbl);

  tmpLabel := TLabel.Create(AContent);
  tmpLabel.Parent := AContent;
  SetControlPosition(tmpLabel, 10, 302);
  SetLabelText(tmpLabel, 'Updated: ');
  ClearStyledSettings(tmpLabel);

  tmLbl := TLabel.Create(AContent);
  tmLbl.Parent := AContent;
  SetControlPosition(tmLbl, 40, 320);
  ClearStyledSettings(tmLbl);

  tmpLabel := TLabel.Create(AContent);
  tmpLabel.Parent := AContent;
  SetControlPosition(tmpLabel, 10, 338);
  SetLabelText(tmpLabel, 'Status: ');
  ClearStyledSettings(tmpLabel);

  stsLbl := TLabel.Create(AContent);
  stsLbl.Parent := AContent;
  SetControlPosition(stsLbl, 40, 356);
  ClearStyledSettings(stsLbl);

  tmpLabel := TLabel.Create(AContent);
  tmpLabel.Parent := AContent;
  SetControlPosition(tmpLabel, 10, 374);
  SetLabelText(tmpLabel, 'E-mail: ');
  ClearStyledSettings(tmpLabel);

  emlLbl := TLabel.Create(AContent);
  emlLbl.Parent := AContent;
  SetControlPosition(emlLbl, 40, 392);
  ClearStyledSettings(emlLbl);

  cvList := TTMSFNCCloudDemoListBox.Create(AContent);
  cvList.Parent := AContent;
  cvList.ItemHeight := 20;
  cvList.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop];
  SetControlPosition(cvList, 10, 410);
  cvList.Width := 200;
  cvList.Height := 150;
  cvList.OnItemChanged := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetConversationHistory;



  msgList := TTMSFNCCloudDemoListBox.Create(ADetailContent);
  msgList.Parent := ADetailContent;
  msgList.ItemHeight := 60;
  SetControlPosition(msgList, 0, 10);
  msgList.Width := 370;
  msgList.Height := 500;
  msgList.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];
  msgList.OnItemChanged := {$IFDEF LCLWEBLIB}@{$ENDIF}GetMessageDetails;
  SetControlMargins(msgList, 10, 10, 10, 10);

  sndEdit := TEdit.Create(ADetailContent);
  sndEdit.Parent := ADetailContent;
  SetControlPosition(sndEdit, 0, 520);
  sndEdit.Width := 310;
  sndEdit.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  sndEdit.Height := 50;
  sndEdit.Enabled := False;

  sndBtn := TButton.Create(ADetailContent);
  sndBtn.Parent := ADetailContent;
  SetControlPosition(sndBtn, 320, 520);
  sndBtn.Width := 50;
  sndBtn.Height := 50;
  sndBtn.Enabled := False;
  SetButtonText(sndBtn, 'Send');
  sndBtn.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  sndBtn.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}PostMessage;


  nOFLbl := TLabel.Create(ADetailContent);
  nOFLbl.Parent := ADetailContent;
  ClearStyledSettings(nOFLbl);
  nOFLbl.Visible := False;

  fileList := TTMSFNCCloudDemoListBox.Create(ADetailContent);
  fileList.Parent := ADetailContent;
  fileList.ItemHeight := 40;
  fileList.Width := 250;
  fileList.Height := 200;
  fileList.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop];
  fileList.Visible := False;


  nORLbl := TLabel.Create(ADetailContent);
  nORLbl.Parent := ADetailContent;
  ClearStyledSettings(nORLbl);
  nORLbl.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom];
  nORLbl.Visible := False;

  numOfRepliesLabel := TLabel.Create(ADetailContent);
  numOfRepliesLabel.Parent := ADetailContent;
  ClearStyledSettings(numOfRepliesLabel);
  numOfRepliesLabel.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop];
  numOfRepliesLabel.Visible := False;

  rplyList := TTMSFNCCloudDemoListBox.Create(ADetailContent);
  rplyList.Parent := ADetailContent;
  rplyList.ItemHeight := 40;
  rplyList.Width := 250;
  rplyList.Height := 200;
  rplyList.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop];
  rplyList.Visible := False;

  Slack.OnGetUserInformation := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetUserInformationResult;
  Slack.OnGetUserConversations := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetUserConversationsResult;
  {$IFNDEF WEBLIB}
  Slack.OnGetProfilePicture := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetProfilePictureResult;
  {$ENDIF}
  Slack.OnGetConversationHistory := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetConversationHistoryResult;
  Slack.OnGetAllMessageReplies := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetAllMessageRepliesResult;
  Slack.OnPostMessage := {$IFDEF LCLWEBLIB}@{$ENDIF}DoPostMessageResult;

  Slack.GetUserInformation(Slack.CurrentUserID);
  Slack.GetUserConversations(Slack.CurrentUserID, 20);
  Slack.GetAllUsers;
end;

class function TTMSFNCCloudSlackService.NeedTokens: Boolean;
begin
  Result := False;
end;

class procedure TTMSFNCCloudSlackService.PostMessage(Sender: TObject);
begin
  if sndEdit.Text <> '' then
    Slack.PostMessage(TTMSFNCCloudSlackConversation(cvList.Items[cvList.ItemIndex].DataObject), sndEdit.Text);
end;

class procedure TTMSFNCCloudSlackService.SetValues(AValues: string);
begin
  inherited;
  Slack.Scopes.Clear;
  Slack.Scopes.Add('users:read');
  Slack.Scopes.Add('channels:read');
  Slack.Scopes.Add('groups:read');
  Slack.Scopes.Add('channels:history');
  Slack.Scopes.Add('chat:write');
  Slack.Scopes.Add('files:read');
  Slack.Scopes.Add('channels:write');
end;

class function TTMSFNCCloudSlackService.Slack: TTMSFNCCloudSlack;
begin
  Result := Service as TTMSFNCCloudSlack;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudSlackService);
end;

end.
