unit TMSFNCCloudGoogleFireBase;

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
  Classes, SysUtils, Generics.Collections, VCL.Forms, VCL.StdCtrls, VCL.ComCtrls, UITypes, VCL.TMSFNCCloudOAuth , VCL.TMSFNCCloudBase,
  CloudServices, VCL.TMSFNCCloudGoogleFireBase, VCL.TMSFNCCloudGoogleFireBaseObject, VCL.TMSFNCCustomControl,
  VCL.TMSFNCBitmapContainer, VCL.TMSFNCUtils, DateUtils, Graphics, VCL.TMSFNCTypes, VCL.TMSFNCCloudDemoListBox,
  VCL.TMSFNCCloudImage;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes, FMX.TMSFNCCloudOAuth, FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudGoogleFireBase, FMX.TMSFNCCloudGoogleFireBaseObject,
  FMX.TMSFNCCustomControl, FMX.ListBox, FMX.Graphics, FMX.Edit, FMX.DateTimeCtrls,
  FMX.TMSFNCBitmapContainer, FMX.TMSFNCTypes, FMX.TMSFNCCloudDemoListBox, FMX.TMSFNCCloudImage;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls, LCLTMSFNCCloudOAuth, LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudGoogleFireBase, LCLTMSFNCCloudGoogleFireBaseObject,
  LCLTMSFNCCustomControl, LCLTMSFNCBitmapContainer, LCLTMSFNCCloudDemoListBox, LCLTMSFNCTypes,
  LCLTMSFNCCloudImage, DateTimePicker;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCloudOAuth, WEBLib.TMSFNCCloudGoogleFireBase, WEBLib.TMSFNCCloudGoogleFireBaseObject,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCBitmapContainer, WEBLib.TMSFNCCloudDemoListBox, WEBLib.TMSFNCTypes,
  WEBLib.TMSFNCCloudImage;
  {$ENDIF}

