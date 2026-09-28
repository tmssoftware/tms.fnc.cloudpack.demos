unit TMSFNCCloudGoogleCalendar;

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
  CloudServices, VCL.TMSFNCCloudGoogleCalendar, VCL.TMSFNCCustomControl, DateUtils,
  VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudGoogleCalendar, FMX.TMSFNCCustomControl,
  FMX.ListBox, FMX.Edit, FMX.DateTimeCtrls, FMX.Memo, DateUtils, FMX.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudGoogleCalendar,
  LCLTMSFNCCustomControl, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCloudGoogleCalendar,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCCloudDemoListBox;
  {$ENDIF}

type
  TTMSFNCCloudGoogleCalendarService = class(TTMSFNCCloudService)
  private
    class var lbCalendars: TTMSFNCCloudDemoListBox;
    class var lbEvents: TTMSFNCCloudDemoListBox;
    class var edTitle: TEdit;
    class var edLocation: TEdit;
    class var meDescription: TMemo;
    class var edCalendar: TEdit;
    {$IFDEF FMX}
    class var deStart: TDateEdit;
    class var deEnd: TDateEdit;
    class var teStart: TTimeEdit;
    class var teEnd: TTimeEdit;
    class var deStartDate: TDateEdit;
    class var deEndDate: TDateEdit;
    {$ENDIF}
    {$IFDEF LCLWEBLIB}
    class var deStart: TDateTimePicker;
    class var deEnd: TDateTimePicker;
    class var teStart: TDateTimePicker;
    class var teEnd: TDateTimePicker;
    class var deStartDate: TDateTimePicker;
    class var deEndDate: TDateTimePicker;
    {$ENDIF}
    {$IFDEF VCL}
    class var deStart: TDateTimePicker;
    class var deEnd: TDateTimePicker;
    class var teStart: TDateTimePicker;
    class var teEnd: TDateTimePicker;
    class var deStartDate: TDateTimePicker;
    class var deEndDate: TDateTimePicker;
    {$ENDIF}
    class var cbAllDay: TCheckBox;
    class var cbRecurrent: TCheckBox;
    class var lbTitle: TLabel;
  protected
    class procedure DoGetCalendarsResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetCalendars(Sender: TObject);

    class procedure DoGetCalendarResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetCalendar(Sender: TObject);

    class procedure DoGetEventDetail(Sender: TObject);

    class procedure DoAddEvent(Sender: TObject);
    class procedure DoUpdateEvent(Sender: TObject);
    class procedure DoDeleteEvent(Sender: TObject);

    class procedure DoAddCalendar(Sender: TObject);
    class procedure DoUpdateCalendar(Sender: TObject);
    class procedure DoDeleteCalendar(Sender: TObject);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function GoogleCalendar: TTMSFNCCloudGoogleCalendar;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGoogleCalendarService }

class procedure TTMSFNCCloudGoogleCalendarService.DoAddCalendar(
  Sender: TObject);
var
  c: TTMSFNCCloudGoogleCal;
begin
  if edCalendar.Text = '' then
    Exit;

  c := GoogleCalendar.Calendars.Add;
  c.Summary := edCalendar.Text;
  GoogleCalendar.AddCalendar(c);
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoAddEvent(
  Sender: TObject);
var
  c: TTMSFNCCloudGoogleCalendarItem;
begin
  if lbCalendars.ItemIndex < 0 then
    Exit;

  c := GoogleCalendar.Items.Add;
  c.CalendarID := TTMSFNCCloudGoogleCal(lbCalendars.Items[lbCalendars.ItemIndex].DataObject).ID;
  c.Summary := edTitle.Text;
  c.StartTime := deStart.Date;
  c.EndTime := deEnd.Date;
  c.Description := meDescription.Text;
  c.Location := edLocation.Text;

  {$IFDEF FMX}
  if cbAllday.IsChecked then
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  if cbAllday.Checked then
  {$ENDIF}
  {$IFDEF VCL}
  if cbAllday.Checked then
  {$ENDIF}
  begin
    c.StartTime := EncodeDateTime(YearOf(deStart.Date), MonthOf(deStart.Date), DayOf(deStart.Date), 0, 0, 0, 0);
    c.EndTime := EncodeDateTime(YearOf(deEnd.Date), MonthOf(deEnd.Date), DayOf(deEnd.Date), 0, 0, 0, 0);
    c.IsAllDay := true;
  end
  else
  begin
    c.StartTime := EncodeDateTime(YearOf(deStart.Date), MonthOf(deStart.Date), DayOf(deStart.Date), HourOf(teStart.Time), MinuteOf(teStart.Time), SecondOf(teStart.Time),0);
    c.EndTime := EncodeDateTime(YearOf(deEnd.Date), MonthOf(deEnd.Date), DayOf(deEnd.Date), HourOf(teEnd.Time), MinuteOf(teEnd.Time), SecondOf(teEnd.Time),0);
    c.IsAllDay := false;
  end;

  GoogleCalendar.Add(c);
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoDeleteCalendar(
  Sender: TObject);
