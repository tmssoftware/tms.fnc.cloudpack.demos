unit Uaimodels;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCCloudBase, VCL.TMSFNCCloudAI, Vcl.Menus, Vcl.Clipbrd;

type
  TForm5 = class(TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Button1: TButton;
    ListBox1: TListBox;
    TMSFNCCloudAI1: TTMSFNCCloudAI;
    PopupMenu1: TPopupMenu;
    Copytoclipboard1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCCloudAI1GetModels(Sender: TObject;
      AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
      AHttpResult: string);
    procedure ComboBox1Change(Sender: TObject);
    procedure Copytoclipboard1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
  TMSFNCCloudAI1.GetModels();
end;

procedure TForm5.ComboBox1Change(Sender: TObject);
var
  i: integer;
begin
  i := integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  TMSFNCCloudAI1.Service := TTMSFNCCloudAIService(i);
end;

procedure TForm5.Copytoclipboard1Click(Sender: TObject);
var
  clip: TClipboard;
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    Clip := TClipboard.Create;
    Clip.AsText := Listbox1.Items[ListBox1.ItemIndex];
    Clip.Free;
  end
  else
    ShowMessage('No model selected');
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  TMSFNCCloudAI1.APIKeys.LoadFromFile('.\..\..\aikeys.cfg','tmssoftware.com');
  TMSFNCCloudAI1.Logging := true;
  TMSFNCCloudAI1.LogFileName := 'e:\tms\temp\models.log';
  ComboBox1.ItemIndex := -1;
  ComboBox1.Items.Assign(TMSFNCCLoudAI1.GetServices);
  ComboBox1.ItemIndex := 0;
  ComboBox1Change(ComboBox1);
end;

procedure TForm5.TMSFNCCloudAI1GetModels(Sender: TObject;
  AResponse: TTMSFNCCloudAIResponse; AHttpStatusCode: Integer;
  AHttpResult: string);
begin
  if AHttpStatusCode = 200 then
  begin
    Listbox1.Items.Assign(TMSFNCCloudAI1.Models);
  end
  else
    ShowMessage('HTTP error ' + AHttpStatusCode.ToString+' : ' + AHttpResult);
end;

end.
