unit TMSFNCCloudGooglePeople;

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
  CloudServices, VCL.TMSFNCCloudGooglePeople, VCL.TMSFNCCloudImage, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudGooglePeople, FMX.TMSFNCCustomControl,
  FMX.ListBox, FMX.Edit, FMX.TMSFNCCloudImage, FMX.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase, LCLTMSFNCCustomControl,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudGooglePeople, LCLTMSFNCCloudImage, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCCloudGooglePeople,
  WebLib.TMSFNCCloudImage, WEBLib.TMSFNCCloudDemoListBox;
  {$ENDIF}

type
  TTMSFNCCloudGooglePeopleService = class(TTMSFNCCloudService)
  private
    class var lbGroups: TTMSFNCCloudDemoListBox;
    class var lbContacts: TTMSFNCCloudDemoListBox;
    class var lbCollections: TListBox;
    class var edGroup: TEdit;
    class var edFirstName: TEdit;
    class var edLastName: TEdit;
    class var edBirthDay: TEdit;
    class var edBirthMonth: TEdit;
    class var edBirthYear: TEdit;
    class var edEmailAddress: TEdit;
    class var ciImage: TTMSFNCCloudImage;
    class var cbCollection: TComboBox;
  protected
    class procedure DoGetGroupsResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePeopleGroups; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetGroups(Sender: TObject);

    class procedure DoAddGroupResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePeopleGroup; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoAddGroup(Sender: TObject);

    class procedure DoDeleteGroupResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoDeleteGroup(Sender: TObject);

    class procedure DoUpdateGroupResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePeopleGroup; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoUpdateGroup(Sender: TObject);

    class procedure DoGetContactsResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePeopleContacts; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetContacts(Sender: TObject);

    class procedure DoAddContactResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePeopleContact; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoAddContact(Sender: TObject);

    class procedure DoDeleteContactResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoDeleteContact(Sender: TObject);

    class procedure DoUpdateContactResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePeopleContact; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoUpdateContact(Sender: TObject);

    class procedure DoAddContactToGroup(Sender: TObject);
    class procedure DoDeleteContactFromGroup(Sender: TObject);

    class procedure DoGetContactDetail(Sender: TObject);
    class procedure DoAddEmail(Sender: TObject);
    class procedure DoDelEmail(Sender: TObject);
    class procedure DoSelCollection(Sender: TObject);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function GooglePeople: TTMSFNCCloudGooglePeople;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGooglePeopleService }

class procedure TTMSFNCCloudGooglePeopleService.DoAddGroup(Sender: TObject);
var
  g: TTMSFNCCloudGooglePeopleGroup;
begin
  g := GooglePeople.Groups.Add;
  g.Summary := edGroup.Text;
  GooglePeople.CreateGroup(g);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoAddGroupResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGooglePeopleGroup;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  lbGroups.InsertItem(0, AInfo.Summary, '', AInfo);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoAddContact(Sender: TObject);
var
  c: TTMSFNCCloudGooglePeopleContact;
begin
  c := GooglePeople.Contacts.Add;
  c.Names.FirstName := edFirstName.Text;
  c.Names.LastName := edLastName.Text;
  GooglePeople.CreateContact(c);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoAddContactResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGooglePeopleContact;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  email: string;
begin
  if AInfo.Emails.Count > 0 then
    email := sRequestLineBreak + AInfo.Emails[0].DisplayName;

  lbContacts.InsertItem(0, AInfo.Names.FirstName + ' ' + AInfo.Names.LastName + email, '', AInfo);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoAddContactToGroup(
  Sender: TObject);
var
  g: TTMSFNCCloudGooglePeopleGroup;
  c: TTMSFNCCloudGooglePeopleContact;
