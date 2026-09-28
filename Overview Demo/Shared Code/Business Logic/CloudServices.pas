unit CloudServices;

interface

{$IFDEF LCL}
{$mode objfpc}{$H+}{$modeswitch advancedrecords}
{$ENDIF}

{$IFDEF WEBLIB}
{$DEFINE LCLWEBLIB}
{$DEFINE CMNWEBLIB}
{$ENDIF}

{$IFDEF LCL}
{$DEFINE LCLWEBLIB}
{$DEFINE CMNWEBLIB}
{$ENDIF}

{$IFDEF FMX}
{$DEFINE VCLFMX}
{$ENDIF}

{$IFDEF VCL}
{$DEFINE VCLFMX}
{$DEFINE CMNWEBLIB}
{$ENDIF}

{$IFDEF ANDROID}
{$DEFINE MOBILE}
{$ENDIF}
{$IFDEF IOS}
{$DEFINE MOBILE}
{$ENDIF}

uses
  {$IFDEF VCL}
  Classes, Generics.Collections, UITypes, VCL.Controls, VCL.TMSFNCCloudOAuth, VCL.TMSFNCCloudBase, VCL.TMSFNCUtils, Types, ExtCtrls,
  VCL.TMSFNCGraphics, VCL.Forms, VCL.TMSFNCCustomControl, VCL.StdCtrls, VCL.TMSFNCTypes, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, Generics.Collections, FMX.Controls, FMX.Types, UITypes, FMX.TMSFNCCloudOAuth, FMX.TMSFNCCloudBase, FMX.TMSFNCTypes, FMX.TMSFNCUtils, Types,
  FMX.TMSFNCGraphics, FMX.Layouts, FMX.TMSFNCCustomControl, FMX.StdCtrls, FMX.Edit, FMX.Forms, FMX.TMSFNCGraphicsTypes, FMX.Memo, FMX.TMSFNCCloudDemoListBox
  {$IFDEF IOS}
  ,iOSApi.UIKit
  {$ENDIF}
  {$IFDEF ANDROID}
  ,AndroidApi.Helpers, AndroidApi.JNI.GraphicsContentViewText
  {$ENDIF}
  ;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, fgl, Controls, LCLTMSFNCCloudOAuth, LCLTMSFNCCloudBase, LCLTMSFNCUtils, Types, LCLTMSFNCTypes, ExtCtrls,
  LCLTMSFNCGraphics, Forms, LCLTMSFNCCustomControl, StdCtrls, LCLTMSFNCGraphicsTypes, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Classes, web, WEBLib.TMSFNCCloudOAuth, WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCUtils, WEBLib.TMSFNCTypes, WEBLib.Controls, Types, WEBLib.ExtCtrls,
  WEBLib.TMSFNCGraphics, WEBLib.Forms, WEBLib.TMSFNCCustomControl, WEBLib.StdCtrls, WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCCloudDemoListBox;
  {$ENDIF}

