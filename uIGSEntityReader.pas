unit uIGSEntityReader;

interface

uses
  uIGSEntityile, uSection, Generics.Collections;

type

  TIGSEntityReader = class;

  TReaderToolsfunc = function(ft: TIGSFile; Index: Integer; Reader: TIGSEntityReader): TBaseEntity;

  TIGSEntityReader = class
  private
    FReadedEntitiesDic: TDictionary<Integer, TBaseEntity>;
    FIGSFile: TIGSFile;
    FReadFunctionDic: TDictionary<Integer, TReaderToolsfunc>;
  public
    constructor Create;
    destructor Destroy; override;

    function GetEntity(index: Integer): TBaseEntity;
    function LoadFromFile(FileName: string): Boolean;
  public
    property ReadedEntitiesDic: TDictionary<Integer, TBaseEntity> read FReadedEntitiesDic;
    property IGSFile: TIGSFile read FIGSFile;
  end;



  function ReadFunctionDic: TDictionary<Integer, TReaderToolsfunc>;
  function RegistEntityReadFun(TypeID: Integer; Func: TReaderToolsfunc): Boolean;

implementation

var
  GReadFunctionDic: TDictionary<Integer, TReaderToolsfunc> = nil;

  function ReadFunctionDic: TDictionary<Integer, TReaderToolsfunc>;
  begin
    if GReadFunctionDic = nil then
      GReadFunctionDic := TDictionary<Integer, TReaderToolsfunc>.Create;
    Result := GReadFunctionDic;
  end;

  function RegistEntityReadFun(TypeID: Integer; Func: TReaderToolsfunc): Boolean;
  begin
    if ReadFunctionDic.ContainsKey(TypeID) then
    begin
      Result := False;
    end
    else
    begin
      ReadFunctionDic.Add(TypeID, Func);
      Result := True;
    end;
  end;
{ TIGSEntityReader }

constructor TIGSEntityReader.Create;
begin
  FReadedEntitiesDic := TDictionary<Integer, TBaseEntity>.Create;
end;

destructor TIGSEntityReader.Destroy;
var
  Ent: TBaseEntity;
begin
  for Ent in FReadedEntitiesDic.Values do
    Ent.Free;
  FReadedEntitiesDic.Free;

  inherited;
end;

function TIGSEntityReader.GetEntity(index: Integer): TBaseEntity;
var
  Afunc: TReaderToolsfunc;
  I: Integer;
begin
  if FReadedEntitiesDic.TryGetValue(index, Result) then
  begin

  end
  else
  begin
    I := FIGSFile.DirSection.Field[index].EntityType;
    if FReadFunctionDic.TryGetValue(I, Afunc) then
    begin
      Result := Afunc(FIGSFile, index, Self);
      if Result <> nil then
        FReadedEntitiesDic.Add(index, Result)
      else
      begin
        Result := nil;
      end;
    end
    else
    begin
      //Œ¥∂®“Â£¨ÃÓ»Înil
      Result := nil;
      FReadedEntitiesDic.Add(index, nil);
    end;
  end;
end;

function TIGSEntityReader.LoadFromFile(FileName: string): Boolean;
var
  I:Integer;
  Entity: TBaseEntity;
  D: TList<Integer>;
begin
  D := TList<Integer>.Create;

  FIGSFile := TIGSFile.Create;
  FIGSFile.LoadFromFile(FileName);
  FReadFunctionDic := ReadFunctionDic;

  for I := 0 to FIGSFile.DirSection.Field.Count - 1 do
  begin
    Entity := GetEntity(I);
    if Entity = nil then
      if not D.Contains(FIGSFile.DirSection.Field[I].EntityType) then
        D.Add(FIGSFile.DirSection.Field[I].EntityType);
  end;
  if D.Count > 0 then
  begin
    D.Sort;
  end;
  Result := True;
end;

initialization

finalization
  if GReadFunctionDic <> nil then
    GReadFunctionDic.Free;
end.
