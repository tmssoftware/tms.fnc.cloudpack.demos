unit UFileConversion;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCCloudFileConversion,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCListBox, FMX.ListBox, FMX.Edit, FMX.TMSFNCCloudBase,
  FMX.TMSFNCImage, FMX.Memo.Types, FMX.Layouts, FMX.ScrollBox, FMX.Memo,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCCloudDemoListBox,
  FMX.TMSFNCCustomComponent, FMX.TabControl;

type
  TForm1 = class(TForm)
    Btn_JobList: TButton;
    Rad_CloudConvert: TRadioButton;
    Rad_Zamzar: TRadioButton;
    Rad_ConvertIO: TRadioButton;
    Combo_Output: TComboBox;
    Btn_JobDetails: TButton;
    Btn_Download: TButton;
    OpenDialog1: TOpenDialog;
    Edit_API: TEdit;
    LblAPI: TLabel;
    Panel_Service: TPanel;
    Panel_List: TPanel;
    LblOutput: TLabel;
    VertScrollBox1: TVertScrollBox;
    ListBox_Jobs: TTMSFNCCloudDemoListBox;
    TMSFNCCloudFileConversion1: TTMSFNCCloudFileConversion;
    Lbl_Error: TLabel;
    Panel_Convert: TPanel;
    Btn_Convert: TButton;
    Panel_Input: TPanel;
    Edit_Url: TEdit;
    Label2: TLabel;
    Rad_Url: TRadioButton;
    Rad_File: TRadioButton;
    Edit_SelFile: TEdit;
    Label_API: TLabel;
    Btn_Dialog: TButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Label1: TLabel;
    Label_Status: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Btn_JobListClick(Sender: TObject);
    procedure Rad_ZamzarChange(Sender: TObject);
    procedure Rad_CloudConvertChange(Sender: TObject);
    procedure Btn_JobDetailsClick(Sender: TObject);
    procedure Btn_DownloadClick(Sender: TObject);
    procedure TMSFNCCloudFileConversion1GetConvertJobDetails(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AJob: TTMSFNCCloudFileConversionJob; AErrorMessage: string);
    procedure TMSFNCCloudFileConversion1ConvertJobCreated(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AJob: TTMSFNCCloudFileConversionJob; AErrorMessage: string);
    procedure Rad_ConvertIOChange(Sender: TObject);
    procedure Btn_ConvertClick(Sender: TObject);
    procedure Combo_OutputChange(Sender: TObject);
    procedure Edit_UrlChange(Sender: TObject);
    procedure Edit_SelFileChange(Sender: TObject);
    procedure Label_APIClick(Sender: TObject);
    procedure Edit_APIChangeTracking(Sender: TObject);
    procedure Btn_DialogClick(Sender: TObject);
    procedure TMSFNCCloudFileConversion1FileDownloadedToFile(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
      AFile: TTMSFNCCloudFileConversionFile; ALocation, AErrorMessage: string);
    procedure Timer1Timer(Sender: TObject);
    procedure Rad_UrlChange(Sender: TObject);
    procedure Rad_FileChange(Sender: TObject);
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
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  JSON;

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

  Btn_Convert.Enabled := en and ((Rad_Url.IsChecked and (Edit_Url.Text <> '')) or (Rad_File.IsChecked and (Edit_SelFile.Text <> ''))) and not converting;

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

procedure TForm1.Btn_JobDetailsClick(Sender: TObject);
var
  j: TTMSFNCCloudFileConversionJob;
begin
  if ListBox_Jobs.ItemIndex >= 0 then
  begin
    Lbl_Error.Text := '';
    j := ListBox_Jobs.Items[ListBox_Jobs.ItemIndex].DataObject as TTMSFNCCloudFileConversionJob;
    j.GetDetails;
  end
  else
    Lbl_Error.Text := 'No Job was selected in the listbox.';
end;

procedure TForm1.Btn_ConvertClick(Sender: TObject);
var
  form: TTMSFNCCloudFileConversionFileFormat;
begin
  form := TMSFNCCloudFileConversion1.GetConversionFileFormatFromString(Combo_Output.Items[Combo_Output.ItemIndex]);
  if Rad_Url.IsChecked then
    TMSFNCCloudFileConversion1.ConvertFileFromURL(Edit_Url.Text, form)
  else if Rad_File.IsChecked then
    TMSFNCCloudFileConversion1.ConvertFile(Edit_SelFile.Text, form);

  converting := True;
  Label_Status.Text := 'Conversion is being created. Please wait ...';
  CheckButtons;
end;

