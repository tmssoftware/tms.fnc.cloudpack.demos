program Demo;

uses
  Vcl.Forms,
  WEBLib.Forms,
  UDemo in 'UDemo.pas' {Form2: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
