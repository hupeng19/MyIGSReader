unit Unit1;
{
曲线曲面的读取
曲面的绘制
}
interface

uses
  SysUtils, Generics.Collections, Windows, BaseTypeInf;

type

  TTypeSurface = class
    {定义面基类}
    {
      面需要提供的基础算法包括：
        内外轮廓线
        到某面的投影结果
    }
  end;

  TType118 = class{直纹面实体}
  private
    FCurve1, FCurve2: TGeCurve3D;
    FDirFlag, FDevFlag: Integer;
  public
    function LoadFromEntry(Entry: Integer): TObject;
    function GetCurves(OuterCurves, InnerCurves: TGeCurve3Ds): Boolean;
    function GetProjCurves(OuterCurves, InnerCurves: TGeCurve2Ds): Boolean;
  end;

  TType130 = class{偏置曲线实体 offset curve}
  private
    FBaseCurve: TGeCurve3D;
    FFlag: Integer;

  end;

  TType140 = class{偏置曲面实体 offset surface}
  private
    FBaseSurface: TTypeSurface;
    NX, NY, NZ: Double;
    D: Double;
  public
    function LoadFromEntry(Entry: Integer): TObject;
    function GetCurves(OuterCurves, InnerCurves: TGeCurve3Ds): Boolean;
    function GetProjCurves(OuterCurves, InnerCurves: TGeCurve2Ds): Boolean;
  end;

  TType141 = class{边界实体}
  private
    FType: Integer;
    FPref: Integer;
    FSurface: TTypeSurface; //未裁剪的曲面
    FBoundaryCount: Integer; //边界曲线的个数（>0）
    FBoundaruCurve: TGeCurve3Ds;
  public
    function LoadFromEntry(Entry: Integer): TObject;
  end;

  TType143 = class(TTypeSurface){有界曲面}
  private
    FType: Integer; //有界曲面表示类型
    FBaseSurface: TTypeSurface;
    FBounds: TList<TType141>;
  public
    function LoadFromEntry(Entry: Integer): TObject;
    function GetCurves(OuterCurves, InnerCurves: TGeCurve3Ds): Boolean;
    function GetProjCurves(OuterCurves, InnerCurves: TGeCurve2Ds): Boolean;
  end;

  TType190 = class{平面内曲面 Plane Surface}
  {平面内曲面是无界的，除非它属于另一个实体，例如143、141}
  private
    FBasePoint: Tpoint3d;
    FNormal: Tpoint3d;
    FRefEntity: TObject;
    FForm: Integer; //格式号，来自索引段[15]，0：非参数面；1：参数面
  public
    function LoadFromEntry(Entry: Integer): TObject;
  end;

  TType192 = class{正圆柱面实体 Right Circular Cylinderical Surface}
  private
    FForm: Integer; //格式号
    FBasePoint: TPoint3D;
    FAixs: TPoint3D;
    FRadius: Double;
  public
    function LoadFromEntry(Entry: Integer): TObject;
  end;

  TType194 = class

  end;

  TType196 = class

  end;

  TType198 = class

  end;


implementation

  /// <summary>从索引获取IGS实体</summary>
  function GetEntity(DireId: Integer): TObject;
  begin
    Result := nil;
  end;

{ TType118 }

function TType118.GetCurves(OuterCurves, InnerCurves: TGeCurve3Ds): Boolean;
var
  Curve1, Curve2, Curve3, Curve4: TGeCurve3D;
begin
  OuterCurves.Clear;

  if FDirFlag = 0 then
  begin
    Curve1 := FCurve1.Clone as TGeCurve3D;
    Curve2 := TGeLine3D.Create(FCurve1.EndPoint, FCurve2.EndPoint);
    Curve3 := (FCurve2.CLone as TGeCurve3D);
    Curve3.Reverse;
    Curve4 := TGeLine3D.Create(FCurve2.StartPoint, FCurve1.StartPoint);
  end
  else
  if FDirFlag = 1 then
  begin
    Curve1 := FCurve1.Clone as TGeCurve3D;
    Curve2 := TGeLine3D.Create(FCurve1.EndPoint, FCurve2.StartPoint);
    Curve3 := FCurve2.CLone as TGeCurve3D;
    Curve4 := TGeLine3D.Create(FCurve2.EndPoint, FCurve1.StartPoint);
  end;

  OuterCurves.Add(Curve1);
  OuterCurves.Add(Curve2);
  OuterCurves.Add(Curve3);
  OuterCurves.Add(Curve4);

