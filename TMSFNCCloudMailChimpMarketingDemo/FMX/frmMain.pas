unit frmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCUtils,
   FMX.TMSFNCCloudMailChimp.Marketing, FMX.Layouts,
  FMX.ListBox, FMX.TMSFNCCloudOAuth, FMX.Edit, System.Rtti, FMX.Grid.Style,
  FMX.Grid, FMX.ScrollBox, FMX.Memo.Types, FMX.Memo, FMX.TabControl;

type
  TForm5 = class(TForm)
    TMSFNCCloudMailChimpMarketing1: TTMSFNCCloudMailChimpMarketing;
    CompanyEdit: TEdit;
    AdressEdit: TEdit;
    CountryEdit: TEdit;
    CityEdit: TEdit;
    PermissionReminderEdit: TEdit;
    LanguageEdit: TEdit;
    FromNameEdit: TEdit;
    FromEmailEdit: TEdit;
    SubjectEdit: TEdit;
    AddNewList: TButton;
    ListsListBox: TListBox;
    ListNameEdit: TEdit;
    UpdateList: TButton;
    DeleteList: TButton;
    ZipEdit: TEdit;
    ListBox1: TListBox;
    SendCampaignButton: TButton;
    ListBox2: TListBox;
    Edit1: TEdit;
    AddMemberButton: TButton;
    DeleteMemberButton: TButton;
    FirstPageButton: TButton;
    CurrentPageButton: TButton;
    NextPageButton: TButton;
    PreviousPageButton: TButton;
    ContentMemo: TMemo;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    APIKey: TEdit;
    Panel1: TPanel;
    ConnectButton: TButton;
    AddCampaign: TButton;
    Title: TEdit;
    FromName: TEdit;
    ReplyTo: TEdit;
    PreviewText: TEdit;
    SubjectLine: TEdit;
    StatusLabel: TLabel;
    SaveCampaignContent: TButton;
    UpdateCampaign: TButton;
    NewCampaign: TButton;
    procedure AddNewListClick(Sender: TObject);
    procedure TMSFNCCloudMailChimpMarketing1GetLists(Sender: TObject;
      ALists: TTMSFNCCloudMailChimpSubscriberLists);
    procedure TMSFNCCloudMailChimpMarketing1GetMembers(Sender: TObject;
      AMembers: TTMSFNCCloudMailChimpListMembers);
    procedure ListsListBoxChange(Sender: TObject);
    procedure TMSFNCCloudMailChimpMarketing1AddList(Sender: TObject;
      AList: TTMSFNCCloudMailChimpSubscriberList);
    procedure UpdateListClick(Sender: TObject);
    procedure TMSFNCCloudMailChimpMarketing1GetCampaigns(Sender: TObject;
      ACampaigns: TTMSFNCCloudMailChimpCampaigns);
    procedure ListBox1Change(Sender: TObject);
    procedure SendCampaignButtonClick(Sender: TObject);
    procedure AddMemberButtonClick(Sender: TObject);
    procedure FirstPageButtonClick(Sender: TObject);
    procedure PreviousPageButtonClick(Sender: TObject);
    procedure NextPageButtonClick(Sender: TObject);
    procedure DeleteMemberButtonClick(Sender: TObject);
    procedure TMSFNCCloudMailChimpMarketing1GetCampaignContent(Sender: TObject;
      ACampaign: TTMSFNCCloudMailChimpCampaign; AHTML, APlainText: string);
    procedure TMSFNCCloudMailChimpMarketing1AddMember(Sender: TObject;
      AMember: TTMSFNCCloudMailChimpListMember);
    procedure DeleteListClick(Sender: TObject);
    procedure AddCampaignClick(Sender: TObject);
    procedure SaveCampaignContentClick(Sender: TObject);
    procedure NewCampaignClick(Sender: TObject);
    procedure TMSFNCCloudMailChimpMarketing1Error(Sender: TObject;
      AErrorMessage: string);
    procedure TMSFNCCloudMailChimpMarketing1AddCampaign(Sender: TObject;
      ACampaign: TTMSFNCCloudMailChimpCampaign);
    procedure TMSFNCCloudMailChimpMarketing1ArchiveMember(Sender: TObject;
      AMember: TTMSFNCCloudMailChimpListMember);
    procedure TMSFNCCloudMailChimpMarketing1DeleteCampaign(Sender: TObject;
      ACampaign: TTMSFNCCloudMailChimpCampaign);
    procedure TMSFNCCloudMailChimpMarketing1DeleteList(Sender: TObject;
      AList: TTMSFNCCloudMailChimpSubscriberList);
    procedure TMSFNCCloudMailChimpMarketing1UpdateList(Sender: TObject;
      AList: TTMSFNCCloudMailChimpSubscriberList);
    procedure TMSFNCCloudMailChimpMarketing1UpdateCampaignSettings(
      Sender: TObject; ACampaign: TTMSFNCCloudMailChimpCampaign);
    procedure TMSFNCCloudMailChimpMarketing1DeleteMember(Sender: TObject;
      AMember: TTMSFNCCloudMailChimpListMember);
    procedure TMSFNCCloudMailChimpMarketing1UpdateMember(Sender: TObject;
      AMember: TTMSFNCCloudMailChimpListMember);
    procedure TMSFNCCloudMailChimpMarketing1SendCampaign(Sender: TObject;
      ACampaign: TTMSFNCCloudMailChimpCampaign);
    procedure TMSFNCCloudMailChimpMarketing1SetCampaignContent(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure CurrentPageButtonClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}



