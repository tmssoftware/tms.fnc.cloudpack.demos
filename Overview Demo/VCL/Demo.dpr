program Demo;

uses
  Vcl.Forms,
  UDemo in '..\Shared Code\Form Unit\UDemo.pas',
  SelectService in '..\Shared Code\Business Logic\SelectService.pas',
  CloudServices in '..\Shared Code\Business Logic\CloudServices.pas',
  TMSFNCCloudDropBox in '..\Shared Code\Business Logic\Services\TMSFNCCloudDropBox.pas',
  TMSFNCCloudGoogleDrive in '..\Shared Code\Business Logic\Services\TMSFNCCloudGoogleDrive.pas',
  TMSFNCCloudGoogleFireBase in '..\Shared Code\Business Logic\Services\TMSFNCCloudGoogleFireBase.pas',
  TMSFNCCloudGoogleGMail in '..\Shared Code\Business Logic\Services\TMSFNCCloudGoogleGMail.pas',
  TMSFNCCloudGoogleLocationLookup in '..\Shared Code\Business Logic\Services\TMSFNCCloudGoogleLocationLookup.pas',
  TMSFNCCloudGoogleLookup in '..\Shared Code\Business Logic\Services\TMSFNCCloudGoogleLookup.pas',
  TMSFNCCloudGooglePeople in '..\Shared Code\Business Logic\Services\TMSFNCCloudGooglePeople.pas',
  TMSFNCCloudGooglePhotos in '..\Shared Code\Business Logic\Services\TMSFNCCloudGooglePhotos.pas',
  TMSFNCCloudGoogleTasks in '..\Shared Code\Business Logic\Services\TMSFNCCloudGoogleTasks.pas',
  TMSFNCCloudGoogleYouTube in '..\Shared Code\Business Logic\Services\TMSFNCCloudGoogleYouTube.pas',
  TMSFNCCloudHubic in '..\Shared Code\Business Logic\Services\TMSFNCCloudHubic.pas',
  TMSFNCCloudImgur in '..\Shared Code\Business Logic\Services\TMSFNCCloudImgur.pas',
  TMSFNCCloudMicrosoftOneDrive in '..\Shared Code\Business Logic\Services\TMSFNCCloudMicrosoftOneDrive.pas',
  TMSFNCCloudMicrosoftOutlookCalendar in '..\Shared Code\Business Logic\Services\TMSFNCCloudMicrosoftOutlookCalendar.pas',
  TMSFNCCloudMicrosoftOutlookContacts in '..\Shared Code\Business Logic\Services\TMSFNCCloudMicrosoftOutlookContacts.pas',
  TMSFNCCloudMicrosoftOutlookMail in '..\Shared Code\Business Logic\Services\TMSFNCCloudMicrosoftOutlookMail.pas',
  TMSFNCCloudPayPal in '..\Shared Code\Business Logic\Services\TMSFNCCloudPayPal.pas',
  TMSFNCCloudGoogleCalendar in '..\Shared Code\Business Logic\Services\TMSFNCCloudGoogleCalendar.pas',
  TMSFNCCloudCloudKit in '..\Shared Code\Business Logic\Services\TMSFNCCloudCloudKit.pas',
  TMSFNCCloudStorageBase in '..\Shared Code\Business Logic\Services\TMSFNCCloudStorageBase.pas',
  TMSFNCCloudSlack in '..\Shared Code\Business Logic\Services\TMSFNCCloudSlack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