type
  TTMSFNCCloudServiceList = class;

  TTMSFNCCloudServiceLoading = class(TTMSFNCCustomControl)
  private
    FAnimMarqueeSwitch: Boolean;
    FAnimMarqueeStartAngle, FAnimMarqueeSweepAngle, FAnimShiftAngle: Single;
    FTimer: TTimer;
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
  protected
    procedure DoTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw({%H-}AGraphics: TTMSFNCGraphics; {%H-}ARect: TRectF); override;
    property Active: Boolean read FActive write SetActive;
  end;

  TTMSFNCCloudService = class
  private
    class var FMode: Integer;
    class var FForm: TCustomForm;
    class var FToggleDetailButton: TButton;
    class var FContentLeftPanel: TTMSFNCCustomControl;
    class var FContentDetailPanel: TTMSFNCCustomControl;
    class var FContent: TTMSFNCCustomControl;
    class var FBottomPanel: TTMSFNCCustomControl;
    class var FServiceLoading: TTMSFNCCloudServiceLoading;
    class var FLogList: TTMSFNCCloudDemoListBox;
    class var FLogLabel: TMemo;
    class var FService: TTMSFNCCloudOAuth;
    class var FOnConnected: TNotifyEvent;
    class var FOnReturnClicked: TNotifyEvent;
  protected
    class procedure DoConnected(Sender: TObject);
    class procedure DoRequestLog(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AMessage: string);
    class procedure DoAccessDenied(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoReturnClicked(Sender: TObject);
    class procedure DoToggleDetailClicked(Sender: TObject);
    class procedure DoLogListClicked(Sender: TObject);
    class procedure DoLogClicked(Sender: TObject);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; virtual; abstract;
    class function GetTitle: string; virtual; abstract;
    class function GetDescription: string; virtual; abstract;
    class function HasTokens: Boolean;
    class function GetClientID: string;
    class function GetSecret: string;
    class function GetKey: string;
    class function GetCallBackURL: string;
    class function NeedTokens: Boolean; virtual;
    class function GetAuthenticationDetailsLabels: TTMSFNCCloudOAuthServiceStringArray; virtual;
    class function GetAuthenticationDetailsValues: TTMSFNCCloudOAuthServiceStringArray; virtual;
    class function IsPhone: Boolean; virtual;
    class procedure PerformResize; virtual;
    class procedure ClearComponent(AComponent: TComponent); virtual;
    class procedure Init(AForm: TCustomForm); virtual;
    class procedure UnInit; virtual;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); virtual;
    class procedure SetClientID(AValue: string);
    class procedure SetKey(AValue: string);
    class procedure SetSecret(AValue: string);
    class procedure SetCallBackURL(AValue: string);
    class procedure SetValues(AValues: string); virtual;
    class procedure Connect; virtual;
    class procedure Save; virtual;
    class procedure Clear; virtual;
    class procedure CreateService;
    class procedure DestroyService;
    class procedure StartLoading;
    class procedure StopLoading;
    class property OnConnected: TNotifyEvent read FOnConnected write FOnConnected;
    class property OnReturnClicked: TNotifyEvent read FOnReturnClicked write FOnReturnClicked;
    class property Service: TTMSFNCCloudOAuth read FService;
  end;

  TTMSFNCCloudServiceClass = class of TTMSFNCCloudService;

  TTMSFNCCloudServiceRegistration = class
  private
    class var FRegisteredServices: TTMSFNCCloudServiceList;
  public
    class function GetRegisteredService(Index: Integer): TTMSFNCCloudServiceClass; static;
    class function RegisteredServiceCount: Integer;
    class procedure RegisterService(AServiceClass: TTMSFNCCloudServiceClass);
    class procedure DestroyRegisteredServices;
    class property RegisteredServices[Index: Integer]: TTMSFNCCloudServiceClass read GetRegisteredService;
  end;

  {$IFDEF WEBLIB}
  TTMSFNCCloudServiceList = class(TList)
  private
    function GetItem(Index: Integer): TTMSFNCCloudServiceClass;
    procedure SetItem(Index: Integer; const Value: TTMSFNCCloudServiceClass);
  public
    property Items[Index: Integer]: TTMSFNCCloudServiceClass read GetItem write SetItem; default;
  end;
  {$ENDIF}
  {$IFNDEF WEBLIB}
  {$IFDEF LCL}
  TTMSFNCCloudServiceList = class(specialize TFPGList<TTMSFNCCloudServiceClass>);
  {$ELSE}
  TTMSFNCCloudServiceList = class(TList<TTMSFNCCloudServiceClass>);
  {$ENDIF}
  {$ENDIF}

  procedure SetControlAlignment(AControl: TControl; AAlignment: TTMSFNCControlAlignment);
  procedure SetControlMargins(AControl: TControl; ALeft, ATop, ARight, ABottom: Single);
  procedure SetControlPosition(AControl: TControl; ALeft, ATop: Single);
  procedure SetButtonText(AButton: TButton; AText: string);
  procedure SetLabelText(ALabel: TLabel; AText: string);
  procedure SetLabelFontColor(ALabel: TLabel; AColor: TTMSFNCGraphicsColor);
  procedure ClearStyledSettings(AControl: TControl);

