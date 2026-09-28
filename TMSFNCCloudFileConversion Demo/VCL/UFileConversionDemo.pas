unit UFileConversionDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCustomScrollControl, VCL.TMSFNCCloudDemoListBox, Vcl.StdCtrls,
  Vcl.ExtCtrls, VCL.TMSFNCCustomComponent, VCL.TMSFNCCloudBase,
  VCL.TMSFNCCloudFileConversion, Vcl.ComCtrls;

type
  TFileConversionDemoForm = class(TForm)
    Panel_Service: TPanel;
    Rad_CloudConvert: TRadioButton;
    Rad_ConvertIO: TRadioButton;
    Rad_Zamzar: TRadioButton;
    Edit_API: TEdit;
    Label_APIKey: TLabel;
    Panel_Create: TPanel;
    Label_Output: TLabel;
    Combo_Output: TComboBox;
    Edit_Url: TEdit;
    Panel_List: TPanel;
    Btn_JobList: TButton;
    ListBox_Jobs: TTMSFNCCloudDemoListBox;
    Btn_Download: TButton;
    Btn_JobDetails: TButton;
    Label_Error: TLabel;
    OpenDialog1: TOpenDialog;
    Edit_SelFile: TEdit;
    Btn_Dialog: TButton;
    Panel1: TPanel;
    Btn_Convert: TButton;
    Rad_Url: TRadioButton;
    Rad_File: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Label_API: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label_Status: TLabel;
    Timer1: TTimer;
    TMSFNCCloudFileConversion1: TTMSFNCCloudFileConversion;
    procedure Edit_APIChange(Sender: TObject);
    procedure Rad_CloudConvertClick(Sender: TObject);
    procedure Rad_ConvertIOClick(Sender: TObject);
    procedure Rad_ZamzarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    procedure Edit_SelFileChange(Sender: TObject);
    procedure Btn_ConvertClick(Sender: TObject);
    procedure Rad_UrlClick(Sender: TObject);
    procedure Rad_FileClick(Sender: TObject);
    procedure Btn_DialogClick(Sender: TObject);
    procedure Combo_OutputChange(Sender: TObject);
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
    procedure ConversionStopped;
    procedure HandleError(AErrorMessage: string; AJobId:string);
  end;

var
  FileConversionDemoForm: TFileConversionDemoForm;

implementation

{$R *.dfm}


procedure TFileConversionDemoForm.Btn_ConvertClick(Sender: TObject);
var
  form: TTMSFNCCloudFileConversionFileFormat;
begin
  form := TMSFNCCloudFileConversion1.GetConversionFileFormatFromString(Combo_Output.Items[Combo_Output.ItemIndex]);
  if Rad_Url.Checked then
    TMSFNCCloudFileConversion1.ConvertFileFromURL(Edit_Url.Text, form)
  else if Rad_File.Checked then
    TMSFNCCloudFileConversion1.ConvertFile(Edit_SelFile.Text, form);

  converting := True;
  Label_Status.Caption := 'Conversion is being created. Please wait ...';
  CheckButtons;
end;

procedure TFileConversionDemoForm.Btn_DialogClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit_SelFile.Text := OpenDialog1.FileName;
  CheckButtons;
end;

procedure TFileConversionDemoForm.Btn_DownloadClick(Sender: TObject);
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

procedure TFileConversionDemoForm.Btn_JobDetailsClick(Sender: TObject);
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

procedure TFileConversionDemoForm.Btn_JobListClick(Sender: TObject);
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

procedure TFileConversionDemoForm.CheckButtons;
var
  en: Boolean;
begin
  en := TMSFNCCloudFileConversion1.APIKey <> '';

  Btn_JobList.Enabled := en;

  Btn_Convert.Enabled := en and ((Rad_Url.Checked and (Edit_Url.Text <> '')) or (Rad_File.Checked and (Edit_SelFile.Text <> ''))) and not converting;

  en := en and (ListBox_Jobs.ItemIndex >= 0) and (ListBox_Jobs.ItemIndex < TMSFNCCloudFileConversion1.ConvertJobs.Count);

  Btn_JobDetails.Enabled := en;

  Btn_Download.Enabled := en and Assigned(ListBox_Jobs.Items[ListBox_Jobs.ItemIndex].DataObject) and ((ListBox_Jobs.Items[ListBox_Jobs.ItemIndex].DataObject as TTMSFNCCloudFileConversionJob).OutputFiles.Count > 0);

