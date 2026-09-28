unit SelectService;

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
uses
  {$IFDEF VCL}
  Classes, SysUtils, Generics.Collections, Types, VCL.Controls, VCL.Forms, VCL.StdCtrls, VCL.ComCtrls, UITypes, VCL.TMSFNCCloudOAuth, VCL.TMSFNCCloudBase,
  CloudServices, VCL.ExtCtrls, VCL.TMSFNCCustomControl, VCL.TMSFNCUtils, VCL.TMSFNCTypes, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, VCL.Dialogs, VCL.TMSFNCCustomScrollControl;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, FMX.Types, Types, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes, FMX.TMSFNCCloudBase, FMX.TMSFNCCloudOAuth, FMX.TMSFNCUtils,
  CloudServices, FMX.TMSFNCCustomControl, FMX.Layouts, FMX.TMSFNCTypes, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.Edit, FMX.Dialogs, FMX.TMSFNCCustomScrollControl;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Types, Dialogs, Controls, StdCtrls, LCLTMSFNCCloudBase, LCLTMSFNCCloudOAuth, LCLTMSFNCUtils, ComCtrls,
  CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCTypes, LCLTMSFNCGraphics, LCLTMSFNCGraphicsTypes, ExtCtrls, LCLTMSFNCCustomScrollControl;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, Types, SysUtils, WEBLib.ExtCtrls, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth, WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCTypes, WEBLib.TMSFNCGraphics,
  WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCCloudPackWEBReg, WEBLib.DesignIntF, WEBLib.TMSFNCCustomScrollControl;
  {$ENDIF}

type
  {$IFDEF FMX}
  TTMSFNCCloudSelectServiceScrollBox = TVertScrollBox;
  {$ELSE}
  TTMSFNCCloudSelectServiceScrollBox = TScrollBox;
  {$ENDIF}

  TTMSFNCCloudSelectService = class
  private
    FBuilding: Boolean;
    FAuthPanel: TTMSFNCCustomControl;
    FScrollBox: TTMSFNCCloudSelectServiceScrollBox;
    FBuildMode: Integer;
    FBuildTimer: TTimer;
    FCreating: Boolean;
    FFilter: string;
    FForm: TCustomForm;
    FActiveServiceClass: TTMSFNCCloudServiceClass;
    FEditValues: array of TEdit;
  protected
    procedure DoFormResized(Sender: TObject);
    procedure DoScrollBoxResized(Sender: TObject);
    procedure DoAuthenticateClicked(Sender: TObject);
    procedure DoCancelClicked(Sender: TObject);
    procedure DoConnected(Sender: TObject);
    procedure DoReturnClicked(Sender: TObject);
    procedure DoBuild(Sender: TObject);
    procedure DoFilter(Sender: TObject);
  public
    destructor Destroy; override;
    procedure Init(AForm: TCustomForm);
    procedure CreateTiles(AScrollBox: TTMSFNCCloudSelectServiceScrollBox);
    procedure PromptServiceDetails(ADetails, AValues: TTMSFNCCloudOAuthServiceStringArray);
  end;

  TTMSFNCCloudSelectServiceTile = class(TTMSFNCCustomControl)
  private
    FMouseEntered: Boolean;
    FConnectButton: TButton;
    FClearButton: TButton;
    FServiceClass: TTMSFNCCloudServiceClass;
    FBitmap: TTMSFNCBitmapHelperClass;
    FSelectService: TTMSFNCCloudSelectService;
  protected
    procedure SetDefaultStyle;
    procedure DoBitmapChanged(Sender: TObject);
    procedure UpdateControlAfterResize; override;
    procedure Click; override;
    procedure DoConnectButtonClicked(Sender: TObject);
    procedure DoClearButtonClicked(Sender: TObject);
    procedure Connect;
    procedure HandleMouseLeave; override;
    procedure HandleMouseEnter; override;
  public
    constructor Create(AOwner: TComponent; AServiceClass: TTMSFNCCloudServiceClass; ASelectService: TTMSFNCCloudSelectService); reintroduce;
    destructor Destroy; override;
    procedure Draw({%H-}AGraphics: TTMSFNCGraphics; {%H-}ARect: TRectF); override;
    property Bitmap: TTMSFNCBitmapHelperClass read FBitmap;
  end;

