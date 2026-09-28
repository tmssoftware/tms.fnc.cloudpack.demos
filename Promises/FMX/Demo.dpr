program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMain in 'UMain.pas' {Form3},
  UHelper in 'UHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
