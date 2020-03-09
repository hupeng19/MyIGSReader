unit uIGSEntityReadFunc;

interface

uses
  uSection, uIGSEntityile, uIGSEntityReader, Generics.Collections, SysUtils, BaseTypeInf, Windows;

implementation

  {$REGION '一些重复的函数'}
  procedure GetParamValue(ParamValue: TList<string>; ft: TIGSFile; Index: Integer);
  var
    I, J, K: Integer;
  begin
      K := Ft.DirSection.Field[Index].ParamData - 1;
    for I := 0 to ft.DirSection.Field[Index].ParameterLineCount - 1 do
    begin
      for J := 0 to Length(ft.ParamSection.Data[I + K].SplitedStr) - 1 do
        ParamValue.Add(ft.ParamSection.Data[I + K].SplitedStr[J]);
    end;
  end;

  /// <summary>设置来自参数段的信息</summary>
  procedure FillDirData(ft: TIGSFile; Index: Integer; Ent: TBaseEntity);
  begin
    with ft.DirSection.Field[Index] do
    begin
      Ent.Form := FormNumber;
      Ent.TransMatrix := TransformationMatrix;
      Ent.States := StatusNumber;
    end;
  end;
  {$ENDREGION}

  {$REGION '100'}
  function ReadCircularArcEntity(ft: TIGSFile; Index: Integer;
     Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TCircularArcEntity;
    Pot: TPoint2D;
  begin
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    if (ParamValue.Count = 8) and (ParamValue[0] = '100') then
    begin
      E := TCircularArcEntity.Create;
      FillDirData(ft, index, E);

      E.ZT := StrToFloat(ParamValue[1]);
      Pot.X := StrToFloat(ParamValue[2]);
      Pot.Y := StrToFloat(ParamValue[3]);
      E.Center := Pot;

      Pot.X := StrToFloat(ParamValue[4]);
      Pot.Y := StrToFloat(ParamValue[5]);
      E.StartPoint := Pot;

      Pot.X := StrToFloat(ParamValue[6]);
      Pot.Y := StrToFloat(ParamValue[7]);
      E.EndPoint := Pot;

      Result := E;
    end
    else
      Result := nil;
    ParamValue.Free;
  end;
  {$ENDREGION}

  {$REGION '102'}
  function ReadCompositeCurveEntity(ft: TIGSFile; Index: Integer;
     Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TCompositeCurveEntity;
    I, C, CurveCount: Integer;
    ent: TBaseEntity;
  begin
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    if (ParamValue.Count > 3) and (ParamValue[0] = '102') then
    begin
      CurveCount := StrToInt(ParamValue[1]);
      E := TCompositeCurveEntity.Create;
      FillDirData(ft, index, E);

      for I := 0 to CurveCount - 1 do
      begin
        C := (StrToInt(ParamValue[2 + I]) - 1) div 2;
        ent := Reader.GetEntity(C);
        E.Curves.Add(ent);
      end;

      Result := E;
    end
    else
      Result := nil;
    ParamValue.Free;
  end;
  {$ENDREGION}

  {$REGION '110'}
  function ReadLineEntity(ft: TIGSFile; Index: Integer;
     Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TLineEntity;
    Pot: TPoint3D;
  begin
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    if (ParamValue.Count = 7) and (ParamValue[0] = '110') then
    begin
      E := TLineEntity.Create;
      FillDirData(Ft, Index, E);

      Pot.X := StrToFloat(ParamValue[1]);
      Pot.Y := StrToFloat(ParamValue[2]);
      Pot.Z := StrToFloat(ParamValue[3]);
      E.StartPoint := Pot;

      Pot.X := StrToFloat(ParamValue[4]);
      Pot.Y := StrToFloat(ParamValue[5]);
      Pot.Z := StrToFloat(ParamValue[6]);
      E.EndPoint := Pot;

      Result := E;
    end
    else
      Result := nil;
    ParamValue.Free;
  end;
  {$ENDREGION}

  {$REGION '120'}
  function ReadRevolutionSurfaceEntity(ft: TIGSFile; Index: Integer;
    Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TRevolutionSurfaceEntity;
    AxisDE, GeneratrixDE: Integer;
  begin
    Result := nil;
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    if (ParamValue.Count = 5) and (ParamValue[0] = '120') then
    begin
      if Reader <> nil then
      begin
        E := TRevolutionSurfaceEntity.Create;
        FillDirData(ft, index, E);

        AxisDE := (StrToInt(ParamValue[1]) - 1) div 2;
        GeneratrixDE := (StrToInt(ParamValue[2]) -+ 1) div 2;

        E.RevolutionAxis := Reader.GetEntity(AxisDE);
        E.Generatrix := Reader.GetEntity(GeneratrixDE);
        E.StartAngle := StrToFloat(ParamValue[3]);
        E.EndAngle := StrToFloat(ParamValue[4]);

        Result := E;
      end;
    end;
    ParamValue.Free;
  end;
  {$ENDREGION}

  {$REGION '124'}
  function ReadTransformationMatrixEntity(ft: TIGSFile; Index: Integer;
    Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TTransformationMatrixEntity;
    Mat: TMatrix3D;
    I: Integer;
  begin
    Result := nil;
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    if (ParamValue.Count = 13) and (ParamValue[0] = '124') then
    begin
      E := TTransformationMatrixEntity.Create;
      FillDirData(ft, index, E);

      for I := 0 to 11 do
      begin
        Mat.Data[I] := StrToFloat(ParamValue[I + 1]);
      end;
      E.Matrix := Mat;
      FillDirData(ft, Index, E);

      Result := E;
    end;
  end;
  {$ENDREGION}

  {$REGION '126'}
  function ReadRationalBSplineCurveEntity(ft: TIGSFile; Index: Integer;
    Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TRationalBSplineCurveEntity;
    K, Cur: Integer;
    I: Integer;
    Pot: TPoint3D;
  begin
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    Result := nil;
    if (ParamValue.Count > 7) and (ParamValue[0] = '126') then
    begin
      E := TRationalBSplineCurveEntity.Create;
      FillDirData(ft, Index, E);

      K := StrToInt(ParamValue[1]);
      E.Degree := StrToInt(ParamValue[2]);
      E.IsPlane := StrToInt(ParamValue[3]) > 0;
      E.MustClosed := StrToInt(ParamValue[4]) > 0;
      E.IsRational := StrToInt(ParamValue[5]) = 0;
      E.IsPeriodic := StrToInt(ParamValue[6]) > 0;
      Cur := 7;
      {节点数：2 + K + degree}
      for I := 0 to K + E.Degree + 1 do
      begin
        E.Knots.Add(StrToFloat(ParamValue[7 + I]))
      end;
      Cur := Cur + K + E.Degree + 2;;
      {权重：K + 1}
      for I := 0 to K do
      begin
        E.Weights.Add(StrToFloat(ParamValue[Cur + I]));
      end;
      Cur := Cur + K + 1;
      {控制点：K + 1}
      I := 0;
      while I < K + 1 do
      begin
        Pot.X := StrToFloat(ParamValue[Cur]);
        Pot.Y := StrToFloat(ParamValue[Cur + 1]);
        Pot.Z := StrToFloat(ParamValue[Cur + 2]);
        E.ControlPoints.Add(Pot);

        inc(I);
        Cur := Cur + 3;
      end;
      E.StartParam := StrToFloat(ParamValue[Cur]);
      E.EndParam := StrToFloat(ParamValue[Cur + 1]);
      Pot.X := StrToFloat(ParamValue[Cur + 2]);
      Pot.Y := StrToFloat(ParamValue[Cur + 3]);
      Pot.Z := StrToFloat(ParamValue[Cur + 4]);
      E.PlaneNormal := Pot;

      Result := E;
    end;
    ParamValue.Free;
  end;
  {$ENDREGION}

  {$REGION '128'}
  function ReadRationalBSplineSurfaceEntity(ft: TIGSFile; Index: Integer;
    Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TRationalBSplineSurfaceEntity;
    KU, KV, Cur: Integer;
    I: Integer;
    Pot: TPoint3D;
  begin
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    Result := nil;
    if (ParamValue.Count > 10) and (ParamValue[0] = '128') then
    begin
      E := TRationalBSplineSurfaceEntity.Create;
      FillDirData(ft, Index, E);

      KU := StrToInt(ParamValue[1]);
      KV := StrToInt(ParamValue[2]);
      E.DegreeU := StrToInt(ParamValue[3]);
      E.DegreeV := StrToInt(ParamValue[4]);
      E.MustClosedU := StrToInt(ParamValue[5]) > 0;
      E.MustClosedV := StrToInt(ParamValue[6]) > 0;
      E.IsRational := StrToInt(ParamValue[7]) = 0;
      E.IsPeriodicU := StrToInt(ParamValue[8]) > 0;
      E.IsPeriodicV := StrToInt(ParamValue[9]) > 0;
      Cur := 10;
      {节点：1 + Degree + K}
      for I := 0 to 1 + KU + E.DegreeU do
      begin
        E.KnotsU.Add(StrToFloat(ParamValue[I + Cur]));
      end;
      Cur := Cur + 2 + KU + E.DegreeU;
      for I := 0 to 1 + KV + E.DegreeV do
      begin
        E.KnotsV.Add(StrToFloat(ParamValue[I + Cur]));
      end;
      Cur := Cur + 2 + KV + E.DegreeV;
      {权值：1 + K}
      for I := 0 to KU do
      begin
        E.WeightsU.Add(StrToFloat(ParamValue[I + Cur]));
      end;
      Cur := Cur + KU + 1;
      for I := 0 to KV do
      begin
        E.WeightsV.Add(StrToFloat(ParamValue[I + Cur]));
      end;
      Cur := Cur + KV + 1;
      {控制点：1 + K}
      I := 0;
      while I < KU + 1 do
      begin
        Pot.X := StrToFloat(ParamValue[I + Cur]);
        Pot.Y := StrToFloat(ParamValue[I + Cur + 1]);
        Pot.Z := StrToFloat(ParamValue[I + Cur + 2]);
        e.ControlPointsU.Add(Pot);

        inc(I);
        Cur := Cur + 3;
      end;
      I := 0;
      while I < KV + 1 do
      begin
        Pot.X := StrToFloat(ParamValue[I + Cur]);
        Pot.Y := StrToFloat(ParamValue[I + Cur + 1]);
        Pot.Z := StrToFloat(ParamValue[I + Cur + 2]);
        e.ControlPointsV.Add(Pot);

        inc(I);
        Cur := Cur + 3;
      end;
      E.StartParamU := StrToFloat(ParamValue[Cur]);
      E.EndParamU := StrToFloat(ParamValue[Cur + 1]);
      E.StartParamV := StrToFloat(ParamValue[Cur + 2]);
      E.EndParamV := StrToFloat(ParamValue[Cur + 3]);

      Result := E;
    end;
  end;
  {$ENDREGION}

  {$REGION '142'}
  function ReadParametricSurfaceCurveEntity(ft: TIGSFile; Index: Integer;
    Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TParametricSurfaceCurveEntity;
    K: Integer;
  begin
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    Result := nil;
    if (ParamValue.Count > 5) and (ParamValue[0] = '142') then
    begin
      E := TParametricSurfaceCurveEntity.Create;
      FillDirData(ft, index, E);

      E.CurveCreatedWay := StrToInt(ParamValue[1]);
      K := (StrToInt(ParamValue[2]) - 1) div 2;
      E.CurveLiesSurface := Reader.GetEntity(K);
      K := (StrToInt(ParamValue[3]) - 1) div 2;
      E.CurveB := Reader.GetEntity(K);
      K := (StrToInt(ParamValue[4]) - 1) div 2;
      E.CurveC := Reader.GetEntity(K);
      E.PreRepInSendingSys := StrToInt(ParamValue[5]);

      Result := E;
    end;
    ParamValue.Free;
  end;
  {$ENDREGION}

  {$REGION '144'}
  function ReadTrimmedSurfaceEntity(ft: TIGSFile; Index: Integer;
    Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TTrimmedSurfaceEntity;
    K, I, Count: Integer;
    ent: TBaseEntity;
  begin
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    Result := nil;
    if (ParamValue.Count > 4) and (ParamValue[0] = '144') then
    begin
      E := TTrimmedSurfaceEntity.Create;
      FillDirData(ft, Index, E);

      K := (StrToInt(ParamValue[1]) - 1) div 2;
      E.Surface := Reader.GetEntity(K);
      E.ContainsOuter := StrToInt(ParamValue[2]) = 0;
      Count := StrToInt(ParamValue[3]);
      K := (StrToInt(ParamValue[4]) - 1) div 2;
      E.OuterBoundary := Reader.GetEntity(K);
        OutputDebugString(PChar(E.OuterBoundary.ClassName));
      for I := 0 to Count - 1 do
      begin
        K := (StrToInt(ParamValue[5 + I]) - 1) div 2;
        ent := Reader.GetEntity(K);
        E.InnerBoundary.Add(ent);
      end;
      Result := E;
    end;
    ParamValue.Free;
  end;
  {$ENDREGION}

  {$REGION '314'}
  function ReadColorDefEntity(ft: TIGSFile; Index: Integer;
    Reader: TIGSEntityReader): TBaseEntity;
  var
    ParamValue: TList<string>;
    E: TColorDefEntity;
  begin
    ParamValue := TList<string>.Create;
    GetParamValue(ParamValue, ft, Index);
    if (ParamValue.Count > 3) and (ParamValue[0] = '314') then
    begin
      e := TColorDefEntity.Create;
      e.Red := StrToFloat(ParamValue[1]);
      e.Green := StrToFloat(ParamValue[2]);
      e.Blue := StrToFloat(ParamValue[3]);
      if ParamValue.Count = 5 then
        e.ColorName := ParamValue[4];

      Result := E;
    end
    else
      Result := nil;
    ParamValue.Free;
  end;
  {$ENDREGION}

initialization

  RegistEntityReadFun(100, ReadCircularArcEntity);
  RegistEntityReadFun(102, ReadCompositeCurveEntity);
  RegistEntityReadFun(110, ReadLineEntity);
  RegistEntityReadFun(120, ReadRevolutionSurfaceEntity);
  RegistEntityReadFun(124, ReadTransformationMatrixEntity);
  RegistEntityReadFun(126, ReadRationalBSplineCurveEntity);
  RegistEntityReadFun(128, ReadRationalBSplineSurfaceEntity);
  RegistEntityReadFun(142, ReadParametricSurfaceCurveEntity);
  RegistEntityReadFun(144, ReadTrimmedSurfaceEntity);
  RegistEntityReadFun(314, ReadColorDefEntity);
end.