implementation

uses
  Math;

type
  TCustomFormOpen = class(TCustomForm);
  TTMSFNCCustomControlOpen = class(TTMSFNCCustomControl);

procedure TTMSFNCCloudSelectService.CreateTiles(AScrollBox: TTMSFNCCloudSelectServiceScrollBox);
var
  t: TTMSFNCCloudSelectServiceTile;
  x, y, w, h: Single;
  I: Integer;
  c: Integer;
  sc: TTMSFNCCloudServiceClass;
  {$IFDEF WEBLIB}
  r: TRegisteredComponent;
  {$ENDIF}
  spc: Single;
  cw: Integer;
begin
  spc := 20;
  x := spc;
  y := spc;
  w := 250;
  h := 150;

  cw := 10;
  while (cw > 0) and (((AScrollBox.Width - spc * 3 - (cw - 1) * spc) / cw) < w) do
    Dec(cw);

  cw := Max(1, cw);

  w := Max(250, ((AScrollBox.Width - spc * 3) - (cw - 1) * spc) / cw);

  TTMSFNCCloudService.ClearComponent(AScrollBox);
  c := TTMSFNCCloudServiceRegistration.RegisteredServiceCount;
  for I := 0 to c - 1 do
  begin
    sc := TTMSFNCCloudServiceRegistration.GetRegisteredService(I);
    if TTMSFNCUtils.MatchStrEx('*' + FFilter + '*', sc.GetTitle, False) or (FFilter = '') then
    begin
      t := TTMSFNCCloudSelectServiceTile.Create(AScrollBox, sc, Self);
      t.Parent := AScrollBox;
      {$IFDEF WEBLIB}
      r := GetRegisteredComponent(sc.GetCloudServiceClass.ClassName);
      if Assigned(r) then
        t.Bitmap.LoadFromResource(r.Icon);
      {$ELSE}
      t.Bitmap.LoadFromResource(UpperCase(sc.GetCloudServiceClass.ClassName));
      {$ENDIF}

      if (x + w + spc > AScrollBox.Width) and (I > 0) then
      begin
        x := spc;
        y := y + h + spc;
      end;

      t.Left := Round(x);
      t.Top := Round(y);
      t.Width := Round(w);
      t.Height := Round(h);

      x := x + w + 20;
    end;
  end;
end;

destructor TTMSFNCCloudSelectService.Destroy;
begin
  FreeAndNil(FBuildTimer);
  inherited;
end;

procedure TTMSFNCCloudSelectService.DoCancelClicked(Sender: TObject);
begin
  FBuildMode := 0;
  FBuildTimer.Enabled := True;
end;

procedure TTMSFNCCloudSelectService.DoConnected(Sender: TObject);
begin
  FBuildMode := 2;
  FBuildTimer.Enabled := True;
end;

procedure TTMSFNCCloudSelectService.DoFilter(Sender: TObject);
begin
  FFilter := (Sender as TEdit).Text;
  FBuildMode := 1;
  FBuildTimer.Enabled := True;
end;

procedure TTMSFNCCloudSelectService.DoFormResized(Sender: TObject);
begin
  if (FBuildMode = 3) and Assigned(FAuthPanel) and Assigned(FForm) then
    FAuthPanel.SetBounds(Round((FForm.ClientWidth - FAuthPanel.Width) / 2), Round((FForm.ClientHeight - FAuthPanel.Height) / 2), FAuthPanel.Width, FAuthPanel.Height);

  if (FBuildMode = 2) and Assigned(FActiveServiceClass) then
    FActiveServiceClass.PerformResize;
end;

procedure TTMSFNCCloudSelectService.DoReturnClicked(Sender: TObject);
begin
  FBuildMode := 0;
  FBuildTimer.Enabled := True;
