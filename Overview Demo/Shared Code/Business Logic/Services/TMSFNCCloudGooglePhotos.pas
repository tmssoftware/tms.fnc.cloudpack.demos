unit TMSFNCCloudGooglePhotos;

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
  Classes, SysUtils, Generics.Collections, VCL.Forms, VCL.StdCtrls, VCL.ComCtrls, UITypes,VCL.TMSFNCCloudOAuth , VCL.TMSFNCCloudBase, VCL.TMSFNCUtils,
  CloudServices, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudGooglePhotos, VCL.TMSFNCCloudImage, VCL.Dialogs, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, IOUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCustomControl, FMX.TMSFNCCloudGooglePhotos, FMX.TMSFNCCloudImage,
  FMX.ListBox, FMX.Edit, FMX.DateTimeCtrls, FMX.Memo, FMX.Dialogs, FMX.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase, LCLTMSFNCCloudImage,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudGooglePhotos, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCCloudGooglePhotos,
  WEBLib.TMSFNCCloudImage, WEBLib.TMSFNCCloudDemoListBox, WEBLib.WebCtrls;
  {$ENDIF}

type
  TTMSFNCCloudGooglePhotosService = class(TTMSFNCCloudService)
  private
    class var tl: TTMSFNCCloudGooglePhotosAlbum;
    class var lbAlbums: TTMSFNCCloudDemoListBox;
    class var lbPhotos: TTMSFNCCloudDemoListBox;
    class var edAlbum: TEdit;
    class var edPhoto: TEdit;
    class var ciImage: TTMSFNCCloudImage;
    class var lblSummary: TLabel;
    class var lTitle: TLabel;
    {$IFDEF WEBLIB}
    class var WebFilePicker: TWebFilePicker;
    {$ENDIF}
  protected
    class procedure DoGetAlbumsResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePhotosAlbums; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetAlbums(Sender: TObject);

    class procedure DoAddAlbumResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePhotosAlbum; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoAddAlbum(Sender: TObject);

    class procedure DoGetPhotosResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePhotosPhotos; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetPhotos(Sender: TObject);

    class procedure DoAddPhotoResult(Sender: TObject; const AInfo: TTMSFNCCloudGooglePhotosPhoto; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoAddPhoto(Sender: TObject);
    {$IFDEF WEBLIB}
    class procedure DoFileLoaded(const AFile: TTMSFNCUtilsFile);
    {$ENDIF}

    class procedure DoDownloadPhoto(Sender: TObject);
    class procedure DoGetPhotoDetail(Sender: TObject);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function GooglePhotos: TTMSFNCCloudGooglePhotos;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGooglePhotosService }

class procedure TTMSFNCCloudGooglePhotosService.DoAddAlbum(Sender: TObject);
var
  al: TTMSFNCCloudGooglePhotosAlbum;
begin
  al := GooglePhotos.Albums.Add;
  al.Title := edAlbum.Text;
  GooglePhotos.CreateAlbum(al);
end;

class procedure TTMSFNCCloudGooglePhotosService.DoAddAlbumResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGooglePhotosAlbum;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  lbAlbums.InsertItem(0, AInfo.Title + '<br/>' + '# of photos: ' + IntToStr(AInfo.ItemsCount), '', AInfo);
end;

class procedure TTMSFNCCloudGooglePhotosService.DoAddPhoto(Sender: TObject);
var
  ta: TTMSFNCCloudGooglePhotosPhoto;
  {$IFNDEF WEBLIB}
  f: string;
  {$ENDIF}
begin
  if lbAlbums.ItemIndex < 0 then
    Exit;

  tl := lbAlbums.Items[lbAlbums.ItemIndex].DataObject as TTMSFNCCloudGooglePhotosAlbum;
  ta := tl.Photos.Add;
  ta.Summary := edPhoto.Text;

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
    GooglePhotos.UploadPhoto(tl, f, edPhoto.Text);
  {$IFDEF FMX}
  end
  );
  {$ENDIF}
  {$ELSE}
  if WebFilePicker.Files.Count > 0 then
    TTMSFNCUtils.LoadFile(WebFilePicker.Files[0].FileObject, @DoFileLoaded);
  {$ENDIF}
