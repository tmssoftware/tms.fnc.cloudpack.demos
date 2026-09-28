unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCWebSocketServer, FMX.TMSFNCWhatsAppServer,
  FMX.TMSFNCWebSocketCommon, FMX.Memo.Types, FMX.StdCtrls, FMX.Edit,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    TMSFNCWhatsAppServer1: TTMSFNCWhatsAppServer;
    Panel1: TPanel;
    Log: TMemo;
    CertificateFile: TEdit;
    CertificateKeyFile: TEdit;
    RootCertificateFile: TEdit;
    VerifyToken: TEdit;
    Port: TEdit;
    Path: TEdit;
    Connect: TButton;
    procedure ConnectClick(Sender: TObject);
    procedure TMSFNCWhatsAppServer1Disconnect(Sender: TObject;
      AConnection: TTMSFNCWebSocketConnection);
    procedure TMSFNCWhatsAppServer1Connect(Sender: TObject;
      AConnection: TTMSFNCWebSocketConnection);
    procedure TMSFNCWhatsAppServer1MessageReceived(Sender: TObject;
      AConnection: TTMSFNCWebSocketConnection; const aMessage: string);
    procedure TMSFNCWhatsAppServer1Ping(Sender: TObject;
      AConnection: TTMSFNCWebSocketConnection;
      const aData: TArray<System.Byte>);
    procedure TMSFNCWhatsAppServer1Pong(Sender: TObject;
      AConnection: TTMSFNCWebSocketConnection;
      const aData: TArray<System.Byte>);
    procedure TMSFNCWhatsAppServer1RawMessage(Sender: TObject; AMessage: string;
      var ABroadcast: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.ConnectClick(Sender: TObject);
begin
  if not TMSFNCWhatsAppServer1.Active then
  begin
  TMSFNCWhatsAppServer1.Port := StrToInt(Port.Text);
  TMSFNCWhatsAppServer1.PathName := Path.Text;
  TMSFNCWhatsAppServer1.VerifyToken := VerifyToken.Text;
  TMSFNCWhatsAppServer1.CertificateFile := CertificateFile.Text;
  TMSFNCWhatsAppServer1.CertificateKeyfile := CertificateKeyFile.Text;
  TMSFNCWhatsAppServer1.RootCertificateFile := RootCertificateFile.Text;

  TMSFNCWhatsAppServer1.Active := true;
  Connect.Text := 'Stop Server';
  Log.Lines.Add('Server Started...');
  end
  else
  begin
    TMSFNCWhatsAppServer1.Active := False;
    Connect.Text := 'Start Server';
    Log.Lines.Add('Server Stopped...');
  end;
end;

procedure TForm1.TMSFNCWhatsAppServer1Connect(Sender: TObject;
  AConnection: TTMSFNCWebSocketConnection);
begin
  Log.Lines.Add(AConnection.PeerIP + ' connected...');
end;

procedure TForm1.TMSFNCWhatsAppServer1Disconnect(Sender: TObject;
  AConnection: TTMSFNCWebSocketConnection);
begin
  Log.Lines.Add(AConnection.PeerIP + ' disconnected...');
end;

procedure TForm1.TMSFNCWhatsAppServer1MessageReceived(Sender: TObject;
  AConnection: TTMSFNCWebSocketConnection; const aMessage: string);
begin
  Log.Lines.Add(AConnection.PeerIP + ': ' + AMessage);
end;

procedure TForm1.TMSFNCWhatsAppServer1Ping(Sender: TObject;
  AConnection: TTMSFNCWebSocketConnection; const aData: TArray<System.Byte>);
begin
   Log.Lines.Add(AConnection.PeerIP + ' ping...');
end;

procedure TForm1.TMSFNCWhatsAppServer1Pong(Sender: TObject;
  AConnection: TTMSFNCWebSocketConnection; const aData: TArray<System.Byte>);
begin
   Log.Lines.Add(AConnection.PeerIP + ' pong...');
end;

procedure TForm1.TMSFNCWhatsAppServer1RawMessage(Sender: TObject;
  AMessage: string; var ABroadcast: Boolean);
begin
  Log.Lines.Add(AMessage);
end;

end.
