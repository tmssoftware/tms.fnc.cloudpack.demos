unit TMSFNCCloudGoogleTasks;

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
  CloudServices, VCL.TMSFNCCustomControl, VCL.TMSFNCCloudGoogleTasks, VCL.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCustomControl, FMX.TMSFNCCloudGoogleTasks,
  FMX.ListBox, FMX.Edit, FMX.DateTimeCtrls, FMX.Memo, FMX.TMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase, DateTimePicker,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCustomControl, LCLTMSFNCCloudGoogleTasks, LCLTMSFNCCloudDemoListBox;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth,WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCloudGoogleTasks, WEBLib.TMSFNCCloudDemoListBox;
  {$ENDIF}

type
  TTMSFNCCloudGoogleTasksService = class(TTMSFNCCloudService)
  private
    class var lbLists: TTMSFNCCloudDemoListBox;
    class var lbTasks: TTMSFNCCloudDemoListBox;
    class var edList: TEdit;
    class var edTask: TEdit;
    {$IFDEF FMX}
    class var deDue: TDateEdit;
    {$ENDIF}
    {$IFDEF LCLWEBLIB}
    class var deDue: TDateTimePicker;
    {$ENDIF}
    {$IFDEF VCL}
    class var deDue: TDateTimePicker;
    {$ENDIF}
    class var meNotes: TMemo;
    class var cbComplete: TCheckBox;
    class var l: TLabel;
  protected
    class procedure DoGetTaskListsResult(Sender: TObject; const AInfo: TTMSFNCCloudGoogleTasksTaskLists; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetTaskLists(Sender: TObject);

    class procedure DoAddListResult(Sender: TObject; const AInfo: TTMSFNCCloudGoogleTasksTaskList; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoAddList(Sender: TObject);

    class procedure DoDeleteListResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoDeleteList(Sender: TObject);

    class procedure DoUpdateListResult(Sender: TObject; const AInfo: TTMSFNCCloudGoogleTasksTaskList; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoUpdateList(Sender: TObject);

    class procedure DoGetTasksResult(Sender: TObject; const AInfo: TTMSFNCCloudGoogleTasksTasks; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoGetTasks(Sender: TObject);

    class procedure DoAddTaskResult(Sender: TObject; const AInfo: TTMSFNCCloudGoogleTasksTask; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoAddTask(Sender: TObject);

    class procedure DoDeleteTaskResult(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoDeleteTask(Sender: TObject);

    class procedure DoUpdateTaskResult(Sender: TObject; const AInfo: TTMSFNCCloudGoogleTasksTask; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    class procedure DoUpdateTask(Sender: TObject);

    class procedure DoGetTaskDetail(Sender: TObject);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function GoogleTasks: TTMSFNCCloudGoogleTasks;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudGoogleTasksService }

class procedure TTMSFNCCloudGoogleTasksService.DoAddList(Sender: TObject);
begin
  GoogleTasks.AddTaskList(edList.Text);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoAddListResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGoogleTasksTaskList;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  lbLists.InsertItem(0, AInfo.Title + '<br>' + DateTimeToStr(AInfo.Updated), '', AInfo);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoAddTask(Sender: TObject);
var
  tl: TTMSFNCCloudGoogleTasksTaskList;
  ta: TTMSFNCCloudGoogleTasksTask;
begin
  if lbLists.ItemIndex < 0 then
    Exit;

  tl := lbLists.Items[lbLists.ItemIndex].DataObject as TTMSFNCCloudGoogleTasksTaskList;
  ta := tl.Tasks.Add;
  ta.Title := edTask.Text;
  ta.Due := deDue.Date;
  {$IFDEF FMX}
  if cbComplete.IsChecked then
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  if cbComplete.Checked then
  {$ENDIF}
  {$IFDEF VCL}
  if cbComplete.Checked then
  {$ENDIF}
    ta.Status := 'completed'
  else
    ta.Status := 'needsAction';
  ta.Notes := meNotes.Text;
  GoogleTasks.AddTaskToList(tl, ta);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoAddTaskResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGoogleTasksTask;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  lbTasks.InsertItem(0, AInfo.Title + '<br>' + DateTimeToStr(AInfo.Due) + ' : ' + AInfo.Status, '', AInfo);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoDeleteList(Sender: TObject);
begin
  if lbLists.ItemIndex < 0 then
    Exit;

  GoogleTasks.DeleteTaskList(lbLists.Items[lbLists.ItemIndex].DataObject as TTMSFNCCloudGoogleTasksTaskList);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoDeleteListResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbLists.ItemIndex < 0 then
    Exit;

  lbLists.Items.Delete(lbLists.ItemIndex);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoDeleteTask(Sender: TObject);
begin
  if lbTasks.ItemIndex < 0 then
    Exit;

  GoogleTasks.DeleteTask(lbTasks.Items[lbTasks.ItemIndex].DataObject as TTMSFNCCloudGoogleTasksTask);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoDeleteTaskResult(
  Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbTasks.ItemIndex < 0 then
    Exit;

  lbTasks.Items.Delete(lbTasks.ItemIndex);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoGetTaskDetail(Sender: TObject);
var
  ta: TTMSFNCCloudGoogleTasksTask;
begin
  if lbTasks.ItemIndex < 0 then
    Exit;

  ta := lbTasks.Items[lbTasks.ItemIndex].DataObject as TTMSFNCCloudGoogleTasksTask;
  edTask.Text := ta.Title;
  deDue.Date := ta.Due;
  {$IFDEF FMX}
  cbComplete.IsChecked := (ta.Status = 'completed');
  {$ENDIF}
  {$IFDEF WEBLIB}
  cbComplete.Checked := (ta.Status = 'completed');
  {$ENDIF}
  {$IFDEF VCL}
  cbComplete.Checked := (ta.Status = 'completed');
  {$ENDIF}
  meNotes.Lines.Text := ta.Notes;
end;

class procedure TTMSFNCCloudGoogleTasksService.DoGetTaskLists(Sender: TObject);
begin
  StartLoading;
  GoogleTasks.GetTaskLists;
end;

class procedure TTMSFNCCloudGoogleTasksService.DoGetTaskListsResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGoogleTasksTaskLists;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  StopLoading;
  if Assigned(lbLists) then
  begin
    SetLabelText(l, 'Task Lists');
    lbLists.Visible := True;
    lbTasks.Visible := False;
    lbLists.Items.Clear;
    for I := 0 to AInfo.Count - 1 do
      lbLists.AddItem(AInfo[I].Title + '<br>' + DateTimeToStr(AInfo[I].Updated), '', AInfo[I]);
  end;
end;

class procedure TTMSFNCCloudGoogleTasksService.DoGetTasks(Sender: TObject);
begin
  if lbLists.ItemIndex < 0 then
    Exit;

  StartLoading;
  GoogleTasks.GetTasks(lbLists.Items[lbLists.ItemIndex].DataObject as TTMSFNCCloudGoogleTasksTaskList);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoGetTasksResult(Sender: TObject;
  const AInfo: TTMSFNCCloudGoogleTasksTasks;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  StopLoading;
  if Assigned(lbTasks) then
  begin
    SetLabelText(l, 'Tasks');
    lbTasks.Visible := True;
    lbLists.Visible := False;
    lbTasks.Items.Clear;
    for I := 0 to AInfo.Count - 1 do
      lbTasks.AddItem(AInfo[I].Title + '<br>' + DateTimeToStr(AInfo[I].Due) + ' : ' + AInfo[I].Status, '', AInfo[I]);
  end;
end;

class procedure TTMSFNCCloudGoogleTasksService.DoUpdateList(Sender: TObject);
var
  tl: TTMSFNCCloudGoogleTasksTaskList;
begin
  if lbLists.ItemIndex < 0 then
    Exit;

  tl := lbLists.Items[lbLists.ItemIndex].DataObject as TTMSFNCCloudGoogleTasksTaskList;
  tl.Title := edList.Text;
  GoogleTasks.UpdateTaskList(tl);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoUpdateListResult(
  Sender: TObject; const AInfo: TTMSFNCCloudGoogleTasksTaskList;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbLists.ItemIndex < 0 then
    Exit;

  lbLists.Items[lbLists.ItemIndex].Text := AInfo.Title + '<br>' + DateTimeToStr(AInfo.Updated);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoUpdateTask(Sender: TObject);
var
  ta: TTMSFNCCloudGoogleTasksTask;
begin
  if lbTasks.ItemIndex < 0 then
    Exit;

  ta := lbTasks.Items[lbTasks.ItemIndex].DataObject as TTMSFNCCloudGoogleTasksTask;
  ta.Title := edTask.Text;
  ta.Due := deDue.Date;
  {$IFDEF FMX}
  if cbComplete.IsChecked then
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  if cbComplete.Checked then
  {$ENDIF}
  {$IFDEF VCL}
  if cbComplete.Checked then
  {$ENDIF}
    ta.Status := 'completed'
  else
    ta.Status := 'needsAction';
  ta.Notes := meNotes.Text;
  GoogleTasks.UpdateTask(ta);
end;

class procedure TTMSFNCCloudGoogleTasksService.DoUpdateTaskResult(
  Sender: TObject; const AInfo: TTMSFNCCloudGoogleTasksTask; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if lbTasks.ItemIndex < 0 then
    Exit;

  lbTasks.Items[lbTasks.ItemIndex].Text := AInfo.Title + sRequestLineBreak + DateTimeToStr(AInfo.Due) + ' : ' + AInfo.Status;
end;

class function TTMSFNCCloudGoogleTasksService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudGoogleTasks;
end;

class function TTMSFNCCloudGoogleTasksService.GetDescription: string;
begin
  Result := 'Get more done with Google Tasks. Manage, capture, and edit your tasks from anywhere, at anytime, with to-dos that sync across all your devices.';
end;

class function TTMSFNCCloudGoogleTasksService.GetTitle: string;
begin
  Result := 'Google Tasks';
end;

class function TTMSFNCCloudGoogleTasksService.GoogleTasks: TTMSFNCCloudGoogleTasks;
begin
  Result := Service as TTMSFNCCloudGoogleTasks;
end;

class procedure TTMSFNCCloudGoogleTasksService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  b: TButton;
  ew: Integer;
begin
  inherited;

  ew := 250;

  b := TButton.Create(AContent);
  b.Parent := AContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetTaskLists;
  SetControlPosition(b, 10, 10);
  SetButtonText(b, 'Get Task Lists');
  ClearStyledSettings(b);

  lbLists := TTMSFNCCloudDemoListBox.Create(AContent);
  lbLists.Parent := AContent;
  lbLists.ItemHeight := 40;
  SetControlAlignment(lbLists, caClient);
  SetControlMargins(lbLists, 10, 40, 10, 10);
  lbLists.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop];
  lbLists.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetTasks;

  edList := TEdit.Create(ADetailContent);
  edList.Parent := ADetailContent;
  SetControlPosition(edList, 20, 40);
  edList.Text := 'New List';
  edList.Width := ew;
  ClearStyledSettings(edList);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.Name := 'btAddList';
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddList;
  SetControlPosition(b, 20, 70);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateList;
  SetControlPosition(b, 140, 70);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteList;
  SetControlPosition(b, 240, 70);
  SetButtonText(b, 'Delete');

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 130, 15);
  SetLabelText(l, 'Task Lists');
  ClearStyledSettings(l);

  lbTasks := TTMSFNCCloudDemoListBox.Create(AContent);
  lbTasks.Parent := AContent;
  lbTasks.ItemHeight := 40;
  SetControlAlignment(lbTasks, caClient);
  SetControlMargins(lbTasks, 10, 40, 10, 10);
  lbTasks.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];
  lbTasks.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetTaskDetail;

  edTask := TEdit.Create(ADetailContent);
  edTask.Parent := ADetailContent;
  SetControlPosition(edTask, 20, 330);
  edTask.Width := ew;
  edTask.Text := 'New Task';
  ClearStyledSettings(edTask);

  {$IFDEF FMX}
  deDue := TDateEdit.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF LCLWEBLIB}
  deDue := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  {$IFDEF VCL}
  deDue := TDateTimePicker.Create(ADetailContent);
  {$ENDIF}
  deDue.Parent := ADetailContent;
  SetControlPosition(deDue, 20, 360);
  deDue.Width := ew;

  cbComplete := TCheckBox.Create(ADetailContent);
  cbComplete.Parent := ADetailContent;
  SetControlPosition(cbComplete, 20, 390);
  {$IFDEF FMX}
  cbComplete.Text := 'Complete';
  {$ENDIF}
  {$IFNDEF FMX}
  cbComplete.Caption := 'Complete';
  {$ENDIF}

  meNotes := TMemo.Create(ADetailContent);
  meNotes.Parent := ADetailContent;
  SetControlPosition(meNotes, 20, 420);
  meNotes.Width := ew;
  meNotes.Height := 50;

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddTask;
  SetControlPosition(b, 20, 480);
  SetButtonText(b, 'Add');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateTask;
  SetControlPosition(b, 130, 480);
  SetButtonText(b, 'Update');
  ClearStyledSettings(b);

  b := TButton.Create(ADetailContent);
  b.Parent := ADetailContent;
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteTask;
  SetControlPosition(b, 240, 480);
  SetButtonText(b, 'Delete');
  ClearStyledSettings(b);

  GoogleTasks.OnGetTaskLists := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetTaskListsResult;
  GoogleTasks.OnAddTaskList := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddListResult;
  GoogleTasks.OnDeleteTaskList := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteListResult;
  GoogleTasks.OnUpdateTaskList := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateListResult;
  GoogleTasks.OnGetTasks := {$IFDEF LCLWEBLIB}@{$ENDIF}DoGetTasksResult;
  GoogleTasks.OnAddTask := {$IFDEF LCLWEBLIB}@{$ENDIF}DoAddTaskResult;
  GoogleTasks.OnDeleteTask := {$IFDEF LCLWEBLIB}@{$ENDIF}DoDeleteTaskResult;
  GoogleTasks.OnUpdateTask := {$IFDEF LCLWEBLIB}@{$ENDIF}DoUpdateTaskResult;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudGoogleTasksService);
end;

end.