procedure TForm1.Btn_DialogClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit_SelFile.Text := OpenDialog1.FileName;
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
    Lbl_Error.Text := 'No Job was selected in the listbox.';
end;

procedure TForm1.UpdateCurrentJob(AJob: TTMSFNCCloudFileConversionJob);
var
  c: TAlphaColor;
begin
  c := gcDarkgray;
  case AJob.Status of
    fcjsUnknown:
    begin
      Label_Status.Text := 'The current status of the conversion is unknown.';
    end;
    fcjsSuccessful:
    begin
      c := gcDarkgreen;
      Label_Status.Text := 'Conversion Successful, saving file to current folder.';
      AJob.DownloadAllFilesToFiles('', True);
      ConversionStopped;
    end;
    fcjsWaiting:
    begin
      if Pos('...', Label_Status.Text) > 0 then
        Label_Status.Text := 'Transfering file '
      else
        Label_Status.Text := Label_Status.Text + '.';
    end;
    fcjsError:
    begin
      c := gcCrimson;
      Label_Status.Text := 'An Error occured during conversion.';
      ConversionStopped;
    end;
    fcjsProcessing:
    begin
      c := gcDodgerblue;
      if Label_Status.Text <> 'Uploading and Converting the file' then
        Label_Status.Text := 'Uploading and Converting the file'
      else
        Label_Status.Text := 'Please wait while we are processing the conversion.';
    end;
    fcjsCancelled:
    begin
      Label_Status.Text := 'This conversion was cancelled';
      ConversionStopped;
    end;
  end;

  Label_Status.FontColor := c;
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

procedure TForm1.DoListboxItemChanged(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm1.Edit_APIChangeTracking(Sender: TObject);
begin
  TMSFNCCloudFileConversion1.APIKey := Edit_API.Text;
  CheckButtons;
end;

procedure TForm1.Edit_SelFileChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm1.Edit_UrlChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListBox_Jobs.Items.Clear;
  ListBox_Jobs.OnItemChanged := DoListboxItemChanged;

  //Initial data for easy start
  Edit_Url.Text := 'https://www.tmssoftware.com/site/img/header/header_runner_large.jpg';
  Combo_Output.ItemIndex := 9;

  CheckButtons;
end;

procedure TForm1.HandleError(AErrorMessage: string; AJobId:string);
begin
  AErrorMessage[1] := UpCase(AErrorMessage[1]);

  if CurrentJobId = AJobId then
  begin
    Label_Status.FontColor := gcCrimson;
    Label_Status.Text := AErrorMessage;
    ConversionStopped;
  end
  else
    Lbl_Error.Text := AErrorMessage;
end;

procedure TForm1.Label_APIClick(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://www.tmssoftware.com/site/cloudkey.asp');
end;

procedure TForm1.Rad_CloudConvertChange(Sender: TObject);
begin
  if Rad_CloudConvert.IsChecked then
  begin
    TMSFNCCloudFileConversion1.Service := fcsCloudConvert;
  end;
end;

procedure TForm1.Rad_ConvertIOChange(Sender: TObject);
begin
  if Rad_ConvertIO.IsChecked then
  begin
    TMSFNCCloudFileConversion1.Service := fcsConvertIO;
  end;
end;

procedure TForm1.Rad_FileChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm1.Rad_UrlChange(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm1.Rad_ZamzarChange(Sender: TObject);
begin
  if Rad_Zamzar.IsChecked then
  begin
    TMSFNCCloudFileConversion1.Service := fcsZamzar;
  end;
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

procedure TForm1.TMSFNCCloudFileConversion1ConvertJobCreated(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AJob: TTMSFNCCloudFileConversionJob; AErrorMessage: string);
begin
  if AErrorMessage <> '' then
  begin
    ConversionStopped;
    AErrorMessage[1] := UpCase(AErrorMessage[1]);
    Label_Status.Text := AErrorMessage;
  end
  else
  begin
    CurrentJobId := AJob.Id;
    UpdateCurrentJob(AJob);
    Timer1.Enabled := True;
  end;
end;

procedure TForm1.TMSFNCCloudFileConversion1FileDownloadedToFile(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult;
  AFile: TTMSFNCCloudFileConversionFile; ALocation, AErrorMessage: string);
begin
  if AErrorMessage <> '' then
    Label_Status.Text := AErrorMessage
  else
  begin
    TTMSFNCUtils.OpenFile(GetCurrentDir);
  end;
end;

procedure TForm1.TMSFNCCloudFileConversion1GetConvertJobDetails(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult; AJob: TTMSFNCCloudFileConversionJob; AErrorMessage: string);
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

end.
