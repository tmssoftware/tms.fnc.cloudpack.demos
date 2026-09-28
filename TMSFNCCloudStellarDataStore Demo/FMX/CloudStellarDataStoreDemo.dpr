program CloudStellarDataStoreDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UCloudStellarDataStore in 'UCloudStellarDataStore.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
