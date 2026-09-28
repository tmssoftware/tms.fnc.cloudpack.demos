program FileConversionDemo;

uses
  Vcl.Forms,
  WEBLib.Forms,
  UFileconversionDemo in 'UFileconversionDemo.pas' {Form1: TWebForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