end;

{$IFDEF WEBLIB}
class procedure TTMSFNCCloudGooglePhotosService.DoFileLoaded(const AFile: TTMSFNCUtilsFile);
begin
  if Assigned(tl) then
    GooglePhotos.UploadPhoto(tl, AFile, edPhoto.Text);
end;
{$ENDIF}

class procedure TTMSFNCCloudGooglePhotosService.DoAddPhotoResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGooglePhotosPhoto;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbAlbums.ItemIndex < 0 then
    Exit;

  tl := nil;
  GooglePhotos.SearchPhotos(lbAlbums.Items[lbAlbums.ItemIndex].DataObject as TTMSFNCCloudGooglePhotosAlbum);
end;

class procedure TTMSFNCCloudGooglePhotosService.DoDownloadPhoto(
  Sender: TObject);
var
  ph: TTMSFNCCloudGooglePhotosPhoto;
  s: string;
begin
  if lbPhotos.ItemIndex < 0 then
    Exit;

  ph := lbPhotos.Items[lbPhotos.ItemIndex].DataObject as TTMSFNCCloudGooglePhotosPhoto;

  s := ph.FileName;
  {$IFNDEF WEBLIB}
  {$IFDEF FMX}
  TTMSFNCUtils.SaveFile(s, '',
  procedure(const AFile: string; const AResult: Boolean)
  begin
    if not AResult then
      Exit;

    s := AFile;
  {$ELSE}
  if TTMSFNCUtils.SaveFile(s) then
  {$ENDIF}
    GooglePhotos.DownloadPhoto(s, ph);
  {$IFDEF FMX}
  end
  );
  {$ENDIF}
  {$ELSE}
  GooglePhotos.DownloadPhoto(s, ph);
  {$ENDIF}
end;

class procedure TTMSFNCCloudGooglePhotosService.DoGetPhotoDetail(Sender: TObject);
var
  ta: TTMSFNCCloudGooglePhotosPhoto;
begin
  if lbPhotos.ItemIndex < 0 then
    Exit;

  ta := lbPhotos.Items[lbPhotos.ItemIndex].DataObject as TTMSFNCCloudGooglePhotosPhoto;
  SetLabelText(lblSummary, ta.Summary);
  ciImage.URL := ta.ImageURL;
end;

class procedure TTMSFNCCloudGooglePhotosService.DoGetAlbums(Sender: TObject);
begin
  StartLoading;
  SetLabelText(lTitle, 'Albums');
  GooglePhotos.GetAlbums;
end;

class procedure TTMSFNCCloudGooglePhotosService.DoGetAlbumsResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGooglePhotosAlbums;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  StopLoading;
  if Assigned(lbAlbums) then
  begin
    lbAlbums.Visible := True;
    lbPhotos.Visible := False;
    lbAlbums.Items.Clear;
    for I := 0 to AInfo.Count - 1 do
      lbAlbums.AddItem('<font size="12"><b>' + AInfo[I].Title + '</b></font>' + '<br/>' + '<font size="10"># of photos: ' + IntToStr(AInfo[I].ItemsCount) + '</font>', '', AInfo[I]);
  end;
end;

class procedure TTMSFNCCloudGooglePhotosService.DoGetPhotos(Sender: TObject);
begin
  if lbAlbums.ItemIndex < 0 then
    Exit;

  SetLabelText(lTitle, 'Photos');
  StartLoading;
  GooglePhotos.SearchPhotos(lbAlbums.Items[lbAlbums.ItemIndex].DataObject as TTMSFNCCloudGooglePhotosAlbum);
end;

class procedure TTMSFNCCloudGooglePhotosService.DoGetPhotosResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGooglePhotosPhotos;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  StopLoading;
  if Assigned(lbPhotos) then
  begin
    lbAlbums.Visible := False;
    lbPhotos.Visible := True;
    lbPhotos.Items.Clear;
    for I := 0 to AInfo.Count - 1 do
      lbPhotos.AddItem(AInfo[I].FileName + '<br/>' + DateTimeToStr(AInfo[I].Created) + ' ' + AInfo[I].Summary, '', AInfo[I]);
  end;