end;

function TType118.GetProjCurves(OuterCurves, InnerCurves: TGeCurve2Ds): Boolean;
begin

end;

function TType118.LoadFromEntry(Entry: Integer): TObject;
begin
{
  FCurve1 := Param[1];
  FCurve1 := Param[2];
  FDirFlag := Param[3];
  FDevFlag := Param[4];
}
end;

{ TType143 }

function TType143.GetCurves(OuterCurves, InnerCurves: TGeCurve3Ds): Boolean;
begin

end;

function TType143.GetProjCurves(OuterCurves, InnerCurves: TGeCurve2Ds): Boolean;
begin

end;

function TType143.LoadFromEntry(Entry: Integer): TObject;
var
  Field: array of string; //1..N
  SurfaceID: Integer;
  N: Integer;
  I: Integer;
  Bound: TType141;
begin
  {载入}
  FType := StrToInt(Field[1]);
  SurfaceID := StrToInt(Field[2]);
  FBaseSurface := getEntity(SurfaceID) as TTypeSurface;
  N := StrToInt(Field[3]);
  for I := 4 to N + 4 do
  begin
    SurfaceID := StrToInt(Field[N]);
    Bound := getEntity(SurfaceID) as TType141; //此处可以改为基类
    FBounds.Add(Bound);
  end;
end;

{ TType141 }

function TType141.LoadFromEntry(Entry: Integer): TObject;
var
  Field: array of string; //1..N
  bType: Integer;
  pref: Integer;
  N: Integer;  //
  SurfaceID: Integer;
  CurveID: Integer;
  Curve: TGeCurve3D; //该边界实体的第一个模型空间曲线
  Sense: Integer; //Curve是否应该反向。1：不需要，PSCPT和CRVPT方向一致。2：模型空间曲线需要反向，不一致
  K: Integer;
  I, J: Integer;
  IDBase: Integer;
  PSCPT: TGeCurve3D;
begin
  bType := StrToInt(Field[1]);
  pref := StrToInt(Field[2]);
  SurfaceID := StrToInt(Field[3]);
  N := StrToInt(Field[4]);
  FSurface := getEntity(SurfaceID) as TTypeSurface;
  {
  嵌套结构
  曲线是否反向
  }
  IDBase := 5;
  for I := 0 to N - 1 do
  begin
    CurveID := StrToInt(Field[IDBase]);
    Sense := StrToInt(Field[IDBase + 1]);
    K := StrToInt(Field[IDBase + 2]);
    Curve := getEntity(CurveID) as TGeCurve3D;
    if Sense = 2 then
      Curve.Reverse;
    FBoundaruCurve.Add(Curve);
    for J := 0 to K - 1 do
    begin
      CurveID := StrToInt(Field[IDBase + 3 + J]);
      PSCPT := getEntity(CurveID) as TGeCurve3D;
    end;
    IDBase := IDBase + 3 + K;
  end;
end;

{ TType140 }

function TType140.GetCurves(OuterCurves, InnerCurves: TGeCurve3Ds): Boolean;
begin

end;

function TType140.GetProjCurves(OuterCurves, InnerCurves: TGeCurve2Ds): Boolean;
begin

end;

function TType140.LoadFromEntry(Entry: Integer): TObject;
var
  Field: array of string; //1..N
  SurfaceID: Integer;
begin
  NX := StrToFloat(Field[1]);
  NY := StrToFloat(Field[2]);
  NZ := StrToFloat(Field[3]);
  D := StrToFloat(Field[4]);
  SurfaceID := StrToInt(Field[5]);
  FBaseSurface := getEntity(SurfaceID) as TTypeSurface;
end;

{ TType190 }

function TType190.LoadFromEntry(Entry: Integer): TObject;
var
  Field: array of string; //1..N
  Index: Integer;
  function GetPoint(ID: Integer): TPoint3D;
  begin

  end;
begin
  FBasePoint := GetPoint(StrToInt(Field[1]));
  FNormal := GetPoint(StrToInt(Field[2]));
  case FForm of
    0:
    begin
    end;
    1:
    begin
      FRefEntity := GetEntity(StrToInt(Field[3]));
    end;
  end;
end;

{ TType192 }

function TType192.LoadFromEntry(Entry: Integer): TObject;
var
  Field: array of string; //1..N
begin
  {
    轴上点：GetPoint(Field[1])
    轴：getPoint(Field[2])
    半径：Field[]3

    if FForm=1
    参考方向DE field[4]
  }
end;

end.
