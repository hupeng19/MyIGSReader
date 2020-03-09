unit IGSParser;

interface

uses
  Generics.Collections, SysUtils;

type

  TDirectoryLine = class

  end;
  TBaseEntity = class

  end;

  TBaseEntityLoader = class
    function loadFromEntry(): TBaseEntity;
  end;

  TBaseParser = class

  end;

  TIgsParser = class(TBaseParser)

  end;


  function RegistIgsType(ID: Integer; ClassName: TClass): Boolean;
  function AllIGSType: TDictionary<Integer, TClass>;

implementation

var
  GAllIGSType: TDictionary<Integer, TClass>;

  function AllIGSType: TDictionary<Integer, TClass>;
  begin
    if GAllIGSType = nil then
      GAllIGSType := TDictionary<Integer, TClass>.Create;
    Result := GAllIGSType;
  end;

  function RegistIgsType(ID: Integer; ClassName: TClass): Boolean;
  begin
    if AllIGSType.ContainsKey(ID) then
    begin
      Result := False;
      Assert('存在相同类型');
    end
    else
    begin
      AllIGSType.Add(ID, ClassName);
      Result := True;
    end;
  end;

{ TBaseEntityLoader }

function TBaseEntityLoader.loadFromEntry: TBaseEntity;
begin

end;

initialization
  GAllIGSType := nil;

finalization
  if GAllIGSType <> nil then
    FreeAndNil(GAllIGSType);
end.