end;

class function TTMSFNCCloudGooglePhotosService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudGooglePhotos;
end;

class function TTMSFNCCloudGooglePhotosService.GetDescription: string;
begin
  Result := 'Google Photos is the home for all your photos and videos, automatically organized and easy to share.';
end;

class function TTMSFNCCloudGooglePhotosService.GetTitle: string;
begin
  Result := 'Google Photos';
end;

class function TTMSFNCCloudGooglePhotosService.GooglePhotos: TTMSFNCCloudGooglePhotos;
begin
  Result := Service as TTMSFNCCloudGooglePhotos;
end;

class procedure TTMSFNCCloudGooglePhotosService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  ew: Integer;
begin
  inherited;

  ew := 250;

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetAlbums;
  SetControlPosition(b, 10, 10);
  SetButtonText(b, 'Get Albums');
  ClearStyledSettings(b);

  lbAlbums := TTMSFNCCloudDemoListBox.Create(AContent);
  lbAlbums.Parent := AContent;
  lbAlbums.ItemHeight := 40;
  SetControlAlignment(lbALbums, caClient);
  SetControlMargins(lbAlbums, 10, 40, 10, 10);
  lbAlbums.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop];
  lbAlbums.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetPhotos;

  edAlbum := TEdit.Create(AContent);
  edAlbum.Parent := AContent;
  SetControlPosition(edAlbum, lbAlbums.Width + 20, 40);
  edAlbum.Text := 'New Album';
  edAlbum.Width := ew;
  ClearStyledSettings(edAlbum);

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.Name := 'btAddAlbum';
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddAlbum;
  SetControlPosition(b, lbAlbums.Width + 20, 70);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  lTitle := TLabel.Create(AContent);
  lTitle.Parent := AContent;
  SetControlPosition(lTitle, 130, 15);
  SetLabelText(lTitle, 'Albums');
  ClearStyledSettings(lTitle);

  lbPhotos := TTMSFNCCloudDemoListBox.Create(AContent);
  lbPhotos.Parent := AContent;
  lbPhotos.ItemHeight := 40;
  SetControlAlignment(lbPhotos, caClient);
  SetControlMargins(lbPhotos, 10, 40, 10, 10);
  lbPhotos.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];
  lbPhotos.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetPhotoDetail;

  edPhoto := TEdit.Create(ADetailContent);
  edPhoto.Parent := ADetailContent;
  SetControlPosition(edPhoto, 20, 330);
  edPhoto.Width := ew;
  edPhoto.Text := 'New Photo';
  ClearStyledSettings(edPhoto);

  lblSummary := TLabel.Create(ADetailContent);
  lblSummary.Parent := ADetailContent;
  SetControlPosition(lblSummary, 20, 300);
  SetLabelText(lblSummary, '');
  ClearStyledSettings(lblSummary);

  ciImage := TTMSFNCCloudImage.Create(ADetailContent);
  ciImage.Parent := ADetailContent;
  SetControlPosition(ciImage, 20, 40);
  ciImage.Height := ew;
  ciImage.Width := ew;

  {$IFDEF WEBLIB}
  WebFilePicker := TWebFilePicker.Create(ADetailContent);
  WebFilePicker.Parent := ADetailContent;
  SetControlPosition(WebFilePicker, 20, 400);
  {$ENDIF}

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddPhoto;
  SetControlPosition(b, 20, 370);
  SetButtonText(b, 'Upload');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDownloadPhoto;
  SetControlPosition(b, 120, 370);
  SetButtonText(b, 'Download');
  {$IFDEF WEBLIB}
  b.Visible := False;
  {$ENDIF}
  ClearStyledSettings(b);

  GooglePhotos.OnGetAlbums := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetAlbumsResult;
  GooglePhotos.OnCreateAlbum := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddAlbumResult;
  GooglePhotos.OnGetPhotos := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetPhotosResult;
  GooglePhotos.OnUploadPhoto := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddPhotoResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudGooglePhotosService);
end;

end.
