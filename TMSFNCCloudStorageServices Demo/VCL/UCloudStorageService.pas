unit UCloudStorageService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Vcl.StdCtrls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCCustomScrollControl,
  VCL.TMSFNCCloudDemoListBox, Vcl.ExtCtrls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCloudStorageServices, VCL.TMSFNCCloudStorage, VCL.TMSFNCCloudBase,
  VCL.TMSFNCCloudBox, VCL.TMSFNCCloudDropBox, VCL.TMSFNCCloudGoogleDrive, VCL.TMSFNCCloudHubic,
  VCL.TMSFNCCloudMicrosoftOneDrive;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    TMSFNCCloudDemoListBox1: TTMSFNCCloudDemoListBox;
    Panel2: TPanel;
    Label1: TLabel;
    lPath: TLabel;
    btRootFolder: TButton;
    btUp: TButton;
    btOpenFolder: TButton;
    edCreateFolder: TEdit;
    btCreateFolder: TButton;
    btDownload: TButton;
    btUpload: TButton;
    btDelete: TButton;
    Panel3: TPanel;
    edCallbackURL: TEdit;
    Label6: TLabel;
    edSecret: TEdit;
    Label5: TLabel;
    edClientID: TEdit;
    Label4: TLabel;
    Label2: TLabel;
    cbStorageService: TComboBox;
    btConnect: TButton;
    TMSFNCCloudStorageServices1: TTMSFNCCloudStorageServices;
    procedure FormCreate(Sender: TObject);
    procedure cbStorageServiceChange(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure TMSFNCCloudStorageServices1Connected(Sender: TObject);
    procedure TMSFNCCloudStorageServices1CreateFolder(Sender: TObject;
      const AFolder: TTMSFNCCloudItem;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStorageServices1DeleteItem(Sender: TObject;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStorageServices1GetFolderList(Sender: TObject;
      const AItems: TTMSFNCCloudItems;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStorageServices1UploadFile(Sender: TObject;
      const AUploadItem: TTMSFNCCloudItem;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure btRootFolderClick(Sender: TObject);
    procedure btUpClick(Sender: TObject);
    procedure btOpenFolderClick(Sender: TObject);
    procedure btCreateFolderClick(Sender: TObject);
    procedure btDownloadClick(Sender: TObject);
    procedure btUploadClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
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
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

{ TForm4 }

procedure TForm4.btConnectClick(Sender: TObject);
begin
  if (edClientID.Text = '') or (edSecret.Text = '') and (edCallbackURL.Text = '') then
    raise Exception.Create('Please fill in ClientID, Secret and CallbackURL')
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

procedure TForm4.btCreateFolderClick(Sender: TObject);
begin
  if edCreateFolder.Text <> '' then
    TMSFNCCloudStorageServices1.CreateFolder(CurrentFolder, edCreateFolder.Text);
end;

procedure TForm4.btDeleteClick(Sender: TObject);
var
  ci: TTMSFNCCloudItem;
begin
  if TMSFNCCloudDemoListBox1.ItemIndex < 0 then
    Exit;

  ci := TMSFNCCloudDemoListBox1.Items[TMSFNCCloudDemoListBox1.ItemIndex].DataObject as TTMSFNCCloudItem;
  TMSFNCCloudStorageServices1.Delete(ci);
end;

procedure TForm4.btDownloadClick(Sender: TObject);
var
  it: TTMSFNCCloudItem;
  s: string;
begin
  if TMSFNCCloudDemoListBox1.ItemIndex < 0 then
    Exit;

  it := TMSFNCCloudDemoListBox1.Items[TMSFNCCloudDemoListBox1.ItemIndex].DataObject as TTMSFNCCloudItem;
  s := it.FileName;
  TTMSFNCUtils.SaveFile(s, '',
  procedure(const AFile: string; const AResult: Boolean)
  begin
    if not AResult then
      Exit;

    s := AFile;
    TMSFNCCloudStorageServices1.Download(it, s);
  end
  );
end;

procedure TForm4.btOpenFolderClick(Sender: TObject);
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

    CurrentFolder.Assign(ci);
    lPath.Caption := lPath.Caption + '\' + ci.FileName;
    TMSFNCCloudStorageServices1.GetFolderListHierarchical(CurrentFolder);
  end;
end;

procedure TForm4.btRootFolderClick(Sender: TObject);
begin
  CurrentFolder := nil;
  TMSFNCCloudStorageServices1.GetFolderList;
end;

procedure TForm4.btUpClick(Sender: TObject);
  function LastIndexOf(const S: string; const Chr: Char): Integer;
  var
    i: Integer;
  begin
    result := 0;
    for i := length(S) downto 1 do
      if S[i] = Chr then
      begin
        result := i-1;
        break;
      end;
  end;

begin
  if Assigned(CurrentFolder) and Assigned(CurrentFolder.ParentFolder) then
  begin
    CurrentFolder := CurrentFolder.ParentFolder;
    lPath.Caption := Copy(lPath.Caption, 0, LastIndexOf(lPath.Caption, '\'));
    if lPath.Caption = '' then
      lPath.Caption := 'root';
    TMSFNCCloudStorageServices1.GetFolderListHierarchical(CurrentFolder);
  end
  else
  begin
    CurrentFolder := nil;
    lPath.Caption := 'root';
    TMSFNCCloudStorageServices1.GetFolderList;
  end;
end;

procedure TForm4.btUploadClick(Sender: TObject);
var
  f: string;
begin
  TTMSFNCUtils.SelectFile(f, '', '',
  procedure(const AFile: string; const AResult: Boolean)
  begin
    if not AResult then
      Exit;

    f := AFile;
    TMSFNCCloudStorageServices1.Upload(CurrentFolder, f);
  end
  );
end;

procedure TForm4.cbStorageServiceChange(Sender: TObject);
begin
  SelectService;
end;

procedure TForm4.FillListBox(AItems: TTMSFNCCloudItems; AAddFolders,
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

procedure TForm4.FormCreate(Sender: TObject);
begin
  GoogleClientID := '';
  GoogleSecret := '';
  GoogleURL := '';

  BoxClientID := '';
  BoxSecret := '';
  BoxURL := '';

  DropBoxClientID := '';
  DropBoxSecret := '';
  DropBoxURL := '';

  OneDriveClientID := '';
  OneDriveSecret := '';
  OneDriveURL := '';

  HubicClientID := '';
  HubicSecret := '';
  HubicURL := '';

  SelectService;
end;

procedure TForm4.Refresh;
begin
  CurrentFolder := nil;
  TMSFNCCloudStorageServices1.GetFolderList;
end;

procedure TForm4.SelectService;
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

procedure TForm4.TMSFNCCloudStorageServices1Connected(Sender: TObject);
begin
  Refresh;
end;

procedure TForm4.TMSFNCCloudStorageServices1CreateFolder(Sender: TObject;
  const AFolder: TTMSFNCCloudItem;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  edCreateFolder.Text := '';
  TMSFNCCloudStorageServices1.GetFolderListHierarchical(CurrentFolder);
end;

procedure TForm4.TMSFNCCloudStorageServices1DeleteItem(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  Refresh;
end;

procedure TForm4.TMSFNCCloudStorageServices1GetFolderList(Sender: TObject;
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

procedure TForm4.TMSFNCCloudStorageServices1UploadFile(Sender: TObject;
  const AUploadItem: TTMSFNCCloudItem;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  TMSFNCCloudStorageServices1.GetFolderList;
end;

end.