procedure TForm5.AddMemberButtonClick(Sender: TObject);
var
  member: TTMSFNCCloudMailChimpListMember;
begin
  member := TTMSFNCCloudMailChimpListMember.Create;
  member.EmailAddress := Edit1.Text;
  member.EmailType := 'html';
  member.Status := TTMSFNCCloudMailChimpListMemberStatus.msSubscribed;
  TMSFNCCloudMailChimpMarketing1.AddMember(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Id, member);
end;

procedure TForm5.AddNewListClick(Sender: TObject);
var
  L: TTMSFNCCloudMailChimpSubscriberList;
begin
  L := TTMSFNCCloudMailChimpSubscriberList.Create;
  L.Contact.Company := CompanyEdit.Text;
  L.Contact.Address1 := AdressEdit.Text;
  L.Contact.Country := CountryEdit.Text;
  L.Contact.City := CityEdit.Text;
  L.PermissionReminder := PermissionReminderEdit.Text;
  L.CampaignDefaults.Language := LanguageEdit.Text;
  L.CampaignDefaults.FromEmail := FromEmailEdit.Text;
  L.CampaignDefaults.FromName := FromNameEdit.Text;
  L.CampaignDefaults.Subject := SubjectEdit.Text;
  L.ListName := ListNameEdit.Text;
  L.Contact.Zip := ZipEdit.Text;
  TMSFNCCloudMailChimpMarketing1.AddList(L);

end;

procedure TForm5.ConnectButtonClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.APIKey := APIKey.Text;
  TMSFNCCloudMailChimpMarketing1.GetLists(100, false);
end;

procedure TForm5.CurrentPageButtonClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.GetCurrentMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm5.AddCampaignClick(Sender: TObject);
var
  c: TTMSFNCCloudMailChimpCampaign;
begin
  c := TTMSFNCCloudMailChimpCampaign.Create;
  c.CampaignType := ctRegular;
  c.ListID := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Id;
  c.Settings.title := Title.Text;
  c.Settings.SubjectLine := SubjectLine.Text;
  c.Settings.FromName := FromName.Text;
  c.Settings.ReplyTo := ReplyTo.Text;
  c.Settings.Authenticate := true;
  c.Settings.PreviewText := PreviewText.Text;

  TMSFNCCloudMailChimpMarketing1.AddCampaign(c);
end;

procedure TForm5.SaveCampaignContentClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.SetCampaignContent(TTMSFNCCloudMailChimpCampaign(ListBox1.Items.Objects[ListBox1.ItemIndex]), ContentMemo.Text);
end;

procedure TForm5.SendCampaignButtonClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.SendCampaign(TTMSFNCCloudMailChimpCampaign(ListBox1.Items.Objects[ListBox1.ItemIndex]))
end;

