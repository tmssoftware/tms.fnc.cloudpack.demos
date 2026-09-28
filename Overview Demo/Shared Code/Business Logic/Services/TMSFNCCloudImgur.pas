unit TMSFNCCloudImgur;

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
  CloudServices, VCL.TMSFNCCloudImgur;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudImgur;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudImgur;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCloudImgur;
  {$ENDIF}

type
  TTMSFNCCloudImgurService = class(TTMSFNCCloudService)
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudImgurService }

class function TTMSFNCCloudImgurService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudImgur;
end;

class function TTMSFNCCloudImgurService.GetDescription: string;
begin
  Result := 'Discover the magic of the internet at Imgur, a community powered entertainment destination.';
end;

class function TTMSFNCCloudImgurService.GetTitle: string;
begin
  Result := 'Imgur';
end;

initialization
begin
//  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudImgurService);
end;

end.
