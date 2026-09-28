unit UHelper;

interface

uses
  SysUtils, Next.Core.Promises, Next.Core.Void,
  FMX.TMSFNCCloudBase, FMX.TMSFNCCloudGoogleCalendar;

type
  TTMSFNCCloudGoogleCalendarPromise = class(TTMSFNCCloudGoogleCalendar)
  private
    FResolve: TProc<TVoid>;
    FReject: TProc<Exception>;
  protected
    procedure DoConnected; override;
    procedure DoGetCalendars(const ARequestResult: TTMSFNCCloudBaseRequestResult); override;
    procedure DoGetCalendar(const ARequestResult: TTMSFNCCloudBaseRequestResult); override;
  public
    procedure ConnectPromise(AResolve: TProc<TVoid>; AReject: TProc<Exception>);
    procedure GetCalendarsPromise(AResolve: TProc<TVoid>; AReject: TProc<Exception>);
    procedure GetCalendarPromise(AID: string; AResolve: TProc<TVoid>; AReject: TProc<Exception>);
  end;

implementation

{ TTMSFNCCloudGoogleCalendarPromise }

procedure TTMSFNCCloudGoogleCalendarPromise.ConnectPromise(AResolve: TProc<TVoid>;
  AReject: TProc<Exception>);
begin
  FResolve := AResolve;
  FReject := AReject;
  Connect;
end;

procedure TTMSFNCCloudGoogleCalendarPromise.DoConnected;
begin
  inherited;
  FResolve(Void);
end;

procedure TTMSFNCCloudGoogleCalendarPromise.DoGetCalendar(
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  inherited;
  if ARequestResult.Success then
    FResolve(Void)
  else
    FReject(Exception.Create('Could not get calendar'));
end;

procedure TTMSFNCCloudGoogleCalendarPromise.DoGetCalendars(
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  inherited;
  if ARequestResult.Success then
    FResolve(Void)
  else
    FReject(Exception.Create('Could not get calendars'));
end;

procedure TTMSFNCCloudGoogleCalendarPromise.GetCalendarPromise(AID: string;
  AResolve: TProc<TVoid>; AReject: TProc<Exception>);
begin
  FResolve := AResolve;
  FReject := AReject;
  GetCalendar(AID);
end;

procedure TTMSFNCCloudGoogleCalendarPromise.GetCalendarsPromise(
  AResolve: TProc<TVoid>; AReject: TProc<Exception>);
begin
  FResolve := AResolve;
  FReject := AReject;
  GetCalendars;
end;

end.
