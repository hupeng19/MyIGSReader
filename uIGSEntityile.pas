unit uIGSEntityile;

interface

uses
  BaseTypeInf, Generics.Collections, Math;

type

  TBaseEntity = class
  public
    Form: Integer;
    TransMatrix: Integer;
    States: Integer;
  private
    function GetStatus(index: Integer): Integer;
  public
    property BlankStatus: Integer index 4 read GetStatus;
    property SubordinateEntitySwitch: Integer index 3 read GetStatus;
    property EntityUseFlag: Integer index 2 read GetStatus;
    property Hierarchy: Integer index 1 read GetStatus;
  end;

  {$REGION '100'}
  TCircularArcEntity = class(TBaseEntity)
  private
    FZT: Double;
    FCenter, FStartPoint, FEndPoint: TPoint2D;
  public
    property ZT: Double read FZT write FZT;
    property Center: TPoint2D read FCenter write FCenter;
    property StartPoint: TPoint2D read FStartPoint write FStartPoint;
    property EndPoint: TPoint2D read FEndPoint write FEndPoint;
  end;
  {$ENDREGION}

  {$REGION '102'}
  TCompositeCurveEntity = class(TBaseEntity)
  private
    FCurves: TList<TBaseEntity>; //不管内部释放
  public
    constructor Create;
    destructor Destroy; override;
  public
    property Curves: TList<TBaseEntity> read FCurves;
  end;
  {$ENDREGION}

  {$REGION '110'}
  TLineEntity = class(TBaseEntity)
  private
    FStartPoint, FEndPoint: TPoint3D;
  public
    property StartPoint: TPoint3D read FStartPoint write FStartPoint;
    property EndPoint: TPoint3D read FEndPoint write FEndPoint;
  end;
  {$ENDREGION}

  {$REGION '120'}
  TRevolutionSurfaceEntity = class(TBaseEntity)
  private
    FRevolutionAxis: TBaseEntity;
    FGeneratrix: TBaseEntity;
    FStartAngle, FEndAngle: Double;
  public
    property RevolutionAxis: TBaseEntity read FRevolutionAxis write FRevolutionAxis;
    property Generatrix: TBaseEntity read FGeneratrix write FGeneratrix;
    property StartAngle: Double read FStartAngle write FStartAngle;
    property EndAngle: Double read FEndAngle write FEndAngle;
  end;
  {$ENDREGION}

  {$REGION '124'}
  TTransformationMatrixEntity = class(TBaseEntity)
  private
    FMatrix: TMatrix3D;   //列矢量
  public
    property Matrix: TMatrix3D read FMatrix write FMatrix;
  end;
  {$ENDREGION}

  {$REGION '126'}
  TRationalBSplineCurveEntity = class(TBaseEntity)
    {Form信息：
    0：
    1：Line
    2：Circular Arc
    3：Elliptical Arc
    4：Parabolic Arc
    5：Hyperbolic Arc}
  private
    FIsPlane: Boolean;
    FPlaneNormal: TPoint3D;
    FMustClosed: Boolean;  //确定重合
    FIsRational: Boolean; //
    FIsPeriodic: Boolean; //周期的
    FDegree: Integer;
    FKnots: TList<Double>;
    FWeights: TList<Double>;
    FControlPoints: TList<TPoint3D>;
    FStartParam, FEndParam: Double;
  public
    constructor Create;
    destructor Destroy; override;
  public
    property IsPlane: Boolean read FIsPlane write FIsPlane;
    property PlaneNormal: TPoint3D read FPlaneNormal write FPlaneNormal;
    property MustClosed: Boolean read FMustClosed write FMustClosed;
    property IsRational: Boolean read FIsRational write FIsRational; //
    property IsPeriodic: Boolean read FIsPeriodic write FIsPeriodic; //周期的
    property Degree: Integer read FDegree write FDegree;
    property Knots: TList<Double> read FKnots;
    property Weights: TList<Double> read FWeights;
    property ControlPoints: TList<TPoint3D> read FControlPoints;
    property StartParam: Double read FStartParam write FStartParam;
    property EndParam: Double read FEndParam write FEndParam;
  end;
  {$ENDREGION}

  {$REGION '128'}
  TRationalBSplineSurfaceEntity = class(TBaseEntity)
  {格式号说明：
  0：
  1：平面/Plane
  2：正圆柱面/Right circular cylinder
  3：圆锥面/Cone
  4：球面/Sphere
  5：圆环面/Torus
  6：回转曲面/Surface of revolution
  7：列表柱面/Tabulated cylinder
  8：直纹面/Ruled surface
  9：一般二次曲面/General quadric surface
  }
  private
    FDegreeU, FDegreeV: Integer;
    FMustClosedU, FMustClosedV: Boolean;
    FIsRational: Boolean;
    FIsPeriodicU, FIsPeriodicV: Boolean;
    FKnotsU, FKnotsV: TList<Double>;
    FWeightsU, FWeightsV: TList<Double>;
    FControlPointsU, FControlPointsV: TList<TPoint3D>;
    FStartParamU, FEndParamU, FStartParamV, FEndParamV: Double;
  public
    constructor Create;
    destructor Destroy; override;
  public
    property DegreeU: Integer read FDegreeU write FDegreeU;
    property DegreeV: Integer read FDegreeV write FDegreeV;
    property MustClosedU: Boolean read FMustClosedU write FMustClosedU;
    property MustClosedV: Boolean read FMustClosedV write FMustClosedV;
    property IsRational: Boolean read FIsRational write FIsRational;
    property IsPeriodicU: Boolean read FIsPeriodicU write FIsPeriodicU;
    property IsPeriodicV: Boolean read FIsPeriodicV write FIsPeriodicV;
    property KnotsU: TList<Double> read FKnotsU;
    property KnotsV: TList<Double> read FKnotsV;
    property WeightsU: TList<Double> read FWeightsU;
    property WeightsV: TList<Double> read FWeightsV;
    property ControlPointsU: TList<TPoint3D> read FControlPointsU;
    property ControlPointsV: TList<TPoint3D> read FControlPointsV;
    property StartParamU: Double read FStartParamU write FStartParamU;
    property EndParamU: Double read FEndParamU write FEndParamU;
    property StartParamV: Double read FStartParamV write FStartParamV;
    property EndParamV: Double read FEndParamV write FEndParamV;
  end;
  {$ENDREGION}

  {$REGION '142'}
  {参数曲面上的曲线相当于将CurveB投影到Surface上，需要曲线位于面的定义域，
  CurveC是投影结果}
  TParametricSurfaceCurveEntity = class(TBaseEntity)
  private
    FCurveCreatedWay: Integer;
    FCurveLiesSurface: TBaseEntity;
    FCurveB: TBaseEntity;
    FCurveC: TBaseEntity;
    FPreRepInSendingSys: Integer;
  public
    property CurveCreatedWay: Integer read FCurveCreatedWay write FCurveCreatedWay;
    property CurveLiesSurface: TBaseEntity read FCurveLiesSurface write FCurveLiesSurface;
    property CurveB: TBaseEntity read FCurveB write FCurveB;
    property CurveC: TBaseEntity read FCurveC write FCurveC;
    property PreRepInSendingSys: Integer read FPreRepInSendingSys write FPreRepInSendingSys;
  end;
  {$ENDREGION}

  {$REGION '144'}
  TTrimmedSurfaceEntity = class(TBaseEntity)
  private
    FSurface: TBaseEntity;
    FContainsOuter: Boolean;
    FOuterBoundary: TBaseEntity;
    FInnerBoundary: TList<TBaseEntity>;
  public
    constructor Create;
    destructor Destroy; override;
  public
    property Surface: TBaseEntity read FSurface write FSurface;
    property ContainsOuter: Boolean read FContainsOuter write FContainsOuter;
    property OuterBoundary: TBaseEntity read FOuterBoundary write FOuterBoundary;
    property InnerBoundary: TList<TBaseEntity> read FInnerBoundary;
  end;
  {$ENDREGION}

  {$REGION '314'}
  TColorDefEntity = class(TBaseEntity)
  private
    FRed, FGreen, FBlue: Double;
    FColorName: string;
  public
    property Red: Double read FRed write FRed;
    property Green: Double read FGreen write FGreen;
    property Blue: Double read FBlue write FBlue;
    property ColorName: string read FColorName write FColorName;
  end;
  {$ENDREGION}

