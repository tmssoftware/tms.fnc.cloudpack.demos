unit UCloudStellarDataStore;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase, FMX.TMSFNCCloudOAuth,
  FMX.TMSFNCCloudDataStore, FMX.TMSFNCCloudStellarDataStore, FMX.DateTimeCtrls,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCloudImage, Data.DB;

type
  TForm3 = class(TForm)
    pnAuth: TPanel;
    Label5: TLabel;
    edClientID: TEdit;
    edSecret: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edCallbackURL: TEdit;
    lbConnected: TLabel;
    pnContacts: TPanel;
    Button1: TButton;
    btConnect: TButton;
    listContacts: TListBox;
    TMSFNCCloudStellarDataStore1: TTMSFNCCloudStellarDataStore;
    pnDetails: TPanel;
    lbContacts: TLabel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    edEmail: TEdit;
    edLastName: TEdit;
    Label1: TLabel;
    Label8: TLabel;
    edFirstName: TEdit;
    Label9: TLabel;
    deBirthDate: TDateEdit;
    cbAdmin: TCheckBox;
    btAdd: TButton;
    btUpdate: TButton;
    btDelete: TButton;
    GroupBox2: TGroupBox;
    TMSFNCCloudImage1: TTMSFNCCloudImage;
    btUpload: TButton;
    btClear: TButton;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    btnLoadContacts: TButton;
    Label2: TLabel;
    Label10: TLabel;
    TMSFNCCloudImage2: TTMSFNCCloudImage;
    procedure btConnectClick(Sender: TObject);
    procedure TMSFNCCloudStellarDataStore1Connected(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCCloudStellarDataStore1GetProjects(Sender: TObject;
      const AInfo: TTMSFNCCloudStellarDataStoreProjects;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCCloudStellarDataStore1GetTables(Sender: TObject;
      const AInfo: TTMSFNCCloudStellarDataStoreTables;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStellarDataStore1GetMetaData(Sender: TObject;
      const AInfo: TTMSFNCCloudStellarDataStoreMetaData;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStellarDataStore1Query(Sender: TObject;
      const AInfo: TTMSFNCCloudStellarDataStoreEntities;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure btUploadClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btUpdateClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure TMSFNCCloudStellarDataStore1DownloadStream(Sender: TObject;
      const AInfo: TStream;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure btnLoadContactsClick(Sender: TObject);
    procedure listContactsChange(Sender: TObject);
    procedure TMSFNCCloudStellarDataStore1Insert(Sender: TObject;
      const AInfo: TTMSFNCCloudStellarDataStoreEntity;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStellarDataStore1Update(Sender: TObject;
      const AInfo: TTMSFNCCloudStellarDataStoreEntity;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStellarDataStore1Delete(Sender: TObject;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudStellarDataStore1Upload(Sender: TObject;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure TMSFNCCloudImage2Click(Sender: TObject);
    procedure lbConnectedClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TableName: string;
    function InitTable: Boolean;
    procedure DisplayContact;
    procedure ClearInput;
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.btAddClick(Sender: TObject);
var
  et: TTMSFNCCloudStellarDataStoreEntity;
begin
  et := TMSFNCCloudStellarDataStore1.Entities.Add;
  et.Values['FirstName'] := edFirstName.Text;
  et.Values['LastName'] := edLastName.Text;
  et.Values['Email'] := edEmail.Text;
  et.Values['Joined'] := deBirthDate.Date;
  et.Values['Admin'] := cbAdmin.IsChecked;

  TMSFNCCloudStellarDataStore1.Insert(et);
end;

procedure TForm3.btClearClick(Sender: TObject);
var
  et: TTMSFNCCloudStellarDataStoreEntity;
begin
  if listContacts.ItemIndex >= 0 then
  begin
    et := TTMSFNCCloudStellarDataStoreEntity(TMSFNCCloudStellarDataStore1.Entities[listContacts.ItemIndex]);
    if Assigned(et) then
    begin
      et.Blob['Avatar'].LoadFromStream(nil);
      DisplayContact;
    end;
  end
  else
  begin
    ShowMessage('No Contact selected');
  end;
end;

procedure TForm3.btConnectClick(Sender: TObject);
begin
  TMSFNCCloudStellarDataStore1.Authentication.ClientID := edClientID.Text;
  TMSFNCCloudStellarDataStore1.Authentication.Secret := edSecret.Text;
  TMSFNCCloudStellarDataStore1.Authentication.CallBackURL := edCallbackURL.Text;

  TMSFNCCloudStellarDataStore1.PersistTokens.Key := TableName;
  TMSFNCCloudStellarDataStore1.LoadTokens;
  TMSFNCCloudStellarDataStore1.Connect;
end;

procedure TForm3.btDeleteClick(Sender: TObject);
var
  et: TTMSFNCCloudStellarDataStoreEntity;
begin
  if listContacts.ItemIndex >= 0 then
  begin
    et := TMSFNCCloudStellarDataStore1.Entities[listContacts.ItemIndex];
    if Assigned(et) then
    begin
      TMSFNCCloudStellarDataStore1.Delete(et.ID);
    end;
  end
  else
  begin
    ShowMessage('No Contact selected');
  end;
end;

procedure TForm3.btnLoadContactsClick(Sender: TObject);
begin
  TMSFNCCloudStellarDataStore1.Query;
end;

procedure TForm3.btUpdateClick(Sender: TObject);
var
  et: TTMSFNCCloudStellarDataStoreEntity;
begin
  if listContacts.ItemIndex >= 0 then
  begin
    et := TMSFNCCloudStellarDataStore1.Entities[listContacts.ItemIndex] as TTMSFNCCloudStellarDataStoreEntity;
    if Assigned(et) then
    begin
      et.Values['FirstName'] := edFirstName.Text;
      et.Values['LastName'] := edLastName.Text;
      et.Values['Email'] := edEmail.Text;
      et.Values['Joined'] := deBirthDate.Date;
      et.Values['Admin'] := cbAdmin.IsChecked;
      TMSFNCCloudStellarDataStore1.Update(et);
    end;
  end
  else
  begin
    ShowMessage('No Contact selected');
  end;
end;

procedure TForm3.btUploadClick(Sender: TObject);
var
  et: TTMSFNCCloudStellarDataStoreEntity;
begin
  if listContacts.ItemIndex >= 0 then
  begin
    if (OpenDialog1.Execute) then
    begin
      et := TTMSFNCCloudStellarDataStoreEntity(TMSFNCCloudStellarDataStore1.Entities[listContacts.ItemIndex]);
      if Assigned(et) then
      begin
        et.Blob['Avatar'].LoadFromFile(OpenDialog1.FileName);
      end;
    end
  end
  else
  begin
    ShowMessage('No Contact selected');
  end;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  TMSFNCCloudStellarDataStore1.ClearTokens;
  lbConnected.Text := '';
  pnContacts.Enabled := False;
  pnDetails.Enabled := False;
end;

procedure TForm3.ClearInput;
begin
  edFirstName.Text := '';
  edLastName.Text := '';
  edEmail.Text := '';
  deBirthDate.Date := Now;
  cbAdmin.IsChecked := False;
  TMSFNCCloudImage1.URL := '';
end;

procedure TForm3.DisplayContact;
var
  et: TTMSFNCCloudStellarDataStoreEntity;
begin
  if listContacts.ItemIndex >= 0 then
  begin
    et := listContacts.Items.Objects[listContacts.ItemIndex] as TTMSFNCCloudStellarDataStoreEntity;
    if Assigned(et) then
    begin
      edFirstName.Text := et.ValueAsString['FirstName'];
      edLastName.Text := et.ValueAsString['LastName'];
      edEmail.Text := et.ValueAsString['Email'];
      deBirthDate.Date := StrToDateTime(et.ValueAsString['Joined']);
      cbAdmin.IsChecked := StrToBool(et.ValueAsString['Admin']);
      et.Blob['Avatar'].SaveToStream;
    end;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  TableName := 'TTMSFNCCloudStellarDataStore';
  pnContacts.Enabled := False;
  pnDetails.Enabled := False;
  ClearInput;
end;

procedure TForm3.lbConnectedClick(Sender: TObject);
begin
  TTMSFNCUtils.Message('test');
end;

procedure TForm3.listContactsChange(Sender: TObject);
begin
  DisplayContact;
end;

procedure TForm3.TMSFNCCloudImage2Click(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://stellards.io');
end;

procedure TForm3.TMSFNCCloudStellarDataStore1Connected(Sender: TObject);
begin
  pnContacts.Enabled := True;
  lbConnected.Text := 'Connected!';
  TMSFNCCloudStellarDataStore1.SaveTokens;
  TMSFNCCloudStellarDataStore1.GetProjects;
end;

procedure TForm3.TMSFNCCloudStellarDataStore1Delete(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  ClearInput;
  TMSFNCCloudStellarDataStore1.GetTables;
end;

procedure TForm3.TMSFNCCloudStellarDataStore1DownloadStream(Sender: TObject;
  const AInfo: TStream; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if Assigned(AInfo) then
    TMSFNCCloudImage1.Bitmap.LoadFromStream(AInfo)
  else
    TMSFNCCloudImage1.URL := '';
end;

procedure TForm3.TMSFNCCloudStellarDataStore1GetMetaData(Sender: TObject;
  const AInfo: TTMSFNCCloudStellarDataStoreMetaData;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if ARequestResult.Success then
  begin
    listContacts.Clear;
    TMSFNCCloudStellarDataStore1.Query;
  end;
end;

procedure TForm3.TMSFNCCloudStellarDataStore1GetProjects(Sender: TObject;
  const AInfo: TTMSFNCCloudStellarDataStoreProjects;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if AInfo.Count > 0 then
  begin
    TMSFNCCloudStellarDataStore1.ProjectId := AInfo[0].Id;
    TMSFNCCloudStellarDataStore1.GetTables;
  end;
end;

function TForm3.InitTable: Boolean;
var
  t: TTMSFNCCloudStellarDataStoreTable;
  mi: TTMSFNCCloudStellarDataStoreMetaDataItem;
  et: TTMSFNCCloudStellarDataStoreEntity;
begin
  Result := False;
  t := TMSFNCCloudStellarDataStore1.TableByName(TableName);
  if Assigned(t) then
  begin
    Result := True;
  end
  else
  begin
    TMSFNCCloudStellarDataStore1.Mode := moSync;
    t := TTMSFNCCloudStellarDataStoreTable.Create(TMSFNCCloudStellarDataStore1.Tables);
    t.Name := TableName;
    TMSFNCCloudStellarDataStore1.AddTable(t);

    TMSFNCCloudStellarDataStore1.TableId := t.ID;

    mi := TMSFNCCloudStellarDataStore1.MetaData.Add;
    mi.PropertyName := 'FirstName';
    mi.DataType := ftString;
    TMSFNCCloudStellarDataStore1.AddMetaData(mi);

    mi := TMSFNCCloudStellarDataStore1.MetaData.Add;
    mi.PropertyName := 'LastName';
    mi.DataType := ftString;
    TMSFNCCloudStellarDataStore1.AddMetaData(mi);

    mi := TMSFNCCloudStellarDataStore1.MetaData.Add;
    mi.PropertyName := 'Email';
    mi.DataType := ftString;
    TMSFNCCloudStellarDataStore1.AddMetaData(mi);

    mi := TMSFNCCloudStellarDataStore1.MetaData.Add;
    mi.PropertyName := 'Joined';
    mi.DataType := ftDateTime;
    TMSFNCCloudStellarDataStore1.AddMetaData(mi);

    mi := TMSFNCCloudStellarDataStore1.MetaData.Add;
    mi.PropertyName := 'Admin';
    mi.DataType := ftBoolean;
    TMSFNCCloudStellarDataStore1.AddMetaData(mi);

    mi := TMSFNCCloudStellarDataStore1.MetaData.Add;
    mi.PropertyName := 'Sales';
    mi.DataType := ftFloat;
    TMSFNCCloudStellarDataStore1.AddMetaData(mi);

    mi := TMSFNCCloudStellarDataStore1.MetaData.Add;
    mi.PropertyName := 'Avatar';
    mi.DataType := ftBlob;
    TMSFNCCloudStellarDataStore1.AddMetaData(mi);

    TMSFNCCloudStellarDataStore1.GetMetaData;

    et := TMSFNCCloudStellarDataStore1.Entities.Add;
    et.Values['FirstName'] := 'Isaac';
    et.Values['LastName'] := 'Tailor';
    et.Values['Email'] := 'isaac@contacts.com';
    et.Values['Admin'] := True;
    et.Values['Joined'] := StrToDateTime('11/08/2009');
    TMSFNCCloudStellarDataStore1.Insert(et);

    et := TMSFNCCloudStellarDataStore1.Entities.Add;
    et.Values['FirstName'] := 'Laura';
    et.Values['LastName'] := 'Schneider';
    et.Values['Email'] := 'laura@contacts.com';
    et.Values['Admin'] := False;
    et.Values['Joined'] := StrToDateTime('17/06/2011');
    TMSFNCCloudStellarDataStore1.Insert(et);

    et := TMSFNCCloudStellarDataStore1.Entities.Add;
    et.Values['FirstName'] := 'Leon';
    et.Values['LastName'] := 'Sastre';
    et.Values['Email'] := 'leon@contacts.com';
    et.Values['Admin'] := False;
    et.Values['Joined'] := StrToDateTime('01/02/1996');
    TMSFNCCloudStellarDataStore1.Insert(et);

    et := TMSFNCCloudStellarDataStore1.Entities.Add;
    et.Values['FirstName'] := 'Marie';
    et.Values['LastName'] := 'Tailleur';
    et.Values['Email'] := 'marie@contacts.com';
    et.Values['Admin'] := False;
    et.Values['Joined'] := StrToDateTime('16/07/2014');
    TMSFNCCloudStellarDataStore1.Insert(et);

    TMSFNCCloudStellarDataStore1.Mode := moAsync;
  end;
end;

procedure TForm3.TMSFNCCloudStellarDataStore1GetTables(Sender: TObject;
  const AInfo: TTMSFNCCloudStellarDataStoreTables;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  if InitTable then
  begin
    for I := 0 to AInfo.Count - 1 do
    begin
      if AInfo[I].Name = TableName then
      begin
        TMSFNCCloudStellarDataStore1.TableId := AInfo[I].ID;
        TMSFNCCloudStellarDataStore1.GetMetaData;
      end;
    end;
  end;
end;

procedure TForm3.TMSFNCCloudStellarDataStore1Insert(Sender: TObject;
  const AInfo: TTMSFNCCloudStellarDataStoreEntity;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  ClearInput;
  TMSFNCCloudStellarDataStore1.GetTables;
end;

procedure TForm3.TMSFNCCloudStellarDataStore1Query(Sender: TObject;
  const AInfo: TTMSFNCCloudStellarDataStoreEntities;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  pnDetails.Enabled := True;
  listContacts.Clear;
  for I := 0 to AInfo.Count - 1 do
  begin
    listContacts.Items.AddObject(AInfo[I].ValueAsString['FirstName'] + ' ' + AInfo[I].ValueAsString['LastName'], AInfo[I]);
  end;
end;

procedure TForm3.TMSFNCCloudStellarDataStore1Update(Sender: TObject;
  const AInfo: TTMSFNCCloudStellarDataStoreEntity;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  ClearInput;
  TMSFNCCloudStellarDataStore1.GetTables;
end;

procedure TForm3.TMSFNCCloudStellarDataStore1Upload(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  DisplayContact;
end;

end.