begin
  if (lbGroups.ItemIndex < 0) or (lbContacts.ItemIndex < 0) then
    Exit;

  g := lbGroups.Items[lbGroups.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleGroup;
  c := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleContact;

  GooglePeople.AddContactToGroup(g, c);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoAddEmail(Sender: TObject);
var
  c: TTMSFNCCloudGooglePeopleContact;
  e: TTMSFNCCloudGooglePeopleEmail;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  if not (edEmailAddress.Text <> '') then
    Exit;

  c := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleContact;
  e := c.Emails.Add;
  e.Address := edEmailAddress.Text;

  lbCollections.Items.Insert(0, e.Address);

  edEmailAddress.Text := '';
end;

class procedure TTMSFNCCloudGooglePeopleService.DoDeleteGroup(Sender: TObject);
begin
  if lbGroups.ItemIndex < 0 then
    Exit;

  GooglePeople.DeleteGroup(lbGroups.Items[lbGroups.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleGroup);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoDeleteGroupResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbGroups.ItemIndex < 0 then
    Exit;

  lbGroups.Items.Delete(lbGroups.ItemIndex);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoDelEmail(Sender: TObject);
var
  e: TTMSFNCCloudGooglePeopleEmail;
begin
  if lbCollections.ItemIndex < 0 then
    Exit;

  e := lbCollections.Items.Objects[lbCollections.ItemIndex] as TTMSFNCCloudGooglePeopleEmail;
  e.Free;

  lbCollections.Items.Delete(lbCollections.ItemIndex);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoDeleteContact(Sender: TObject);
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  GooglePeople.DeleteContact(lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleContact);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoDeleteContactFromGroup(
  Sender: TObject);
var
  g: TTMSFNCCloudGooglePeopleGroup;
  c: TTMSFNCCloudGooglePeopleContact;
begin
  if (lbGroups.ItemIndex < 0) or (lbContacts.ItemIndex < 0) then
    Exit;

  g := lbGroups.Items[lbGroups.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleGroup;
  c := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleContact;

  GooglePeople.DeleteContactFromGroup(g, c);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoDeleteContactResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  lbContacts.Items.Delete(lbContacts.ItemIndex);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoGetContactDetail(Sender: TObject);
var
  ta: TTMSFNCCloudGooglePeopleContact;
  I: Integer;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  ta := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleContact;
  edFirstName.Text := ta.Names.FirstName;
  edLastName.Text := ta.Names.LastName;

  edBirthDay.Text := IntToStr(ta.BirthDay.Date.Day);
  edBirthMonth.Text := IntToStr(ta.BirthDay.Date.Month);
  edBirthYear.Text := IntToStr(ta.BirthDay.Date.Year);

  cbCollection.ItemIndex := 1;
  {$IFNDEF WEBLIB}
  cbCollection.ItemHeight := 20;
  {$ENDIF}

  lbCollections.Items.Clear;
  for I := 0 to ta.Emails.Count - 1 do
    lbCollections.Items.AddObject(ta.Emails[I].Address, ta.Emails[I]);

  ciImage.URL := ta.ImageURL;
end;

class procedure TTMSFNCCloudGooglePeopleService.DoGetGroups(Sender: TObject);
begin
  StartLoading;
  GooglePeople.GetGroups;
end;

class procedure TTMSFNCCloudGooglePeopleService.DoGetGroupsResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGooglePeopleGroups;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  StopLoading;
  if Assigned(lbGroups) then
  begin
    lbGroups.Visible := True;
    lbContacts.Visible := False;
    lbGroups.Items.Clear;
    for I := 0 to AInfo.Count - 1 do
      lbGroups.AddItem(AInfo[I].Summary, '', AInfo[I]);
  end;
end;

class procedure TTMSFNCCloudGooglePeopleService.DoSelCollection(
  Sender: TObject);
var
  I: Integer;
  c: TTMSFNCCloudGooglePeopleContact;
  gn: string;
  J: Integer;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  c := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleContact;

  lbCollections.Items.Clear;
  lbCollections.ItemHeight := 20;
  case cbCollection.ItemIndex of
    0:
    begin
      for I := 0 to c.Groups.Count - 1 do
      begin
        gn := c.Groups[I].ID;
        for J := 0 to GooglePeople.Groups.Count - 1 do
        begin
          if GooglePeople.Groups[I].ID = 'contactGroups/' + gn then
            gn := GooglePeople.Groups[I].Summary;
        end;
        lbCollections.Items.AddObject(gn, c.Groups[I]);
      end;
    end;
    1:
    begin
      for I := 0 to c.Emails.Count - 1 do
        lbCollections.Items.AddObject(c.Emails[I].Address, c.Emails[I]);
    end;
    2:
    begin
      for I := 0 to c.PhoneNumbers.Count - 1 do
        lbCollections.Items.AddObject(c.PhoneNumbers[I].Number, c.PhoneNumbers[I]);
    end;
    3:
    begin
      for I := 0 to c.Websites.Count - 1 do
        lbCollections.Items.AddObject(c.Websites[I].URL, c.Websites[I]);
    end;
    4:
    begin
      lbCollections.ItemHeight := 70;
      for I := 0 to c.PostalAddresses.Count - 1 do
        lbCollections.Items.AddObject(c.PostalAddresses[I].Address, c.PostalAddresses[I]);
    end;
    5:
    begin
      for I := 0 to c.CustomItems.Count - 1 do
        lbCollections.Items.AddObject(c.CustomItems[I].Value, c.CustomItems[I]);
    end;
  end;
end;

class procedure TTMSFNCCloudGooglePeopleService.DoGetContacts(Sender: TObject);
begin
  StartLoading;
  GooglePeople.GetContacts;
end;

class procedure TTMSFNCCloudGooglePeopleService.DoGetContactsResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGooglePeopleContacts;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  StopLoading;
  if Assigned(lbContacts) then
  begin
    lbGroups.Visible := False;
    lbContacts.Visible := True;
    lbContacts.Items.Clear;
    for I := 0 to AInfo.Count - 1 do
      lbContacts.AddItem(AInfo[I].Names.FirstName + ' ' + AInfo[I].Names.LastName, '', AInfo[I]);
  end;
end;

class procedure TTMSFNCCloudGooglePeopleService.DoUpdateGroup(Sender: TObject);
var
  tl: TTMSFNCCloudGooglePeopleGroup;
begin
  if lbGroups.ItemIndex < 0 then
    Exit;

  tl := lbGroups.Items[lbGroups.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleGroup;
  tl.Summary := edGroup.Text;
  GooglePeople.UpdateGroup(tl);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoUpdateGroupResult(
  Sender: TObject; const AInfo: TTMSFNCCloudGooglePeopleGroup;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbGroups.ItemIndex < 0 then
    Exit;

  lbGroups.Items[lbGroups.ItemIndex].Text := AInfo.Summary;
end;

class procedure TTMSFNCCloudGooglePeopleService.DoUpdateContact(Sender: TObject);
var
  ta: TTMSFNCCloudGooglePeopleContact;
  d, m, y: integer;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  ta := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudGooglePeopleContact;
  ta.Names.FirstName := edFirstName.Text;
  ta.Names.LastName := edLastName.Text;
  d := ta.BirthDay.Date.Day;
  if TryStrToInt(edBirthDay.Text, d) then
    ta.BirthDay.Date.Day := d;
  m := ta.BirthDay.Date.Month;
  if TryStrToInt(edBirthMonth.Text, m) then
    ta.BirthDay.Date.Month := m;
  y := ta.BirthDay.Date.Year;
  if TryStrToInt(edBirthYear.Text, y) then
    ta.BirthDay.Date.Year := y;
  GooglePeople.UpdateContact(ta);
end;

class procedure TTMSFNCCloudGooglePeopleService.DoUpdateContactResult(
  Sender: TObject; const AInfo: TTMSFNCCloudGooglePeopleContact; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  lbContacts.Items[lbContacts.ItemIndex].Text := AInfo.Names.FirstName + ' ' + AInfo.Names.LastName;
end;

class function TTMSFNCCloudGooglePeopleService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudGooglePeople;
end;

class function TTMSFNCCloudGooglePeopleService.GetDescription: string;
begin
  Result := 'The People API lets you Group and manage the authenticated user''s Contacts.';
end;

class function TTMSFNCCloudGooglePeopleService.GetTitle: string;
begin
  Result := 'Google People';
end;

class function TTMSFNCCloudGooglePeopleService.GooglePeople: TTMSFNCCloudGooglePeople;
begin
  Result := Service as TTMSFNCCloudGooglePeople;
end;

class procedure TTMSFNCCloudGooglePeopleService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  l: TLabel;
  ew: Integer;
begin
  inherited;

  ew := 250;

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetGroups;
  SetControlPosition(b, 10, 10);
  SetButtonText(b, 'Get Groups');
  ClearStyledSettings(b);

  lbGroups := TTMSFNCCloudDemoListBox.Create(AContent);
  lbGroups.Parent := AContent;
  lbGroups.ItemHeight := 20;
  SetControlAlignment(lbGroups, caClient);
  SetControlMargins(lbGroups, 10, 40, 10, 10);
  lbGroups.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop];

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetContacts;
  SetControlPosition(b, 120, 10);
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
  SetLabelText(l, 'Title');
  ClearStyledSettings(l);

  edGroup := TEdit.Create(ADetailContent);
  edGroup.Parent := ADetailContent;
  SetControlPosition(edGroup, 120, 40);
  edGroup.Text := 'New Group';
  edGroup.Width := ew;
  ClearStyledSettings(edGroup);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.Name := 'btAddGroup';
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddGroup;
  SetControlPosition(b, 20, 70);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateGroup;
  SetControlPosition(b, 130, 70);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteGroup;
  SetControlPosition(b, 240, 70);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddContactToGroup;
  SetControlPosition(b, 20, 110);
  b.Width := 260;
  SetButtonText(b, 'Add Contact To Group');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteContactFromGroup;
  SetControlPosition(b, 20, 140);
  b.Width := 260;
  SetButtonText(b, 'Remove Contact From Group');
  ClearStyledSettings(b);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 330);
  SetLabelText(l, 'First Name');
  ClearStyledSettings(l);

  edFirstName := TEdit.Create(ADetailContent);
  edFirstName.Parent := ADetailContent;
  SetControlPosition(edFirstName, 120, 330);
  edFirstName.Width := ew;
  edFirstName.Text := 'First Name';
  ClearStyledSettings(edFirstName);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 360);
  SetLabelText(l, 'Last Name');
  ClearStyledSettings(l);

  edLastName := TEdit.Create(ADetailContent);
  edLastName.Parent := ADetailContent;
  SetControlPosition(edLastName, 120, 360);
  edLastName.Width := ew;
  edLastName.Text := 'Last Name';
  ClearStyledSettings(edLastName);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 390);
  SetLabelText(l, 'Birthday');
  ClearStyledSettings(l);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 120, 390);
  SetLabelText(l, 'D:');
  l.Width := 25;
  ClearStyledSettings(l);

  edBirthDay := TEdit.Create(ADetailContent);
  edBirthDay.Parent := ADetailContent;
  SetControlPosition(edBirthDay, 145, 390);
  edBirthDay.Width := 50;
  edBirthDay.Text := '31';
  ClearStyledSettings(edBirthDay);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 205, 390);
  SetLabelText(l, 'M:');
  l.Width := 25;
  ClearStyledSettings(l);

  edBirthMonth := TEdit.Create(ADetailContent);
  edBirthMonth.Parent := ADetailContent;
  SetControlPosition(edBirthMonth, 230, 390);
  edBirthMonth.Width := 50;
  edBirthMonth.Text := '12';
  ClearStyledSettings(edBirthMonth);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 290, 390);
  SetLabelText(l, 'Y:');
  l.Width := 25;
  ClearStyledSettings(l);

  edBirthYear := TEdit.Create(ADetailContent);
  edBirthYear.Parent := ADetailContent;
  SetControlPosition(edBirthYear, 320, 390);
  edBirthYear.Width := 50;
  edBirthYear.Text := '2000';
  ClearStyledSettings(edBirthDay);

  cbCollection := TComboBox.Create(ADetailContent);
  cbCollection.Parent := ADetailContent;
  SetControlPosition(cbCollection, 20, 420);
  cbCollection.Items.Add('Group');
  cbCollection.Items.Add('Email');
  cbCollection.Items.Add('Telephone');
  cbCollection.Items.Add('Website');
  cbCollection.Items.Add('Address');
  cbCollection.Items.Add('Custom');
  cbCollection.ItemIndex := 1;
  cbCollection.OnChange := {$IFDEF LCLWEBLIB}@{$ENDIF}DoSelCollection;
  cbCollection.Width := 90;
  ClearStyledSettings(cbCollection);

  lbCollections := TListBox.Create(ADetailContent);
  lbCollections.Parent := ADetailContent;
  SetControlPosition(lbCollections, 120, 420);
  lbCollections.Width := ew;
  lbCollections.Height := 90;

  ciImage := TTMSFNCCloudImage.Create(ADetailContent);
  ciImage.Parent := ADetailContent;
  SetControlPosition(ciImage, 20, 170);
  ciImage.Height := 100;
  ciImage.Width := 100;

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDelEmail;
  SetControlPosition(b, 230, 420);
  SetButtonText(b, 'Remove');
  b.Visible := False;
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddEmail;
  SetControlPosition(b, 230, 450);
  SetButtonText(b, 'Insert');
  b.Visible := False;
  ClearStyledSettings(b);

  edEmailAddress := TEdit.Create(ADetailContent);
  edEmailAddress.Parent := ADetailContent;
  SetControlPosition(edEmailAddress, 120, 480);
  edEmailAddress.Width := ew;
  edEmailAddress.Visible := False;
  ClearStyledSettings(edEmailAddress);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddContact;
  SetControlPosition(b, 20, 520);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateContact;
  SetControlPosition(b, 130, 520);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteContact;
  SetControlPosition(b, 240, 520);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  GooglePeople.OnGetGroups := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetGroupsResult;
  GooglePeople.OnCreateGroup := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddGroupResult;
  GooglePeople.OnDeleteGroup := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteGroupResult;
  GooglePeople.OnUpdateGroup := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateGroupResult;
  GooglePeople.OnGetContacts := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetContactsResult;
  GooglePeople.OnCreateContact := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddContactResult;
  GooglePeople.OnDeleteContact := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteContactResult;
  GooglePeople.OnUpdateContact := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateContactResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudGooglePeopleService);
end;

end.
