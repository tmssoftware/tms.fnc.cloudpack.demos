unit UCloudStellarDataStoreDataSet;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase, FMX.StdCtrls, FMX.Edit,
  FMX.Controls.Presentation, System.Rtti, FMX.Grid.Style, Data.DB,
  Datasnap.DBClient, FMX.TMSFNCCloudDataStore, FMX.TMSFNCCloudStellarDataStore,
  FMX.TMSFNCCloudCustomDataSet, FMX.TMSFNCCloudStellarDataStoreDataSet, FMX.ScrollBox,
  FMX.Grid, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  Data.Bind.Controls, FMX.Layouts, Fmx.Bind.Navigator, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCloudImage;

type
  TForm2 = class(TForm)
    pnAuth: TPanel;
    Label5: TLabel;
    edClientID: TEdit;
    edSecret: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edCallbackURL: TEdit;
    lbConnected: TLabel;
    btDisconnect: TButton;
    btConnect: TButton;
    Grid1: TGrid;
    TMSFNCCloudStellarDataStoreConnection1: TTMSFNCCloudStellarDataStoreConnection;
    BindingsList1: TBindingsList;
    Panel1: TPanel;
    cbBlob: TCheckBox;
    BindNavigator1: TBindNavigator;
    Label3: TLabel;
    edProjectID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    TMSFNCCloudImage1: TTMSFNCCloudImage;
    Label10: TLabel;
    TMSFNCCloudStellarDataStoreDataSetFMX1: TTMSFNCCloudStellarDataStoreDataSetFMX;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    procedure btConnectClick(Sender: TObject);
    procedure TMSFNCCloudStellarDataStoreDataSetFMX1AfterOpen(DataSet: TDataSet);
    procedure TMSFNCCloudStellarDataStoreDataSetFMX1GetBlobData(Sender: TObject;
      const AField, ARecordID: string; var AAllow: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cbBlobChange(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure TMSFNCCloudStellarDataStoreConnection1Connected(Sender: TObject);
    procedure TMSFNCCloudImage1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TableName: string;
    procedure InitTable;
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.btConnectClick(Sender: TObject);
begin
  TMSFNCCloudStellarDataStoreConnection1.Authentication.ClientID := edClientID.Text;
  TMSFNCCloudStellarDataStoreConnection1.Authentication.Secret := edSecret.Text;
  TMSFNCCloudStellarDataStoreConnection1.Authentication.CallBackURL := edCallbackURL.Text;

  TMSFNCCloudStellarDataStoreConnection1.PersistTokens.Key := 'StellarDataStoreConnection';

  TMSFNCCloudStellarDataStoreDataSetFMX1.Connection := TMSFNCCloudStellarDataStoreConnection1;
  TMSFNCCloudStellarDataStoreDataSetFMX1.ProjectID := edProjectID.Text;
  TMSFNCCloudStellarDataStoreDataSetFMX1.Table := TableName;
  TMSFNCCloudStellarDataStoreDataSetFMX1.Active := True;
end;

procedure TForm2.btDisconnectClick(Sender: TObject);
begin
  TMSFNCCloudStellarDataStoreDataSetFMX1.Active := False;
end;

procedure TForm2.cbBlobChange(Sender: TObject);
begin
  if TMSFNCCloudStellarDataStoreDataSetFMX1.Active then
  begin
    TMSFNCCloudStellarDataStoreDataSetFMX1.Active := False;
    TMSFNCCloudStellarDataStoreDataSetFMX1.Active := True;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  c: TLinkGridToDataSourceColumn;
begin
  TableName := 'TTMSFNCCloudStellarDataStore';

  c := LinkGridToDataSourceBindSourceDB2.Columns.Add;
  c.ColumnStyle := 'ImageColumn';
  c.MemberName := 'Avatar';

  c := LinkGridToDataSourceBindSourceDB2.Columns.Add;
  c.MemberName := 'FirstName';

  c := LinkGridToDataSourceBindSourceDB2.Columns.Add;
  c.MemberName := 'LastName';

  c := LinkGridToDataSourceBindSourceDB2.Columns.Add;
  c.MemberName := 'Email';

  c := LinkGridToDataSourceBindSourceDB2.Columns.Add;
  c.MemberName := 'Admin';

  c := LinkGridToDataSourceBindSourceDB2.Columns.Add;
  c.ColumnStyle := 'DateColumn';
  c.MemberName := 'Joined';
end;

procedure TForm2.InitTable;
var
  StellarDataStore: TTMSFNCCloudStellarDataStore;
  t: TTMSFNCCloudStellarDataStoreTable;
  mi: TTMSFNCCloudStellarDataStoreMetaDataItem;
  et: TTMSFNCCloudStellarDataStoreEntity;
begin
  StellarDataStore := TTMSFNCCloudStellarDataStore.Create(Self);
  StellarDataStore.Mode := moSync;

  StellarDataStore.Authentication.AccessToken := TMSFNCCloudStellarDataStoreConnection1.Authentication.AccessToken;

  if StellarDataStore.Authentication.AccessToken <> '' then
  begin
    StellarDataStore.ProjectId := TMSFNCCloudStellarDataStoreDataSetFMX1.ProjectID;
    StellarDataStore.GetTables;

    t := StellarDataStore.TableByName(TableName);
    if not Assigned(t) then
    begin
      t := TTMSFNCCloudStellarDataStoreTable.Create(StellarDataStore.Tables);
      t.Name := TableName;
      StellarDataStore.AddTable(t);

      StellarDataStore.TableId := t.ID;

      mi := StellarDataStore.MetaData.Add;
      mi.PropertyName := 'FirstName';
      mi.DataType := ftString;
      StellarDataStore.AddMetaData(mi);

      mi := StellarDataStore.MetaData.Add;
      mi.PropertyName := 'LastName';
      mi.DataType := ftString;
      StellarDataStore.AddMetaData(mi);

      mi := StellarDataStore.MetaData.Add;
      mi.PropertyName := 'Email';
      mi.DataType := ftString;
      StellarDataStore.AddMetaData(mi);

      mi := StellarDataStore.MetaData.Add;
      mi.PropertyName := 'Joined';
      mi.DataType := ftDateTime;
      StellarDataStore.AddMetaData(mi);

      mi := StellarDataStore.MetaData.Add;
      mi.PropertyName := 'Admin';
      mi.DataType := ftBoolean;
      StellarDataStore.AddMetaData(mi);

      mi := StellarDataStore.MetaData.Add;
      mi.PropertyName := 'Avatar';
      mi.DataType := ftBlob;
      StellarDataStore.AddMetaData(mi);

      StellarDataStore.GetMetaData;

      et := StellarDataStore.Entities.Add as TTMSFNCCloudStellarDataStoreEntity;
      et.Values['FirstName'] := 'Isaac';
      et.Values['LastName'] := 'Tailor';
      et.Values['Email'] := 'isaac@contacts.com';
      et.Values['Admin'] := True;
      et.Values['Joined'] := EncodeDate(2009, 11, 10);
      StellarDataStore.Insert(et);

      et := StellarDataStore.Entities.Add as TTMSFNCCloudStellarDataStoreEntity;
      et.Values['FirstName'] := 'Laura';
      et.Values['LastName'] := 'Schneider';
      et.Values['Email'] := 'laura@contacts.com';
      et.Values['Admin'] := False;
      et.Values['Joined'] := EncodeDate(2011, 06, 21);
      StellarDataStore.Insert(et);

      et := StellarDataStore.Entities.Add as TTMSFNCCloudStellarDataStoreEntity;
      et.Values['FirstName'] := 'Leon';
      et.Values['LastName'] := 'Sastre';
      et.Values['Email'] := 'leon@contacts.com';
      et.Values['Admin'] := False;
      et.Values['Joined'] := EncodeDate(1996, 02, 01);
      StellarDataStore.Insert(et);

      et := StellarDataStore.Entities.Add as TTMSFNCCloudStellarDataStoreEntity;
      et.Values['FirstName'] := 'Marie';
      et.Values['LastName'] := 'Tailleur';
      et.Values['Email'] := 'marie@contacts.com';
      et.Values['Admin'] := False;
      et.Values['Joined'] := EncodeDate(2014, 07, 06);
      StellarDataStore.Insert(et);
    end;
  end;

  StellarDataStore.Free;
end;

procedure TForm2.TMSFNCCloudImage1Click(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://stellards.io');
end;

procedure TForm2.TMSFNCCloudStellarDataStoreConnection1Connected(Sender: TObject);
begin
  lbConnected.Text := 'Connected!';
  InitTable;
end;

procedure TForm2.TMSFNCCloudStellarDataStoreDataSetFMX1AfterOpen(DataSet: TDataSet);
var
  i: Integer;
begin
  Grid1.RowHeight := 50;
  for i := 0 to Grid1.ColumnCount - 1 do
    Grid1.Columns[i].Width := 128;
end;

procedure TForm2.TMSFNCCloudStellarDataStoreDataSetFMX1GetBlobData(Sender: TObject;
  const AField, ARecordID: string; var AAllow: Boolean);
begin
  if AField = 'Avatar' then
    AAllow := cbBlob.IsChecked;
end;

end.
