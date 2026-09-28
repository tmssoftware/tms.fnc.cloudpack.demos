unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCCloudBase, VCL.TMSFNCCloudOAuth,
  VCL.TMSFNCCloudMailChimp.Marketing, VCL.TMSFNCUtils;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    APIKey: TEdit;
    Button1: TButton;
    ListsListBox: TListBox;
    ListName: TEdit;
    FromNameEdit: TEdit;
    FromEmailEdit: TEdit;
    CompanyEdit: TEdit;
    AdressEdit: TEdit;
    CityEdit: TEdit;
    PermissionReminderEdit: TEdit;
    LanguageEdit: TEdit;
    CountryEdit: TEdit;
    ZipEdit: TEdit;
    DeleteList: TButton;
    EditList: TButton;
    AddList: TButton;
    TMSFNCCloudMailChimpMarketing1: TTMSFNCCloudMailChimpMarketing;
    SubjectEdit: TEdit;
    DeleteMember: TButton;
    AddMember: TButton;
    Next: TButton;
    FirstPage: TButton;
    Current: TButton;
    Previous: TButton;
    MembersListBox: TListBox;
    Edit1: TEdit;
    CampaignsListBox: TListBox;
    Send: TButton;
    NewCampaign: TButton;
    AddCampaign: TButton;
    UpdateCampaign: TButton;
    TitleEdit: TEdit;
    SubjectLineEdit: TEdit;
    PreviewTextEdit: TEdit;
    FromEdit: TEdit;
    ReplyToEdit: TEdit;
    StatusLabel: TLabel;
    ContentMemo: TMemo;
    SaveContent: TButton;
    procedure AddMemberClick(Sender: TObject);
    procedure AddListClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AddCampaignClick(Sender: TObject);
    procedure SaveContentClick(Sender: TObject);
    procedure SendClick(Sender: TObject);
    procedure FirstPageClick(Sender: TObject);
    procedure NewCampaignClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure PreviousClick(Sender: TObject);
    procedure DeleteListClick(Sender: TObject);
    procedure DeleteMemberClick(Sender: TObject);
    procedure CampaignsListBoxClick(Sender: TObject);
    procedure ListsListBoxClick(Sender: TObject);
    procedure TMSFNCCloudMailChimpMarketing1AddCampaign(Sender: TObject;
      ACampaign: TTMSFNCCloudMailChimpCampaign);
    procedure TMSFNCCloudMailChimpMarketing1AddList(Sender: TObject;
      AList: TTMSFNCCloudMailChimpSubscriberList);
    procedure TMSFNCCloudMailChimpMarketing1AddMember(Sender: TObject;
      AMember: TTMSFNCCloudMailChimpListMember);
    procedure TMSFNCCloudMailChimpMarketing1ArchiveMember(Sender: TObject;
      AMember: TTMSFNCCloudMailChimpListMember);
    procedure TMSFNCCloudMailChimpMarketing1DeleteCampaign(Sender: TObject;
      ACampaign: TTMSFNCCloudMailChimpCampaign);
    procedure TMSFNCCloudMailChimpMarketing1DeleteList(Sender: TObject;
      AList: TTMSFNCCloudMailChimpSubscriberList);
    procedure TMSFNCCloudMailChimpMarketing1DeleteMember(Sender: TObject;
      AMember: TTMSFNCCloudMailChimpListMember);
    procedure TMSFNCCloudMailChimpMarketing1Error(Sender: TObject;
      AErrorMessage: string);
    procedure TMSFNCCloudMailChimpMarketing1GetCampaignContent(Sender: TObject;
      ACampaign: TTMSFNCCloudMailChimpCampaign; AHTML, APlainText: string);
    procedure TMSFNCCloudMailChimpMarketing1GetCampaigns(Sender: TObject;
      ACampaigns: TTMSFNCCloudMailChimpCampaigns);
    procedure TMSFNCCloudMailChimpMarketing1GetLists(Sender: TObject;
      ALists: TTMSFNCCloudMailChimpSubscriberLists);
    procedure TMSFNCCloudMailChimpMarketing1GetMembers(Sender: TObject;
      AMembers: TTMSFNCCloudMailChimpListMembers);
    procedure TMSFNCCloudMailChimpMarketing1SendCampaign(Sender: TObject;
      ACampaign: TTMSFNCCloudMailChimpCampaign);
    procedure TMSFNCCloudMailChimpMarketing1SetCampaignContent(Sender: TObject);
    procedure TMSFNCCloudMailChimpMarketing1UpdateCampaignSettings(
      Sender: TObject; ACampaign: TTMSFNCCloudMailChimpCampaign);
    procedure TMSFNCCloudMailChimpMarketing1UpdateList(Sender: TObject;
      AList: TTMSFNCCloudMailChimpSubscriberList);
    procedure TMSFNCCloudMailChimpMarketing1UpdateMember(Sender: TObject;
      AMember: TTMSFNCCloudMailChimpListMember);
    procedure EditListClick(Sender: TObject);
    procedure CurrentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.AddCampaignClick(Sender: TObject);
