program NinePatchTest;

uses
  //EMemLeaks,
  Vcl.Forms,
  Form.NinePatchTestMain in 'Form.NinePatchTestMain.pas' {FormNinePatchTestMain},
  NinePatch.Image in '..\src\NinePatch.Image.pas',
  NinePatch.PNGUtil in '..\src\NinePatch.PNGUtil.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'NinePatch Test v1.0';
  Application.CreateForm(TFormNinePatchTestMain, FormNinePatchTestMain);
  Application.Run;
end.
