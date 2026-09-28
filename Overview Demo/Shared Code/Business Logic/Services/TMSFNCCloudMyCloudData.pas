unit TMSFNCCloudMyCloudData;

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
  CloudServices, VCL.TMSFNCCloudMyCloudData, VCL.TMSFNCCloudImage, VCL.TMSFNCCustomControl, VCL.TMSFNCUtils,
  VCL.Dialogs, VCL.TMSFNCCloudDemoListBox, VCL.Imaging.jpeg, RTTI;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, IOUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCustomControl, FMX.TMSFNCCloudMyCloudData,
  FMX.ListBox, FMX.Edit, FMX.TMSFNCCloudImage, FMX.DateTimeCtrls, FMX.Dialogs, FMX.TMSFNCCloudDemoListBox, RTTI;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudMyCloudData, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCloudMyCloudData, WEBLib.TMSFNCCloudImage, WEBLib.TMSFNCCloudDemoListBox, RTTI;
  {$ENDIF}

type
  TTMSFNCCloudMyCloudDataService = class(TTMSFNCCloudService)
  private
    class var lbContacts: TTMSFNCCloudDemoListBox;
    class var edName: TEdit;
    class var edEmailAddress: TEdit;
    class var ciImage: TTMSFNCCloudImage;
    {$IFNDEF WEBLIB}
    {$IFDEF FMX}
    class var deBirthDay: TDateEdit;
    {$ENDIF}
    {$IFNDEF FMX}
    class var deBirthDay: TDateTimePicker;
    {$ENDIF}
    {$ENDIF}
    {$IFDEF WEBLIB}
    class var deBirthDay: TDateTimePicker;
    {$ENDIF}
    class var table: TTMSFNCCloudMyCloudDataTable;
    class var cbIsFriend: TCheckBox;
    class var rdMale: TRadioButton;
    class var rdFemale: TRadioButton;
  protected
    class procedure DoGetTablesResult(Sender: TObject; const AInfo: TTMSFNCCloudMyCloudDataTables; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetMetaDataResult(Sender: TObject; const AInfo: TTMSFNCCloudMyCloudDataMetaData; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoQueryResult(Sender: TObject; const AInfo: TTMSFNCCloudMyCloudDataEntities; const ARequestResult: TTMSFNCCloudBaseRequestResult);

    class procedure DoGetContacts(Sender: TObject);
    class procedure DoGetContactDetail(Sender: TObject);

    class procedure DoAddContact(Sender: TObject);
    class procedure DoAddContactResult(Sender: TObject; const AInfo: TTMSFNCCloudMyCloudDataEntity; const ARequestResult: TTMSFNCCloudBaseRequestResult);

    class procedure DoUpdateContact(Sender: TObject);
    class procedure DoUpdateContactResult(Sender: TObject; const AInfo: TTMSFNCCloudMyCloudDataEntity; const ARequestResult: TTMSFNCCloudBaseRequestResult);

    class procedure DoDeleteContact(Sender: TObject);
    class procedure DoDeleteContactResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);

    {$IFNDEF WEBLIB}
    class procedure DoDownloadStreamResult(Sender: TObject; const AInfo: TStream; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    {$ENDIF}

    class procedure DoUploadImage(Sender: TObject);
    class procedure DoUploadImageResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function MyCloudData: TTMSFNCCloudMyCloudData;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudMyCloudDataService }

class procedure TTMSFNCCloudMyCloudDataService.DoAddContact(Sender: TObject);
var
  entity: TTMSFNCCloudMyCloudDataEntity;
begin
  entity := MyCloudData.Entities.Add as TTMSFNCCloudMyCloudDataEntity;
  entity.Values['NAME'] := TValue.From(edName.Text);
  entity.Values['EMAIL'] := TValue.From(edEmailAddress.Text);
  entity.Values['BIRTHDATE'] := TValue.From(DateTimeToStr(deBirthDay.Date));
  entity.Insert;
end;

class procedure TTMSFNCCloudMyCloudDataService.DoAddContactResult(
  Sender: TObject; const AInfo: TTMSFNCCloudMyCloudDataEntity;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  lbContacts.AddItem(ValueToString((AInfo as TTMSFNCCloudMyCloudDataEntity).Value['NAME']), '', AInfo);
end;

class procedure TTMSFNCCloudMyCloudDataService.DoDeleteContact(Sender: TObject);
var
  entity: TTMSFNCCloudMyCloudDataEntity;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  entity := TTMSFNCCloudMyCloudDataEntity(lbContacts.Items[lbContacts.ItemIndex].DataObject);
  entity.Delete;
end;

class procedure TTMSFNCCloudMyCloudDataService.DoDeleteContactResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  lbContacts.Items.Delete(lbContacts.ItemIndex);
end;

{$IFNDEF WEBLIB}
class procedure TTMSFNCCloudMyCloudDataService.DoDownloadStreamResult(
  Sender: TObject; const AInfo: TStream;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);

{$IFDEF VCL}
var
 jpg: TJPEGImage;
begin
  if Assigned(AInfo) then
  begin
    jpg := TJPEGImage.Create;
    jpg.LoadFromStream(AInfo);
    ciImage.Bitmap.Assign(jpg);
    jpg.Free;
  end
  else
    ciImage.URL := '';
{$ENDIF}

{$IFDEF FMX}
begin
  if Assigned(AInfo) then
    ciImage.Bitmap.LoadFromStream(AInfo)
  else
    ciImage.URL := '';
{$ENDIF}

end;
{$ENDIF}

class procedure TTMSFNCCloudMyCloudDataService.DoGetContactDetail(
  Sender: TObject);
var
  entity: TTMSFNCCloudMyCloudDataEntity;
  v: string;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  entity := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMyCloudDataEntity;

  v := ValueToString((entity as TTMSFNCCloudMyCloudDataEntity).Value['NAME']);
  edName.Text := v;

  v := ValueToString((entity as TTMSFNCCloudMyCloudDataEntity).Value['BIRTHDATE']);
  deBirthDay.Date := StrToDateTime(v);

  v := ValueToString((entity as TTMSFNCCloudMyCloudDataEntity).Value['EMAIL']);
  edEmailAddress.Text := v;

  v := ValueToString((entity as TTMSFNCCloudMyCloudDataEntity).Value['FRIEND']);
  {$IFDEF FMX}
  cbIsFriend.IsChecked := StrToBool(v);
  {$ENDIF}
  {$IFNDEF FMX}
  cbIsFriend.Checked := StrToBool(v);
  {$ENDIF}

  v := ValueToString((entity as TTMSFNCCloudMyCloudDataEntity).Value['SEX']);
  if v = 'M' then
  begin
    {$IFDEF FMX}
    rdMale.IsChecked := True
    {$ENDIF}
    {$IFNDEF FMX}
    rdMale.Checked := True
    {$ENDIF}
  end
  else
  begin
    {$IFDEF FMX}
    rdFemale.IsChecked := True
    {$ENDIF}
    {$IFNDEF FMX}
    rdFemale.Checked := True
    {$ENDIF}
  end;

  MyCloudData.DownloadAsStream(MyCloudData.TableId, entity.IntID, 'PICTURE');
end;

class procedure TTMSFNCCloudMyCloudDataService.DoGetContacts(Sender: TObject);
begin
  StartLoading;
  MyCloudData.GetTables;
end;

class procedure TTMSFNCCloudMyCloudDataService.DoGetMetaDataResult(
  Sender: TObject; const AInfo: TTMSFNCCloudMyCloudDataMetaData;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  StartLoading;
  MyCloudData.Query;
end;

class procedure TTMSFNCCloudMyCloudDataService.DoGetTablesResult(
  Sender: TObject; const AInfo: TTMSFNCCloudMyCloudDataTables;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  tn: string;
begin
  StopLoading;
  tn := 'CONTACTS';
  table := MyCloudData.TableByName(tn);

  if Assigned(table) then
  begin
    MyCloudData.TableId := table.ID;
    MyCloudData.GetMetaData;
  end;
end;

class procedure TTMSFNCCloudMyCloudDataService.DoQueryResult(Sender: TObject;
  const AInfo: TTMSFNCCloudMyCloudDataEntities;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
  v: string;
begin
  StopLoading;
  lbContacts.Items.Clear;
  for I := 0 to AInfo.Count - 1 do
  begin
    v := ValueToString((AInfo[i] as TTMSFNCCloudMyCloudDataEntity).Value['NAME']);
    lbContacts.AddItem(v, '', AInfo[I]);
  end;
end;

class procedure TTMSFNCCloudMyCloudDataService.DoUpdateContact(Sender: TObject);
var
  entity: TTMSFNCCloudMyCloudDataEntity;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  entity := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMyCloudDataEntity;
  entity.Values['NAME'] := TValue.From(edName.Text);
  entity.Values['EMAIL'] := TValue.From(edEmailAddress.Text);
  entity.Values['BIRTHDATE'] := TValue.From(DateTimeToStr(deBirthDay.Date));
  {$IFDEF FMX}
  entity.Values['FRIEND'] := BoolToStr(cbIsFriend.IsChecked, True);
  {$ENDIF}
  {$IFNDEF FMX}
  entity.Values['FRIEND'] := TValue.From(BoolToStr(cbIsFriend.Checked, True));
  {$ENDIF}

  {$IFDEF FMX}
  if rdMale.IsChecked then
  {$ENDIF}
  {$IFNDEF FMX}
  if rdMale.Checked then
  {$ENDIF}
    entity.Values['SEX'] := TValue.From('M')
  else
    entity.Values['SEX'] := TValue.From('F');
  entity.Update;
end;

class procedure TTMSFNCCloudMyCloudDataService.DoUpdateContactResult(
  Sender: TObject; const AInfo: TTMSFNCCloudMyCloudDataEntity;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  lbContacts.Items[lbContacts.ItemIndex].Text := ValueToString((AInfo as TTMSFNCCloudMyCloudDataEntity).Value['NAME']);
end;

class procedure TTMSFNCCloudMyCloudDataService.DoUploadImage(Sender: TObject);
{$IFNDEF WEBLIB}
var
  entity: TTMSFNCCloudMyCloudDataEntity;
  f: string;
{$ENDIF}
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  {$IFNDEF WEBLIB}
  entity := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMyCloudDataEntity;
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
  {$IFDEF FMX}
  end
  );
  {$ENDIF}
    MyCloudData.Upload(MyCloudData.TableId, entity.IntID, 'PICTURE', f);
  {$ENDIF}
end;

class procedure TTMSFNCCloudMyCloudDataService.DoUploadImageResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  entity: TTMSFNCCloudMyCloudDataEntity;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  entity := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudMyCloudDataEntity;

  MyCloudData.DownloadAsStream(MyCloudData.TableId, entity.IntID, 'PICTURE');
end;

class function TTMSFNCCloudMyCloudDataService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudMyCloudData;
end;

class function TTMSFNCCloudMyCloudDataService.GetDescription: string;
begin
  Result := 'The fastest and easiest route to host your data in the cloud.';
end;

class function TTMSFNCCloudMyCloudDataService.GetTitle: string;
begin
  Result := 'TMS myCloudData';
end;

class function TTMSFNCCloudMyCloudDataService.MyCloudData: TTMSFNCCloudMyCloudData;
begin
  Result := Service as TTMSFNCCloudMyCloudData;
end;

class procedure TTMSFNCCloudMyCloudDataService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  l: TLabel;
  ew: Integer;
begin
  inherited;

  ew := 250;
  table := nil;

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
  SetLabelText(l, 'Name');
  ClearStyledSettings(l);

  edName := TEdit.Create(ADetailContent);
  edName.Parent := ADetailContent;
  SetControlPosition(edName, 120, 40);
  edName.Width := ew;
  edName.Text := 'Name';
  ClearStyledSettings(edName);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 70);
  SetLabelText(l, 'Email');
  ClearStyledSettings(l);

  edEmailAddress := TEdit.Create(ADetailContent);
  edEmailAddress.Parent := ADetailContent;
  SetControlPosition(edEmailAddress, 120, 70);
  edEmailAddress.Width := ew;
  ClearStyledSettings(edEmailAddress);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 100);
  SetLabelText(l, 'Birthday');
  ClearStyledSettings(l);

  {$IFDEF FMX}
  deBirthDay := TDateEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFNDEF FMX}
  deBirthDay := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  deBirthDay.Parent := ADetailContent;
  SetControlPosition(deBirthDay, 120, 100);
  deBirthDay.Width := ew;

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 130);
  SetLabelText(l, 'Friend');
  ClearStyledSettings(l);

  cbIsFriend := TCheckBox.Create(ADetailContent);
  cbIsFriend.Parent := ADetailContent;
  SetControlPosition(cbIsFriend, 120, 130);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 160);
  SetLabelText(l, 'Gender');
  ClearStyledSettings(l);

  rdFemale := TRadioButton.Create(ADetailContent);
  rdFemale.Parent := ADetailContent;
  SetControlPosition(rdFemale, 120, 160);
  {$IFDEF FMX}
  rdFemale.Text := 'Female';
  rdFemale.GroupName := 'Gender';
  {$ENDIF}
  {$IFNDEF FMX}
  rdFemale.Caption := 'Female';
  {$ENDIF}
  {$IFDEF WEBLIB}
  rdFemale.GroupName := 'Gender';
  {$ENDIF}

  rdMale := TRadioButton.Create(ADetailContent);
  rdMale.Parent := ADetailContent;
  SetControlPosition(rdMale, 220, 160);
  {$IFDEF FMX}
  rdMale.Text := 'Male';
  rdMale.GroupName := 'Gender';
  {$ENDIF}
  {$IFNDEF FMX}
  rdMale.Caption := 'Male';
  {$ENDIF}
  {$IFDEF WEBLIB}
  rdMale.GroupName := 'Gender';
  {$ENDIF}

  ciImage := TTMSFNCCloudImage.Create(ADetailContent);
  ciImage.Parent := ADetailContent;
  SetControlPosition(ciImage, 20, 235);
  ciImage.Height := 100;
  ciImage.Width := 100;
  {$IFDEF WEBLIB}
  ciImage.Visible := False;
  {$ENDIF}

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUploadImage;
  SetControlPosition(b, 20, 345);
  SetButtonText(b, 'Upload');
  {$IFDEF WEBLIB}
  b.Visible := False;
  {$ENDIF}
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddContact;
  SetControlPosition(b, 20, 200);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateContact;
  SetControlPosition(b, 130, 200);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteContact;
  SetControlPosition(b, 240, 200);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  MyCloudData.OnGetTables := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetTablesResult;
  MyCloudData.OnQuery := {$IFDEF LCLWEBLIB}@{$ENDIF}DoQueryResult;
  MyCloudData.OnGetMetaData := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetMetaDataResult;
  MyCloudData.OnDelete := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteContactResult;
  MyCloudData.OnUpdate := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateContactResult;
  MyCloudData.OnInsert := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddContactResult;
  {$IFNDEF WEBLIB}
  MyCloudData.OnDownloadStream := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDownloadStreamResult;
 {$ENDIF}
  MyCloudData.OnUpload := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUploadImageResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudMyCloudDataService);
end;

end.
