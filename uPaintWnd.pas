unit uPaintWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GLCrossPlatform, BaseClasses, GLScene, GLObjects, GLCoordinates,
  GLWin32Viewer, uIGSEntityReader, uIGESFileRender, Menus, GLColor;

type
  TViewFrame = class(TFrame)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    GLSphere1: TGLSphere;
    GLLines1: TGLLines;
    pmGLScene: TPopupMenu;
    nSelect: TMenuItem;
    GLDummyCubeCenter: TGLDummyCube;
    glnsX: TGLLines;
    glnsY: TGLLines;
    glnsZ: TGLLines;
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure nSelectClick(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FReader: TIGSEntityReader;
    FRender: TIGESFileRender;

    FMouseMoveSelect: Boolean;
    FPreSelectObj: TRenderBase;
    FMousePos: TPoint;
  public
    { Public declarations }
    function InitRender: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GLSceneViewer1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ResetView;
  public
    property Reader: TIGSEntityReader read FReader write FReader;
  end;

implementation

{$R *.dfm}

constructor TViewFrame.Create(AOwner: TComponent);
begin
  inherited;

  FRender := TIGESFileRender.Create(nil, nil);

  FMouseMoveSelect := False;
  FPreSelectObj := nil;
end;

destructor TViewFrame.Destroy;
begin
  FRender.Free;

  inherited;
end;

procedure TViewFrame.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Sel: TGLBaseSceneObject;
begin
  Sel := GLSceneViewer1.Buffer.GetPickedObject(X, Y);
  if Sel <> nil then
    OutputDebugString(PChar(Sel.ClassName));
  FMousePos := Point(X, Y);
end;

procedure TViewFrame.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Sel: TGLBaseSceneObject;
  Sels: TGLPickList;
  SelBase: TRenderBase;
begin
  SelBase := nil;
  if [ssLeft] = Shift then
  begin
    GLDummyCubeCenter.RotateAbsolute(x-Fmousepos.X, Y-Fmousepos.Y,0);
  end
  else
  if FMouseMoveSelect then
  begin
    Sels := GLSceneViewer1.Buffer.GetPickedObjects(Rect(X - 2, Y - 2, X + 2, Y + 2));
    if Sels.Count > 1 then
    begin
      Sel := Sels.Hit[0];
      if sel is TRenderBase then
      begin
        SelBase := sel as TRenderBase;
      end
      else
      if Sel.Parent is TRenderBase then
        SelBase := sel.Parent as TRenderBase
      else
        SelBase := nil;
    end;
    if FPreSelectObj <> SelBase then
    begin
      if FPreSelectObj <> nil then
        FPreSelectObj.Selected := False;
      if SelBase <> nil then
        SelBase.Selected := True;
    end;
    GLSceneViewer1.Update;
    FPreSelectObj := SelBase;
    Sels.Free;
  end;
  FMousePos := Point(X, Y);
end;

procedure TViewFrame.GLSceneViewer1MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  if WheelDelta > 0 then
    GLDummyCube1.Scale.Scale(1.1)
  else
    GLDummyCube1.Scale.Scale(0.9);
end;

function TViewFrame.InitRender: boolean;
begin
  GLDummyCube1.DeleteChildren;

  FRender.IGESFile := FReader;
  FRender.OwnerObj := GLDummyCube1;
  ResetView;
  FRender.InitRender;
  Result := True;
end;

procedure TViewFrame.nSelectClick(Sender: TObject);
begin
  FMouseMoveSelect := not FMouseMoveSelect;
end;

procedure TViewFrame.ResetView;
begin
  GLDummyCubeCenter.Direction.SetVector(0, 0, 1);
  GLDummyCubeCenter.Up.SetVector(0, 1, 0);

  GLDummyCube1.Direction.SetVector(0, 0, 1);
  GLDummyCube1.Up.SetVector(0, 1, 0);
end;

end.