var
  c: TTMSFNCCloudMailChimpCampaign;
begin
  c := TTMSFNCCloudMailChimpCampaign.Create;
  c.CampaignType := ctRegular;
  c.ListID := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Id;
  c.Settings.title := TitleEdit.Text;
  c.Settings.SubjectLine := SubjectLineEdit.Text;
  c.Settings.FromName := FromNameEdit.Text;
  c.Settings.ReplyTo := ReplyToEdit.Text;
  c.Settings.Authenticate := true;
  c.Settings.PreviewText := PreviewTextEdit.Text;

  TMSFNCCloudMailChimpMarketing1.AddCampaign(c);
end;

procedure TForm1.AddListClick(Sender: TObject);
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
  L.ListName := ListName.Text;
  L.Contact.Zip := ZipEdit.Text;
  TMSFNCCloudMailChimpMarketing1.AddList(L);

end;

procedure TForm1.AddMemberClick(Sender: TObject);
var
  member: TTMSFNCCloudMailChimpListMember;
begin
  member := TTMSFNCCloudMailChimpListMember.Create;
  member.EmailAddress := Edit1.Text;
  member.EmailType := 'html';
  member.Status := TTMSFNCCloudMailChimpListMemberStatus.msSubscribed;
  TMSFNCCloudMailChimpMarketing1.AddMember(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).Id, member);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.APIKey := APIKey.Text;
  TMSFNCCloudMailChimpMarketing1.GetLists(100, false);
end;

procedure TForm1.CampaignsListBoxClick(Sender: TObject);
begin
  if CampaignsListBox.ItemIndex = -1 then
    exit;

  NewCampaign.Enabled := true;
  AddCampaign.Enabled := false;
  UpdateCampaign.Enabled := true;

  SubjectLineEdit.Text := TTMSFNCCloudMailChimpCampaign(CampaignsListBox.Items.Objects[CampaignsListBox.ItemIndex]).Settings.SubjectLine;
  PreviewTextEdit.Text := TTMSFNCCloudMailChimpCampaign(CampaignsListBox.Items.Objects[CampaignsListBox.ItemIndex]).Settings.PreviewText;
  TitleEdit.Text := TTMSFNCCloudMailChimpCampaign(CampaignsListBox.Items.Objects[CampaignsListBox.ItemIndex]).Settings.Title;
  FromNameEdit.Text := TTMSFNCCloudMailChimpCampaign(CampaignsListBox.Items.Objects[CampaignsListBox.ItemIndex]).Settings.FromName;
  ReplyToEdit.Text := TTMSFNCCloudMailChimpCampaign(CampaignsListBox.Items.Objects[CampaignsListBox.ItemIndex]).Settings.ReplyTo;
  StatusLabel.Caption := 'Status: ' + TTMSFNCCloudMailChimpCampaign(CampaignsListBox.Items.Objects[CampaignsListBox.ItemIndex]).Status;

  TMSFNCCloudMailChimpMarketing1.GetCampaignContent(TTMSFNCCloudMailChimpCampaign(CampaignsListBox.Items.Objects[CampaignsListBox.ItemIndex]))
end;

procedure TForm1.CurrentClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.GetCurrentMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm1.DeleteListClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.DeleteList(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm1.DeleteMemberClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.DeleteMember(TTMSFNCCloudMailChimpListMember(MembersListBox.Items.Objects[MembersListBox.ItemIndex]));
end;

procedure TForm1.EditListClick(Sender: TObject);
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
  TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).ListName := ListName.Text;

  TMSFNCCloudMailChimpMarketing1.UpdateList( TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm1.FirstPageClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.GetFirstMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm1.ListsListBoxClick(Sender: TObject);
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
  ListName.Text := TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]).ListName;

  MembersListBox.Clear;
  TMSFNCCloudMailChimpMarketing1.GetFirstMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
  TMSFNCCloudMailChimpMarketing1.GetCampaigns(0,TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex])) ;
end;

procedure TForm1.NewCampaignClick(Sender: TObject);
begin
  AddCampaign.Enabled := true;
  UpdateCampaign.Enabled := False;
  TitleEdit.Text := '';
  SubjectLineEdit.Text := '';
  PreviewTextEdit.Text := '';
  FromNameEdit.Text := '';
  ReplyToEdit.Text := '';
end;

procedure TForm1.NextClick(Sender: TObject);
begin
   TMSFNCCloudMailChimpMarketing1.GetNextMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm1.PreviousClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.GetPreviousMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm1.SaveContentClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.SetCampaignContent(TTMSFNCCloudMailChimpCampaign(CampaignsListBox.Items.Objects[CampaignsListBox.ItemIndex]), ContentMemo.Text);
end;