type

  TTMSFNCCloudGoogleFireBaseContactGender = (gMale, gFemale, gUndefined);

  TTMSFNCCloudGoogleFireBasePicture = class(TPersistent)
  private
    FP: TTMSFNCBitmap;
    function GetDataString: string;
    procedure SetDataString(const Value: string);
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create;
    destructor Destroy; override;
  published
    property DataString: string read GetDataString write SetDataString;
  end;

  TTMSFNCCloudGoogleFireBaseContact = class(TTMSFNCCloudGoogleFireBaseObject)
  private
    FName: string;
    FPicture: TTMSFNCCloudGoogleFireBasePicture;
    FBirthDate: TDateTime;
    FEmail: string;
    FSex: TTMSFNCCloudGoogleFireBaseContactGender;
    FFriend: boolean;
    procedure SetPicture(const Value: TTMSFNCCloudGoogleFireBasePicture);
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Name: string read FName write FName;
    property Email: string read FEmail write FEmail;
    property Sex: TTMSFNCCloudGoogleFireBaseContactGender read FSex write FSex;
    property BirthDate: TDateTime read FBirthDate write FBirthDate;
    property Picture: TTMSFNCCloudGoogleFireBasePicture read FPicture write SetPicture;
    property Friend: boolean read FFriend write FFriend;
  end;

  TTMSFNCCloudGoogleFireBaseService = class(TTMSFNCCloudService)
  private
    class var lst: TTMSFNCCloudGoogleFireBaseObjectList;
    class var TMSFNCBitmapContainer: TTMSFNCBitmapContainer;
    class var lbList: TTMSFNCCloudDemoListBox;
    class var edName: TEdit;
    class var edEmail: TEdit;
    class var edDatabaseName: TEdit;
    class var edTableName: TEdit;
    {$IFDEF FMX}
    class var deBirthDay: TDateEdit;
    {$ENDIF}
    {$IFNDEF FMX}
    class var deBirthDay: TDateTimePicker;
    {$ENDIF}
    class var imcProfile: TTMSFNCCloudImage;
    class var cbIsFriend: TCheckBox;
    class var rdMale: TRadioButton;
    class var rdFemale: TRadioButton;
  protected
    class procedure DoReadDataResult(Sender: TObject; const AList: TTMSFNCCloudGoogleFireBaseObjectList; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoReadData(Sender: TObject);

    class procedure DoAddDataResult(Sender: TObject; const AInsertDataParams: TTMSFNCCloudGoogleFireBaseInsertData;
      const AResultData: string; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoAddData(Sender: TObject);

    class procedure DoDeleteDataResult(Sender: TObject; const AID: string; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoDeleteData(Sender: TObject);

    class procedure DoUpdateDataResult(Sender: TObject; const AUpdateDataParams: TTMSFNCCloudGoogleFireBaseUpdateData;
      const AResultData: string; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoUpdateData(Sender: TObject);

    class procedure DoGetDetail(Sender: TObject);
    class procedure GetObjects;
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function GoogleFireBase: TTMSFNCCloudGoogleFireBaseObjectDataBase;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGoogleFireBaseService }

class procedure TTMSFNCCloudGoogleFireBaseService.DoReadData(Sender: TObject);
begin
  GoogleFireBase.DatabaseName := edDatabaseName.Text;
  GoogleFireBase.TableName := edTableName.Text;
  GetObjects;
end;

class procedure TTMSFNCCloudGoogleFireBaseService.DoAddData(Sender: TObject);
var
  bc: TTMSFNCCloudGoogleFireBaseContact;
const
FirstNames: array[0 .. 19] of string = ('John', 'Sarah', 'Fred', 'Beth',
 'Eric', 'Tina', 'Thomas', 'Judy', 'Robert', 'Angela', 'Tim', 'Traci',
 'David', 'Paula', 'Bruce', 'Jessica', 'Richard', 'Carla', 'James',
 'Mary');
 LastNames: array[0 .. 11] of string = ('Parker', 'Johnson', 'Jones',
 'Thompson', 'Smith', 'Baker', 'Wallace', 'Harper', 'Parson', 'Edwards',
 'Mandel', 'Stone');
begin
  bc := TTMSFNCCloudGoogleFireBaseContact.Create;
  bc.Name := FirstNames[Random(20)] + ' ' + LastNames[Random(12)];
  bc.Email := LowerCase(StringReplace(bc.Name, ' ', '', [rfReplaceAll])) + '@email.com';
  bc.Sex := TTMSFNCCloudGoogleFireBaseContactGender(Random(3));
  bc.BirthDate := EncodeDate(1950, 1, 1) + Random(10000);
  bc.Picture.FP.Assign(TMSFNCBitmapContainer.RandomBitmap);
  bc.Friend := True;

  GoogleFireBase.InsertObject(bc);
  bc.Free;
end;

class procedure TTMSFNCCloudGoogleFireBaseService.DoAddDataResult(
  Sender: TObject;
  const AInsertDataParams: TTMSFNCCloudGoogleFireBaseInsertData;
  const AResultData: string;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  GetObjects;
end;

class procedure TTMSFNCCloudGoogleFireBaseService.DoDeleteData(Sender: TObject);
begin
  if lbList.ItemIndex > -1 then
    GoogleFireBase.DeleteObject(TTMSFNCCloudGoogleFireBaseObject(lbList.Items[lbList.ItemIndex].DataObject));
end;

class procedure TTMSFNCCloudGoogleFireBaseService.DoDeleteDataResult(
  Sender: TObject; const AID: string;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  GetObjects;
end;

class procedure TTMSFNCCloudGoogleFireBaseService.DoGetDetail(Sender: TObject);
var
  c: TTMSFNCCloudGoogleFireBaseContact;
begin
  if lbList.ItemIndex < 0 then
    Exit;

  c := TTMSFNCCloudGoogleFireBaseContact(lbList.Items[lbList.ItemIndex].DataObject);
  imcProfile.Bitmap.Assign(c.Picture.FP);
  edName.Text := c.Name;
  edEmail.Text := c.Email;
  deBirthDay.Date := c.BirthDate;
  {$IFDEF FMX}
  cbIsFriend.IsChecked := c.Friend;
  rdMale.IsChecked := c.Sex = gMale;
  rdFemale.IsChecked := c.Sex = gFemale;
  {$ENDIF}
  {$IFNDEF FMX}
  rdMale.Checked := c.Sex = gMale;
  rdFemale.Checked := c.Sex = gFemale;
  cbIsFriend.Checked := c.Friend;
  {$ENDIF}
end;

class procedure TTMSFNCCloudGoogleFireBaseService.DoReadDataResult(Sender: TObject; const AList: TTMSFNCCloudGoogleFireBaseObjectList;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  b: TTMSFNCCloudGoogleFireBaseObject;
  c: TTMSFNCCloudGoogleFireBaseContact;
  I: Integer;
begin
  StopLoading;
  lbList.Items.Clear;
  for I := 0 to AList.Count - 1 do
  begin
    b := AList[I];
    if b is TTMSFNCCloudGoogleFireBaseContact then
    begin
      c := TTMSFNCCloudGoogleFireBaseContact(b);
      lbList.AddItem(c.Name, '', c);
    end;
  end;
end;

class procedure TTMSFNCCloudGoogleFireBaseService.DoUpdateData(Sender: TObject);
var
  bc: TTMSFNCCloudGoogleFireBaseContact;
begin
  if lbList.ItemIndex > -1 then
  begin
    bc := TTMSFNCCloudGoogleFireBaseContact(lbList.Items[lbList.ItemIndex].DataObject);
    bc.Name := edName.Text;
    bc.Email := edEmail.Text;
    bc.BirthDate := deBirthDay.Date;
    {$IFDEF FMX}
    bc.Friend := cbIsFriend.IsChecked;
    {$ENDIF}
    {$IFNDEF FMX}
    bc.Friend := cbIsFriend.Checked;
    {$ENDIF}

    {$IFDEF FMX}
    if rdMale.IsChecked then
    {$ENDIF}
    {$IFNDEF FMX}
    if rdMale.Checked then
    {$ENDIF}
      bc.Sex := gMale
    else
      bc.Sex := gFemale;

    GoogleFireBase.WriteObject(bc);
  end;
end;

class procedure TTMSFNCCloudGoogleFireBaseService.DoUpdateDataResult(
  Sender: TObject;
  const AUpdateDataParams: TTMSFNCCloudGoogleFireBaseUpdateData;
  const AResultData: string;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  GetObjects;
end;

class function TTMSFNCCloudGoogleFireBaseService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudGoogleFireBaseObjectDataBase;
end;

class function TTMSFNCCloudGoogleFireBaseService.GetDescription: string;
begin
  Result := 'Firebase is Google''s mobile platform that helps you quickly develop high-quality apps and grow your business.';
end;

class procedure TTMSFNCCloudGoogleFireBaseService.GetObjects;
begin
  StartLoading;
  lst.Clear;
  GoogleFireBase.ReadList(lst);
end;

class function TTMSFNCCloudGoogleFireBaseService.GetTitle: string;
begin
  Result := 'Google Firebase';
end;

class function TTMSFNCCloudGoogleFireBaseService.GoogleFireBase: TTMSFNCCloudGoogleFireBaseObjectDataBase;
begin
  Result := Service as TTMSFNCCloudGoogleFireBaseObjectDataBase;
end;

class procedure TTMSFNCCloudGoogleFireBaseService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  l: TLabel;
  ew: Integer;
begin
  inherited;
  ew := 250;

  RegisterClass(TTMSFNCCloudGoogleFireBaseContact);
  lst := TTMSFNCCloudGoogleFireBaseObjectList.Create;
  TMSFNCBitmapContainer := TTMSFNCBitmapContainer.Create;

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 10, 10);
  SetLabelText(l, 'Database:');
  ClearStyledSettings(l);

  edDatabaseName := TEdit.Create(AContent);
  edDatabaseName.Parent := AContent;
  SetControlPosition(edDatabaseName, 110, 10);
  edDatabaseName.Text := 'data-ce981';
  edDatabaseName.Width := 150;
  ClearStyledSettings(edDatabaseName);

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 10, 40);
  SetLabelText(l, 'Table:');
  ClearStyledSettings(l);

  edTableName := TEdit.Create(AContent);
  edTableName.Parent := AContent;
  SetControlPosition(edTableName, 110, 40);
  edTableName.Text := 'Sample Customers';
  edTableName.Width := 150;
  ClearStyledSettings(edTableName);

  b := TButton.Create(AContent);
  b.Parent := AContent;
  SetControlPosition(b, 10, 70);
  SetButtonText(b, 'Get List');
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoReadData;
  ClearStyledSettings(b);

  lbList := TTMSFNCCloudDemoListBox.Create(AContent);
  lbList.Parent := AContent;
  SetControlMargins(lbList, 10, 100, 10, 10);
  SetControlAlignment(lbList, caClient);
  lbList.Width := ew;
  lbList.Height := AContent.Height - 90;
  lbList.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetDetail;

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 70);
  SetLabelText(l, 'Details');
  ClearStyledSettings(l);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 100);
  SetLabelText(l, 'Name:');
  ClearStyledSettings(l);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 130);
  SetLabelText(l, 'Email:');
  ClearStyledSettings(l);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 160);
  SetLabelText(l, 'Birthday:');
  ClearStyledSettings(l);

  edName := TEdit.Create(ADetailContent);
  edName.Parent := ADetailContent;
  SetControlPosition(edName, 120, 100);
  edName.Width := ew;
  ClearStyledSettings(edName);

  edEmail := TEdit.Create(ADetailContent);
  edEmail.Parent := ADetailContent;
  SetControlPosition(edEmail, 120, 130);
  edEmail.Width := ew;
  ClearStyledSettings(edEmail);

  {$IFDEF FMX}
  deBirthDay := TDateEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFNDEF FMX}
  deBirthDay := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  deBirthDay.Parent := ADetailContent;
  deBirthDay.Width := ew;
  SetControlPosition(deBirthDay, 120, 160);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 190);
  SetLabelText(l, 'Friend');
  ClearStyledSettings(l);

  cbIsFriend := TCheckBox.Create(ADetailContent);
  cbIsFriend.Parent := ADetailContent;
  SetControlPosition(cbIsFriend, 120, 190);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 220);
  SetLabelText(l, 'Gender');
  ClearStyledSettings(l);

  rdFemale := TRadioButton.Create(ADetailContent);
  rdFemale.Parent := ADetailContent;
  SetControlPosition(rdFemale, 120, 220);
  {$IFDEF FMX}
  rdFemale.Text := 'Female';
  rdFemale.GroupName := 'Gender';
  {$ENDIF}
  {$IFNDEF FMX}
  rdFemale.Caption := 'Female';
  {$ENDIF}

  rdMale := TRadioButton.Create(ADetailContent);
  rdMale.Parent := ADetailContent;
  SetControlPosition(rdMale, 220, 220);
  {$IFDEF FMX}
  rdMale.Text := 'Male';
  rdMale.GroupName := 'Gender';
  {$ENDIF}
  {$IFNDEF FMX}
  rdMale.Caption := 'Male';
  {$ENDIF}

  imcProfile := TTMSFNCCloudImage.Create(ADetailContent);
  imcProfile.Parent := ADetailContent;
  SetControlPosition(imcProfile, 20, 280);
  {$IFDEF WEBLIB}
  imcProfile.Visible := False;
  {$ENDIF}

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddData;
  SetControlPosition(b, 20, 250);
  SetButtonText(b, 'Add Random');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateData;
  SetControlPosition(b, 130, 250);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteData;
  SetControlPosition(b, 240, 250);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  GoogleFireBase.OnReadDataList := {$IFDEF LCLWEBLIB}@{$ENDIF}DoReadDataResult;
  GoogleFireBase.OnInsertData := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddDataResult;
  GoogleFireBase.OnDeleteData := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteDataResult;
  GoogleFireBase.OnUpdateData := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateDataResult;
