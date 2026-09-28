unit TMSFNCCloudGoogleDrive;

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
  CloudServices, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudGoogleDrive, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudGoogleDrive, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCloudStorage, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudGoogleDrive, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCloudGoogleDrive, WEBLib.TMSFNCCloudStorage, TMSFNCCloudStorageBase;
  {$ENDIF}

type
  TTMSFNCCloudGoogleDriveService = class(TTMSFNCCloudStorageService)
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function GoogleDrive: TTMSFNCCloudGoogleDrive;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGoogleDriveService }

class function TTMSFNCCloudGoogleDriveService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudGoogleDrive;
end;

class function TTMSFNCCloudGoogleDriveService.GetDescription: string;
begin
  Result := 'Read and write files and folders stored in Google Drive';
end;

class function TTMSFNCCloudGoogleDriveService.GetTitle: string;
begin
  Result := 'Google Drive';
end;

class function TTMSFNCCloudGoogleDriveService.GoogleDrive: TTMSFNCCloudGoogleDrive;
begin
  Result := Service as TTMSFNCCloudGoogleDrive;
end;

class procedure TTMSFNCCloudGoogleDriveService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
begin
  inherited;
  GoogleDrive.OnGetFolderList := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetInfoResult;
  GoogleDrive.OnCreateFolder := {$IFDEF LCLWEBLIB}@{$ENDIF}DoCreateFolderResult;
  GoogleDrive.OnDeleteItem := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteResult;
  GoogleDrive.OnUploadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUploadResult;
  GoogleDrive.OnDownloadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDownloadResult;
  GoogleDrive.OnRequestProgress := {$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestProgressResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudGoogleDriveService);
end;

end.
