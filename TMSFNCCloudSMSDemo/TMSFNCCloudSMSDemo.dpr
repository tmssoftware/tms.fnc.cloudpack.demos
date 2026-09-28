program TMSFNCCloudSMSDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UTMSFNCCloudSMSDemo in 'UTMSFNCCloudSMSDemo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
