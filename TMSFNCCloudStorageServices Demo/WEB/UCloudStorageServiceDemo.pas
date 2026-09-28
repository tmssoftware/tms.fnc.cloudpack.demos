unit UCloudStorageServiceDemo;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Vcl.Controls, Vcl.StdCtrls,
  WEBLib.StdCtrls, VCL.TMSFNCCustomComponent, VCL.TMSFNCCloudStorageServices,
  VCL.TMSFNCCustomControl, VCL.TMSFNCCustomScrollControl,
  VCL.TMSFNCCloudDemoListBox, WEBLib.ExtCtrls, VCL.TMSFNCCloudStorage,
  VCL.TMSFNCCloudBase, VCL.TMSFNCEdit, WEBLib.WebCtrls, VCL.TMSFNCCloudDropBox, VCL.TMSFNCCloudGoogleDrive,
  VCL.TMSFNCCloudGoogle, VCL.TMSFNCCloudHubic, VCL.TMSFNCCloudMicrosoftOneDrive,
  VCL.TMSFNCCloudBox;

type
  TForm1 = class(TWebForm)
    WebPanel1: TWebPanel;
    TMSFNCCloudDemoListBox1: TTMSFNCCloudDemoListBox;
    WebPanel2: TWebPanel;
    WebLabel2: TWebLabel;
    lPath: TWebLabel;
    btRootFolder: TWebButton;
    btOpenFolder: TWebButton;
    btCreateFolder: TWebButton;
    btDelete: TWebButton;
    edCreateFolder: TWebEdit;
    WebMessageDlg1: TWebMessageDlg;
    WebPanel3: TWebPanel;
    WebLabel3: TWebLabel;
    cbStorageService: TWebComboBox;
    btConnect: TWebButton;
    TMSFNCCloudStorageServices1: TTMSFNCCloudStorageServices;
    WebLabel5: TWebLabel;
    edClientiD: TWebEdit;
    WebLabel6: TWebLabel;
    edSecret: TWebEdit;
    WebLabel7: TWebLabel;
    edCallbackURL: TWebEdit;
    btDownload: TWebButton;
    WebFilePicker1: TWebFilePicker;
    btUpload: TWebButton;
    WebLabel1: TWebLabel;
    procedure WebFormCreate(Sender: TObject);
    procedure cbStorageServiceChange(Sender: TObject);
    procedure TMSFNCCloudStorageServices1Connected(Sender: TObject);
    procedure TMSFNCCloudStorageServices1CreateFolder(Sender: TObject;
      const AFolder: TTMSFNCCloudItem;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStorageServices1DeleteItem(Sender: TObject;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStorageServices1GetFolderList(Sender: TObject;
      const AItems: TTMSFNCCloudItems;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure btRootFolderClick(Sender: TObject);
    procedure btOpenFolderClick(Sender: TObject);
    procedure btCreateFolderClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btDownloadClick(Sender: TObject);
    procedure btUploadClick(Sender: TObject);
    procedure TMSFNCCloudStorageServices1UploadFile(Sender: TObject;
      const AUploadItem: TTMSFNCCloudItem;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
  private
    { Private declarations }
  public
    { Public declarations }
    GoogleClientID: string;
    GoogleSecret: string;
    GoogleURL: string;

    BoxClientID: string;
    BoxSecret: string;
    BoxURL: string;

    DropBoxClientID: string;
    DropBoxSecret: string;
    DropBoxURL: string;

    OneDriveClientID: string;
    OneDriveSecret: string;
    OneDriveURL: string;

    HubicClientID: string;
    HubicSecret: string;
    HubicURL: string;

    CurrentFolder: TTMSFNCCloudItem;
    procedure Refresh;
    procedure SelectService;
    procedure FillListBox(AItems: TTMSFNCCloudItems; AAddFolders, AAddFiles: Boolean);
    procedure DoFileLoaded(const AFile: TTMSFNCUtilsFile);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.DoFileLoaded(const AFile: TTMSFNCUtilsFile);
begin
  TMSFNCCloudStorageServices1.Upload(CurrentFolder, AFile);
end;

procedure TForm1.btConnectClick(Sender: TObject);
begin
  if (edClientID.Text = '') or (edSecret.Text = '') and (edCallbackURL.Text = '') then
    WebMessageDlg1.ShowDialog('Please fill in ClientID, Secret and CallbackURL', mtError, [], nil)
  else
  begin
    if cbStorageService.ItemIndex = 2 then
    begin
      GoogleClientID := edClientID.Text;
      GoogleSecret := edSecret.Text;
      GoogleURL := edCallbackURL.Text;
    end
    else if cbStorageService.ItemIndex = 0 then
    begin
      BoxClientID := edClientID.Text;
      BoxSecret := edSecret.Text;
      BoxURL := edCallbackURL.Text;
    end
    else if cbStorageService.ItemIndex = 1 then
    begin
      DropBoxClientID := edClientID.Text;
      DropBoxSecret := edSecret.Text;
      DropBoxURL := edCallbackURL.Text;
    end
    else if cbStorageService.ItemIndex = 3 then
    begin
      OneDriveClientID := edClientID.Text;
      OneDriveSecret := edSecret.Text;
      OneDriveURL := edCallbackURL.Text;
    end
    else if cbStorageService.ItemIndex = 4 then
    begin
      HubicClientID := edClientID.Text;
      HubicSecret := edSecret.Text;
      HubicURL := edCallbackURL.Text;
    end;
    SelectService;
    TMSFNCCloudStorageServices1.Connect;
  end;
end;

procedure TForm1.btCreateFolderClick(Sender: TObject);
begin
  if edCreateFolder.Text <> '' then
    TMSFNCCloudStorageServices1.CreateFolder(CurrentFolder, edCreateFolder.Text);
end;

procedure TForm1.btDeleteClick(Sender: TObject);
var
  ci: TTMSFNCCloudItem;
begin
  if TMSFNCCloudDemoListBox1.ItemIndex < 0 then
    Exit;

  ci := TMSFNCCloudDemoListBox1.Items[TMSFNCCloudDemoListBox1.ItemIndex].DataObject as TTMSFNCCloudItem;
  TMSFNCCloudStorageServices1.Delete(ci);
end;

procedure TForm1.btDownloadClick(Sender: TObject);
var
  ci: TTMSFNCCloudItem;
begin
  if TMSFNCCloudDemoListBox1.ItemIndex < 0 then
    Exit;

  ci := TMSFNCCloudDemoListBox1.Items[TMSFNCCloudDemoListBox1.ItemIndex].DataObject as TTMSFNCCloudItem;

  TMSFNCCloudStorageServices1.Download(ci, ci.FileName);
end;

procedure TForm1.btOpenFolderClick(Sender: TObject);
var
  ci: TTMSFNCCloudItem;
begin
  if TMSFNCCloudDemoListBox1.ItemIndex < 0 then
    Exit;

  ci := TMSFNCCloudDemoListBox1.Items[TMSFNCCloudDemoListBox1.ItemIndex].DataObject as TTMSFNCCloudItem;

  if ci.ItemType = ciFolder then
  begin
    case TMSFNCCloudStorageServices1.Service of
      cssBox: CurrentFolder := TTMSFNCCloudBoxItem.Create(nil);
      cssDropBox: CurrentFolder := TTMSFNCCloudDropBoxItem.Create(nil);
      cssGoogleDrive: CurrentFolder := TTMSFNCCloudGoogleDriveItem.Create(nil);
      cssHubic: CurrentFolder := TTMSFNCCloudHubicItem.Create(nil);
      cssMicrosoftOneDrive: CurrentFolder := TTMSFNCCloudMicrosoftOneDriveItem.Create(nil);
    end;

    CurrentFolder := ci;
    lPath.Caption := lPath.Caption + '\' + ci.FileName;
    TMSFNCCloudStorageServices1.GetFolderListHierarchical(CurrentFolder);
  end;
end;

procedure TForm1.btRootFolderClick(Sender: TObject);
begin
  lPath.Caption := 'root';
  CurrentFolder := nil;
  TMSFNCCloudStorageServices1.GetFolderList;
end;

procedure TForm1.btUploadClick(Sender: TObject);
var
  f: TTMSFNCUtilsFile;
begin
  if WebFilePicker1.Files.Count > 0 then
    TTMSFNCUtils.LoadFile(WebFilePicker1.Files[0].FileObject, @DoFileLoaded)
  else
    ShowMessage('Select a file to upload first');
end;

procedure TForm1.cbStorageServiceChange(Sender: TObject);
begin
  SelectService;
end;

procedure TForm1.FillListBox(AItems: TTMSFNCCloudItems; AAddFolders,
  AAddFiles: Boolean);
var
  I: Integer;
  ftype: string;
  ci: TTMSFNCCloudItem;
begin
  if not Assigned(AItems) then
    Exit;

  TMSFNCCloudDemoListBox1.BeginUpdate;
  for I := 0 to AItems.Count - 1 do
  begin
    ci := AItems.Items[I];
    ftype := LowerCase(StringReplace(ExtractFileExt(ci.FileName), '.', '', [rfReplaceAll]));
    if AItems.Items[I].ItemType = ciFolder then
      ftype := 'folder'
    else if ftype = '' then
      ftype := 'file';

    if not TMSFNCCloudDemoListBox1.SupportsFileType(ftype) then
      ftype := 'file';

    if ((ci.ItemType = ciFolder) and AAddFolders) or ((ci.ItemType = ciFile) and AAddFiles) then
      TMSFNCCloudDemoListBox1.AddItem(AItems.Items[I].Filename, ftype, ci);
  end;
  TMSFNCCloudDemoListBox1.EndUpdate;
end;

procedure TForm1.Refresh;
begin
  CurrentFolder := nil;
  TMSFNCCloudStorageServices1.GetFolderList;
end;

procedure TForm1.SelectService;
var
  spersist: string;
begin
  spersist := TTMSFNCUtils.AddBackslash(TTMSFNCUtils.GetDocumentsPath) + TMSFNCCloudStorageServices1.ClassName;

  if cbStorageService.ItemIndex = 2 then
  begin
    TMSFNCCloudStorageServices1.Service := cssGoogleDrive;
    TMSFNCCloudStorageServices1.Authentication.ClientID := GoogleClientID;
    TMSFNCCloudStorageServices1.Authentication.Secret := GoogleSecret;
    TMSFNCCloudStorageServices1.Authentication.CallBackURL := GoogleURL;
    TMSFNCCloudStorageServices1.PersistTokens.Key := spersist + 'GoogleDrive.ini';
  end
  else if cbStorageService.ItemIndex = 0 then
  begin
    TMSFNCCloudStorageServices1.Service := cssBox;
    TMSFNCCloudStorageServices1.Authentication.ClientID := BoxClientID;
    TMSFNCCloudStorageServices1.Authentication.Secret := BoxSecret;
    TMSFNCCloudStorageServices1.Authentication.CallBackURL := BoxURL;
    TMSFNCCloudStorageServices1.PersistTokens.Key := spersist + 'Box.ini';
  end
  else if cbStorageService.ItemIndex = 1 then
  begin
    TMSFNCCloudStorageServices1.Service := cssDropBox;
    TMSFNCCloudStorageServices1.Authentication.ClientID := DropBoxClientID;
    TMSFNCCloudStorageServices1.Authentication.Secret := DropBoxSecret;
    TMSFNCCloudStorageServices1.Authentication.CallBackURL := DropBoxURL;
    TMSFNCCloudStorageServices1.PersistTokens.Key := spersist + 'DropBox.ini';
  end
  else if cbStorageService.ItemIndex = 3 then
  begin
    TMSFNCCloudStorageServices1.Service := cssMicrosoftOneDrive;
    TMSFNCCloudStorageServices1.Authentication.ClientID := OneDriveClientID;
    TMSFNCCloudStorageServices1.Authentication.Secret := OneDriveSecret;
    TMSFNCCloudStorageServices1.Authentication.CallBackURL := OneDriveURL;
    TMSFNCCloudStorageServices1.PersistTokens.Key := spersist + 'OneDrive.ini';
  end
  else if cbStorageService.ItemIndex = 4 then
  begin
    TMSFNCCloudStorageServices1.Service := cssHubic;
    TMSFNCCloudStorageServices1.Authentication.ClientID := HubicClientID;
    TMSFNCCloudStorageServices1.Authentication.Secret := HubicSecret;
    TMSFNCCloudStorageServices1.Authentication.CallBackURL := HubicURL;
    TMSFNCCloudStorageServices1.PersistTokens.Key := spersist + 'Hubic.ini';
  end;

  edClientID.Text := TMSFNCCloudStorageServices1.Authentication.ClientID;
  edSecret.Text := TMSFNCCloudStorageServices1.Authentication.Secret;
  edCallbackURL.Text := TMSFNCCloudStorageServices1.Authentication.CallBackURL;

  TMSFNCCloudStorageServices1.Storage.LoadTokens;
end;

procedure TForm1.TMSFNCCloudStorageServices1Connected(Sender: TObject);
begin
  Refresh;
end;

procedure TForm1.TMSFNCCloudStorageServices1CreateFolder(Sender: TObject;
  const AFolder: TTMSFNCCloudItem;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  edCreateFolder.Text := '';
  TMSFNCCloudStorageServices1.GetFolderListHierarchical(CurrentFolder);
end;

procedure TForm1.TMSFNCCloudStorageServices1DeleteItem(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  Refresh;
end;

procedure TForm1.TMSFNCCloudStorageServices1GetFolderList(Sender: TObject;
  const AItems: TTMSFNCCloudItems;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  TMSFNCCloudDemoListBox1.BeginUpdate;
  TMSFNCCloudDemoListBox1.ItemIndex := -1;
  TMSFNCCloudDemoListBox1.Items.Clear;
  FillListBox(AItems, True, False);
  FillListBox(AItems, False, True);
  TMSFNCCloudDemoListBox1.EndUpdate;
end;

procedure TForm1.TMSFNCCloudStorageServices1UploadFile(Sender: TObject;
  const AUploadItem: TTMSFNCCloudItem;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if ARequestResult.Success then
  begin
    ShowMessage('File uploaded');
    TMSFNCCloudStorageServices1.GetFolderListHierarchical(CurrentFolder);
  end
  else
  begin
    ShowMessage('Upload failed');
  end;
end;

procedure TForm1.WebFormCreate(Sender: TObject);
begin
  SelectService;
end;

end.