begin
  if lbCalendars.ItemIndex < 0 then
    Exit;

  GoogleCalendar.DeleteCalendar(TTMSFNCCloudGoogleCal(lbCalendars.Items[lbCalendars.ItemIndex].DataObject));
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoDeleteEvent(
  Sender: TObject);
begin
  if lbEvents.ItemIndex < 0 then
    Exit;

  GoogleCalendar.Delete(TTMSFNCCloudGoogleCalendarItem(lbEvents.Items[lbEvents.ItemIndex].DataObject));
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoGetCalendar(
  Sender: TObject);
var
 c: TTMSFNCCloudGoogleCal;
begin
  if lbCalendars.ItemIndex < 0 then
    Exit;

  StartLoading;
  c := TTMSFNCCloudGoogleCal(lbCalendars.Items[lbCalendars.ItemIndex].DataObject);
  edCalendar.Text := c.Summary;
  GoogleCalendar.GetCalendar(c.ID, deStartDate.Date, EncodeDateTime(YearOf(deEndDate.Date), MonthOf(deEndDate.Date), DayOf(deEndDate.Date), 23, 59, 59, 999));
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoGetCalendarResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
  c: TTMSFNCCloudGoogleCalendarItem;
begin
  StopLoading;
  SetLabelText(lbTitle, 'Events');
  lbEvents.Visible := True;
  lbCalendars.Visible := False;
  lbEvents.Items.Clear;
  for I := 0 to GoogleCalendar.Items.Count - 1 do
  begin
    c := GoogleCalendar.Items[I];
    lbEvents.AddItem(c.Summary + sLineBreak + DateTimeToStr(c.StartTime), '', c);
  end;
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoGetCalendars(
  Sender: TObject);
begin
  StartLoading;
  GoogleCalendar.GetCalendars;
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoGetCalendarsResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  StopLoading;
  SetLabelText(lbTitle, 'Calendars');
  lbCalendars.Visible := True;
  lbEvents.Visible := False;
  lbCalendars.Items.Clear;
  for I := 0 to GoogleCalendar.Calendars.Count - 1 do
    lbCalendars.AddItem(GoogleCalendar.Calendars[I].Summary, '', GoogleCalendar.Calendars[I]);
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoGetEventDetail(
  Sender: TObject);
var
  c: TTMSFNCCloudGoogleCalendarItem;
begin
  if lbEvents.ItemIndex < 0 then
    Exit;

  c := TTMSFNCCloudGoogleCalendarItem(lbEvents.Items[lbEvents.ItemIndex].DataObject);
  edTitle.Text := c.Summary;
  meDescription.Text := c.Description;
  edLocation.Text := c.Location;
  deStart.Date := c.StartTime;
  deEnd.Date := c.EndTime;
  teStart.Time := c.StartTime;
  teEnd.Time := c.EndTime;
  {$IFDEF FMX}
  cbAllDay.IsChecked := c.IsAllDay;
  cbRecurrent.IsChecked := (c.RecurringID <> '');
  {$ENDIF}
  {$IFDEF LCLWEB}
  cbAllDay.Checked := c.IsAllDay;
  cbRecurrent.Checked := (c.RecurringID <> '');
  {$ENDIF}
  {$IFDEF VCL}
  cbAllDay.Checked := c.IsAllDay;
  cbRecurrent.Checked := (c.RecurringID <> '');
  {$ENDIF}
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoUpdateCalendar(
  Sender: TObject);
begin
  if lbCalendars.ItemIndex < 0 then
    Exit;

  if edCalendar.Text = '' then
    Exit;

  GoogleCalendar.UpdateCalendar(TTMSFNCCloudGoogleCal(lbCalendars.Items[lbCalendars.ItemIndex].DataObject));
end;

class procedure TTMSFNCCloudGoogleCalendarService.DoUpdateEvent(
  Sender: TObject);
var
  c: TTMSFNCCloudGoogleCalendarItem;
