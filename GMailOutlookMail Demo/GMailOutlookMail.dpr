program GMailOutlookMail;

uses
  System.StartUpCopy,
  FMX.Forms,
  UGMailOutlookMail in 'UGMailOutlookMail.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
