program FMXFNCCloudAIDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFNCCloudAIDemo in 'UFNCCloudAIDemo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
