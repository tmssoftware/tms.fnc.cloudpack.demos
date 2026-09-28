unit TMSFNCCloudBox;

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
  CloudServices, VCL.TMSFNCCloudBox, VCL.TMSFNCCustomControl, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudBox, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCloudStorage, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls, LCLTMSFNCCloudOAuth, LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudBox, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.TMSFNCCloudOAuth, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCloudBox, WEBLib.TMSFNCCustomControl, TMSFNCCloudStorageBase;
  {$ENDIF}

type
  TTMSFNCCloudBoxService = class(TTMSFNCCloudStorageService)
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function Box: TTMSFNCCloudBox;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudBoxService }

class function TTMSFNCCloudBoxService.Box: TTMSFNCCloudBox;
begin
  Result := Service as TTMSFNCCloudBox;
end;

class function TTMSFNCCloudBoxService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudBox;
end;

class function TTMSFNCCloudBoxService.GetDescription: string;
begin
  Result := 'Cloud File Sharing and Storage for your Business.';
end;

class function TTMSFNCCloudBoxService.GetTitle: string;
begin
  Result := 'Box';
end;

class procedure TTMSFNCCloudBoxService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
begin
  inherited;
  Box.OnGetFolderList := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetInfoResult;
  Box.OnCreateFolder := {$IFDEF LCLWEBLIB}@{$ENDIF}DoCreateFolderResult;
  Box.OnDeleteItem := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteResult;
  Box.OnUploadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUploadResult;
  Box.OnDownloadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDownloadResult;
  Box.OnRequestProgress := {$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestProgressResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudBoxService);
end;

end.