end;

procedure TFileConversionDemoForm.Combo_OutputChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TFileConversionDemoForm.ConversionStopped;
begin
  converting := False;
  Timer1.Enabled := False;
  CurrentJobId := '';
  CheckButtons;
end;

procedure TFileConversionDemoForm.DoListboxItemChanged(Sender: TObject);
begin
  CheckButtons;
end;

procedure TFileConversionDemoForm.Edit_APIChange(Sender: TObject);
begin
  TMSFNCCloudFileConversion1.APIKey := Edit_API.Text;
  CheckButtons;
end;

procedure TFileConversionDemoForm.Edit_SelFileChange(Sender: TObject);
begin
  CheckButtons
end;

procedure TFileConversionDemoForm.Edit_UrlChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TFileConversionDemoForm.FormCreate(Sender: TObject);
begin
  ListBox_Jobs.Items.Clear;
  ListBox_Jobs.OnItemChanged := DoListboxItemChanged;

  //Initial data for easy start
  Edit_Url.Text := 'https://www.tmssoftware.com/site/img/header/header_runner_large.jpg';
  Combo_Output.ItemIndex := 9;

  CheckButtons;
end;

procedure TFileConversionDemoForm.HandleError(AErrorMessage, AJobId: string);
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

procedure TFileConversionDemoForm.Label_APIClick(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://www.tmssoftware.com/site/cloudkey.asp');
end;

procedure TFileConversionDemoForm.Rad_CloudConvertClick(Sender: TObject);
begin
  if Rad_CloudConvert.Checked then
  begin
    TMSFNCCloudFileConversion1.Service := fcsCloudConvert;
    Rad_ConvertIO.Checked := False;
    Rad_Zamzar.Checked := False;
  end;
end;

procedure TFileConversionDemoForm.Rad_ConvertIOClick(Sender: TObject);
begin
  if Rad_ConvertIO.Checked then
  begin
    TMSFNCCloudFileConversion1.Service := fcsConvertIO;
    Rad_CloudConvert.Checked := False;
    Rad_Zamzar.Checked := False;
  end;
end;

procedure TFileConversionDemoForm.Rad_FileClick(Sender: TObject);
begin
  if Rad_File.Checked then
    Rad_Url.Checked := False;
  CheckButtons;
end;

procedure TFileConversionDemoForm.Rad_UrlClick(Sender: TObject);
begin
  if Rad_Url.Checked then
    Rad_File.Checked := False;
  CheckButtons;
end;

procedure TFileConversionDemoForm.Rad_ZamzarClick(Sender: TObject);
begin
  if Rad_Zamzar.Checked then
  begin
    Rad_CloudConvert.Checked := False;
    Rad_ConvertIO.Checked := False;
    TMSFNCCloudFileConversion1.Service := fcsZamzar;
  end;
end;

procedure TFileConversionDemoForm.Timer1Timer(Sender: TObject);
var
  j: TTMSFNCCloudFileConversionJob;
begin
  j := TMSFNCCloudFileConversion1.GetConvertJobById(CurrentJobId);
  if Assigned(j) then
    j.GetDetails
  else
    ConversionStopped;
end;

procedure TFileConversionDemoForm.TMSFNCCloudFileConversion1ConvertJobCreated(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
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

procedure TFileConversionDemoForm.TMSFNCCloudFileConversion1FileDownloadedToFile(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AFile: TTMSFNCCloudFileConversionFile; ALocation, AErrorMessage: string);
begin
  if AErrorMessage <> '' then
    Label_Error.Caption := AErrorMessage
  else
  begin
    TTMSFNCUtils.OpenFile(GetCurrentDir);
  end;
end;

procedure TFileConversionDemoForm.TMSFNCCloudFileConversion1GetConvertJobDetails(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AJob: TTMSFNCCloudFileConversionJob; AErrorMessage: string);
begin
  if AErrorMessage <> '' then
  begin
    HandleError(AErrorMessage, AJob.Id);
  end
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

procedure TFileConversionDemoForm.UpdateCurrentJob(AJob: TTMSFNCCloudFileConversionJob);
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

procedure TFileConversionDemoForm.UpdateJobInList(AJob: TTMSFNCCloudFileConversionJob);
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

procedure TFileConversionDemoForm.UpdateListItem(AItem: TTMSFNCCloudDemoListBoxItem; AJob: TTMSFNCCloudFileConversionJob);
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