implementation

uses
  SysUtils;

type
  TTMSFNCCustomControlOpen = class(TTMSFNCCustomControl);
  TTMSFNCCloudOAuthOpen = class(TTMSFNCCloudOAuth);

procedure SetControlAlignment(AControl: TControl; AAlignment: TTMSFNCControlAlignment);
begin
  {$IFDEF FMX}
  case AAlignment of
    caNone: AControl.Align := TAlignLayout.None;
    caTop: AControl.Align := TAlignLayout.Top;
    caBottom: AControl.Align := TAlignLayout.Bottom;
    caLeft: AControl.Align := TAlignLayout.Left;
    caRight: AControl.Align := TAlignLayout.Right;
    caClient: AControl.Align := TAlignLayout.Client;
  end;
  {$ELSE}
  case AAlignment of
    caNone: AControl.Align := alNone;
    caTop: AControl.Align := alTop;
    caBottom: AControl.Align := alBottom;
    caLeft: AControl.Align := alLeft;
    caRight: AControl.Align := alRight;
    caClient: AControl.Align := alClient;
  end;
  {$ENDIF}
end;

procedure SetControlMargins(AControl: TControl; ALeft, ATop, ARight, ABottom: Single);
begin
  {$IFDEF FMX}
  AControl.Margins.Left := ALeft;
  AControl.Margins.Top := ATop;
  AControl.Margins.Right := ARight;
  AControl.Margins.Bottom := ABottom;
  {$ENDIF}
  {$IFDEF VCL}
  AControl.AlignWithMargins := True;
  AControl.Margins.Left := Round(ALeft);
  AControl.Margins.Top := Round(ATop);
  AControl.Margins.Right := Round(ARight);
  AControl.Margins.Bottom := Round(ABottom);
  {$ENDIF}
  {$IFDEF WEBLIB}
  AControl.AlignWithMargins := True;
  AControl.Margins.Left := Round(ALeft);
  AControl.Margins.Top := Round(ATop);
  AControl.Margins.Right := Round(ARight);
  AControl.Margins.Bottom := Round(ABottom);
  {$ENDIF}
  {$IFDEF LCL}
  AControl.BorderSpacing.Left := Round(ALeft);
  AControl.BorderSpacing.Top := Round(ATop);
  AControl.BorderSpacing.Right := Round(ARight);
  AControl.BorderSpacing.Bottom := Round(ABottom);
  {$ENDIF}
end;

procedure SetControlPosition(AControl: TControl; ALeft, ATop: Single);
begin
  {$IFDEF FMX}
  AControl.Position.X := ALeft;
  AControl.Position.Y := ATop;
  {$ELSE}
  AControl.Left := Round(ALeft);
  AControl.Top := Round(ATop);
  {$ENDIF}
end;

procedure SetButtonText(AButton: TButton; AText: string);
begin
  {$IFDEF FMX}
  AButton.Text := AText;
  {$ELSE}
  AButton.Caption := AText;
  {$ENDIF}
end;

procedure ClearStyledSettings(AControl: TControl);
begin
  {$IFDEF FMX}
  if AControl is TEdit then
    (AControl as TEdit).StyledSettings := [TStyledSetting.Style, TStyledSetting.FontColor]
  else if AControl is TButton then
  begin
    {$IFDEF IOS}
    (AControl as TButton).TextSettings.HorzAlign := TTextAlign.Leading;
    (AControl as TButton).Width := (AControl as TButton).Width + 25;
    {$ENDIF}
    {$IFDEF ANDROID}
    (AControl as TButton).Width := (AControl as TButton).Width + 10;
    (AControl as TButton).Height := (AControl as TButton).Height - 15;
    {$ENDIF}
    {$IFDEF MOBILE}
    (AControl as TButton).TextSettings.Font.Size := (AControl as TButton).TextSettings.Font.Size - 1;
    {$ENDIF}
    (AControl as TButton).StyledSettings := [TStyledSetting.Style, TStyledSetting.FontColor]
  end
  else if AControl is TLabel then
  begin
    (AControl as TLabel).WordWrap := False;
    (AControl as TLabel).StyledSettings := [TStyledSetting.Style, TStyledSetting.FontColor];
    (AControl as TLabel).Width := 300;
  end;
  {$ENDIF}