end;

procedure TTMSFNCCloudSelectService.DoAuthenticateClicked(Sender: TObject);
var
  I: Integer;
  s: TStringList;
begin
  if Assigned(FActiveServiceClass) then
  begin
    FActiveServiceClass.SetClientID(FEditValues[0].Text);
    FActiveServiceClass.SetSecret(FEditValues[1].Text);
    FActiveServiceClass.SetKey(FEditValues[2].Text);
    FActiveServiceClass.SetCallBackURL(FEditValues[3].Text);
    s := TStringList.Create;
    try
      s.Delimiter := ';';
      for I := 4 to Length(FEditValues) - 1 do
        s.Add(FEditValues[I].Text);
      FActiveServiceClass.SetValues(s.Text);
    finally
      s.Free;
    end;
    FActiveServiceClass.Save;

    if (FActiveServiceClass.GetClientID <> '') or (FActiveServiceClass.GetKey <> '') then
      FActiveServiceClass.Connect
    else
      ShowMessage('Please enter the correct authentication settings');
  end;
end;

procedure TTMSFNCCloudSelectService.DoBuild(Sender: TObject);
var
  a, b: TTMSFNCCloudOAuthServiceStringArray;
begin
  FBuildTimer.Enabled := False;
  FBuilding := True;
  if Assigned(FActiveServiceClass) then
    FActiveServiceClass.UnInit;

  case FBuildMode of
    0: Init(FForm);
    1: CreateTiles(FScrollBox);
    2:
    begin
      if Assigned(FActiveServiceClass) then
        FActiveServiceClass.Init(FForm);
    end;
    3:
    begin
      if Assigned(FActiveServiceClass) then
      begin
        if not FActiveServiceClass.HasTokens or (not (FActiveServiceClass.GetClientID <> '') and not (FActiveServiceClass.GetKey <> '')) then
        begin
          a := FActiveServiceClass.GetAuthenticationDetailsLabels;
          b := FActiveServiceClass.GetAuthenticationDetailsValues;
          PromptServiceDetails(a, b);
        end
        else
          FActiveServiceClass.Connect;
      end;
    end;
  end;
  FBuilding := False;
end;

procedure TTMSFNCCloudSelectService.DoScrollBoxResized(Sender: TObject);
begin
  if FCreating or FBuilding then
    Exit;

  FBuildMode := 1;
  FBuildTimer.Enabled := True;
end;

procedure TTMSFNCCloudSelectService.Init(AForm: TCustomForm);
var
  lblTitle: TLabel;
  edFilter: TEdit;
begin
  if not Assigned(FBuildTimer) then
  begin
    FBuildTimer := TTimer.Create(nil);
    FBuildTimer.OnTimer := {$IFDEF LCL}@{$ENDIF}DoBuild;
    FBuildTimer.Interval := 1;
    FBuildTimer.Enabled := False;
  end;

  TTMSFNCCloudService.OnConnected := {$IFDEF LCL}@{$ENDIF}DoConnected;
  TTMSFNCCloudService.OnReturnClicked := {$IFDEF LCL}@{$ENDIF}DoReturnClicked;

  FForm := AForm;
  TCustomFormOpen(FForm).OnResize := {$IFDEF LCL}@{$ENDIF}DoFormResized;
  FCreating := True;

  TTMSFNCCloudService.ClearComponent(FForm);

  edFilter := TEdit.Create(FForm);
  edFilter.Parent := FForm;
  SetControlAlignment(edFilter, caTop);
  SetControlMargins(edFilter, 10, 10, 10, 10);
  edFilter.Height := 35;
  edFilter.Text := FFilter;
  SetControlPosition(edFilter, 0, 1);
  edFilter.OnChange := {$IFDEF LCL}@{$ENDIF}DoFilter;

  lblTitle := TLabel.Create(FForm);
  lblTitle.Parent := FForm;
  lblTitle.AutoSize := True;
  SetControlAlignment(lblTitle, caTop);
  SetLabelText(lblTitle, 'Select Service');
  SetLabelFontColor(lblTitle, gcSteelblue);
  SetControlMargins(lblTitle, 10, 10, 10, 10);
  SetControlPosition(lblTitle, 0, 0);

  TTMSFNCUtils.SetFontSize(lblTitle.Font, 24);

  FScrollBox := TTMSFNCCloudSelectServiceScrollBox.Create(FForm);
  FScrollBox.Parent := FForm;
  {$IFNDEF FMX}
  FScrollBox.BorderStyle := bsNone;
  {$ENDIF}
  FScrollBox.OnResize := {$IFDEF LCL}@{$ENDIF}DoScrollBoxResized;

  SetControlAlignment(FScrollBox, caClient);
  SetControlMargins(FScrollBox, 10, 10, 10, 10);

  CreateTiles(FScrollBox);
  FCreating := False;