begin
  if lbEvents.ItemIndex < 0 then
    Exit;

  c := TTMSFNCCloudGoogleCalendarItem(lbEvents.Items[lbEvents.ItemIndex].DataObject);
  c.CalendarID := TTMSFNCCloudGoogleCal(lbCalendars.Items[lbCalendars.ItemIndex].DataObject).ID;
  c.Summary := edTitle.Text;
  c.StartTime := deStart.Date;
  c.EndTime := deEnd.Date;
  c.Description := meDescription.Text;
  c.Location := edLocation.Text;

  {$IFDEF FMX}
  if cbAllday.IsChecked then
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  if cbAllday.Checked then
  {$ENDIF}
  {$IFDEF VCL}
  if cbAllday.Checked then
  {$ENDIF}
  begin
    c.StartTime := EncodeDateTime(YearOf(deStart.Date), MonthOf(deStart.Date), DayOf(deStart.Date), 0, 0, 0, 0);
    c.EndTime := EncodeDateTime(YearOf(deEnd.Date), MonthOf(deEnd.Date), DayOf(deEnd.Date), 0, 0, 0, 0);
    c.IsAllDay := true;
  end
  else
  begin
    c.StartTime := EncodeDateTime(YearOf(deStart.Date), MonthOf(deStart.Date), DayOf(deStart.Date), HourOf(teStart.Time), MinuteOf(teStart.Time), SecondOf(teStart.Time),0);
    c.EndTime := EncodeDateTime(YearOf(deEnd.Date), MonthOf(deEnd.Date), DayOf(deEnd.Date), HourOf(teEnd.Time), MinuteOf(teEnd.Time), SecondOf(teEnd.Time),0);
    c.IsAllDay := false;
  end;
  GoogleCalendar.Update(c);
end;

class function TTMSFNCCloudGoogleCalendarService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudGoogleCalendar;
end;

class function TTMSFNCCloudGoogleCalendarService.GetDescription: string;
begin
  Result := 'Manage Google Calendars and events';
end;

class function TTMSFNCCloudGoogleCalendarService.GetTitle: string;
begin
  Result := 'Google Calendar';
end;

class procedure TTMSFNCCloudGoogleCalendarService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  mid: Integer;
  l: TLabel;
