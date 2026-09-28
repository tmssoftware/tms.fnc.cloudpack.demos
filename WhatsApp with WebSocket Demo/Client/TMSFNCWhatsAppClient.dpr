program TMSFNCWhatsAppClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  main in 'main.pas' {Form2},
  WhatsAppWrapper in 'WhatsAppWrapper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
