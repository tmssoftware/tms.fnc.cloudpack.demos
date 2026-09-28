unit TMSFNCCloudPayPal;

interface

{$IFDEF LCL}
{$mode objfpc}{$H+}{$modeswitch advancedrecords}
{$ENDIF}

{$IFDEF WEBLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

{$IFDEF LCL}
{$DEFINE LCLWEBLIB}
{$ENDIF}

{$IFDEF FMX}
{$DEFINE VCLFMX}
{$ENDIF}

{$IFDEF VCL}
{$DEFINE VCLFMX}
{$ENDIF}

uses
  {$IFDEF VCL}
  Classes, SysUtils, Generics.Collections, VCL.Forms, VCL.StdCtrls, VCL.ComCtrls, UITypes,VCL.TMSFNCCloudOAuth , VCL.TMSFNCCloudBase,
  CloudServices, VCL.TMSFNCCloudPayPal, VCL.TMSFNCCustomControl;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Forms, FMX.StdCtrls, UITypes,FMX.TMSFNCCloudOAuth , FMX.TMSFNCCloudBase,
  FMX.TMSFNCUtils, CloudServices, FMX.TMSFNCCloudPayPal, FMX.TMSFNCCustomControl, FMX.Edit, FMX.Memo;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, DateUtils, Forms, Dialogs, Controls, StdCtrls,LCLTMSFNCCloudOAuth , LCLTMSFNCCloudBase,
  LCLTMSFNCUtils, ComCtrls, CloudServices, LCLTMSFNCCloudPayPal, LCLTMSFNCCustomControl;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ComCtrls, WEBLib.Controls, WEBLib.Dialogs,
  WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCCloudOAuth, WEBLib.TMSFNCUtils, CloudServices, WEBLib.TMSFNCCloudPayPal, WEBLib.TMSFNCCustomControl;
  {$ENDIF}

type
  TTMSFNCCloudPayPalService = class(TTMSFNCCloudService)
  private
    class var edName: TEdit;
    class var edDescription: TEdit;
    class var edPrice: TEdit;
    class var edQuantity: TEdit;
    class var mePayment: TMemo;
  protected
    class procedure DoPayment(Sender: TObject);
    class procedure DoPaymentAccepted(Sender: TObject);
    class procedure DoPaymentFailed(Sender: TObject);
    class procedure DoPaymentCancelled(Sender: TObject);
  public
    class function GetCloudServiceClass: TTMSFNCCloudOAuthClass; override;
    class function GetTitle: string; override;
    class function GetDescription: string; override;
    class function NeedTokens: Boolean; override;
    class procedure Clear; override;
    class function PayPal: TTMSFNCCloudPayPal;
    class procedure InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl); override;
  end;

implementation

type
  TCustomFormOpen = class(TCustomForm);

{ TTMSFNCCloudPayPalService }

class procedure TTMSFNCCloudPayPalService.Clear;
begin
  SetClientID('');
  SetSecret('');
  SetKey('');
  inherited;
end;

class procedure TTMSFNCCloudPayPalService.DoPayment(Sender: TObject);
var
  pi: TTMSFNCCloudPayPalItem;
  price: Double;
  quantity: Integer;
begin
  StartLoading;
  PayPal.Transaction.Currency := pcEUR;
  PayPal.Transaction.Insurance := 0;
  PayPal.Transaction.Shipping := 5;

  PayPal.Transaction.Items.Clear;
  pi := PayPal.Transaction.Items.Add;
  price := 1;
  TryStrToFloat(edPrice.Text, price);
  pi.Price := price;
  pi.Name := edName.Text;
  pi.Description := edDescription.Text;
  quantity := 1;
  TryStrToInt(edQuantity.Text, quantity);
  pi.Quantity := quantity;

  PayPal.DoPayment;
end;

class procedure TTMSFNCCloudPayPalService.DoPaymentAccepted(Sender: TObject);
begin
  StopLoading;
  mePayment.Text := 'Payment accepted'#13
  + PayPal.Payment.State + #13
  + PayPal.Payment.TransactionID + #13
  + PayPal.Payment.Payer.FirstName + ' ' + PayPal.Payment.Payer.LastName + #13
  + PayPal.Payment.Payer.Street + ', ' + PayPal.Payment.Payer.City + #13
  + PayPal.Payment.Payer.CountryCode + #13
  + PayPal.Payment.Total + ' ' + PayPal.Payment.Currency;