procedure TForm1.SendClick(Sender: TObject);
begin
  TMSFNCCloudMailChimpMarketing1.SendCampaign(TTMSFNCCloudMailChimpCampaign(CampaignsListBox.Items.Objects[CampaignsListBox.ItemIndex]))
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1AddCampaign(Sender: TObject;
  ACampaign: TTMSFNCCloudMailChimpCampaign);
begin
  TMSFNCCloudMailChimpMarketing1.GetCampaigns(0,TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex])) ;
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1AddList(Sender: TObject;
  AList: TTMSFNCCloudMailChimpSubscriberList);
var
  List: TTMSFNCCloudMailChimpSubscriberList;
begin
  ListsListBox.Items.Clear;
  for List in TMSFNCCloudMailChimpMarketing1.Lists do
  begin
    ListsListBox.Items.AddObject(List.ListName, List);
  end;
  ListsListBox.ItemIndex := 0;
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1AddMember(Sender: TObject;
  AMember: TTMSFNCCloudMailChimpListMember);
begin
  TMSFNCCloudMailChimpMarketing1.GetCurrentMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1ArchiveMember(Sender: TObject;
  AMember: TTMSFNCCloudMailChimpListMember);
begin
   TTMSFNCUtils.Message(AMember.EmailAddress + 'has been archived');
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1DeleteCampaign(Sender: TObject;
  ACampaign: TTMSFNCCloudMailChimpCampaign);
begin
  TMSFNCCloudMailChimpMarketing1.GetCampaigns(0,TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex])) ;
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1DeleteList(Sender: TObject;
  AList: TTMSFNCCloudMailChimpSubscriberList);
begin
  TMSFNCCloudMailChimpMarketing1.GetLists(100, false);
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1DeleteMember(Sender: TObject;
  AMember: TTMSFNCCloudMailChimpListMember);
begin
  TMSFNCCloudMailChimpMarketing1.GetFirstMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1Error(Sender: TObject;
  AErrorMessage: string);
begin
  TTMSFNCUtils.Message(AErrorMessage);
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1GetCampaignContent(
  Sender: TObject; ACampaign: TTMSFNCCloudMailChimpCampaign; AHTML,
  APlainText: string);
begin
  ContentMemo.Text := AHTML;
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1GetCampaigns(Sender: TObject;
  ACampaigns: TTMSFNCCloudMailChimpCampaigns);
var
  c: TTMSFNCCloudMailChimpCampaign;
  i: Integer;
begin
  UpdateCampaign.Enabled := true;

  CampaignsListBox.Items.Clear;
  for c in ACampaigns do
  begin
    i := CampaignsListBox.Items.AddObject(c.Settings.Title, c);
  end;

  if CampaignsListBox.Items.Count > 0 then
  begin
    CampaignsListBox.ItemIndex := 0;
    CampaignsListBoxClick(Self);
  end;

end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1GetLists(Sender: TObject;
  ALists: TTMSFNCCloudMailChimpSubscriberLists);
var
  List: TTMSFNCCloudMailChimpSubscriberList;
begin

  ListsListBox.Items.Clear;
  for List in ALists do
  begin
    ListsListBox.Items.AddObject(List.ListName, List);
  end;

  if ListsListBox.Items.Count > 0 then
  begin
    ListsListBox.ItemIndex := 0;
    ListsListBoxClick(Self);
  end;
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1GetMembers(Sender: TObject;
  AMembers: TTMSFNCCloudMailChimpListMembers);
var
  Member: TTMSFNCCloudMailChimpListMember;
begin
  MembersListBox.Clear;
  for Member in AMembers do
  begin
    MembersListBox.Items.AddObject(Member.EmailAddress, Member);
  end;

  if MembersListBox.Items.Count > 0 then
    MembersListBox.ItemIndex := 0;
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1SendCampaign(Sender: TObject;
  ACampaign: TTMSFNCCloudMailChimpCampaign);
begin
  TTMSFNCUtils.Message(ACampaign.Settings.Title + 'has been sent');
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1SetCampaignContent(
  Sender: TObject);
begin
  TTMSFNCUtils.Message('content has been saved');
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1UpdateCampaignSettings(
  Sender: TObject; ACampaign: TTMSFNCCloudMailChimpCampaign);
begin
  TMSFNCCloudMailChimpMarketing1.GetCampaigns(0,TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex])) ;
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1UpdateList(Sender: TObject;
  AList: TTMSFNCCloudMailChimpSubscriberList);
begin
  TMSFNCCloudMailChimpMarketing1.GetLists(100, false);
end;

procedure TForm1.TMSFNCCloudMailChimpMarketing1UpdateMember(Sender: TObject;
  AMember: TTMSFNCCloudMailChimpListMember);
begin
  TMSFNCCloudMailChimpMarketing1.GetCurrentMembers(TTMSFNCCloudMailChimpSubscriberList(ListsListBox.Items.Objects[ListsListBox.ItemIndex]));
end;

end.