end;

procedure SetLabelFontColor(ALabel: TLabel; AColor: TTMSFNCGraphicsColor);
begin
  {$IFDEF FMX}
  ALabel.FontColor := AColor;
  {$ELSE}
  ALabel.Font.Color := AColor;
  {$ENDIF}
end;

procedure SetLabelText(ALabel: TLabel; AText: string);
begin
  {$IFDEF FMX}
  ALabel.Text := AText;
  {$ELSE}
  ALabel.Caption := AText;
  {$ENDIF}
end;

{$IFDEF WEBLIB}
function TTMSFNCCloudServiceList.GetItem(Index: Integer): TTMSFNCCloudServiceClass;
begin
  Result := TTMSFNCCloudServiceClass(inherited Items[Index]);
end;

procedure TTMSFNCCloudServiceList.SetItem(Index: Integer; const Value: TTMSFNCCloudServiceClass);
begin
  inherited Items[Index] := Value;
end;
{$ENDIF}

{ TTMSFNCCloudServiceRegistration }

class procedure TTMSFNCCloudServiceRegistration.RegisterService(AServiceClass: TTMSFNCCloudServiceClass);
begin
  if not Assigned(FRegisteredServices) then
    FRegisteredServices := TTMSFNCCloudServiceList.Create;

  FRegisteredServices.Add(AServiceClass);
end;

class procedure TTMSFNCCloudServiceRegistration.DestroyRegisteredServices;
var
  I: Integer;
begin
  if Assigned(FRegisteredServices) then
  begin
    for I := 0 to FRegisteredServices.Count - 1 do
      FRegisteredServices[I].DestroyService;

    FRegisteredServices.Free;
  end;
end;

class function TTMSFNCCloudServiceRegistration.GetRegisteredService(
  Index: Integer): TTMSFNCCloudServiceClass;
begin
  Result := nil;
  if Assigned(FRegisteredServices) then
    Result := FRegisteredServices[Index];
end;

class function TTMSFNCCloudServiceRegistration.RegisteredServiceCount: Integer;
begin
  Result := 0;
  if Assigned(FRegisteredServices) then
    Result := FRegisteredServices.Count;
end;

{ TTMSFNCCloudService }

class procedure TTMSFNCCloudService.Clear;
begin
  if Assigned(FService) then
    FService.ClearTokens;
end;

class function TTMSFNCCloudService.HasTokens: Boolean;
begin
  Result := False;
  if Assigned(FService) then
    Result := ((FService.Authentication.AccessToken <> '') and NeedTokens) or not NeedTokens;
end;

class procedure TTMSFNCCloudService.Connect;
begin
  if Assigned(FService) then
    FService.Connect;
end;

class procedure TTMSFNCCloudService.ClearComponent(AComponent: TComponent);
var
  I: Integer;
  c: TComponent;
begin
  FLogList := nil;
  FLogLabel := nil;
  FServiceLoading := nil;
  for I := AComponent.ComponentCount - 1 downto 0 do
  begin
    {$IFDEF FMX}
    if AComponent.Components[I] is TScrollContent then
      Continue;
    {$ENDIF}

    c := AComponent.Components[I];
    AComponent.RemoveComponent(c);
    {$IFDEF LCLWEBLIB}
    c.Free;
    {$ELSE}
    c.Free;
    {$ENDIF}    
  end;
end;

class procedure TTMSFNCCloudService.CreateService;
var
  c: TTMSFNCCloudOAuthClass;
