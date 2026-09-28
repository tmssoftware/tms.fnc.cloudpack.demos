program TMSFNCCloudSendgridDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmSendGrid in 'frmSendGrid.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
