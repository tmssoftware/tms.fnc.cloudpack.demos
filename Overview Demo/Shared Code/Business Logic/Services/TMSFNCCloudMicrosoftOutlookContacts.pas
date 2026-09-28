unit TMSFNCCloudMicrosoftOutlookContacts;

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
  CloudServices, VCL.TMSFNCCloudMicrosoftOutlookContacts, VCL.TMSFNCCloudImage, VCL.Dialogs, VCL.TMSFNCUtils,
  VCL.TMSFNCCustomControl, VCL.TMSFNCTypes, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, IOUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCustomControl, FMX.TMSFNCCloudMicrosoftOutlookContacts,
  FMX.ListBox, FMX.Edit, FMX.TMSFNCCloudImage, FMX.DateTimeCtrls, FMX.Dialogs, FMX.TMSFNCTypes,
  FMX.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase, LCLTMSFNCCloudImage, DateTimePicker,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudMicrosoftOutlookContacts,
  LCLTMSFNCCustomControl, LCLTMSFNCTypes, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCCloudMicrosoftOutlookContacts,
  WEBLib.TMSFNCCloudImage, WEBLib.TMSFNCTypes, WEBLib.TMSFNCCloudDemoListBox, WEBLib.WebCtrls;
  {$ENDIF}

type
  TTMSFNCCloudMicrosoftOutlookContactsService = class(TTMSFNCCloudService)
  private
    class var lbContacts: TTMSFNCCloudDemoListBox;
    class var lbCollections: TListBox;
    class var edFirstName: TEdit;
    class var edLastName: TEdit;
    class var edEmailAddress: TEdit;
    class var ciImage: TTMSFNCCloudImage;
    {$IFDEF FMX}
    class var deBirthDay: TDateEdit;
    {$ENDIF}
    {$IFDEF WEBLIB}
    class var deBirthDay: TWebDateTimePicker;
    {$ENDIF}
    {$IFDEF LCL}
    class var deBirthDay: TDateTimePicker;
    {$ENDIF}
    {$IFDEF VCL}
    class var deBirthDay: TDateTimePicker;
    {$ENDIF}
    {$IFDEF WEBLIB}
    class var WebFilePicker: TWebFilePicker;
    {$ENDIF}
  protected
    class procedure DoGetContactsResult(Sender: TObject; const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContacts; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetContacts(Sender: TObject);

    class procedure DoAddContactResult(Sender: TObject; const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContact; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoAddContact(Sender: TObject);

    class procedure DoDeleteContactResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoDeleteContact(Sender: TObject);

    class procedure DoUpdateContactResult(Sender: TObject; const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContact; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoUpdateContact(Sender: TObject);

    class procedure DoGetContactDetail(Sender: TObject);
    class procedure DoDownloadContactImageResult(Sender: TObject; const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContact; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoUploadContactImageResult(Sender: TObject; const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContact; const ARequestResult: TTMSFNCCloudBaseRequestResult);

    class procedure DoUploadImage(Sender: TObject);
    {$IFDEF WEBLIB}
    class procedure DoFileLoaded(const AFile: TTMSFNCUtilsFile);
    {$ENDIF}
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function MicrosoftOutlookContacts: TTMSFNCCloudMicrosoftOutlookContacts;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudMicrosoftOutlookContactsService }

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoAddContact(Sender: TObject);
var
  c: TTMSFNCCloudMicrosoftOutlookContactsContact;
begin
  c := MicrosoftOutlookContacts.Contacts.Add;
  c.FirstName := edFirstName.Text;
  c.LastName := edLastName.Text;
  MicrosoftOutlookContacts.CreateContact(c);
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoAddContactResult(Sender: TObject;
  const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContact;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  lbContacts.InsertItem(0, AInfo.FirstName + ' ' + AInfo.LastName, '', AInfo);
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoDeleteContact(Sender: TObject);
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  MicrosoftOutlookContacts.DeleteContact(lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMicrosoftOutlookContactsContact);
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoDeleteContactResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  lbContacts.Items.Delete(lbContacts.ItemIndex);
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoDownloadContactImageResult(
  Sender: TObject; const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContact;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if Assigned(AInfo) and Assigned(AInfo.Image) then
    ciImage.Bitmap := AInfo.Image
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoGetContactDetail(Sender: TObject);
var
  ta: TTMSFNCCloudMicrosoftOutlookContactsContact;
  I: Integer;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  ta := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMicrosoftOutlookContactsContact;
  edFirstName.Text := ta.FirstName;
  edLastName.Text := ta.LastName;

  lbCollections.Items.Clear;
  for I := 0 to ta.EmailAddresses.Count - 1 do
    lbCollections.Items.AddObject(ta.EmailAddresses[I].Address, ta.EmailAddresses[I]);

  if not IsBitmapEmpty(ta.Image) then
    ciImage.Bitmap := ta.Image
  else
    MicrosoftOutlookContacts.DownloadContactImage(ta);

  deBirthDay.Date := ta.BirthDay;
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoGetContacts(Sender: TObject);
begin
  StartLoading;
  MicrosoftOutlookContacts.GetContacts;
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoGetContactsResult(Sender: TObject;
  const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContacts;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  StopLoading;
  if Assigned(lbContacts) then
  begin
    lbContacts.Items.Clear;
    for I := 0 to AInfo.Count - 1 do
      lbContacts.AddItem(AInfo[I].FirstName + ' ' + AInfo[I].LastName, '', AInfo[I]);
  end;
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoUpdateContact(Sender: TObject);
var
  ta: TTMSFNCCloudMicrosoftOutlookContactsContact;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  ta := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMicrosoftOutlookContactsContact;
  ta.FirstName := edFirstName.Text;
  ta.LastName := edLastName.Text;
  ta.BirthDay := deBirthDay.Date;
  MicrosoftOutlookContacts.UpdateContact(ta);
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoUpdateContactResult(
  Sender: TObject; const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContact; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  lbContacts.Items[lbContacts.ItemIndex].Text := AInfo.FirstName + ' ' + AInfo.LastName;
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoUploadContactImageResult(
  Sender: TObject; const AInfo: TTMSFNCCloudMicrosoftOutlookContactsContact;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  ta: TTMSFNCCloudMicrosoftOutlookContactsContact;
begin
  ta := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMicrosoftOutlookContactsContact;
  MicrosoftOutlookContacts.DownloadContactImage(ta);
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoUploadImage(
  Sender: TObject);
{$IFNDEF WEBLIB}
var
  c: TTMSFNCCloudMicrosoftOutlookContactsContact;
  f: string;
{$ENDIF}
begin
  {$IFNDEF WEBLIB}
  if lbContacts.ItemIndex < 0 then
    Exit;

  c := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMicrosoftOutlookContactsContact;
  {$IFDEF FMX}
  TTMSFNCUtils.SelectFile(f, '', '',
  procedure(const AFile: string; const AResult: Boolean)
  begin
    if not AResult then
      Exit;

    f := AFile;
  {$ELSE}
  if TTMSFNCUtils.SelectFile(f) then
  {$ENDIF}
    MicrosoftOutlookContacts.UploadContactImage(c, f);
  {$IFDEF FMX}
  end);
  {$ENDIF}
  {$ELSE}
  if WebFilePicker.Files.Count > 0 then
    TTMSFNCUtils.LoadFile(WebFilePicker.Files[0].FileObject, @DoFileLoaded);
  {$ENDIF}
end;

{$IFDEF WEBLIB}
class procedure TTMSFNCCloudMicrosoftOutlookContactsService.DoFileLoaded(const AFile: TTMSFNCUtilsFile);
var
  c: TTMSFNCCloudMicrosoftOutlookContactsContact;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  c := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMicrosoftOutlookContactsContact;

  if Assigned(c) then
    MicrosoftOutlookContacts.UploadContactImage(c, AFile);
end;
{$ENDIF}

class function TTMSFNCCloudMicrosoftOutlookContactsService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudMicrosoftOutlookContacts;
end;

class function TTMSFNCCloudMicrosoftOutlookContactsService.GetDescription: string;
begin
  Result := 'In Outlook on the web, you use the People page to view, create, edit, find, and delete contacts.';
end;

class function TTMSFNCCloudMicrosoftOutlookContactsService.GetTitle: string;
begin
  Result := 'Microsoft Outlook Contacts';
end;

class function TTMSFNCCloudMicrosoftOutlookContactsService.MicrosoftOutlookContacts: TTMSFNCCloudMicrosoftOutlookContacts;
begin
  Result := Service as TTMSFNCCloudMicrosoftOutlookContacts;
end;

class procedure TTMSFNCCloudMicrosoftOutlookContactsService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  l: TLabel;
  ew: Integer;
begin
  inherited;

  ew := 250;

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetContacts;
  SetControlPosition(b, 10, 10);
  SetButtonText(b, 'Get Contacts');
  ClearStyledSettings(b);

  lbContacts := TTMSFNCCloudDemoListBox.Create(AContent);
  lbContacts.Parent := AContent;
  lbContacts.ItemHeight := 20;
  SetControlAlignment(lbContacts, caClient);
  SetControlMargins(lbContacts, 10, 40, 10, 10);
  lbContacts.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];
  lbContacts.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetContactDetail;

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 40);
  SetLabelText(l, 'First Name');
  ClearStyledSettings(l);

  edFirstName := TEdit.Create(ADetailContent);
  edFirstName.Parent := ADetailContent;
  SetControlPosition(edFirstName, 120, 40);
  edFirstName.Width := ew;
  edFirstName.Text := 'First Name';
  ClearStyledSettings(edFirstName);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 70);
  SetLabelText(l, 'Last Name');
  ClearStyledSettings(l);

  edLastName := TEdit.Create(ADetailContent);
  edLastName.Parent := ADetailContent;
  SetControlPosition(edLastName, 120, 70);
  edLastName.Width := ew;
  edLastName.Text := 'Last Name';
  ClearStyledSettings(edLastName);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 100);
  SetLabelText(l, 'Birthday');
  ClearStyledSettings(l);

  {$IFDEF FMX}
  deBirthDay := TDateEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF WEBLIB}
  deBirthDay := TWebDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF VCL}
  deBirthDay := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF LCL}
  deBirthDay := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  deBirthDay.Parent := ADetailContent;
  SetControlPosition(deBirthDay, 120, 100);
  deBirthDay.Width := ew;

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 130);
  SetLabelText(l, 'Emails');
  ClearStyledSettings(l);

  lbCollections := TListBox.Create(ADetailContent);
  lbCollections.Parent := ADetailContent;
  SetControlPosition(lbCollections, 120, 130);
  lbCollections.Width := ew;
  lbCollections.Height := 90;

  edEmailAddress := TEdit.Create(ADetailContent);
  edEmailAddress.Parent := ADetailContent;
  SetControlPosition(edEmailAddress, 120, 230);
  edEmailAddress.Width := ew;
  edEmailAddress.Visible := False;
  ClearStyledSettings(edEmailAddress);

  ciImage := TTMSFNCCloudImage.Create(ADetailContent);
  ciImage.Parent := ADetailContent;
  SetControlPosition(ciImage, 20, 300);
  ciImage.Height := 100;
  ciImage.Width := 100;

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUploadImage;
  SetControlPosition(b, 20, 410);
  SetButtonText(b, 'Upload');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddContact;
  SetControlPosition(b, 20, 240);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateContact;
  SetControlPosition(b, 130, 240);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteContact;
  SetControlPosition(b, 240, 240);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  {$IFDEF WEBLIB}
  WebFilePicker := TWebFilePicker.Create(ADetailContent);
  WebFilePicker.Parent := ADetailContent;
  SetControlPosition(WebFilePicker, 20, 440);
  {$ENDIF}

  MicrosoftOutlookContacts.OnGetContacts := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetContactsResult;
  MicrosoftOutlookContacts.OnCreateContact := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddContactResult;
  MicrosoftOutlookContacts.OnDeleteContact := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteContactResult;
  MicrosoftOutlookContacts.OnUpdateContact := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateContactResult;
  MicrosoftOutlookContacts.OnDownloadContactImage := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDownloadContactImageResult;
  MicrosoftOutlookContacts.OnUploadContactImage := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUploadContactImageResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudMicrosoftOutlookContactsService);
end;

end.