implementation


{ TCompositeCurveEntity }

constructor TCompositeCurveEntity.Create;
begin
  FCurves := TList<TBaseEntity>.Create;
end;

destructor TCompositeCurveEntity.Destroy;
begin
  FCurves.Free;

  inherited;
end;

{ TRationalBSplineCurveEntity }

constructor TRationalBSplineCurveEntity.Create;
begin
  FKnots := TList<Double>.Create;
  FWeights := TList<Double>.Create;
  FControlPoints := TList<TPoint3D>.Create;
end;

destructor TRationalBSplineCurveEntity.Destroy;
begin
  FKnots.Free;
  FWeights.Free;
  FControlPoints.Free;

  inherited;
end;

{ TRationalBSplineSurfaceEntity }

constructor TRationalBSplineSurfaceEntity.Create;
begin
  FKnotsU := TList<Double>.Create;
  FKnotsV := TList<Double>.Create;
  FWeightsU := TList<Double>.Create;
  FWeightsV := TList<Double>.Create;
  FControlPointsU := TList<TPoint3D>.Create;
  FControlPointsV := TList<TPoint3D>.Create;
end;

destructor TRationalBSplineSurfaceEntity.Destroy;
begin
  FKnotsU.Free;
  FKnotsV.Free;
  FWeightsU.Free;
  FWeightsV.Free;
  FControlPointsU.Free;
  FControlPointsV.Free;

  inherited;
end;

{ TTrimmedSurfaceEntity }

constructor TTrimmedSurfaceEntity.Create;
begin
  FSurface := nil;
  FContainsOuter := False;
  FOuterBoundary := nil;
  FInnerBoundary := TList<TBaseEntity>.Create;
end;

destructor TTrimmedSurfaceEntity.Destroy;
begin
  FInnerBoundary.Free;

  inherited;
end;

{ TBaseEntity }

function TBaseEntity.GetStatus(index: Integer): Integer;
var
  I: Integer;
begin
  Result := States;
  for I := 1 to index - 1 do
    Result := Result div 100;
  Result := Result mod 100;
end;

end.