end;

procedure TTMSFNCCloudSelectService.PromptServiceDetails(ADetails, AValues: TTMSFNCCloudOAuthServiceStringArray);
var
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  I: Integer;
  y: Integer;
  lblTitle: TLabel;
  b: TButton;

  function GetAveCharSize: TPoint;
  var
    K: Integer;
    Buffer: string;
    g: TTMSFNCGraphics;
    sz: TSizeF;
  begin
    Buffer := '';
    for K := 0 to 25 do Buffer := Buffer + Chr(K + Ord('A'));
    for K := 0 to 25 do Buffer := Buffer + Chr(K + Ord('a'));

    g := TTMSFNCGraphics.CreateBitmapCanvas;
    g.BeginScene;
    try
      sz := g.CalculateTextSize(Buffer);
      Result.X := Round(sz.cx);
      Result.Y := Round(sz.cy);
    finally
      g.EndScene;
      g.Free;
    end;

    Result.X := Result.X div 52;
  end;
begin
  TTMSFNCCloudService.ClearComponent(FForm);

  lblTitle := TLabel.Create(FForm);
  lblTitle.Parent := FForm;
  lblTitle.AutoSize := True;
  SetLabelText(lblTitle, 'Authentication Details');
  SetLabelFontColor(lblTitle, gcSteelblue);
  SetControlAlignment(lblTitle, caTop);
  SetControlMargins(lblTitle, 10, 10, 10, 10);
  ClearStyledSettings(lblTitle);

  TTMSFNCUtils.SetFontSize(lblTitle.Font, 24);

  FAuthPanel := TTMSFNCCustomControl.Create(FForm);
  try
    TTMSFNCCustomControlOpen(FAuthPanel).Fill.Color := gcWhite;
    TTMSFNCCustomControlOpen(FAuthPanel).Fill.ColorTo := gcWhitesmoke;
    TTMSFNCCustomControlOpen(FAuthPanel).Fill.Kind := gfkGradient;

    DialogUnits := GetAveCharSize;
    FAuthPanel.Width := TTMSFNCUtils.MulDivInt(180, DialogUnits.X, 4);
    y := 0;

    SetLength(FEditValues, Length(ADetails));
    for I := 0 to Length(ADetails) - 1 do
    begin
      Prompt := TLabel.Create(FAuthPanel);
      Prompt.Parent := FAuthPanel;
      SetLabelFontColor(Prompt, gcSteelblue);
      SetLabelText(Prompt, ADetails[I]);
      SetControlPosition(Prompt, TTMSFNCUtils.MulDivInt(8, DialogUnits.X, 4), y + TTMSFNCUtils.MulDivInt(8, DialogUnits.Y, 8));
      Prompt.AutoSize := True;
      Prompt.Width := 100;
      ClearStyledSettings(Prompt);

      Edit := TEdit.Create(FAuthPanel);
      Edit.Parent := FAuthPanel;
      {$IFDEF FMX}
      Edit.Position.X := Prompt.Position.X;
      Edit.Position.Y := Prompt.Position.Y + DialogUnits.Y + 5;
      {$ENDIF}
      {$IFDEF CMNWEBLIB}
      Edit.Left := Prompt.Left;
      Edit.Top := Prompt.Top + DialogUnits.Y + 5;
      {$ENDIF}
      if (I >= 0) and (I <= Length(AValues) - 1) then
        Edit.Text := AValues[I];

      Edit.Width := TTMSFNCUtils.MulDivInt(164, DialogUnits.X, 4);

      if ADetails[I] <> '' then
      begin
        {$IFDEF FMX}
        y := y + Round(DialogUnits.Y + Edit.Height) + 15;
        {$ELSE}
        y := y + DialogUnits.Y + Edit.Height + 15;
        {$ENDIF}
      end
      else
      begin
        Prompt.Visible := False;
        Edit.Visible := False;
      end;

      FEditValues[I] := Edit;
    end;

    ButtonTop := y + 25;
    ButtonWidth := TTMSFNCUtils.MulDivInt(65, DialogUnits.X, 4);
    ButtonHeight := TTMSFNCUtils.MulDivInt(14, DialogUnits.Y, 8);

    b := TButton.Create(FAuthPanel);
    b.Parent := FAuthPanel;
    {$IFDEF FMX}
    b.Text := 'Authenticate';
    {$ENDIF}
    {$IFDEF CMNWEBLIB}
    b.Caption := 'Authenticate';
    {$ENDIF}
    b.OnClick := {$IFDEF LCL}@{$ENDIF}DoAuthenticateClicked;
    b.Default := True;
    b.SetBounds(TTMSFNCUtils.MulDivInt(25, DialogUnits.X, 4), ButtonTop, ButtonWidth, ButtonHeight);

    b := TButton.Create(FAuthPanel);
    b.Parent := FAuthPanel;
    {$IFDEF FMX}
    b.Text := 'Cancel';
    {$ENDIF}
    {$IFDEF CMNWEBLIB}
    b.Caption := 'Cancel';
    {$ENDIF}
    b.OnClick := {$IFDEF LCL}@{$ENDIF}DoCancelClicked;
    b.Cancel := True;
    {$IFDEF FMX}
    b.SetBounds(TTMSFNCUtils.MulDivInt(95, DialogUnits.X, 4), y + 25, ButtonWidth, ButtonHeight);
    FAuthPanel.Height := Round(b.Position.Y + b.Height + 38);
    {$ENDIF}
    {$IFDEF CMNWEBLIB}
    b.SetBounds(TTMSFNCUtils.MulDivInt(95, DialogUnits.X, 4), y + 25, ButtonWidth, ButtonHeight);
    FAuthPanel.Height := Round(b.Top + b.Height + 13);
    {$ENDIF}

    FAuthPanel.Parent := FForm;
    FAuthPanel.SetBounds(Round((FForm.ClientWidth - FAuthPanel.Width) / 2), Round((FForm.ClientHeight - FAuthPanel.Height) / 2), FAuthPanel.Width, FAuthPanel.Height);
  finally

  end;
