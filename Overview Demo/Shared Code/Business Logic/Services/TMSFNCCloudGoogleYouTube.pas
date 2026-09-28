unit TMSFNCCloudGoogleYouTube;

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
  CloudServices, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudGoogleYouTube, VCL.Dialogs,
  VCL.TMSFNCCloudImage, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, IOUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCustomControl, FMX.TMSFNCCloudGoogleYouTube,
  FMX.ListBox, FMX.Edit, FMX.DateTimeCtrls, FMX.Memo, FMX.TMSFNCCloudImage, FMX.Dialogs, FMX.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase, DateTimePicker,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudGoogleYouTube, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCloudGoogleYouTube, WEBLib.TMSFNCCloudImage, WEBLib.TMSFNCCloudDemoListBox, WEBLib.WebCtrls;
  {$ENDIF}

type
  TTMSFNCCloudGoogleYouTubeService = class(TTMSFNCCloudService)
  private
    class var lbVideos: TTMSFNCCloudDemoListBox;
    class var edTitle: TEdit;
    class var ciImage: TTMSFNCCloudImage;
    {$IFDEF WEBLIB}
    class var WebFilePicker: TWebFilePicker;
    {$ENDIF}
  protected
    class procedure DoGetVideosResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetVideos(Sender: TObject);

    class procedure DoAddVideoResult(Sender: TObject; const AInfo: TTMSFNCCloudGoogleYouTubeVideo; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoAddVideo(Sender: TObject);
    {$IFDEF WEBLIB}
    class procedure DoFileLoaded(const AFile: TTMSFNCUtilsFile);
    {$ENDIF}

    class procedure DoDeleteVideoResult(Sender: TObject; const AInfo: TTMSFNCCloudGoogleYouTubeVideo; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoDeleteVideo(Sender: TObject);

    class procedure DoUpdateVideoResult(Sender: TObject; const AInfo: TTMSFNCCloudGoogleYouTubeVideo; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoUpdateVideo(Sender: TObject);

    class procedure DoGetVideoDetail(Sender: TObject);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function GoogleYouTube: TTMSFNCCloudGoogleYouTube;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGoogleYouTubeService }

{$IFDEF WEBLIB}
class procedure TTMSFNCCloudGoogleYouTubeService.DoFileLoaded(const AFile: TTMSFNCUtilsFile);
begin
  GoogleYouTube.UploadVideo(AFile, edTitle.Text, '');
end;
{$ENDIF}

class procedure TTMSFNCCloudGoogleYouTubeService.DoAddVideo(Sender: TObject);
{$IFNDEF WEBLIB}
var
  f: string;
{$ENDIF}
begin
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
    GoogleYouTube.UploadVideo(f, edTitle.Text, '');
  {$IFDEF FMX}
  end
  );
  {$ENDIF}
  {$ELSE}
  if WebFilePicker.Files.Count > 0 then
    TTMSFNCUtils.LoadFile(WebFilePicker.Files[0].FileObject, @DoFileLoaded);
  {$ENDIF}
end;

class procedure TTMSFNCCloudGoogleYouTubeService.DoAddVideoResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGoogleYouTubeVideo;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  lbVideos.InsertItem(0, AInfo.Title + sRequestLineBreak + DateTimeToStr(AInfo.PublishDate), '', AInfo);
end;

class procedure TTMSFNCCloudGoogleYouTubeService.DoDeleteVideo(Sender: TObject);
begin
  if lbVideos.ItemIndex < 0 then
    Exit;

  GoogleYouTube.DeleteVideo(lbVideos.Items[lbVideos.ItemIndex].DataObject as TTMSFNCCloudGoogleYouTubeVideo);
end;

class procedure TTMSFNCCloudGoogleYouTubeService.DoDeleteVideoResult(
  Sender: TObject; const AInfo: TTMSFNCCloudGoogleYouTubeVideo; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbVideos.ItemIndex < 0 then
    Exit;

  lbVideos.Items.Delete(lbVideos.ItemIndex);
end;

class procedure TTMSFNCCloudGoogleYouTubeService.DoGetVideoDetail(
  Sender: TObject);
var
  v: TTMSFNCCloudGoogleYouTubeVideo;
begin
  if lbVideos.ItemIndex < 0 then
    Exit;

  v := (lbVideos.Items[lbVideos.ItemIndex].DataObject as TTMSFNCCloudGoogleYouTubeVideo);
  edTitle.Text := v.Title;
  ciImage.URL := v.ImageURL;
end;

class procedure TTMSFNCCloudGoogleYouTubeService.DoGetVideos(Sender: TObject);
begin
  GoogleYouTube.GetAllVideos;
end;

class procedure TTMSFNCCloudGoogleYouTubeService.DoGetVideosResult(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  if Assigned(lbVideos) then
  begin
    lbVideos.Items.Clear;
    for I := 0 to GoogleYouTube.Videos.Count - 1 do
      lbVideos.AddItem(GoogleYouTube.Videos[I].Title + '<br>' + DateTimeToStr(GoogleYouTube.Videos[I].PublishDate), '', GoogleYouTube.Videos[I]);
  end;
end;

class procedure TTMSFNCCloudGoogleYouTubeService.DoUpdateVideo(Sender: TObject);
var
  v: TTMSFNCCloudGoogleYouTubeVideo;
begin
  if lbVideos.ItemIndex < 0 then
    Exit;

  v := lbVideos.Items[lbVideos.ItemIndex].DataObject as TTMSFNCCloudGoogleYouTubeVideo;
  v.Title := edTitle.Text;
  v.CategoryID := 1;

  GoogleYouTube.UpdateVideo(v);
end;

class procedure TTMSFNCCloudGoogleYouTubeService.DoUpdateVideoResult(
  Sender: TObject; const AInfo: TTMSFNCCloudGoogleYouTubeVideo;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbVideos.ItemIndex < 0 then
    Exit;

  lbVideos.Items[lbVideos.ItemIndex].Text := AInfo.Title + sRequestLineBreak + DateTimeToStr(AInfo.PublishDate);
end;


class function TTMSFNCCloudGoogleYouTubeService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudGoogleYouTube;
end;

class function TTMSFNCCloudGoogleYouTubeService.GetDescription: string;
begin
  Result := 'Manage and upload YouTube videos.';
end;

class function TTMSFNCCloudGoogleYouTubeService.GetTitle: string;
begin
  Result := 'Google YouTube';
end;

class function TTMSFNCCloudGoogleYouTubeService.GoogleYouTube: TTMSFNCCloudGoogleYouTube;
begin
  Result := Service as TTMSFNCCloudGoogleYouTube;
end;

class procedure TTMSFNCCloudGoogleYouTubeService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  ew: Integer;
  l: TLabel;
begin
  inherited;

  ew := 250;

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetVideos;
  SetControlPosition(b, 10, 10);
  SetButtonText(b, 'Get Videos');
  ClearStyledSettings(b);

  lbVideos := TTMSFNCCloudDemoListBox.Create(AContent);
  lbVideos.Parent := AContent;
  lbVideos.ItemHeight := 40;
  SetControlAlignment(lbVideos, caClient);
  SetControlMargins(lbVideos, 10, 40, 10, 10);
  lbVideos.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop];
  lbVideos.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetVideoDetail;

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetLabelText(l, 'Title');
  SetControlPosition(l, 20, 20);
  ClearStyledSettings(l);

  edTitle := TEdit.Create(ADetailContent);
  edTitle.Parent := ADetailContent;
  SetControlPosition(edTitle, 20, 40);
  edTitle.Text := 'New Video';
  edTitle.Width := ew;
  ClearStyledSettings(edTitle);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.Name := 'btAddList';
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddVideo;
  SetControlPosition(b, 20, 70);
  SetButtonText(b, 'Upload');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateVideo;
  SetControlPosition(b, 130, 70);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteVideo;
  SetControlPosition(b, 240, 70);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  ciImage := TTMSFNCCloudImage.Create(ADetailContent);
  ciImage.Parent := ADetailContent;
  SetControlPosition(ciImage, 20, 100);
  ciImage.Height := 150;
  ciImage.Width := 150;

  {$IFDEF WEBLIB}
  WebFilePicker := TWebFilePicker.Create(ADetailContent);
  WebFilePicker.Parent := ADetailContent;
  SetControlPosition(WebFilePicker, 20, 280);
  {$ENDIF}

  GoogleYouTube.OnGetVideos := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetVideosResult;
  GoogleYouTube.OnUploadVideo := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddVideoResult;
  GoogleYouTube.OnDeleteVideo := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteVideoResult;
  GoogleYouTube.OnUpdateVideo := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateVideoResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudGoogleYouTubeService);
end;

end.
