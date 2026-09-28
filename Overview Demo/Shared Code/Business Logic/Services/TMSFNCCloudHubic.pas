unit TMSFNCCloudHubic;

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
  CloudServices, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudHubic, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudHubic, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCloudStorage, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudHubic, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCloudHubic, WEBLib.TMSFNCCloudStorage, TMSFNCCloudStorageBase;
  {$ENDIF}

type
  TTMSFNCCloudHubicService = class(TTMSFNCCloudStorageService)
  protected
    class procedure DoGetInfo(Sender: TObject); override;
    class procedure Refresh; override;
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function Hubic: TTMSFNCCloudHubic;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudHubicService }

class procedure TTMSFNCCloudHubicService.DoGetInfo(Sender: TObject);
begin
  Hubic.Drive.Clear;
  inherited;
end;

class function TTMSFNCCloudHubicService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudHubic;
end;

class function TTMSFNCCloudHubicService.GetDescription: string;
begin
  Result := 'Read and write files and folders stored in Hubic';
end;

class function TTMSFNCCloudHubicService.GetTitle: string;
begin
  Result := 'Hubic';
end;

class function TTMSFNCCloudHubicService.Hubic: TTMSFNCCloudHubic;
begin
  Result := Service as TTMSFNCCloudHubic;
end;

class procedure TTMSFNCCloudHubicService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
begin
  inherited;
  Hubic.OnGetFolderList := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetInfoResult;
  Hubic.OnGetDriveInfo := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetInfoResult;
  Hubic.OnCreateFolder := {$IFDEF LCLWEBLIB}@{$ENDIF}DoCreateFolderResult;
  Hubic.OnDeleteItem := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteResult;
  Hubic.OnUploadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUploadResult;
  Hubic.OnDownloadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDownloadResult;
  Hubic.OnRequestProgress := {$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestProgressResult;
end;

class procedure TTMSFNCCloudHubicService.Refresh;
begin
  Hubic.Drive.Clear;
  inherited;
end;

initialization
begin
  {$IFNDEF WEBLIB}
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudHubicService);
  {$ENDIF}
end;

end.
