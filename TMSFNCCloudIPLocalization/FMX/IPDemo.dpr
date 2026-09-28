program IPDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UIPDemoFMX in 'UIPDemoFMX.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