procedure TForm5.FirstPageButtonClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.GetFirstMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm5.NewCampaignClick(Sender: TObject);
begin
  AddCampaign.Enabled := true;
  UpdateCampaign.Enabled := False;
  Title.Text := '';
  SubjectLine.Text := '';
  PreviewText.Text := '';
  FromName.Text := '';
  ReplyTo.Text := '';
end;

procedure TForm5.NextPageButtonClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.GetNextMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm5.PreviousPageButtonClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.GetPreviousMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm5.DeleteListClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.DeleteList(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm5.DeleteMemberButtonClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.DeleteMember(TTMSFNCCloudMailChimpListMember(ListBox2.Items.Objects[ListBox2.ItemIndex]));
end;


procedure TForm5.ListBox1Change(Sender: TObject);
begin
  if Listbox1.ItemIndex = -1 then
    exit;

  NewCampaign.Enabled := true;
  AddCampaign.Enabled := false;
  UpdateCampaign.Enabled := true;

  SubjectLine.Text := TTMSFNCCloudMailChimpCampaign(ListBox1.Items.Objects[ListBox1.ItemIndex]).Settings.SubjectLine;
  PreviewText.Text := TTMSFNCCloudMailChimpCampaign(ListBox1.Items.Objects[ListBox1.ItemIndex]).Settings.PreviewText;
  Title.Text := TTMSFNCCloudMailChimpCampaign(ListBox1.Items.Objects[ListBox1.ItemIndex]).Settings.Title;
  FromName.Text := TTMSFNCCloudMailChimpCampaign(ListBox1.Items.Objects[ListBox1.ItemIndex]).Settings.FromName;
  ReplyTo.Text := TTMSFNCCloudMailChimpCampaign(ListBox1.Items.Objects[ListBox1.ItemIndex]).Settings.ReplyTo;
  StatusLabel.Text := 'Status: ' + TTMSFNCCloudMailChimpCampaign(ListBox1.Items.Objects[ListBox1.ItemIndex]).Status;

  TMSFNCCloudMailChimpMarketing1.GetCampaignContent(TTMSFNCCloudMailChimpCampaign(ListBox1.Items.Objects[ListBox1.ItemIndex]))
end;

procedure TForm5.ListsListBoxChange(Sender: TObject);
begin
  if ListsListBox.ItemIndex = -1 then
    exit;

  CompanyEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.Company;
  AdressEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.Address1;
  CountryEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.Country;
  ZipEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.Zip;
  CityEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.City;
  PermissionReminderEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).PermissionReminder;
  LanguageEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).CampaignDefaults.Language;
  FromEmailEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).CampaignDefaults.FromEmail;
  FromNameEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).CampaignDefaults.FromName;
  SubjectEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).CampaignDefaults.Subject;
  ListNameEdit.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).ListName;

  ListBox2.Clear;
  TMSFNCCloudMailChimpMarketing1.GetFirstMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
  TMSFNCCloudMailChimpMarketing1.GetCampaigns(0,TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex])) ;
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1AddCampaign(Sender: TObject;
  ACampaign: TTMSFNCCloudMailChimpCampaign);
begin
  TMSFNCCloudMailChimpMarketing1.GetCampaigns(0,TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex])) ;
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1AddList(Sender: TObject;
  AList: TTMSFNCCloudMailChimpSubscriberList);
  var
  List: TTMSFNCCloudMailChimpSubscriberList;
begin
  ListsListBox.BeginUpdate;
  ListsListBox.Items.Clear;
  for List in TMSFNCCloudMailChimpMarketing1.Lists do
  begin
    ListsListBox.Items.AddObject(List.ListName, List);
  end;
  ListsListBox.EndUpdate;
  ListsListBox.ItemIndex := 0;
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1AddMember(Sender: TObject;
  AMember: TTMSFNCCloudMailChimpListMember);
begin
  TMSFNCCloudMailChimpMarketing1.GetCurrentMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1ArchiveMember(Sender: TObject;
  AMember: TTMSFNCCloudMailChimpListMember);
begin
  TTMSFNCUtils.Message(AMember.EmailAddress + 'has been archived');
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1DeleteCampaign(Sender: TObject;
  ACampaign: TTMSFNCCloudMailChimpCampaign);
