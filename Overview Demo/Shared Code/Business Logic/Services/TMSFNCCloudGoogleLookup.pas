unit TMSFNCCloudGoogleLookup;

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
  CloudServices, VCL.TMSFNCCloudGoogleLookup, VCL.TMSFNCCustomControl;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudGoogleLookup, FMX.TMSFNCCustomControl, FMX.Edit, FMX.ListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudGoogleLookup;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCloudGoogleLookup, WEBLib.TMSFNCCustomControl;
  {$ENDIF}

type
  TTMSFNCCloudGoogleLookupService = class(TTMSFNCCloudService)
  private
    class var edLookupQuery: TEdit;
    class var lbLookup: TListBox;
  protected
    class procedure DoLookup(Sender: TObject);
    class procedure DoLookupResult(Sender: TObject; const AInfo: TStrings; const ARequestResult: TTMSFNCCloudBaseRequestResult);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function NeedTokens: Boolean; override;
    class procedure Clear; override;
    class function GoogleLookup: TTMSFNCCloudGoogleLookup;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGoogleLookupService }

class procedure TTMSFNCCloudGoogleLookupService.Clear;
begin
  SetKey('');
  inherited;
end;

class procedure TTMSFNCCloudGoogleLookupService.DoLookup(Sender: TObject);
begin
  GoogleLookup.Lookup(edLookupQuery.Text);
end;

class procedure TTMSFNCCloudGoogleLookupService.DoLookupResult(Sender: TObject;
  const AInfo: TStrings; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  lbLookup.Items.Clear;
  for I := 0 to AInfo.Count - 1 do
    lbLookup.Items.Add(AInfo[I]);
end;

class function TTMSFNCCloudGoogleLookupService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudGoogleLookup;
end;

class function TTMSFNCCloudGoogleLookupService.GetDescription: string;
begin
  Result := 'Google Lookup';
end;

class function TTMSFNCCloudGoogleLookupService.GetTitle: string;
begin
  Result := 'Google Lookup';
end;

class function TTMSFNCCloudGoogleLookupService.GoogleLookup: TTMSFNCCloudGoogleLookup;
begin
  Result := Service as TTMSFNCCloudGoogleLookup;
end;

class procedure TTMSFNCCloudGoogleLookupService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  l: TLabel;
  b: TButton;
begin
  inherited;
  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 10, 10);
  SetLabelText(l, 'Search for:');
  ClearStyledSettings(l);

  edLookupQuery := TEdit.Create(AContent);
  edLookupQuery.Parent := AContent;
  SetControlPosition(edLookupQuery, 10, 40);
  edLookupQuery.Width := 160;
  edLookupQuery.Text := 'TMS Software';
  ClearStyledSettings(edLookupQuery);

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoLookup;
  SetControlPosition(b, 180, 40);
  SetButtonText(b, 'Lookup');
  ClearStyledSettings(b);

  lbLookup := TListBox.Create(AContent);
  lbLookup.Parent := AContent;
  SetControlAlignment(lbLookup, caClient);
  SetControlMargins(lbLookup, 10, 70, 10, 10);
  lbLookup.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];

  GoogleLookup.OnLookup := {$IFDEF LCLWEBLIB}@{$ENDIF}DoLookupResult;
end;

class function TTMSFNCCloudGoogleLookupService.NeedTokens: Boolean;
begin
  Result := False;
end;

initialization
begin
  {$IFNDEF WEBLIB}
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudGoogleLookupService);
  {$ENDIF}
end;

end.
