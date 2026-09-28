unit UHelper;

interface

uses
  SysUtils, Web, js, WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudGoogleCalendar;

type
  TTMSFNCCloudGoogleCalendarPromise = class(TTMSFNCCloudGoogleCalendar)
  private
    FResolve: TJSPromiseResolver;
    FReject: TJSPromiseResolver;
  protected
    procedure DoConnected; override;
    procedure DoGetCalendars(const ARequestResult: TTMSFNCCloudBaseRequestResult); override;
    procedure DoGetCalendar(const ARequestResult: TTMSFNCCloudBaseRequestResult); override;
  public
    function ConnectPromise: TJSPromise;
    function GetCalendarsPromise: TJSPromise;
    function GetCalendarPromise(AID: string): TJSPromise;
  end;

implementation

{ TTMSFNCCloudGoogleCalendarPromise }

function TTMSFNCCloudGoogleCalendarPromise.ConnectPromise: TJSPromise;
begin
  Result := TJSPromise.new(procedure (AResolve, AReject: TJSPromiseResolver)
  begin
    FResolve := AResolve;
    FReject := AReject;
    Connect;
  end);
end;

procedure TTMSFNCCloudGoogleCalendarPromise.DoConnected;
begin
  inherited;
  FResolve(nil);
end;

procedure TTMSFNCCloudGoogleCalendarPromise.DoGetCalendar(
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  inherited;
  if ARequestResult.Success then
    FResolve(nil)
  else
    FReject('Could not get calendar');
end;

procedure TTMSFNCCloudGoogleCalendarPromise.DoGetCalendars(
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  inherited;
  if ARequestResult.Success then
    FResolve(nil)
  else
    FReject('Could not get calendars');
end;

function TTMSFNCCloudGoogleCalendarPromise.GetCalendarPromise(AID: string): TJSPromise;
begin
  Result := TJSPromise.new(procedure (AResolve, AReject: TJSPromiseResolver)
  begin
    FResolve := AResolve;
    FReject := AReject;
    GetCalendar(AID);
  end);
end;

function TTMSFNCCloudGoogleCalendarPromise.GetCalendarsPromise: TJSPromise;
begin
  Result := TJSPromise.new(procedure (AResolve, AReject: TJSPromiseResolver)
  begin
    FResolve := AResolve;
    FReject := AReject;
    GetCalendars;
  end);
end;

end.