begin
  inherited;

  mid := Round(AContent.Height / 2);

  b := TButton.Create(AContent);
  b.Parent := AContent;
  SetControlPosition(b, 10, 10);
  SetButtonText(b, 'Get Calendars');
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetCalendars;
  ClearStyledSettings(b);

  lbCalendars := TTMSFNCCloudDemoListBox.Create(AContent);
  lbCalendars.Parent := AContent;
  SetControlAlignment(lbCalendars, caClient);
  SetControlMargins(lbCalendars, 10, 40, 10, 10);
  lbCalendars.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];
  lbCalendars.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetCalendar;

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 50);
  SetLabelText(l, 'Name:');
  ClearStyledSettings(l);

  edCalendar := TEdit.Create(ADetailContent);
  edCalendar.Parent := ADetailContent;
  SetControlPosition(edCalendar, 120, 50);
  edCalendar.Width := 210;
  ClearStyledSettings(edCalendar);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddCalendar;
  SetControlPosition(b, 20, 80);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateCalendar;
  SetControlPosition(b, 130, 80);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteCalendar;
  SetControlPosition(b, 240, 80);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, 130);
  SetLabelText(l, 'From/To:');
  ClearStyledSettings(l);

  {$IFDEF FMX}
  deStartDate := TDateEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  deStartDate := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF VCL}
  deStartDate := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  deStartDate.Parent := ADetailContent;
  deStartDate.Date := IncMonth(deStartDate.Date, -2);
  deStartDate.Width := 100;
  SetControlPosition(deStartDate, 120, 130);

  {$IFDEF FMX}
  deEndDate := TDateEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  deEndDate := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF VCL}
  deEndDate := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  deEndDate.Parent := ADetailContent;
  deEndDate.Date := IncMonth(deEndDate.Date, 1);
  deEndDate.Width := 100;
  SetControlPosition(deEndDate, 230, 130);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  SetControlPosition(b, 20, 160);
  SetButtonText(b, 'Get Events');
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetCalendar;
  ClearStyledSettings(b);

  lbTitle := TLabel.Create(AContent);
  lbTitle.Parent := AContent;
  SetControlPosition(lbTitle, 130, 15);
  SetLabelText(lbTitle, 'Calendars');
  ClearStyledSettings(lbTitle);

  lbEvents := TTMSFNCCloudDemoListBox.Create(AContent);
  lbEvents.Parent := AContent;
  lbEvents.ItemHeight := 40;
  SetControlAlignment(lbEvents, caClient);
  SetControlMargins(lbEvents, 10, 40, 10, 10);
  lbEvents.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];
  lbEvents.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetEventDetail;

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, mid + 30);
  SetLabelText(l, 'Title:');
  ClearStyledSettings(l);

  edTitle := TEdit.Create(ADetailContent);
  edTitle.Parent := ADetailContent;
  SetControlPosition(edTitle, 120, mid + 30);
  edTitle.Width := 210;
  ClearStyledSettings(edTitle);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, mid + 60);
  SetLabelText(l, 'Location:');
  ClearStyledSettings(l);

  edLocation := TEdit.Create(ADetailContent);
  edLocation.Parent := ADetailContent;
  SetControlPosition(edLocation, 120, mid + 60);
  edLocation.Width := 210;
  ClearStyledSettings(edLocation);

  cbAllDay := TCheckBox.Create(ADetailContent);
  cbAllDay.Parent := ADetailContent;
  SetControlPosition(cbAllDay, 120, mid + 90);
  {$IFDEF FMX}
  cbAllDay.Text := 'All day event';
  {$ENDIF}
  {$IFNDEF FMX}
  cbAllDay.Caption := 'All day event';
  {$ENDIF}

  cbRecurrent := TCheckBox.Create(ADetailContent);
  cbRecurrent.Parent := ADetailContent;
  SetControlPosition(cbRecurrent, 220, mid + 90);
  {$IFDEF FMX}
  cbRecurrent.Text := 'Recurrent event';
  {$ENDIF}
  {$IFNDEF FMX}
  cbRecurrent.Caption := 'Recurrent event';
  {$ENDIF}
  cbRecurrent.Enabled := False;

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, mid + 120);
  SetLabelText(l, 'Start:');
  ClearStyledSettings(l);

  {$IFDEF FMX}
  deStart := TDateEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  deStart := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF VCL}
  deStart := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  deStart.Parent := ADetailContent;
  deStart.Width := 100;
  SetControlPosition(deStart, 120, mid + 120);

  {$IFDEF FMX}
  teStart := TTimeEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  teStart := TDateTimePicker.Create(ADetailContent);
  teStart.Kind := dtkTime;
  {$ENDIF}
  {$IFDEF VCL}
  teStart := TDateTimePicker.Create(ADetailContent);
  teStart.Kind := dtkTime;
  {$ENDIF}
  teStart.Parent := ADetailContent;
  teStart.Width := 100;
  SetControlPosition(teStart, 230, mid + 120);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, mid + 150);
  SetLabelText(l, 'End:');
  ClearStyledSettings(l);

  {$IFDEF FMX}
  deEnd := TDateEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  deEnd := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF VCL}
  deEnd := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  deEnd.Parent := ADetailContent;
  deEnd.Width := 100;
  SetControlPosition(deEnd, 120, mid + 150);

  {$IFDEF FMX}
  teEnd := TTimeEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  teEnd := TDateTimePicker.Create(ADetailContent);
  teEnd.Kind := dtkTime;
  {$ENDIF}
  {$IFDEF VCL}
  teEnd := TDateTimePicker.Create(ADetailContent);
  teEnd.Kind := dtkTime;
  {$ENDIF}
  teEnd.Parent := ADetailContent;
  teEnd.Width := 100;
  SetControlPosition(teEnd, 230, mid + 150);

  l := TLabel.Create(ADetailContent);
  l.Parent := ADetailContent;
  SetControlPosition(l, 20, mid + 180);
  SetLabelText(l, 'Description:');
  ClearStyledSettings(l);

  meDescription := TMemo.Create(ADetailContent);
  meDescription.Parent := ADetailContent;
  SetControlPosition(meDescription, 120, mid + 180);
  meDescription.Height := 50;
  meDescription.Width := 210;

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddEvent;
  SetControlPosition(b, 20, mid + 240);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateEvent;
  SetControlPosition(b, 130, mid + 240);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteEvent;
  SetControlPosition(b, 240, mid + 240);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  GoogleCalendar.OnGetCalendars := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetCalendarsResult;
  GoogleCalendar.OnGetCalendar := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetCalendarResult;
end;

class function TTMSFNCCloudGoogleCalendarService.GoogleCalendar: TTMSFNCCloudGoogleCalendar;
begin
  Result := Service as TTMSFNCCloudGoogleCalendar;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudGoogleCalendarService);
end;

end.
