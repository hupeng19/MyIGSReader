unit BaseTypeInf;

interface

uses
  Generics.Collections, Math;

type
  TPoint2D = record
    X,Y: Double;
  end;

  TPoint3D = record
    X,Y,Z: Double;
  end;

  TMatrix3D = record
    case Integer of
      0: (R11, R12, R13, T1, R21, R22, R23, T2, R31, R32, R33, T3: Double);
      1: (Data: array[0..11] of Double);
  end;

  TDoubleAry = array of Double;

  TGeCurveBase = class

  public
    procedure Reverse;
  end;

  TGeCurve2D = class(TGeCurveBase)
  private
    FStartPoint, FEndPoint: TPoint2D;
  public
    function Clone: TObject;
    property StartPoint: TPoint2D read FStartPoint;
    property EndPoint: TPoint2D read FEndPoint;
  end;

  TGeCurve3D = class(TGeCurveBase)
  private
    FStartPoint, FEndPoint: TPoint3D;
  public
    function Clone: TObject;
    property StartPoint: TPoint3D read FStartPoint;
    property EndPoint: TPoint3D read FEndPoint;
  end;

  TGeCurve2Ds = TList<TGeCurve2D>;
  TGeCurve3Ds = TList<TGeCurve3D>;

  TGeLine3D = class(TGeCurve3D)
  public
    constructor Create(St, Et: TPoint3D);
  end;

  TGeSurface = class

  end;

  function Point3D(X, Y, Z: double): TPoint3D;
  function Angle(Pot: TPoint3D): Double;
implementation

  function Point3D(X, Y, Z: double): TPoint3D;
  begin
    Result.X := X;
    Result.Y := Y;
    Result.Z := Z;
  end;

  function Angle(Pot: TPoint3D): Double;
  var
    X: Double;
  begin
    X := Sqrt(Pot.X * Pot.X + Pot.Y * Pot.Y);
    Result := 0;
    if X > 0 then
    begin
      if Pot.Y > 0 then
      begin
        Result := ArcCos(Pot.X / X)
      end
      else
      if Pot.Y < 0 then
        Result := ArcCos(Pot.X / X) + Pi
      else
      if X < 0 then
        Result := Pi;
    end;
  end;
{ TGeCurve2D }

function TGeCurve2D.Clone: TObject;
begin
  Result := Self;
end;

{ TGeLine3D }

constructor TGeLine3D.Create(St, Et: TPoint3D);
begin

end;

{ TGeCurve3D }

function TGeCurve3D.Clone: TObject;
begin
  Result := Self;
end;

{ TGeCurveBase }

procedure TGeCurveBase.Reverse;
begin

end;

end.
