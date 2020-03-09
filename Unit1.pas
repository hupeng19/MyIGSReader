unit Unit1;
{
��������Ķ�ȡ
����Ļ���
}
interface

uses
  SysUtils, Generics.Collections, Windows, BaseTypeInf;

type

  TTypeSurface = class
    {���������}
    {
      ����Ҫ�ṩ�Ļ����㷨������
        ����������
        ��ĳ���ͶӰ���
    }
  end;

  TType118 = class{ֱ����ʵ��}
  private
    FCurve1, FCurve2: TGeCurve3D;
    FDirFlag, FDevFlag: Integer;
  public
    function LoadFromEntry(Entry: Integer): TObject;
    function GetCurves(OuterCurves, InnerCurves: TGeCurve3Ds): Boolean;
    function GetProjCurves(OuterCurves, InnerCurves: TGeCurve2Ds): Boolean;
  end;

  TType130 = class{ƫ������ʵ�� offset curve}
  private
    FBaseCurve: TGeCurve3D;
    FFlag: Integer;

  end;

  TType140 = class{ƫ������ʵ�� offset surface}
  private
    FBaseSurface: TTypeSurface;
    NX, NY, NZ: Double;
    D: Double;
  public
    function LoadFromEntry(Entry: Integer): TObject;
    function GetCurves(OuterCurves, InnerCurves: TGeCurve3Ds): Boolean;
    function GetProjCurves(OuterCurves, InnerCurves: TGeCurve2Ds): Boolean;
  end;

  TType141 = class{�߽�ʵ��}
  private
    FType: Integer;
    FPref: Integer;
    FSurface: TTypeSurface; //δ�ü�������
    FBoundaryCount: Integer; //�߽����ߵĸ�����>0��
    FBoundaruCurve: TGeCurve3Ds;
  public
    function LoadFromEntry(Entry: Integer): TObject;
  end;

  TType143 = class(TTypeSurface){�н�����}
  private
    FType: Integer; //�н������ʾ����
    FBaseSurface: TTypeSurface;
    FBounds: TList<TType141>;
  public
    function LoadFromEntry(Entry: Integer): TObject;
    function GetCurves(OuterCurves, InnerCurves: TGeCurve3Ds): Boolean;
    function GetProjCurves(OuterCurves, InnerCurves: TGeCurve2Ds): Boolean;
  end;

  TType190 = class{ƽ�������� Plane Surface}
  {ƽ�����������޽�ģ�������������һ��ʵ�壬����143��141}
  private
    FBasePoint: Tpoint3d;
    FNormal: Tpoint3d;
    FRefEntity: TObject;
    FForm: Integer; //��ʽ�ţ�����������[15]��0���ǲ����棻1��������
  public
    function LoadFromEntry(Entry: Integer): TObject;
  end;

  TType192 = class{��Բ����ʵ�� Right Circular Cylinderical Surface}
  private
    FForm: Integer; //��ʽ��
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

  /// <summary>��������ȡIGSʵ��</summary>
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
  {����}
  FType := StrToInt(Field[1]);
  SurfaceID := StrToInt(Field[2]);
  FBaseSurface := getEntity(SurfaceID) as TTypeSurface;
  N := StrToInt(Field[3]);
  for I := 4 to N + 4 do
  begin
    SurfaceID := StrToInt(Field[N]);
    Bound := getEntity(SurfaceID) as TType141; //�˴����Ը�Ϊ����
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
  Curve: TGeCurve3D; //�ñ߽�ʵ��ĵ�һ��ģ�Ϳռ�����
  Sense: Integer; //Curve�Ƿ�Ӧ�÷���1������Ҫ��PSCPT��CRVPT����һ�¡�2��ģ�Ϳռ�������Ҫ���򣬲�һ��
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
  Ƕ�׽ṹ
  �����Ƿ���
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
    ���ϵ㣺GetPoint(Field[1])
    �᣺getPoint(Field[2])
    �뾶��Field[]3

    if FForm=1
    �ο�����DE field[4]
  }
end;

end.
