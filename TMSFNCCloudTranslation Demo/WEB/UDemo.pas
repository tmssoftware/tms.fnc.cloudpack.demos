unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  WebLib.StdCtrls, WebLib.Controls, WebLib.TMSFNCCustomComponent, WebLib.TMSFNCCloudBase,
  WebLib.TMSFNCCloudTranslation, WebLib.ExtCtrls, WebLib.Forms, Vcl.StdCtrls,
  Vcl.Controls, VCL.TMSFNCCustomComponent, VCL.TMSFNCCloudBase,
  VCL.TMSFNCCloudTranslation, Vcl.ExtCtrls;

type
  TForm2 = class(TWebForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    TMSFNCCloudTranslation1: TTMSFNCCloudTranslation;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    ListBox1: TListBox;
    Label5: TLabel;
    Button2: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Button3: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Button4: TButton;
    Edit5: TEdit;
    Label6: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCCloudTranslation1GetSupportedLanguages(Sender: TObject;
      const ALanguages: TStringList;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure Edit1Change(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
  private
    { Private declarations }
    FTranslationLanguage: String;
    procedure DoTranslateMemo(const ARequest: TTMSFNCCloudTranslationRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoTranslateEdit(const ARequest: TTMSFNCCloudTranslationRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoDetectEdit(const ARequest: TTMSFNCCloudTranslationRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  TMSFNCCloudTranslation1.GetSupportedLanguages;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  sl: TStringList;
begin
  Memo2.Lines.Clear;
  sl := TStringList.Create;
  try
    sl.Assign(Memo1.Lines);
    TMSFNCCloudTranslation1.Translate(sl, FTranslationLanguage, @DoTranslateMemo);
  finally
    sl.Free;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  TMSFNCCloudTranslation1.Translate(Edit3.Text, FTranslationLanguage, @DoTranslateEdit);
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  TMSFNCCloudTranslation1.Detect(Edit5.Text, @DoDetectEdit);
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
  FTranslationLanguage := 'en';
  label5.Caption := 'Selected Language:';
  ListBox1.Items.Clear;
  TMSFNCCloudTranslation1.Service := TTMSFNCCloudTranslationService(ComboBox1.ItemIndex);
  Memo2.Lines.Clear;
  Edit4.Text := '';
  Label6.Caption := 'Detected Language:';
  TMSFNCCloudTranslation1.APIKey := Edit1.Text;
end;

procedure TForm2.DoDetectEdit(const ARequest: TTMSFNCCloudTranslationRequest;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if ARequest.Detections.Count > 0 then
    Label6.Caption := 'Detected Language: ' + ARequest.Detections[0].SourceLanguage;
end;

procedure TForm2.DoTranslateEdit(
  const ARequest: TTMSFNCCloudTranslationRequest;
  const ARequestResult: TTMSFNCCloudBaseRequestResult
  );
begin
  if ARequest.Translations.Count > 0 then
    Edit4.Text := ARequest.Translations[0].TranslatedText;
end;

procedure TForm2.DoTranslateMemo(
  const ARequest: TTMSFNCCloudTranslationRequest;
  const ARequestResult: TTMSFNCCloudBaseRequestResult
  );
var
  I: Integer;
begin
  for I := 0 to ARequest.Translations.Count - 1 do
    Memo2.Lines.Add(ARequest.Translations[I].TranslatedText);
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  TMSFNCCloudTranslation1.APIKey := Edit1.Text;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FTranslationLanguage := 'en';
end;

procedure TForm2.ListBox1Click(Sender: TObject);
begin
  if (ListBox1.ItemIndex >= 0) and (ListBox1.ItemIndex <= ListBox1.Items.Count - 1) then
  begin
    Label5.Caption := 'Selected Language: ' + ListBox1.Items.Names[ListBox1.ItemIndex];
    FTranslationLanguage := ListBox1.Items.Values[ListBox1.Items.Names[ListBox1.ItemIndex]];
  end;
end;

procedure TForm2.TMSFNCCloudTranslation1GetSupportedLanguages(Sender: TObject;
  const ALanguages: TStringList;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  ListBox1.Items.Assign(ALanguages);
end;

procedure TForm2.WebFormCreate(Sender: TObject);
var
  lbl: TWebLabel;
begin
  FormContainer := 'appcontent';
  lbl := TWebLabel.Create(Self);
  lbl.ElementID := 'title';
  lbl.Caption := 'TMSFNCCloudTranslation Demo';

  lbl := TWebLabel.Create(Self);
  lbl.ElementID := 'description';
  lbl.Caption := 'Translate & detect language on one or multiple lines of text';

end;

end.
