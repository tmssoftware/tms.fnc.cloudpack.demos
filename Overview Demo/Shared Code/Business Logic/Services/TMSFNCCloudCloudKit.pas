unit TMSFNCCloudCloudKit;

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
  CloudServices, VCL.TMSFNCCloudCloudKit, VCL.TMSFNCCloudImage, VCL.TMSFNCCustomControl,
  VCL.Dialogs, VCL.TMSFNCCloudDataStore, DB, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCustomControl, FMX.TMSFNCCloudCloudKit,
  FMX.ListBox, FMX.Edit, FMX.TMSFNCCloudImage, FMX.Dialogs, FMX.TMSFNCCloudDataStore,
  DB, FMX.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudCloudKit, LCLTMSFNCCloudDataStore,
  DB, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCCloudCloudKit,
  WEBLib.TMSFNCCloudImage, WEBLib.TMSFNCCloudDataStore, DB, WEBLib.TMSFNCCloudDemoListBox;
  {$ENDIF}

type
  TTMSFNCCloudCloudKitService = class(TTMSFNCCloudService)
  private
    class var lbContacts: TTMSFNCCloudDemoListBox;
    class var edName: TEdit;
    class var edChildren: TEdit;
    class var edSalary: TEdit;
  protected
    class procedure DoQueryResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoQuery(Sender: TObject);
    class procedure DoGetContactDetail(Sender: TObject);

    class procedure DoAddContact(Sender: TObject);
    class procedure DoAddContactResult(Sender: TObject; const AEntity: TTMSFNCCloudDataStoreEntity; const ARequestResult: TTMSFNCCloudBaseRequestResult);

    class procedure DoUpdateContact(Sender: TObject);
    class procedure DoUpdateContactResult(Sender: TObject; const AEntity: TTMSFNCCloudDataStoreEntity; const ARequestResult: TTMSFNCCloudBaseRequestResult);

    class procedure DoDeleteContact(Sender: TObject);
    class procedure DoDeleteContactResult(Sender: TObject; const AID: string; const ARequestResult: TTMSFNCCloudBaseRequestResult);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function NeedTokens: Boolean; override;
    class procedure Clear; override;
    class procedure SetValues(AValues: string); override;
    class function CloudKit: TTMSFNCCloudCloudKit;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudCloudKitService }

class procedure TTMSFNCCloudCloudKitService.DoAddContact(Sender: TObject);
var
  values: TStringList;
begin
  values := TStringList.Create;
  values.Add(edName.Text);
  values.Add(edChildren.Text);
  values.Add(edSalary.Text);
  CloudKit.Insert(values);
  values.Free;
end;

