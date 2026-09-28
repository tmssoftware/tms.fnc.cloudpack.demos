unit TMSFNCCloudStorageBase;

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
  Classes, SysUtils, Generics.Collections, VCL.Forms, VCL.StdCtrls, VCL.ComCtrls, UITypes, VCL.TMSFNCCloudBase, VCL.TMSFNCCloudOAuth, VCL.TMSFNCUtils,
  CloudServices, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudStorage, VCL.Dialogs, SelectService, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, IOUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes, FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCustomControl, SelectService, FMX.TMSFNCCloudDemoListBox,
  FMX.ListBox, FMX.Edit, FMX.DateTimeCtrls, FMX.Memo, FMX.TMSFNCCloudStorage, FMX.Dialogs;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls, LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase, SelectService,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudStorage, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth, WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl, SelectService,
  WEBLib.TMSFNCCloudStorage, WEBLib.TMSFNCCloudDemoListBox, WEBLib.WebCtrls;
  {$ENDIF}

type
  TTMSFNCCloudStorageService = class(TTMSFNCCloudService)
  private
    class var CurrentFolder: TTMSFNCCloudItem;
    class var lbDrive: TTMSFNCCloudDemoListBox;
    class var edFolderName: TEdit;
    class var lFileSize: TLabel;
    class var lPath: TLabel;
    {$IFDEF WEBLIB}
    class var WebFilePicker: TWebFilePicker;
    {$ENDIF}
    class var p: TProgressBar;
  protected
    class procedure DoGetInfoResult(Sender: TObject; const AInfo: TTMSFNCCloudItems; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetInfo(Sender: TObject); virtual;
    class procedure DoGetFileDetail(Sender: TObject);
    class procedure DoDrillDown(Sender: TObject);

    class procedure DoCreateFolderResult(Sender: TObject; const AInfo: TTMSFNCCloudItem; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoCreateFolder(Sender: TObject);

    class procedure DoDeleteResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoDelete(Sender: TObject);

    class procedure DoUploadResult(Sender: TObject; const AInfo: TTMSFNCCloudItem; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoUpload(Sender: TObject);
    {$IFDEF WEBLIB}
    class procedure DoFileLoaded(const AFile: TTMSFNCUtilsFile);
    {$ENDIF}

    class procedure DoDownloadResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoDownload(Sender: TObject);

    class procedure DoRequestProgressResult(Sender: TObject;  const ARequestResult: TTMSFNCCloudBaseRequestResult; AProgress: Single; AUpload: Boolean);

    class procedure DoGetFiles(Sender: TObject);
    class procedure DoUp(Sender: TObject);

    class procedure FillListBox(AItems: TTMSFNCCloudItems; AAddFolders: Boolean; AAddFiles: Boolean);
    class procedure Refresh; virtual;
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function Storage: TTMSFNCCloudStorage;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
    class procedure UnInit; override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGoogleDriveService }

function GetLabelText(ALabel: TLabel): string;
begin
  {$IFDEF FMX}
  Result := ALabel.Text;
  {$ELSE}
  Result := ALabel.Caption;
  {$ENDIF}
end;

function LastIndexOf(const S: string; const Chr: Char): Integer;
var
  i: Integer;
begin
  result := 0;
  for i := length(S) downto 1 do
    if S[i] = Chr then
    begin
      result := i-1;
      break;
    end;
end;

class procedure TTMSFNCCloudStorageService.DoCreateFolder(Sender: TObject);
begin
  StartLoading;
  Storage.CreateFolder(CurrentFolder, edFolderName.Text);
  edFolderName.Text := '';
end;

class procedure TTMSFNCCloudStorageService.DoCreateFolderResult(
  Sender: TObject; const AInfo: TTMSFNCCloudItem;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  StartLoading;
  Refresh;
end;

class procedure TTMSFNCCloudStorageService.DoDelete(Sender: TObject);
var
  ci: TTMSFNCCloudItem;
begin
  if lbDrive.ItemIndex < 0 then
    Exit;

  ci := lbDrive.Items[lbDrive.ItemIndex].DataObject as TTMSFNCCloudItem;
  Storage.Delete(ci);
end;

class procedure TTMSFNCCloudStorageService.DoDeleteResult(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  StartLoading;
  Refresh;
end;

class procedure TTMSFNCCloudStorageService.DoDownload(Sender: TObject);
var
  it: TTMSFNCCloudItem;
  s: string;
begin
  if lbDrive.ItemIndex < 0 then
    Exit;

  it := lbDrive.Items[lbDrive.ItemIndex].DataObject as TTMSFNCCloudItem;
  s := it.FileName;
  {$IFNDEF WEBLIB}
  {$IFDEF FMX}
  {$IFNDEF IOS}
  TTMSFNCUtils.SaveFile(s, '',
  procedure(const AFile: string; const AResult: Boolean)
  begin
    if not AResult then
      Exit;

    s := AFile;
  {$ELSE}
    s := TTMSFNCUtils.GetDocumentsPath + PthDel + s;
  {$ENDIF}
  {$ELSE}
  if TTMSFNCUtils.SaveFile(s) then
  {$ENDIF}
    StartLoading;
    Storage.Download(it, s);
  {$IFDEF FMX}
  {$IFNDEF IOS}
  end
  );
  {$ENDIF}
  {$ENDIF}
  {$ELSE}
  StartLoading;
  Storage.Download(it, s);
  {$ENDIF}
end;

class procedure TTMSFNCCloudStorageService.DoDownloadResult(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
{$IFDEF FMX}
{$IFDEF IOS}
var
  f: string;
{$ENDIF}
{$ENDIF}
begin
  {$IFDEF FMX}
  {$IFDEF IOS}
  f := ARequestResult.ResultFile;
  TTMSFNCUtils.SaveFile(f);
  {$ENDIF}
  {$ENDIF}
  StopLoading;
end;

class procedure TTMSFNCCloudStorageService.DoDrillDown(Sender: TObject);
var
  ci: TTMSFNCCloudItem;
begin
  if lbDrive.ItemIndex < 0 then
    Exit;

  ci := lbDrive.Items[lbDrive.ItemIndex].DataObject as TTMSFNCCloudItem;

  if ci.ItemType = ciFolder then
  begin
    StartLoading;
    CurrentFolder := ci;
    SetLabelText(lPath, GetLabelText(lPath) + '\' + ci.FileName);
    Storage.GetFolderListHierarchical(CurrentFolder);
  end;
end;

class procedure TTMSFNCCloudStorageService.DoGetFileDetail(Sender: TObject);
var
  it: TTMSFNCCloudItem;
begin
  if (lbDrive.ItemIndex < 0) or (lbDrive.ItemIndex >= lbDrive.Items.Count) then
    Exit;

  it := lbDrive.Items[lbDrive.ItemIndex].DataObject as TTMSFNCCloudItem;
  SetLabelText(lFileSize, 'Size: ' + IntToStr(Round(it.Size / 1024)) + ' KB TimeStamp: ' + DateTimeToStr(it.CreationDate));
end;

class procedure TTMSFNCCloudStorageService.DoGetFiles(Sender: TObject);
begin
  StartLoading;

  if Assigned(CurrentFolder) then
    Storage.GetFolderListHierarchical(CurrentFolder)
  else
    Storage.GetFolderList;
end;

class procedure TTMSFNCCloudStorageService.DoGetInfo(Sender: TObject);
begin
  StartLoading;
  SetLabelText(lPath, 'root');
  CurrentFolder := nil;
  Storage.GetFolderList;
end;

class procedure TTMSFNCCloudStorageService.DoGetInfoResult(Sender: TObject;
  const AInfo: TTMSFNCCloudItems;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  StopLoading;
  if Assigned(lbDrive) then
  begin
    lbDrive.BeginUpdate;
    lbDrive.Items.Clear;

    if Assigned(CurrentFolder) then
    begin
      FillListBox(CurrentFolder.Folder, True, False);
      FillListBox(CurrentFolder.Folder, False, True);
    end
    else
    begin
      FillListBox(AInfo, True, False);
      FillListBox(AInfo, False, True);
    end;
    lbDrive.EndUpdate;
  end;
end;

class procedure TTMSFNCCloudStorageService.DoRequestProgressResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AProgress: Single; AUpload: Boolean);
begin
  if Assigned(p) then
  begin
    {$IFDEF FMX}
    p.Value := AProgress;
    {$ELSE}
    p.Position := Round(AProgress);
    {$ENDIF}
  end;
end;

class procedure TTMSFNCCloudStorageService.DoUp(Sender: TObject);
begin
  StartLoading;

  if Assigned(CurrentFolder) and Assigned(CurrentFolder.ParentFolder) then
  begin
    CurrentFolder := CurrentFolder.ParentFolder;
    SetLabelText(lPath, Copy(GetLabelText(lPath), 0, LastIndexOf(GetLabelText(lPath), '\')));
    if GetLabelText(lPath) = '' then
      SetLabelText(lPath, 'root');
    Storage.GetFolderListHierarchical(CurrentFolder);
  end
  else
  begin
    CurrentFolder := nil;
    SetlabelText(lPath, 'root');
    Storage.GetFolderList;
  end;
end;

{$IFDEF WEBLIB}
class procedure TTMSFNCCloudStorageService.DoFileLoaded(const AFile: TTMSFNCUtilsFile);
begin
  Storage.Upload(CurrentFolder, AFile);
end;
{$ENDIF}

class procedure TTMSFNCCloudStorageService.DoUpload(Sender: TObject);
{$IFNDEF WEBLIB}
var
  f: string;
{$ENDIF}
begin
  StartLoading;
  {$IFNDEF WEBLIB}
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
    Storage.Upload(CurrentFolder, f);
  {$IFDEF FMX}
  end
  );
  {$ENDIF}
  {$ELSE}
  if WebFilePicker.Files.Count > 0 then
    TTMSFNCUtils.LoadFile(WebFilePicker.Files[0].FileObject, @DoFileLoaded);
  {$ENDIF}
end;

class procedure TTMSFNCCloudStorageService.DoUploadResult(Sender: TObject;
  const AInfo: TTMSFNCCloudItem;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  StartLoading;
  Refresh;
end;

class procedure TTMSFNCCloudStorageService.FillListBox(AItems: TTMSFNCCloudItems; AAddFolders,
  AAddFiles: Boolean);
var
  I: Integer;
  ftype: string;
  ci: TTMSFNCCloudItem;
begin
  if not Assigned(AItems) then
    Exit;

  lbDrive.BeginUpdate;
  for I := 0 to AItems.Count - 1 do
  begin
    ci := AItems.Items[I];
    ftype := LowerCase(StringReplace(ExtractFileExt(ci.FileName), '.', '', [rfReplaceAll]));
    if AItems.Items[I].ItemType = ciFolder then
      ftype := 'folder'
    else if ftype = '' then
      ftype := 'file';

    if not lbDrive.SupportsFileType(ftype) then
      ftype := 'file';

    if ((ci.ItemType = ciFolder) and AAddFolders) or ((ci.ItemType = ciFile) and AAddFiles) then
      lbDrive.AddItem(AItems.Items[I].Filename, ftype, ci);
  end;
  lbDrive.EndUpdate;
end;

class function TTMSFNCCloudStorageService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudStorage;
end;

class function TTMSFNCCloudStorageService.GetDescription: string;
begin
  Result := 'File Sotrage base class';
end;

class function TTMSFNCCloudStorageService.GetTitle: string;
begin
  Result := 'File Storage';
end;

class function TTMSFNCCloudStorageService.Storage: TTMSFNCCloudStorage;
begin
  Result := Service as TTMSFNCCloudStorage;
end;

class procedure TTMSFNCCloudStorageService.UnInit;
begin
  inherited;
  p := nil;
end;

class procedure TTMSFNCCloudStorageService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  ew: Integer;
  l: TLabel;
begin
  inherited;

  CurrentFolder := nil;
  ew := 250;

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetInfo;
  SetButtonText(b, 'Get Root');
  ClearStyledSettings(b);
  SetControlPosition(b, 10, 10);

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetFiles;
  SetButtonText(b, 'Refresh');
  ClearStyledSettings(b);
  SetControlPosition(b, 120, 10);

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUp;
  SetButtonText(b, 'Up');
  ClearStyledSettings(b);
  SetControlPosition(b, 10, 40);

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDrillDown;
  SetButtonText(b, 'Open');
  ClearStyledSettings(b);
  SetControlPosition(b, 120, 40);

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetLabelText(l, 'Path:');
  ClearStyledSettings(l);
  SetControlPosition(l, 10, 70);

  lPath := TLabel.Create(AContent);
  lPath.Parent := AContent;
  lPath.Width := ew - 40;
  SetLabelText(lPath, 'root');
  ClearStyledSettings(lPath);
  SetControlPosition(lPath, 50, 70);

  lbDrive := TTMSFNCCloudDemoListBox.Create(AContent);
  lbDrive.Parent := AContent;
  SetControlMargins(lbDrive, 10, 100, 10, 10);
  SetControlAlignment(lbDrive, caClient);
  lbDrive.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];
  lbDrive.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetFileDetail;
  lbDrive.OnDblClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDrillDown;

  lFileSize := TLabel.Create(ADetailContent);
  lFileSize.Parent := ADetailContent;
  SetLabelText(lFileSize, 'Details');
  lFileSize.Width := ew;
  ClearStyledSettings(lFileSize);
  SetControlPosition(lFileSize, 20, 100);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetLabelText(l, 'Folder Name:');
  ClearStyledSettings(l);
  SetControlPosition(l, 20, 130);

  edFolderName := TEdit.Create(ADetailContent);
  edFolderName.Parent := ADetailContent;
  ClearStyledSettings(edFolderName);
  SetControlPosition(edFolderName, 120, 130);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoCreateFolder;
  ClearStyledSettings(b);
  SetButtonText(b, 'Create Folder');
  SetControlPosition(b, 20, 160);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  SetButtonText(b, 'Delete');
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDelete;
  ClearStyledSettings(b);
  SetControlPosition(b, 20, 190);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  SetButtonText(b, 'Upload');
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpload;
  ClearStyledSettings(b);
  SetControlPosition(b, 20, 220);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  SetButtonText(b, 'Download');
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDownload;
  ClearStyledSettings(b);
  SetControlPosition(b, 20, 250);

  p := TProgressbar.Create(ADetailContent);
  p.Parent := ADetailContent;
  p.Min := 0;
  p.Max := 100;
  SetControlPosition(p, 20, 280);

  {$IFDEF WEBLIB}
  WebFilePicker := TWebFilePicker.Create(ADetailContent);
  WebFilePicker.Parent := ADetailContent;
  SetControlPosition(WebFilePicker, 20, 280);
  {$ENDIF}
end;

class procedure TTMSFNCCloudStorageService.Refresh;
begin
  if Storage.Drive.Count = 0 then
    DoGetInfo(nil);

  if Assigned(CurrentFolder) then
    Storage.GetFolderListHierarchical(CurrentFolder)
  else
    Storage.GetFolderList;
end;

initialization

end.