begin
  DestroyService;

  if not Assigned(FService) then
  begin
    c := GetCloudServiceClass;
    if Assigned(c) then
    begin
      FMode := 0;
      FService := c.Create;
      FService.PersistTokens.SaveClientID := True;
      FService.PersistTokens.SaveSecret := True;
      FService.PersistTokens.SaveCallBack := True;
      FService.PersistTokens.SaveKey := True;
      FService.PersistTokens.SaveExtra := True;
      FService.PersistTokens.Location := plIniFile;
      FService.PersistTokens.Key := TTMSFNCUtils.AddBackslash(TTMSFNCUtils.GetDocumentsPath) + FService.ClassName + '.ini';
      {$IFDEF WEBLIB}
      FService.Authentication.CallBackURL := window.location.href + '?oauthcallback=true';
      {$ELSE}
      FService.Authentication.CallBackURL := 'http://127.0.0.1:8000';
      {$ENDIF}
      FService.LoadTokens;
      FService.OnConnected := {$IFDEF LCL}@{$ENDIF}DoConnected;
      FService.OnRequestLog := {$IFDEF LCL}@{$ENDIF}DoRequestLog;
      FService.OnAccessDenied := {$IFDEF LCL}@{$ENDIF}DoAccessDenied;
      FService.Logging := True;
      SetValues(FService.PersistTokens.Extra);
    end;
  end;
end;

class procedure TTMSFNCCloudService.UnInit;
begin
//
end;

class procedure TTMSFNCCloudService.DestroyService;
begin
  {$IFNDEF WEBLIB}
  FreeAndNil(FService);
  {$ELSE}
  FService := nil;
  {$ENDIF}
end;

