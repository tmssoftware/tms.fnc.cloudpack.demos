unit TMSFNCCloudDropBox;

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
  CloudServices, VCL.TMSFNCCloudDropBox, VCL.TMSFNCCustomControl, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudDropBox, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCloudStorage, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls, LCLTMSFNCCloudOAuth, LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudDropBox, TMSFNCCloudStorageBase;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.TMSFNCCloudOAuth, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCloudDropBox, WEBLib.TMSFNCCustomControl, TMSFNCCloudStorageBase;
  {$ENDIF}

type
  TTMSFNCCloudDropBoxService = class(TTMSFNCCloudStorageService)
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function DropBox: TTMSFNCCloudDropBox;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudDropBoxService }

class function TTMSFNCCloudDropBoxService.DropBox: TTMSFNCCloudDropBox;
begin
  Result := Service as TTMSFNCCloudDropBox;
end;

class function TTMSFNCCloudDropBoxService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudDropBox;
end;

class function TTMSFNCCloudDropBoxService.GetDescription: string;
begin
  Result := 'Cloud File Sharing and Storage for your Business.';
end;

class function TTMSFNCCloudDropBoxService.GetTitle: string;
begin
  Result := 'Dropbox';
end;

class procedure TTMSFNCCloudDropBoxService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
begin
  inherited;
  DropBox.OnGetFolderList := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetInfoResult;
  DropBox.OnCreateFolder := {$IFDEF LCLWEBLIB}@{$ENDIF}DoCreateFolderResult;
  DropBox.OnDeleteItem := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteResult;
  DropBox.OnUploadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUploadResult;
  DropBox.OnDownloadFile := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDownloadResult;
  DropBox.OnRequestProgress := {$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestProgressResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudDropBoxService);
end;

end.
