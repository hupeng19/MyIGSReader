program IGSProj;

uses
  Forms,
  IGS in 'IGS.pas' {Form3},
  BaseTypeInf in 'BaseTypeInf.pas',
  uSection in 'uSection.pas',
  uIGSEntityile in 'uIGSEntityile.pas',
  uIGSEntityReader in 'uIGSEntityReader.pas',
  uIGSEntityReadFunc in 'uIGSEntityReadFunc.pas',
  uPaintWnd in 'uPaintWnd.pas' {ViewFrame: TFrame},
  uIGESFileRender in 'uIGESFileRender.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