class procedure TTMSFNCCloudCloudKitService.DoAddContactResult(
  Sender: TObject; const AEntity: TTMSFNCCloudDataStoreEntity;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  CloudKit.Query;
end;

class procedure TTMSFNCCloudCloudKitService.DoDeleteContact(Sender: TObject);
var
  entity: TTMSFNCCloudCloudKitEntity;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  entity := TTMSFNCCloudCloudKitEntity(lbContacts.Items[lbContacts.ItemIndex].DataObject);
  CloudKit.Delete(entity.ID);
end;

class procedure TTMSFNCCloudCloudKitService.DoDeleteContactResult(
  Sender: TObject; const AID: string; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  lbContacts.Items.Delete(lbContacts.ItemIndex);
end;

class procedure TTMSFNCCloudCloudKitService.DoGetContactDetail(
  Sender: TObject);
var
  entity: TTMSFNCCloudCloudKitEntity;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  entity := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudCloudKitEntity;
  edName.Text := entity.Strings[0];
  edChildren.Text := entity.Strings[1];
  edSalary.Text := entity.Strings[2];
end;

class procedure TTMSFNCCloudCloudKitService.DoQuery(Sender: TObject);
begin
  StartLoading;
  CloudKit.Query;
end;

class procedure TTMSFNCCloudCloudKitService.DoQueryResult(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
  v: string;
  e: TTMSFNCCloudCloudKitEntity;
begin
  StopLoading;
  lbContacts.Items.Clear;
  for I := 0 to CloudKit.Entities.Count - 1 do
  begin
    e := (CloudKit.Entities[i] as TTMSFNCCloudCloudKitEntity);
    if e.Strings.Count > 0 then
    begin
      v := e.Strings[0];
      lbContacts.AddItem(v, '', CloudKit.Entities[I]);
    end;
  end;
end;

class procedure TTMSFNCCloudCloudKitService.DoUpdateContact(Sender: TObject);
var
  entity: TTMSFNCCloudCloudKitEntity;
begin
  if lbContacts.ItemIndex < 0 then
    Exit;

  entity := lbContacts.Items[lbContacts.ItemIndex].DataObject as TTMSFNCCloudCloudKitEntity;
  entity.Strings[0] := edName.Text;
  entity.Strings[1] := edChildren.Text;
  entity.Strings[2] := edSalary.Text;

  CloudKit.Update(entity);
end;

class procedure TTMSFNCCloudCloudKitService.DoUpdateContactResult(
  Sender: TObject; const AEntity: TTMSFNCCloudDataStoreEntity;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  CloudKit.Query;
end;

class function TTMSFNCCloudCloudKitService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudCloudKit;
end;

class function TTMSFNCCloudCloudKitService.GetDescription: string;
begin
  Result := 'Store your app’s data in iCloud and keep everything up to date across apps and on the web.';
end;

class function TTMSFNCCloudCloudKitService.GetTitle: string;
begin
  Result := 'Apple CloudKit';
end;

class procedure TTMSFNCCloudCloudKitService.Clear;
begin
  SetClientID('');
  inherited;
end;

class function TTMSFNCCloudCloudKitService.CloudKit: TTMSFNCCloudCloudKit;
begin
  Result := Service as TTMSFNCCloudCloudKit;
end;

class procedure TTMSFNCCloudCloudKitService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  l: TLabel;
  ew: Integer;
  mi: TTMSFNCCloudDataStoreMetaDataItem;
begin
  inherited;

  ew := 250;

  CloudKit.Access := caPublic;
  CloudKit.Environment := ceDevelopment;
  CloudKit.Database := 'Test';
  {$IFDEF WEBLIB}
  CloudKit.Authentication.CallBackURL := 'http://localhost:8000/TMSWeb_FNCCloud/index.html';
  {$ENDIF}

  CloudKit.MetaData.Clear;

  mi := CloudKit.MetaData.Add;
  mi.PropertyName := 'Name';
  mi.DataType := ftString;

  mi := CloudKit.MetaData.Add;
  mi.PropertyName := 'Children';
  mi.DataType := ftInteger;

  mi := CloudKit.MetaData.Add;
  mi.PropertyName := 'Salary';
  mi.DataType := ftFloat;

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoQuery;
  SetControlPosition(b, 10, 10);
  SetButtonText(b, 'Get Contacts');
  ClearStyledSettings(b);

  lbContacts := TTMSFNCCloudDemoListBox.Create(AContent);
  lbContacts.Parent := AContent;
  lbContacts.ItemHeight := 20;
  SetControlAlignment(lbContacts, caClient);
  SetControlMargins(lbContacts, 10, 40, 10, 10);
  lbContacts.Height := AContent.Height - 50;
  lbContacts.Width := ew;
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
  SetLabelText(l, 'Orders');
  ClearStyledSettings(l);

  edChildren := TEdit.Create(ADetailContent);
  edChildren.Parent := ADetailContent;
  SetControlPosition(edChildren, 120, 70);
  edChildren.Width := ew;
  ClearStyledSettings(edChildren);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 100);
  SetLabelText(l, 'Sales');
  ClearStyledSettings(l);

  edSalary := TEdit.Create(ADetailContent);
  edSalary.Parent := ADetailContent;
  SetControlPosition(edSalary, 120, 100);
  edSalary.Width := ew;
  ClearStyledSettings(edSalary);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddContact;
  SetControlPosition(b, 20, 150);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateContact;
  SetControlPosition(b, 110, 150);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteContact;
  SetControlPosition(b, 200, 150);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  CloudKit.OnQuery := {$IFDEF LCLWEBLIB}@{$ENDIF}DoQueryResult;
  CloudKit.OnDelete := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteContactResult;
  CloudKit.OnUpdate := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateContactResult;
  CloudKit.OnInsert := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddContactResult;
end;

class function TTMSFNCCloudCloudKitService.NeedTokens: Boolean;
begin
  Result := True;
end;

class procedure TTMSFNCCloudCloudKitService.SetValues(AValues: string);
var
  s: TStringList;
begin
  inherited;
  s := TStringList.Create;
  try
    s.Delimiter := ';';
    s.Text := AValues;
    if s.Count > 0 then
      CloudKit.Project := s[0];
  finally
    s.Free;
  end;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudCloudKitService);
end;

end.