end;

class procedure TTMSFNCCloudPayPalService.DoPaymentCancelled(Sender: TObject);
begin
  StopLoading;
  mePayment.Text := 'Payment cancelled';
end;

class procedure TTMSFNCCloudPayPalService.DoPaymentFailed(Sender: TObject);
begin
  StopLoading;
  mePayment.Text := 'Payment failed'#10#13 + PayPal.PaymentError.ErrorName;
end;

class function TTMSFNCCloudPayPalService.GetCloudServiceClass: TTMSFNCCloudOAuthClass;
begin
  Result := TTMSFNCCloudPayPal;
end;

class function TTMSFNCCloudPayPalService.GetDescription: string;
begin
  Result := 'Discover PayPal, the safer way to pay, receive payments for your goods or services and transfer money to friends and family online.';
end;

class function TTMSFNCCloudPayPalService.GetTitle: string;
begin
  Result := 'PayPal';
end;

class procedure TTMSFNCCloudPayPalService.InitContent(AContent: TTMSFNCCustomControl; ADetailContent: TTMSFNCCustomControl);
var
  l: TLabel;
  b: TButton;
begin
  inherited;

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 10, 10);
  SetLabelText(l, 'Create payment');
  ClearStyledSettings(l);

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 10, 40);
  SetLabelText(l, 'Name:');
  ClearStyledSettings(l);

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 10, 70);
  SetLabelText(l, 'Description:');
  ClearStyledSettings(l);

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 10, 100);
  SetLabelText(l, 'Price:');
  ClearStyledSettings(l);

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 10, 130);
  SetLabelText(l, 'Quantity:');
  ClearStyledSettings(l);

  edName := TEdit.Create(AContent);
  edName.Parent := AContent;
  SetControlPosition(edName, 110, 40);
  edName.Text := 'Name';
  edName.Width := 190;
  ClearStyledSettings(edName);

  edDescription := TEdit.Create(AContent);
  edDescription.Parent := AContent;
  SetControlPosition(edDescription, 110, 70);
  edDescription.Text := 'Description';
  edDescription.Width := 190;
  ClearStyledSettings(edDescription);

  edPrice := TEdit.Create(AContent);
  edPrice.Parent := AContent;
  SetControlPosition(edPrice, 110, 100);
  edPrice.Text := '10';
  edPrice.Width := 190;
  ClearStyledSettings(edPrice);

  edQuantity := TEdit.Create(AContent);
  edQuantity.Parent := AContent;
  SetControlPosition(edQuantity, 110, 130);
  edQuantity.Text := '1';
  edQuantity.Width := 190;
  ClearStyledSettings(edQuantity);

  b := TButton.Create(AContent);
  b.Parent := AContent;
  SetControlPosition(b, 10, 160);
  SetButtonText(b, 'Pay now');
  b.OnClick := {$IFDEF LCLWEBLIB}@{$ENDIF}DoPayment;
  ClearStyledSettings(b);

  l := TLabel.Create(AContent);
  l.Parent := AContent;
  SetControlPosition(l, 10, 200);
  SetLabelText(l, 'Payment result');
  ClearStyledSettings(l);

  mePayment := TMemo.Create(AContent);
  mePayment.Parent := AContent;
  SetControlPosition(mePayment, 10, 230);
  mePayment.Height := 150;
  mePayment.Width := 280;

  PayPal.OnPaymentAccepted := {$IFDEF LCLWEBLIB}@{$ENDIF}DoPaymentAccepted;
  PayPal.OnPaymentFailed := {$IFDEF LCLWEBLIB}@{$ENDIF}DoPaymentFailed;
  PayPal.OnPaymentCancelled := {$IFDEF LCLWEBLIB}@{$ENDIF}DoPaymentCancelled;
end;

class function TTMSFNCCloudPayPalService.NeedTokens: Boolean;
begin
  Result := False;
end;

class function TTMSFNCCloudPayPalService.PayPal: TTMSFNCCloudPayPal;
begin
  Result := Service as TTMSFNCCloudPayPal;
end;

initialization
begin
  TTMSFNCCloudServiceRegistration.RegisterService(TTMSFNCCloudPayPalService);
end;

end.
