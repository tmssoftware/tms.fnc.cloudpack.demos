program CloudStellarDataStoreDataSetDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UCloudStellarDataStoreDataSet in 'UCloudStellarDataStoreDataSet.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
