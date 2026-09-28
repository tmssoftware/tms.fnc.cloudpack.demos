unit TMSFNCCloudMicrosoftOneDrive;

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
  CloudServices, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudMicrosoftOneDrive, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudMicrosoftOneDrive, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCloudStorage, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudMicrosoftOneDrive, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCloudMicrosoftOneDrive, TMSFNCCloudStorageBase;
  {$ENDIF}

type
  TTMSFNCCloudMicrosoftOneDriveService = class(TTMSFNCCloudStorageService)
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function MicrosoftOneDrive: TTMSFNCCloudMicrosoftOneDrive;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudMicrosoftOneDriveService }

class function TTMSFNCCloudMicrosoftOneDriveService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudMicrosoftOneDrive;
end;

class function TTMSFNCCloudMicrosoftOneDriveService.GetDescription: string;
begin
  Result := 'Read and write files and folders stored in OneDrive';
end;

class function TTMSFNCCloudMicrosoftOneDriveService.GetTitle: string;
begin
  Result := 'OneDrive';
end;

class function TTMSFNCCloudMicrosoftOneDriveService.MicrosoftOneDrive: TTMSFNCCloudMicrosoftOneDrive;
begin
  Result := Service as TTMSFNCCloudMicrosoftOneDrive;
end;

class procedure TTMSFNCCloudMicrosoftOneDriveService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
begin
  inherited;
  MicrosoftOneDrive.OnGetFolderList := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetInfoResult;
  MicrosoftOneDrive.OnCreateFolder := {$IFDEF LCLWEBLIB}@{$ENDIF}DoCreateFolderResult;
  MicrosoftOneDrive.OnDeleteItem := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteResult;
  MicrosoftOneDrive.OnUploadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUploadResult;
  MicrosoftOneDrive.OnDownloadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDownloadResult;
  MicrosoftOneDrive.OnRequestProgress := {$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestProgressResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudMicrosoftOneDriveService);
end;

end.
