unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCloudWhatsApp, FMX.TMSFNCCloudBase, FMX.TMSFNCCloudOAuth,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCWebSocketClient,
  FMX.TMSFNCWhatsAppReceiver, FMX.TMSFNCUtils, FMX.TMSFNCWebSocketCommon,
  FMX.Controls.Presentation, FMX.Edit, FMX.TMSFNCTypes, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCListBox, WhatsAppWrapper,
  FMX.Layouts, FMX.ListBox, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.StdCtrls, Generics.Collections;

type
  TChat = class(TPersistent)
  public
    Number: Integer;
    WAMessage: TTMSFNCWhatsAppReceiverMessage;
  end;

  TForm2 = class(TForm)
    TMSFNCWhatsAppReceiver1: TTMSFNCWhatsAppReceiver;
    TMSFNCCloudWhatsApp1: TTMSFNCCloudWhatsApp;
    Conversations: TListBox;
    Messages: TListBox;
    Panel1: TPanel;
    APIKey: TEdit;
    PhoneNumberID: TEdit;
    Host: TEdit;
    Path: TEdit;
    Port: TEdit;
    Connect: TButton;
    DownloadMedia: TButton;
    Reply: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo2: TMemo;
    procedure TMSFNCWhatsAppReceiver1WhatsAppMessageReceived(Sender: TObject;
      AMessage: TTMSFNCWhatsAppReceiverMessage);
    procedure TMSFNCWhatsAppReceiver1Connect(Sender: TObject;
      AConnection: TTMSFNCWebSocketConnection);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCCloudWhatsApp1SendSuccess(Sender: TObject;
      AMessage: TTMSFNCCloudWhatsAppMessage);
    procedure TMSFNCCloudWhatsApp1Error(Sender: TObject; AErrorMessage: string);
    procedure TMSFNCCloudWhatsApp1DownloadFileSuccess(Sender: TObject;
      AStream: TMemoryStream; AFileName, AMimeType: string);
    procedure ConversationsClick(Sender: TObject);
    procedure MessagesClick(Sender: TObject);
    procedure DownloadMediaClick(Sender: TObject);
    procedure ConnectClick(Sender: TObject);
    procedure ReplyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FConversations: TTMSFNCWhatsAppConversations;
    procedure UpdateMessages;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.DownloadMediaClick(Sender: TObject);
var
  msg: TTMSFNCWhatsAppMessage;
begin
  if Messages.ItemIndex = -1 then
    exit;

  msg := Messages.Items.Objects[Messages.ItemIndex] as TTMSFNCWhatsAppMessage;

  case msg.MessageType of
    mtIncoming: TMSFNCCloudWhatsApp1.DownloadFile(msg.Incoming.Media.ID, msg.Incoming.Media.ID);
    mtOutgoing: TMSFNCCloudWhatsApp1.DownloadFile(msg.Outgoing.Media.ID, msg.Outgoing.Media.ID);
  end;

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FConversations := TTMSFNCWhatsAppConversations.Create([DoOwnsValues]);
  Memo1.WordWrap := true;
  Memo2.WordWrap := true;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FConversations.Free;
end;

procedure TForm2.ConnectClick(Sender: TObject);
begin
  TMSFNCWhatsAppReceiver1.HostName := Host.Text;
  TMSFNCWhatsAppReceiver1.PathName := Path.Text;
  TMSFNCWhatsAppReceiver1.Port := StrToInt(Port.Text);

  TMSFNCWhatsAppReceiver1.Connect;
end;

procedure TForm2.ConversationsClick(Sender: TObject);
begin
  UpdateMessages;
end;

procedure TForm2.MessagesClick(Sender: TObject);
var
  msg: TTMSFNCWhatsAppMessage;
begin
  if Messages.ItemIndex = -1 then
    exit;

  msg := TTMSFNCWhatsAppMessage(Messages.Items.Objects[Messages.ItemIndex]);
  Memo1.Lines.Clear;
  case msg.MessageType of
    mtIncoming:
    begin
      Reply.Enabled := true;
      Memo2.Enabled := true;
      case msg.Incoming.MessageType of
        wamtImage,
        wamtDocument,
        wamtAudio,
        wamtVideo,
        wamtSticker:
        begin
          DownloadMedia.Enabled := true;
        end;
        wamtText:
        begin
          DownloadMedia.Enabled := False;
          Memo1.Text := msg.Incoming.Text.Body;
        end;
        wamtLocation:
        begin
          DownloadMedia.Enabled := False;
          Memo1.Text := msg.Incoming.Location.ToJSON;
        end;
        wamtContacts:
        begin
          DownloadMedia.Enabled := False;
          Memo1.Text := msg.Incoming.Contacts.ToJSON;
        end;
      end;
    end;
    mtOutgoing:
    begin
      Reply.Enabled := false;
      Memo2.Enabled := false;
      case msg.Outgoing.MessageType of
        mtImage,
        mtDocument,
        mtAudio,
        mtVideo,
        mtSticker:
        begin
          DownloadMedia.Enabled := true;
        end;
        mtText:
        begin
          DownloadMedia.Enabled := False;
          Memo1.Text := msg.Outgoing.Text.Body;
        end;
        mtLocation:
        begin
          DownloadMedia.Enabled := False;
          Memo1.Text := msg.Outgoing.Location.ToJSON;
        end;
        mtContacts:
        begin
          DownloadMedia.Enabled := False;
          Memo1.Text := msg.Outgoing.Contacts.ToJSON;
        end;
      end;
    end;
  end;
