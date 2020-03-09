unit uIGESFileRender;

{为了渲染IGES对象而生}

interface

uses
  uIGSEntityReader, GLScene, uIGSEntityile, Generics.Collections,GLObjects, GLColor
  ,Math, BaseTypeInf;

type
  TIGESFileRender = class
  private
    FIGESFile: TIGSEntityReader;
    FOwnerObj: TGLBaseSceneObject;
  private

  public
    constructor Create(IGESFile: TIGSEntityReader; AOwnerObj: TGLBaseSceneObject);
    procedure InitRender;
  public
    property IGESFile: TIGSEntityReader read FIGESFile write FIGESFile;
    property OwnerObj: TGLBaseSceneObject read FOwnerObj write FOwnerObj;
  end;

  TRenderBase = class(TGLBaseSceneObject)
  private
    FEntity: TBaseEntity;
    FSelected: Boolean;
  private
    procedure SetSelect(Value: Boolean); virtual;
  public
    procedure InitRender; virtual;
  public
    property Entity: TBaseEntity read FEntity write FEntity;
    property Selected: Boolean Read FSelected write SetSelect;
  end;

  TRenderBaseClass = class of TRenderBase;

  //110
  TGLLineEntity = class(TRenderBase)
  private
    FShowLine: TGLLines;
  private
    procedure SetSelect(Value: Boolean); override;
  public
    procedure InitRender; override;
  end;

  //100
  TGLCircularArcEntity = class(TGLLineEntity)
  private
    FShowLine: TGLLines;
  public
    procedure InitRender; override;
  end;

//  function RenderDic: TDictionary<TClass, TRenderBaseClass>;
  function AddRenderClass(EntiyClass: TClass; RenderClass: TRenderBaseClass): Boolean;
  function GetRenderClass(EntiyClass: TClass): TRenderBaseClass;

implementation

var
  GGRenderDic: TDictionary<TClass, TRenderBaseClass>;

  function GetRenderClass(EntiyClass: TClass): TRenderBaseClass;
  begin
    if GGRenderDic = nil then
      GGRenderDic := TDictionary<TClass, TRenderBaseClass>.Create;
    if GGRenderDic.TryGetValue(EntiyClass, Result) then
    else
      Result := nil;

  end;

  function AddRenderClass(EntiyClass: TClass; RenderClass: TRenderBaseClass): Boolean;
  begin
    if GGRenderDic = nil then
      GGRenderDic := TDictionary<TClass, TRenderBaseClass>.Create;
    GGRenderDic.AddOrSetValue(EntiyClass, RenderClass);
    Result := True;
  end;

{ TIGESFileRender }

constructor TIGESFileRender.Create(IGESFile: TIGSEntityReader;
  AOwnerObj: TGLBaseSceneObject);
begin
  FIGESFile := IGESFile;
  FOwnerObj := AOwnerObj;
end;

procedure TIGESFileRender.InitRender;
var
  R: TRenderBaseClass;
  G: TRenderBase;
begin
  with FIGESFile.ReadedEntitiesDic.GetEnumerator do
  begin
    while MoveNext do
    begin
      R := GetRenderClass(Current.Value.ClassType);
      if R <> nil  then
      begin
        G := R.CreateAsChild(FOwnerObj);
        G.Entity := Current.Value;
        G.InitRender;
      end;
    end;
    Free;
  end;
end;

{ TRenderBase }

procedure TRenderBase.InitRender;
begin

end;

procedure TRenderBase.SetSelect(Value: Boolean);
begin
  FSelected := Value;
end;

{ TGLLineEntity }

procedure TGLLineEntity.InitRender;
begin
  inherited;

  with FEntity as TLineEntity do
  begin
    FShowLine := TGLLines.CreateAsChild(Self);
    FShowLine.Nodes.AddNode(StartPoint.X, StartPoint.Y, StartPoint.Z);
    FShowLine.Nodes.AddNode(EndPoint.X, EndPoint.Y, EndPoint.Z);
  end;
  FShowLine.LineWidth := 3;
  FShowLine.NodesAspect:= lnaInvisible;
end;

procedure TGLLineEntity.SetSelect(Value: Boolean);
begin
  inherited;
  if FShowLine <> nil then
  begin
    if FSelected then
    begin
      FShowLine.LineColor.Color := clrRed
    end
    else
      FShowLine.LineColor.Color := clrWhite;
  end;
end;

{ TGLCircularArcEntity }

procedure TGLCircularArcEntity.InitRender;
var
  I, J: Integer;
  R: Double;
  s, e, K: Double;
begin
  FShowLine := TGLLines.CreateAsChild(Self);
  with FEntity as TCircularArcEntity do
  begin
    R := Power(StartPoint.X - Center.X, 2) + Power(StartPoint.Y - Center.Y, 2);
    R := Sqrt(R);
    S := Angle(Point3D(StartPoint.X - Center.X, StartPoint.Y - Center.Y, 0));
    E := Angle(Point3D(EndPoint.X - Center.X, EndPoint.Y - Center.Y, 0));
    J := 32;
    K := (E - S) / J;
    I := 0;
    while I <= J do
    begin
      FShowLine.AddNode(Center.X + R*cos(S + I * K), Center.Y + R*sin(S + I * K), ZT);
      I := I + 1;
    end;
  end;
  FShowLine.LineWidth := 3;
  FShowLine.NodesAspect:= lnaInvisible;
end;

initialization
  AddRenderClass(TLineEntity, TGLLineEntity);
  AddRenderClass(TCircularArcEntity, TGLCircularArcEntity);

finalization
  if GGRenderDic <> nil then
  begin
    GGRenderDic.Free;
    GGRenderDic := nil;
  end;
end.
