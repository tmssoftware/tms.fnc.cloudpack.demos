{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright (c) 2022                                      }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The complete source code remains property of the author and may    }
{ not be distributed, published, given or sold in any form as such.  }
{ No parts of the source code can be included in any other component }
{ or application without written authorization of the author.        }
{********************************************************************}

unit WhatsAppWrapper;

{$I FMX.TMSFNCDefines.inc}

{$IFDEF WEBLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}
{$IFDEF LCLLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

interface

uses
Classes, FMX.TMSFNCTypes, SysUtils, FMX.TMSFNCUtils, FMX.TMSFNCCloudWhatsApp, FMX.TMSFNCWhatsAppReceiver
  {$IFDEF WEBLIB}
  ,WEBLib.JSON, JS, Generics.Collections
  {$ENDIF}
  {$IFDEF FMXLIB}
  ,JSON, Generics.Collections
  {$ENDIF}
  {$IFDEF VCLLIB}
  ,JSON, Generics.Collections
  {$ENDIF}
  {$IFDEF LCLLIB}
  ,fpjson, jsonparser, fgl
  {$ENDIF}
  ;

type
  TTMSFNCWhatsAppMessageStatus = (msSent, msDelivered, msRead);
  TTMSFNCWhatsAppMessageType = (mtIncoming, mtOutgoing);

  TTMSFNCWhatsAppMessage= class(TPersistent)
  private
    FMessageStatus: TTMSFNCWhatsAppMessageStatus;
    FOutgoing: TTMSFNCCloudWhatsAppMessage;
    FIncoming: TTMSFNCWhatsAppReceiverMessage;
    FMessageType: TTMSFNCWhatsAppMessageType;
    procedure SetMessageStatus(const Value: TTMSFNCWhatsAppMessageStatus);
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Incoming: TTMSFNCWhatsAppReceiverMessage read FIncoming;
    property Outgoing: TTMSFNCCloudWhatsAppMessage read FOutgoing;
    property MessageType: TTMSFNCWhatsAppMessageType read FMessageType;
    property MessageStatus: TTMSFNCWhatsAppMessageStatus read FMessageStatus write SetMessageStatus;
  end;

  TTMSFNCWhatsAppMessages = class(TObjectList<TTMSFNCWhatsAppMessage>)
  public
    function AddIncomingMessage(AMessage: TTMSFNCWhatsAppReceiverMessage): TTMSFNCWhatsAppMessage;
    function AddOutgoingMessage(AMessage: TTMSFNCCloudWhatsAppMessage): TTMSFNCWhatsAppMessage;
  end;

  TTMSFNCWhatsAppConversations = class(TObjectDictionary<String, TTMSFNCWhatsAppMessages>)
  public
    function AddNewConversation(ANumber: string): TTMSFNCWhatsAppMessages;
  end;

implementation

{ TTMSFNCWhatsAppMessages }

function TTMSFNCWhatsAppMessages.AddIncomingMessage(
  AMessage: TTMSFNCWhatsAppReceiverMessage): TTMSFNCWhatsAppMessage;
begin
  Result := TTMSFNCWhatsAppMessage.Create;
  Result.Incoming.Assign(AMessage);
  Result.FMessageType := mtIncoming;
  Add(Result);
end;

function TTMSFNCWhatsAppMessages.AddOutgoingMessage(
  AMessage: TTMSFNCCloudWhatsAppMessage): TTMSFNCWhatsAppMessage;
begin
  Result := TTMSFNCWhatsAppMessage.Create;
  Result.Outgoing.Assign(AMessage);
  Result.FMessageType := mtOutgoing;
  Add(Result);
end;

{ TTMSFNCWhatsAppConversations }

function TTMSFNCWhatsAppConversations.AddNewConversation(
  ANumber: string): TTMSFNCWhatsAppMessages;
begin
  Result := TTMSFNCWhatsAppMessages.Create;
  Add(ANumber, Result);
end;

{ TTMSFNCWhatsAppMessage }

procedure TTMSFNCWhatsAppMessage.Assign(Source: TPersistent);
begin
  if Source is TTMSFNCWhatsAppMessage then
  begin
    FMessageStatus := (Source as TTMSFNCWhatsAppMessage).MessageStatus;
    FMessageType := (Source as TTMSFNCWhatsAppMessage).MessageType;
    FIncoming := (Source as TTMSFNCWhatsAppMessage).Incoming;
    FOutgoing := (Source as TTMSFNCWhatsAppMessage).Outgoing;
  end
  else
    inherited;
end;

constructor TTMSFNCWhatsAppMessage.Create;
begin
  FOutgoing := TTMSFNCCloudWhatsAppMessage.Create;
  FIncoming := TTMSFNCWhatsAppReceiverMessage.Create;
end;

destructor TTMSFNCWhatsAppMessage.Destroy;
begin
  FOutgoing.Free;
  FIncoming.Free;
  inherited;
end;

procedure TTMSFNCWhatsAppMessage.SetMessageStatus(
  const Value: TTMSFNCWhatsAppMessageStatus);
begin
  FMessageStatus := Value;
end;

end.
