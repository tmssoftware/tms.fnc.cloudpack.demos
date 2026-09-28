unit UFileconversionDemo;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCloudBase, WEBLib.TMSFNCCloudFileConversion, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCustomScrollControl, VCL.TMSFNCCloudDemoListBox, Vcl.StdCtrls,
  WEBLib.StdCtrls, Vcl.Controls, WEBLib.ExtCtrls, WEBLib.WebCtrls,
  VCL.TMSFNCCloudFileConversion, WEBLib.ComCtrls;

type
  TForm1 = class(TWebForm)
    Panel_Service: TWebPanel;
    Rad_CloudConvert: TWebRadioButton;
    Rad_ConvertIO: TWebRadioButton;
    Edit_API: TWebEdit;
    Label_APIKey: TWebLabel;
    Panel_Create: TWebPanel;
    Label_Output: TWebLabel;
    Combo_Output: TWebComboBox;
    Edit_Url: TWebEdit;
    Panel_List: TWebPanel;
    Btn_JobList: TWebButton;
    ListBox_Jobs: TTMSFNCCloudDemoListBox;
    Btn_Download: TWebButton;
    Btn_JobDetails: TWebButton;
    Label_Error: TWebLabel;
    Panel1: TWebPanel;
    Btn_Convert: TWebButton;
    Rad_Url: TWebRadioButton;
    Rad_File: TWebRadioButton;
    Label1: TWebLabel;
    Label2: TWebLabel;
    Label_API: TWebLabel;
    PageControl1: TWebPageControl;
    TabSheet1: TWebTabSheet;
    TabSheet2: TWebTabSheet;
    Label_Status: TWebLabel;
    Timer1: TWebTimer;
    TMSFNCCloudFileConversion1: TTMSFNCCloudFileConversion;
    WebFilePicker1: TWebFilePicker;
    procedure Edit_APIChange(Sender: TObject);
    procedure Rad_CloudConvertClick(Sender: TObject);
    procedure Rad_ConvertIOClick(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
    procedure Btn_JobListClick(Sender: TObject);
    procedure Btn_JobDetailsClick(Sender: TObject);
    procedure Btn_DownloadClick(Sender: TObject);
    procedure TMSFNCCloudFileConversion1ConvertJobCreated(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AJob: TTMSFNCCloudFileConversionJob; AErrorMessage: string);
    procedure TMSFNCCloudFileConversion1GetConvertJobDetails(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AJob: TTMSFNCCloudFileConversionJob; AErrorMessage: string);
    procedure Label_APIClick(Sender: TObject);
    procedure TMSFNCCloudFileConversion1FileDownloadedToFile(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
      AFile: TTMSFNCCloudFileConversionFile; ALocation, AErrorMessage: string);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit_UrlChange(Sender: TObject);
    procedure Btn_ConvertClick(Sender: TObject);
    procedure Rad_UrlClick(Sender: TObject);
    procedure Rad_FileClick(Sender: TObject);
    procedure Combo_OutputChange(Sender: TObject);
    procedure WebFilePicker1Change(Sender: TObject);
  private
    { Private declarations }
    CurrentJobId: string;
  public
    { Public declarations }
    converting: Boolean;
    procedure DoListboxItemChanged(Sender: TObject);
    procedure UpdateListItem(AItem: TTMSFNCCloudDemoListBoxItem; AJob: TTMSFNCCloudFileConversionJob);
    procedure UpdateJobInList(AJob:TTMSFNCCloudFileConversionJob);
    procedure CheckButtons;
    procedure UpdateCurrentJob(AJob: TTMSFNCCloudFileConversionJob);
    procedure DoFileLoaded(const AFile: TTMSFNCUtilsFile);
    procedure ConversionStopped;
    procedure HandleError(AErrorMessage: string; AJobId:string);
  end;


var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DoFileLoaded(const AFile: TTMSFNCUtilsFile);
begin
  TMSFNCCloudFileConversion1.ConvertFile(AFile, TMSFNCCloudFileConversion1.GetConversionFileFormatFromString(Combo_Output.Items[Combo_Output.ItemIndex]));
end;

procedure TForm1.Btn_ConvertClick(Sender: TObject);
var
  form: TTMSFNCCloudFileConversionFileFormat;
begin
  form := TMSFNCCloudFileConversion1.GetConversionFileFormatFromString(Combo_Output.Items[Combo_Output.ItemIndex]);
  if Rad_Url.Checked then
    TMSFNCCloudFileConversion1.ConvertFileFromURL(Edit_Url.Text, form)
  else if Rad_File.Checked then
    TTMSFNCUtils.LoadFile(WebFilePicker1.Files[0].FileObject, @DoFileLoaded);

  converting := True;
  Label_Status.Caption := 'Conversion is being created. Please wait ...';
  CheckButtons;
end;

procedure TForm1.Btn_DownloadClick(Sender: TObject);
var
  j: TTMSFNCCloudFileConversionJob;
begin
  if (ListBox_Jobs.ItemIndex >= 0) then
  begin
    j := (ListBox_Jobs.Items[ListBox_Jobs.ItemIndex].DataObject as TTMSFNCCloudFileConversionJob);
    j.DownloadAllFilesToFiles('', True);
  end
  else
    Label_Error.Caption := 'No Job was selected in the listbox.';
end;

procedure TForm1.Btn_JobDetailsClick(Sender: TObject);
var
  j: TTMSFNCCloudFileConversionJob;
begin
  if ListBox_Jobs.ItemIndex >= 0 then
  begin
    Label_Error.Caption := '';
    j := ListBox_Jobs.Items[ListBox_Jobs.ItemIndex].DataObject as TTMSFNCCloudFileConversionJob;
    j.GetDetails;
  end
  else
    Label_Error.Caption := 'No Job was selected in the listbox.';
end;

procedure TForm1.Btn_JobListClick(Sender: TObject);
begin
  TMSFNCCloudFileConversion1.GetConvertJobs(True, 10,
    procedure(AJobs: TTMSFNCCloudFileConversionJobs; AErrorMessage: string)
    var
      I: Integer;
      li: TTMSFNCCloudDemoListBoxItem;
    begin
      ListBox_Jobs.Items.Clear;
      if AErrorMessage <> '' then
      begin
        li := ListBox_Jobs.Items.Add;
        li.Text := AErrorMessage;
        li.TextColor := gcRed;
      end;
      for I := 0 to AJobs.Count - 1 do
      begin
        li := ListBox_Jobs.Items.Add;
        UpdateListItem(li, AJobs[I]);
      end;
    end);

  ListBox_Jobs.ItemIndex := -1;
end;

procedure TForm1.CheckButtons;
var
  en: Boolean;
begin
  en := TMSFNCCloudFileConversion1.APIKey <> '';

  Btn_JobList.Enabled := en;

  Btn_Convert.Enabled := en and ((Rad_Url.Checked and (Edit_Url.Text <> '')) or (Rad_File.Checked and (WebFilePicker1.Files.Count > 0))) and not converting;

  en := en and (ListBox_Jobs.ItemIndex >= 0) and (ListBox_Jobs.ItemIndex < TMSFNCCloudFileConversion1.ConvertJobs.Count);

  Btn_JobDetails.Enabled := en;

  Btn_Download.Enabled := en and Assigned(ListBox_Jobs.Items[ListBox_Jobs.ItemIndex].DataObject) and ((ListBox_Jobs.Items[ListBox_Jobs.ItemIndex].DataObject as TTMSFNCCloudFileConversionJob).OutputFiles.Count > 0);

end;

procedure TForm1.Combo_OutputChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm1.ConversionStopped;
begin
  converting := False;
  Timer1.Enabled := False;
  CurrentJobId := '';
  CheckButtons;
end;

procedure TForm1.DoListboxItemChanged(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm1.Edit_APIChange(Sender: TObject);
begin
  TMSFNCCloudFileConversion1.APIKey := Edit_API.Text;
  CheckButtons;
end;

procedure TForm1.Edit_UrlChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm1.HandleError(AErrorMessage, AJobId: string);
begin
  AErrorMessage[1] := UpCase(AErrorMessage[1]);

  if CurrentJobId = AJobId then
  begin
    Label_Status.Font.Color := gcCrimson;
    Label_Status.Caption := AErrorMessage;
    ConversionStopped;
  end
  else
    Label_Error.Caption := AErrorMessage;
end;

procedure TForm1.WebFilePicker1Change(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm1.WebFormCreate(Sender: TObject);
begin
  ListBox_Jobs.Items.Clear;
  ListBox_Jobs.OnItemChanged := DoListboxItemChanged;

  //Initial data for easy start
  Edit_Url.Text := 'https://www.tmssoftware.com/site/img/header/header_runner_large.jpg';
  Combo_Output.ItemIndex := 9;

  CheckButtons;
end;

procedure TForm1.Label_APIClick(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://www.tmssoftware.com/site/cloudkey.asp');
end;

procedure TForm1.Rad_CloudConvertClick(Sender: TObject);
begin
  if Rad_CloudConvert.Checked then
  begin
    TMSFNCCloudFileConversion1.Service := fcsCloudConvert;
    Rad_ConvertIO.Checked := False;
  end;
end;

procedure TForm1.Rad_ConvertIOClick(Sender: TObject);
begin
  if Rad_ConvertIO.Checked then
  begin
    TMSFNCCloudFileConversion1.Service := fcsConvertIO;
    Rad_CloudConvert.Checked := False;
  end;
end;

procedure TForm1.Rad_FileClick(Sender: TObject);
begin
  if Rad_File.Checked then
    Rad_Url.Checked := False;
  CheckButtons;
end;

procedure TForm1.Rad_UrlClick(Sender: TObject);
begin
  if Rad_Url.Checked then
    Rad_File.Checked := False;
  CheckButtons;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  j: TTMSFNCCloudFileConversionJob;
begin
  j := TMSFNCCloudFileConversion1.GetConvertJobById(CurrentJobId);
  if Assigned(j) then
    j.GetDetails
  else
    ConversionStopped;
end;

procedure TForm1.TMSFNCCloudFileConversion1ConvertJobCreated(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AJob: TTMSFNCCloudFileConversionJob; AErrorMessage: string);
begin
  if AErrorMessage <> '' then
  begin
    ConversionStopped;
    AErrorMessage[1] := UpCase(AErrorMessage[1]);
    Label_Status.Caption := AErrorMessage;
  end
  else
  begin
    CurrentJobId := AJob.Id;
    UpdateCurrentJob(AJob);
    Timer1.Enabled := True;
  end;
end;

procedure TForm1.TMSFNCCloudFileConversion1FileDownloadedToFile(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AFile: TTMSFNCCloudFileConversionFile; ALocation, AErrorMessage: string);
begin
  if AErrorMessage <> '' then
    Label_Error.Caption := AErrorMessage;
end;

procedure TForm1.TMSFNCCloudFileConversion1GetConvertJobDetails(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AJob: TTMSFNCCloudFileConversionJob; AErrorMessage: string);
begin
  if AErrorMessage <> '' then
    HandleError(AErrorMessage, AJob.Id)
  else
  begin
    if AJob.Id = CurrentJobId then
    begin
      UpdateCurrentJob(AJob);
    end;

    UpdateJobInList(AJob);
  end;

  CheckButtons;
end;

procedure TForm1.UpdateCurrentJob(AJob: TTMSFNCCloudFileConversionJob);
var
  c: TColor;
begin
  c := gcDarkgray;
  case AJob.Status of
    fcjsUnknown:
    begin
      Label_Status.Caption := 'The current status of the conversion is unknown.';
    end;
    fcjsSuccessful:
    begin
      c := gcDarkgreen;
      Label_Status.Caption := 'Conversion Successful, saving file to current folder.';
      AJob.DownloadAllFilesToFiles('', True);
      ConversionStopped;
    end;
    fcjsWaiting:
    begin
      if Pos('...', Label_Status.Caption) > 0 then
        Label_Status.Caption := 'Transfering file '
      else
        Label_Status.Caption := Label_Status.Caption + '.';
    end;
    fcjsError:
    begin
      c := gcCrimson;
      Label_Status.Caption := 'An Error occured during conversion.';
      ConversionStopped;
    end;
    fcjsProcessing:
    begin
      c := gcDodgerblue;
      if Label_Status.Caption <> 'Uploading and Converting the file' then
        Label_Status.Caption := 'Uploading and Converting the file'
      else
        Label_Status.Caption := 'Please wait while we are processing the conversion.';
    end;
    fcjsCancelled:
    begin
      Label_Status.Caption := 'This conversion was cancelled';
      ConversionStopped;
    end;
  end;

  Label_Status.Font.Color := c;
end;

procedure TForm1.UpdateJobInList(AJob: TTMSFNCCloudFileConversionJob);
var
  I: Integer;
begin
  if Assigned(AJob) then
  begin
    for I := 0 to ListBox_Jobs.Items.Count - 1 do
    begin
      if (ListBox_Jobs.Items[I].DataObject as TTMSFNCCloudFileConversionJob).Id = AJob.Id then
      begin
        UpdateListItem(ListBox_Jobs.Items[I], AJob);
        Exit;
      end;
    end;

    UpdateListItem(ListBox_Jobs.Items.Add, AJob);
  end;
  CheckButtons;
end;

procedure TForm1.UpdateListItem(AItem: TTMSFNCCloudDemoListBoxItem; AJob: TTMSFNCCloudFileConversionJob);
begin
  if Assigned(AJob) then
  begin
    if (AJob.OutputFiles.Count > 0) then
      AItem.Text := AJob.OutputFiles[0].Name + '[' + IntToStr(AJob.OutputFiles.Count) + ']' + ' (' + TMSFNCCloudFileConversion1.GetStatusText(AJob.Status) + ')'
    else
      AItem.Text := AJob.Id + ' - ' + TMSFNCCloudFileConversion1.GetFileFormatText(AJob.OutputFormat) + ' (' + TMSFNCCloudFileConversion1.GetStatusText(AJob.Status) + ')';

    case AJob.Status of
      fcjsWaiting: AItem.TextColor := gcOrange;
      fcjsProcessing: AItem.TextColor := gcSlateblue;
      fcjsSuccessful: AItem.TextColor := gcDarkgreen;
      fcjsError: AItem.TextColor := gcRed;
      fcjsCancelled: AItem.TextColor := gcDarkgray;
    end;

    AItem.DataObject := AJob;
  end;
end;

end.