end;

procedure TForm2.ReplyClick(Sender: TObject);
var
  body: string;
  msg: TTMSFNCWhatsAppMessage;
begin
  body := Memo2.Text;
  msg := TTMSFNCWhatsAppMessage(Messages.Items.Objects[Messages.ItemIndex]);
  TMSFNCCloudWhatsApp1.SendTextMessage(msg.Incoming.From.Phone, body, true, msg.Incoming.ID);
end;

procedure TForm2.TMSFNCCloudWhatsApp1DownloadFileSuccess(Sender: TObject;
  AStream: TMemoryStream;AFileName, AMimeType: string);
begin
  AStream.SaveToFile(AFileName + '.' + TTMSFNCUtils.GetFileExtension(AMimeType));
  TTMSFNCUtils.Message(AFileName + ' has been downloaded ');
  TTMSFNCUtils.OpenFile(ExtractFilePath(ParamStr(0)));
end;

procedure TForm2.TMSFNCCloudWhatsApp1Error(Sender: TObject;
  AErrorMessage: string);
begin
  TTMSFNCUtils.Log(AErrorMessage);
end;

procedure TForm2.TMSFNCCloudWhatsApp1SendSuccess(Sender: TObject;
  AMessage: TTMSFNCCloudWhatsAppMessage);
begin
  if FConversations.ContainsKey(AMessage.SendTo) then
    FConversations.Items[AMessage.SendTo].AddOutgoingMessage(AMessage)
  else
   begin
    FConversations.AddNewConversation(AMessage.SendTo).AddOutgoingMessage(AMessage);
    Conversations.Items.Add(AMessage.SendTo);
  end;

  UpdateMessages;
end;

procedure TForm2.TMSFNCWhatsAppReceiver1Connect(Sender: TObject;
  AConnection: TTMSFNCWebSocketConnection);
begin
  TTMSFNCUtils.Message('Connected!' + #13#10 + 'Client will now receive all messages sent to this account.');
  TMSFNCCloudWhatsApp1.Authentication.Key := APIKey.Text;
  TMSFNCCloudWhatsApp1.PhoneNumberID := PhoneNumberID.Text;

  Conversations.Enabled := true;
end;

procedure TForm2.TMSFNCWhatsAppReceiver1WhatsAppMessageReceived(Sender: TObject;
  AMessage: TTMSFNCWhatsAppReceiverMessage);
begin
  if FConversations.ContainsKey(AMessage.From.Phone) then
    FConversations.Items[AMessage.From.Phone].AddIncomingMessage(AMessage)
  else
  begin
    FConversations
        .AddNewConversation(AMessage.From.Phone)
        .AddIncomingMessage(AMessage);

    Conversations.Items.Add(AMessage.From.Phone);
  end;

  if Conversations.ItemIndex = -1 then
    Conversations.ItemIndex := 0;

  UpdateMessages;
end;

procedure TForm2.UpdateMessages;
var
  msg : TTMSFNCWhatsAppMessage;
  i: Integer;
begin
  if Conversations.ItemIndex = -1 then
    exit;

  Messages.Enabled := true;
  Messages.Clear;
  Messages.BeginUpdate;

  for I := 0 to FConversations[COnversations.Items[Conversations.ItemIndex]].Count -1 do
  begin
    msg := FConversations[Conversations.Items[Conversations.ItemIndex]][i];
    if msg.MessageType = mtIncoming then
    begin
      case msg.Incoming.MessageType of
        wamtText: Messages.Items.AddObject(msg.Incoming.From.Name + ': text message', msg);
        wamtImage: Messages.Items.AddObject(msg.Incoming.From.Name + ': image ', msg);
        wamtDocument:Messages.Items.AddObject(msg.Incoming.From.Name + ': document', msg);
        wamtContacts: Messages.Items.AddObject(msg.Incoming.From.Name + ': contact information', msg);
        wamtAudio: Messages.Items.AddObject(msg.Incoming.From.Name + ': audio', msg);
        wamtLocation: Messages.Items.AddObject(msg.Incoming.From.Name + ': location', msg);
        wamtVideo: Messages.Items.AddObject(msg.Incoming.From.Name + ': video ', msg);
        wamtSticker: Messages.Items.AddObject(msg.Incoming.From.Name + ': sticker ', msg);
      end;
    end
    else
    begin
      case msg.Outgoing.MessageType of
        mtText: Messages.Items.AddObject('you: text message', msg);
        mtAudio: Messages.Items.AddObject('you: audio ', msg);
        mtContacts: Messages.Items.AddObject('you: contact', msg);
        mtDocument: Messages.Items.AddObject('you: document ', msg);
        mtVideo: Messages.Items.AddObject('you: video ', msg);
        mtImage: Messages.Items.AddObject('you: image ', msg);
        mtLocation: Messages.Items.AddObject('you: location', msg);
        mtSticker: Messages.Items.AddObject('you: sticker ', msg);
      end;

    end;
  end;

  Messages.EndUpdate;
end;

end.