end;

{ TTMSFNCCloudGoogleFireBasePicture }

procedure TTMSFNCCloudGoogleFireBasePicture.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleFireBasePicture) then
    FP.Assign((Source as TTMSFNCCloudGoogleFireBasePicture).FP)
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleFireBasePicture.Create;
begin
  FP := TTMSFNCBitmap.Create;
end;

destructor TTMSFNCCloudGoogleFireBasePicture.Destroy;
begin
  FP.Free;
  inherited;
end;

function TTMSFNCCloudGoogleFireBasePicture.GetDataString: string;
begin
  Result := TTMSFNCUtils.EscapeString(TTMSFNCUtils.SaveBitmapToHexStr(FP));
end;

procedure TTMSFNCCloudGoogleFireBasePicture.SetDataString(const Value: string);
begin
  if Assigned(FP) then
    FP.Free;

  FP := TTMSFNCUtils.CreateBitmapFromHexStr(TTMSFNCUtils.UnescapeString(Value));
end;

{ TTMSFNCCloudGoogleFireBaseCustomer }

constructor TTMSFNCCloudGoogleFireBaseContact.Create;
begin
  inherited;
  FPicture := TTMSFNCCloudGoogleFireBasePicture.Create;
end;

destructor TTMSFNCCloudGoogleFireBaseContact.Destroy;
begin
  FPicture.Free;
  inherited;
end;

procedure TTMSFNCCloudGoogleFireBaseContact.SetPicture(const Value: TTMSFNCCloudGoogleFireBasePicture);
begin
  FPicture.Assign(Value);
end;

initialization
begin
   TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudGoogleFireBaseService);
end;

end.