end;

{ TTMSFNCCloudSelectServiceTile }

procedure TTMSFNCCloudSelectServiceTile.Click;
begin
  inherited;
  Connect;
end;

procedure TTMSFNCCloudSelectServiceTile.Connect;
begin
  FConnectButton.Enabled := False;
  SetButtonText(FConnectButton, 'Connecting ...');
  if FSelectService.FActiveServiceClass <> FServiceClass then
    FServiceClass.CreateService;

  FSelectService.FActiveServiceClass := FServiceClass;

  if Assigned(FSelectService) then
  begin
    FSelectService.FBuildMode := 3;
    FSelectService.FBuildTimer.Enabled := True;
  end;
end;

constructor TTMSFNCCloudSelectServiceTile.Create(AOwner: TComponent;
  AServiceClass: TTMSFNCCloudServiceClass; ASelectService: TTMSFNCCloudSelectService);
begin
  inherited Create(AOwner);
  Cursor := crHandPoint;
  FSelectService := ASelectService;
  FServiceClass := AServiceClass;

  FBitmap := TTMSFNCBitmap.Create;
  FBitmap.OnChange := {$IFDEF LCL}@{$ENDIF}DoBitmapChanged;
  SetDefaultStyle;
  FConnectButton := TButton.Create(Self);
  FConnectButton.Width := 100;
  FConnectButton.Cursor := crArrow;
  SetButtonText(FConnectButton, 'Connect');
  FConnectButton.Parent := Self;
  FConnectButton.OnClick := {$IFDEF LCL}@{$ENDIF}DoConnectButtonClicked;
  ClearStyledSettings(FConnectButton);

  FClearButton := TButton.Create(Self);
  FClearButton.Width := 50;
  SetButtonText(FClearButton, 'Clear');
  FClearButton.Cursor := crArrow;
  FClearButton.Parent := Self;
  FClearButton.OnClick := {$IFDEF LCL}@{$ENDIF}DoClearButtonClicked;
  ClearStyledSettings(FClearButton);