class procedure TTMSFNCCloudService.DoAccessDenied(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  TTMSFNCUtils.Message(ARequestResult.ResultString);
end;

class procedure TTMSFNCCloudService.DoConnected(Sender: TObject);
begin
  if Assigned(OnConnected) then
    OnConnected(Sender);
end;

class procedure TTMSFNCCloudService.DoLogClicked(Sender: TObject);
begin
  if (Sender as TButton).Tag = 0 then
  begin
    (Sender as TButton).Tag := 1;
    FLogLabel.Visible := True;
    FLogList.Visible := True;
    FContent.Visible := False;
    FServiceLoading.Visible := False;
    SetControlAlignment(FBottomPanel, caClient);
  end
  else
  begin
    (Sender as TButton).Tag := 0;
    SetControlAlignment(FBottomPanel, caBottom);
    FBottomPanel.Height := 40;
    FLogLabel.Visible := False;
    FLogList.Visible := False;
    FServiceLoading.Visible := True;
    FContent.Visible := True;
  end;
end;

class procedure TTMSFNCCloudService.DoLogListClicked(Sender: TObject);
begin
  if Assigned(FLogList) and Assigned(FLogLabel) and (FLogList.ItemIndex <> -1) then
    FLogLabel.Text := FLogList.Items[FLogList.ItemIndex].DataString;
end;

class procedure TTMSFNCCloudService.StopLoading;
begin
  if Assigned(FServiceLoading) then
    FServiceLoading.Active := False;
end;

class procedure TTMSFNCCloudService.StartLoading;
begin
  if Assigned(FServiceLoading) then
    FServiceLoading.Active := True;
end;

class procedure TTMSFNCCloudService.DoRequestLog(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult; AMessage: string);
var
  it: TTMSFNCCloudDemoListBoxItem;
begin
  if Assigned(FLogList) then
  begin
    it := FLogList.Items.Add;
    it.DataString := AMessage;
    it.Text := '[' + DateTimeToStr(Now) + '] Log request message from ' + Sender.ClassName +  ' with request name : ' + ARequestResult.Name;
  end;
end;

class procedure TTMSFNCCloudService.DoReturnClicked(Sender: TObject);
begin
  if Assigned(OnReturnClicked) then
    OnReturnClicked(Sender);
end;

class procedure TTMSFNCCloudService.DoToggleDetailClicked(Sender: TObject);
begin
  if Assigned(FContentDetailPanel) and Assigned(FContentLeftPanel) then
  begin
    case FToggleDetailButton.Tag of
      0:
      begin
        FToggleDetailButton.Tag := 1;
        SetButtonText(FToggleDetailButton, 'Hide Detail');
      end;
      1:
      begin
        FToggleDetailButton.Tag := 0;
        SetButtonText(FToggleDetailButton, 'Show Detail');
      end;
    end;
    FContentDetailPanel.Visible := (FToggleDetailButton.Tag = 1);
    FContentLeftPanel.Visible := (FToggleDetailButton.Tag = 0);
  end;
end;

class function TTMSFNCCloudService.GetAuthenticationDetailsLabels: TTMSFNCCloudOAuthServiceStringArray;
begin
  Result := nil;
  if Assigned(FService) then
    Result := TTMSFNCCloudOAuthOpen(FService).GetAuthenticationDetailsLabels;
end;

class function TTMSFNCCloudService.GetAuthenticationDetailsValues: TTMSFNCCloudOAuthServiceStringArray;
begin
  Result := nil;
  if Assigned(FService) then
    Result := TTMSFNCCloudOAuthOpen(FService).GetAuthenticationDetailsValues;
end;

class function TTMSFNCCloudService.GetCallBackURL: string;
begin
  Result := '';
  if Assigned(FService) then
    Result := FService.Authentication.CallBackURL;
end;

class function TTMSFNCCloudService.GetClientID: string;
begin
  Result := '';
  if Assigned(FService) then
    Result := FService.Authentication.ClientID;
end;

class function TTMSFNCCloudService.GetKey: string;
begin
  Result := '';
  if Assigned(FService) then
    Result := FService.Authentication.Key;
end;

class function TTMSFNCCloudService.GetSecret: string;
begin
  Result := '';
  if Assigned(FService) then
    Result := FService.Authentication.Secret;
end;

class procedure TTMSFNCCloudService.Init(AForm: TCustomForm);
var
  lblTitle: TLabel;
  btnReturn: TButton;
  btnLog: TButton;
begin
  FForm := AForm;

  ClearComponent(AForm);

  lblTitle := TLabel.Create(AForm);
  lblTitle.Parent := AForm;
  lblTitle.AutoSize := True;
  SetLabelText(lblTitle, 'Demo of ' + GetTitle);
  SetLabelFontColor(lblTitle, gcSteelblue);
  SetControlAlignment(lblTitle, caTop);
  SetControlMargins(lblTitle, 10, 10, 10, 10);

  TTMSFNCUtils.SetFontSize(lblTitle.Font, 24);

  FBottomPanel := TTMSFNCCustomControl.Create(AForm);
  FBottomPanel.Parent := AForm;
  FBottomPanel.ControlAlignment := caBottom;
  FBottomPanel.Height := 40;

  FLogList := TTMSFNCCloudDemoListBox.Create(FBottomPanel);
  FLogList.Visible := False;
  FLogList.Parent := FBottomPanel;
  FLogList.OnClick := {$IFDEF LCL}@{$ENDIF}DoLogListClicked;
  FLogList.ItemHeight := 25;
  SetControlAlignment(FLogList, caClient);
  SetControlMargins(FLogList, 5, 40, 5, 5);

  FLogLabel := TMemo.Create(FBottomPanel);
  FLogLabel.Visible := False;
  FLogLabel.Parent := FBottomPanel;
  SetControlAlignment(FLogLabel, caBottom);
  FLogLabel.Height := 300;
  SetControlMargins(FLogLabel, 5, 0, 5, 5);
  FLogLabel.WordWrap := True;

  btnLog := TButton.Create(FBottomPanel);
  btnLog.Parent := FBottomPanel;
  SetButtonText(btnLog, 'Show Log');
  SetControlPosition(btnLog, 5, 5);
  btnLog.Height := 30;
  btnLog.Width := 85;
  btnLog.OnClick := {$IFDEF LCL}@{$ENDIF}DoLogClicked;
  {$IFDEF FMX}
  {$IFDEF MOBILE}
  btnLog.TextSettings.Font.Size := btnLog.TextSettings.Font.Size - 1;
  {$ENDIF}
  btnLog.StyledSettings := [TStyledSetting.Style, TStyledSetting.FontColor];
  {$ENDIF}

  btnReturn := TButton.Create(FBottomPanel);
  btnReturn.Parent := FBottomPanel;
  SetButtonText(btnReturn, 'Select Service');
  SetControlPosition(btnReturn, btnLog.Width + 10, 5);
  btnReturn.Height := 30;
  btnReturn.Width := 120;
  btnReturn.OnClick := {$IFDEF LCL}@{$ENDIF}DoReturnClicked;
  {$IFDEF FMX}
  {$IFDEF MOBILE}
  btnReturn.TextSettings.Font.Size := btnReturn.TextSettings.Font.Size - 1;
  {$ENDIF}
  btnReturn.StyledSettings := [TStyledSetting.Style, TStyledSetting.FontColor];
  {$ENDIF}

  FToggleDetailButton := TButton.Create(FBottomPanel);
  FToggleDetailButton.Parent := FBottomPanel;
  SetButtonText(FToggleDetailButton, 'Show Detail');
  SetControlMargins(FToggleDetailButton, 5, 5, 5, 5);
  SetControlAlignment(FToggleDetailButton, caRight);
  FToggleDetailButton.Height := 30;
  FToggleDetailButton.Width := 120;
  SetControlPosition(FToggleDetailButton, 1, 0);
  FToggleDetailButton.OnClick := {$IFDEF LCL}@{$ENDIF}DoToggleDetailClicked;
  {$IFDEF FMX}
  {$IFDEF MOBILE}
  FToggleDetailButton.TextSettings.Font.Size := FToggleDetailButton.TextSettings.Font.Size - 1;
  {$ENDIF}
  FToggleDetailButton.StyledSettings := [TStyledSetting.Style, TStyledSetting.FontColor];
  {$ENDIF}
  FToggleDetailButton.Visible := IsPhone;

  FServiceLoading := TTMSFNCCloudServiceLoading.Create(FBottomPanel);
  FServiceLoading.Parent := FBottomPanel;
  SetControlPosition(FServiceLoading, btnLog.Width + btnReturn.Width + 20, 0);
  FServiceLoading.Height := FBottomPanel.Height;
  FServiceLoading.Width := FServiceLoading.Height;
  FServiceLoading.Transparent := True;
  FServiceLoading.NativeCanvas := True;
  FServiceLoading.DisableBackground;

  FContent := TTMSFNCCustomControl.Create(AForm);
  FContent.Parent := AForm;
  FContent.ControlAlignment := caClient;
  FContent.Height := 40;

  FContentLeftPanel := TTMSFNCCustomControl.Create(FContent);
  FContentLeftPanel.Parent := FContent;

  FContentDetailPanel := TTMSFNCCustomControl.Create(FContent);
  FContentDetailPanel.Visible := not IsPhone;
  FContentDetailPanel.ControlAlignment := caClient;
  FContentDetailPanel.Parent := FContent;

  if IsPhone then
    FContentLeftPanel.ControlAlignment := caClient
  else
  begin
    FContentLeftPanel.ControlAlignment := caLeft;
    FContentLeftPanel.Width := 300;
  end;

  FContentLeftPanel.DisableBackground;
  FContentDetailPanel.DisableBackground;

  InitContent(FContentLeftPanel, FContentDetailPanel);
end;

class procedure TTMSFNCCloudService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
begin
end;

class function TTMSFNCCloudService.IsPhone: Boolean;
begin
  Result := Assigned(FForm) and (FForm.Width < 575);
end;

class function TTMSFNCCloudService.NeedTokens: Boolean;
begin
  Result := True;
end;

class procedure TTMSFNCCloudService.PerformResize;
begin
  if Assigned(FContentLeftPanel) and Assigned(FContentDetailPanel) then
  begin
    FToggleDetailButton.Visible := IsPhone;
    FContentDetailPanel.Visible := not IsPhone;

    if IsPhone then
      FContentLeftPanel.ControlAlignment := caClient
    else
    begin
      FContentLeftPanel.ControlAlignment := caLeft;
      FContentLeftPanel.Width := 300;
    end;
  end;
end;

class procedure TTMSFNCCloudService.Save;
begin
  if Assigned(FService) then
    FService.SaveTokens;
end;

class procedure TTMSFNCCloudService.SetCallBackURL(AValue: string);
begin
  if Assigned(FService) then
    FService.Authentication.CallBackURL := AValue;
end;

class procedure TTMSFNCCloudService.SetClientID(AValue: string);
begin
  if Assigned(FService) then
    FService.Authentication.ClientID := AValue;
end;

class procedure TTMSFNCCloudService.SetKey(AValue: string);
begin
  if Assigned(FService) then
    FService.Authentication.Key := AValue;
end;

class procedure TTMSFNCCloudService.SetSecret(AValue: string);
begin
  if Assigned(FService) then
    FService.Authentication.Secret := AValue;
end;

class procedure TTMSFNCCloudService.SetValues(AValues: string);
begin
  if Assigned(FService) then
    FService.PersistTokens.Extra := AValues;
end;

{ TTMSFNCCloudServiceLoading }

constructor TTMSFNCCloudServiceLoading.Create(AOwner: TComponent);
begin
  inherited;
  FTimer := TTimer.Create(Self);
  FTimer.OnTimer := {$IFDEF LCL}@{$ENDIF}DoTimer;
  FTimer.Interval := 1;
end;

destructor TTMSFNCCloudServiceLoading.Destroy;
begin
  FreeAndNil(FTimer);
  inherited;
end;

procedure TTMSFNCCloudServiceLoading.DoTimer(Sender: TObject);
begin
  FAnimShiftAngle := FAnimShiftAngle + 5;
  if FAnimShiftAngle = 360 then
    FAnimShiftAngle := 0;

  if not FAnimMarqueeSwitch then
    FAnimMarqueeSweepAngle := FAnimMarqueeSweepAngle + 10
  else
  begin
    FAnimMarqueeStartAngle := FAnimMarqueeStartAngle + 10;
    FAnimMarqueeSweepAngle := FAnimMarqueeSweepAngle - 10;
  end;

  if (FAnimMarqueeSweepAngle = 360) and (FAnimMarqueeStartAngle = 0) then
    FAnimMarqueeSwitch := True
  else if ((FAnimMarqueeStartAngle = 360) and (FAnimMarqueeSweepAngle = 0)) then
  begin
    FAnimMarqueeSwitch := False;
    FAnimMarqueeStartAngle := 0;
  end;

  Invalidate;
end;

procedure TTMSFNCCloudServiceLoading.Draw(AGraphics: TTMSFNCGraphics;
  ARect: TRectF);
var
  r: TRectF;
  sz: Single;
  pm: Integer;
begin
  inherited;
  if FActive then
  begin
    r := ARect;
    sz := 25;
    r := RectF(r.Left + ((r.Right - r.Left) - sz) / 2, r.Top + ((r.Bottom - r.Top) - sz) / 2, r.Left + ((r.Right - r.Left) - sz) / 2 + sz, r.Top  + ((r.Bottom - r.Top) - sz) / 2 + sz);
    pm := 0;
    AGraphics.Stroke.Kind := gskSolid;
    AGraphics.Stroke.Color := gcSteelblue;
    AGraphics.Stroke.Width := 4;
    case pm of
      0: AGraphics.DrawArc(CenterPointEx(r), PointF((r.Right - r.Left) / 2, (r.Bottom - r.Top) / 2), FAnimMarqueeStartAngle, FAnimMarqueeSweepAngle);
      1: AGraphics.DrawArc(CenterPointEx(r), PointF((r.Right - r.Left) / 2, (r.Bottom - r.Top) / 2), FAnimShiftAngle + FAnimMarqueeStartAngle, FAnimMarqueeSweepAngle);
    end;
  end;
end;

procedure TTMSFNCCloudServiceLoading.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    FTimer.Enabled := FActive;
    Invalidate;
  end;
end;

{$IFNDEF WEBLIB}
initialization
finalization
begin
  TTMSFNCCloudServiceRegistration.DestroyRegisteredServices;
end;
{$ENDIF}

end.
