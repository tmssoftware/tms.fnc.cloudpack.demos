program FileConversion;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFileConversion in 'UFileConversion.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
