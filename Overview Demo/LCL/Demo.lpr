program Demo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, SelectService, CloudServices, TMSFNCCloudDropBox,
  TMSFNCCloudGoogleFireBase, TMSFNCCloudGoogleGMail, TMSFNCCloudGooglePeople,
  TMSFNCCloudGooglePhotos, TMSFNCCloudGoogleTasks, TMSFNCCloudImgur,
  TMSFNCCloudMicrosoftOneDrive, TMSFNCCloudMicrosoftOutlookCalendar,
  TMSFNCCloudMicrosoftOutlookContacts, TMSFNCCloudMicrosoftOutlookMail, TMSFNCCloudSlack, UDemo;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