end;

destructor TTMSFNCCloudSelectServiceTile.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TTMSFNCCloudSelectServiceTile.DoBitmapChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TTMSFNCCloudSelectServiceTile.DoClearButtonClicked(Sender: TObject);
begin
  if FSelectService.FActiveServiceClass <> FServiceClass then
    FServiceClass.CreateService;

  FSelectService.FActiveServiceClass := FServiceClass;
  if Assigned(FServiceClass) then
    FServiceClass.Clear;
end;

procedure TTMSFNCCloudSelectServiceTile.DoConnectButtonClicked(Sender: TObject);
begin
  Connect;
end;

procedure TTMSFNCCloudSelectServiceTile.Draw(AGraphics: TTMSFNCGraphics;
  ARect: TRectF);
var
  bmpr, txtr, descr: TRectF;
begin
  inherited;
  if Assigned(FServiceClass) then
  begin
    if FMouseEntered then
      AGraphics.Font.Color := gcWhite;

    bmpr := RectF(ARect.Left + 5, ARect.Top + 5, ARect.Left + 38, ARect.Top + 38);
    AGraphics.DrawBitmap(bmpr, Bitmap);

    txtr := RectF(ARect.Left + 43, ARect.Top + 5, ARect.Right - 43, ARect.Top + 38);
    TTMSFNCUtils.SetFontSize(AGraphics.Font, 14);
    AGraphics.DrawText(txtr, FServiceClass.GetTitle);

    descr := RectF(ARect.Left + 5, ARect.Top + 43, ARect.Right - 5, ARect.Bottom - 30);
    TTMSFNCUtils.SetFontSize(AGraphics.Font, 12);
    AGraphics.DrawText(descr, FServiceClass.GetDescription, True, gtaLeading, gtaLeading);
  end;
end;

procedure TTMSFNCCloudSelectServiceTile.HandleMouseEnter;
begin
  inherited;
  FMouseEntered := True;
  Fill.Color := Lighter(gcSteelblue, 20);
  Fill.ColorTo := Darker(gcSteelblue, 20);
  Fill.Kind := gfkGradient;
end;

procedure TTMSFNCCloudSelectServiceTile.HandleMouseLeave;
begin
  inherited;
  FMouseEntered := False;
  SetDefaultStyle;
end;

procedure TTMSFNCCloudSelectServiceTile.SetDefaultStyle;
begin
  Fill.Color := gcWhite;
  Fill.ColorTo := gcWhitesmoke;
  Fill.Kind := gfkGradient;
end;

procedure TTMSFNCCloudSelectServiceTile.UpdateControlAfterResize;
begin
  inherited;
  if Assigned(FConnectButton) then
    FConnectButton.SetBounds(Width - FConnectButton.Width - 5, Height - FConnectButton.Height - 5, FConnectButton.Width, FConnectButton.Height);

  if Assigned(FClearButton) then
    FClearButton.SetBounds(5, Height - FClearButton.Height - 5, FClearButton.Width, FClearButton.Height);
end;

end.