begin
  TMSFNCCloudMailChimpMarketing1.GetCampaigns(0,TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex])) ;
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1DeleteList(Sender: TObject;
  AList: TTMSFNCCloudMailChimpSubscriberList);
begin
  TMSFNCCloudMailChimpMarketing1.GetLists(100, false);
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1DeleteMember(Sender: TObject;
  AMember: TTMSFNCCloudMailChimpListMember);
begin
  TMSFNCCloudMailChimpMarketing1.GetFirstMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1Error(Sender: TObject;
  AErrorMessage: string);
begin
  TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1GetCampaignContent(
  Sender: TObject; ACampaign: TTMSFNCCloudMailChimpCampaign; AHTML,
  APlainText: string);
begin
  ContentMemo.Text := AHTML;
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1GetCampaigns(Sender: TObject;
  ACampaigns: TTMSFNCCloudMailChimpCampaigns);
var
  c: TTMSFNCCloudMailChimpCampaign;
  i: Integer;
begin
  UpdateCampaign.Enabled := true;

  ListBox1.BeginUpdate;
  ListBox1.Items.Clear;
  for c in ACampaigns do
  begin
    i := ListBox1.Items.AddObject(c.Settings.Title, c);

  end;
  ListBox1.EndUpdate;

  if ListBox1.Items.Count > 0 then
  begin
    ListBox1.ItemIndex := 0
  end;


end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1GetLists(Sender: TObject;
  ALists: TTMSFNCCloudMailChimpSubscriberLists);
var
  List: TTMSFNCCloudMailChimpSubscriberList;
begin
  ListsListBox.BeginUpdate;
  ListsListBox.Items.Clear;
  for List in ALists do
  begin
    ListsListBox.Items.AddObject(List.ListName, List);
  end;
  ListsListBox.EndUpdate;

  if ListsListBox.Items.Count > 0 then
  begin
    ListsListBox.ItemIndex := 0;
  end;
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1GetMembers(Sender: TObject;
  AMembers: TTMSFNCCloudMailChimpListMembers);
var
  Member: TTMSFNCCloudMailChimpListMember;
begin
  Listbox2.BeginUpdate;
  ListBox2.Clear;
  for Member in AMembers do
  begin
    ListBox2.Items.AddObject(Member.EmailAddress, Member);
  end;

  ListBox2.EndUpdate;
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1SendCampaign(Sender: TObject;
  ACampaign: TTMSFNCCloudMailChimpCampaign);
begin
  TTMSFNCUtils.Message(ACampaign.Settings.Title + 'has been sent');
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1SetCampaignContent(
  Sender: TObject);
begin
  TTMSFNCUtils.Message('content has been saved');
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1UpdateCampaignSettings(
  Sender: TObject; ACampaign: TTMSFNCCloudMailChimpCampaign);
begin
TMSFNCCloudMailChimpMarketing1.GetCampaigns(0,TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex])) ;
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1UpdateList(Sender: TObject;
  AList: TTMSFNCCloudMailChimpSubscriberList);
begin
  TMSFNCCloudMailChimpMarketing1.GetLists(100, false);
end;

procedure TForm5.TMSFNCCloudMailChimpMarketing1UpdateMember(Sender: TObject;
  AMember: TTMSFNCCloudMailChimpListMember);
begin
  TMSFNCCloudMailChimpMarketing1.GetCurrentMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm5.UpdateListClick(Sender: TObject);
begin
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.Company := CompanyEdit.Text;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.Address1 := AdressEdit.Text;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.Country := CountryEdit.Text;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.Zip := ZipEdit.Text;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Contact.City := CityEdit.Text;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).PermissionReminder := PermissionReminderEdit.Text;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).CampaignDefaults.Language := LanguageEdit.Text ;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).CampaignDefaults.FromEmail := FromEmailEdit.Text;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).CampaignDefaults.FromName := FromNameEdit.Text;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).CampaignDefaults.Subject := SubjectEdit.Text;
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).ListName := ListNameEdit.Text;
  TMSFNCCloudMailChimpMarketing1.UpdateList( TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

end.
