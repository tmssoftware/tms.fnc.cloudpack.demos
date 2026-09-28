program FileConversionDemo;

uses
  Vcl.Forms,
  UFileConversionDemo in 'UFileConversionDemo.pas' {FileConversionDemoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFileConversionDemoForm, FileConversionDemoForm);
  Application.Run;
end.
