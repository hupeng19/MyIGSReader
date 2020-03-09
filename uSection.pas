unit uSection;

{
�����
1. 1���µ�����δ����
}

interface

uses
  SysUtils, Windows, Generics.Collections, Generics.Defaults, uIGSEntityile;

type

  TAnsiCharAry = array of AnsiChar;

  TDirCell = record
    EntityType: Integer;
    ParamData: Integer; //ָ��
    Structure: Integer; //ָ�롢������������ʾָ��
    LineFontPattern: Integer;//ͬ��
    Level: Integer; //ͬ��
    View: Integer; //0��ָ��
    TransformationMatrix: Integer; //0��ָ��
    LabelDisplayAssoc: Integer; //0��ָ��
    StatusNumber: Integer;
    SequenceNumber: Integer;
    LineWeightNumber: Integer;
    ColorNumber: Integer; //������ָ��
    ParameterLineCount: Integer;
    FormNumber: Integer;
    Field16, Field17: string;
    EntityLabel: string;
    EntitySubscriptNumber: Integer;
  end;

  TPrmCell = record
    SplitedStr: array of string;
    DirIndex: Integer;
    LineNum: Integer;
  end;

  TBaseSection = class
  public
    procedure ClearData; virtual;
  end;

  TFlagSection = class(TBaseSection)  //��־��

  end;

  TStartSection = class(TBaseSection)

  end;

  TGlobalSection = class(TBaseSection)
  private
    FData: TAnsiCharAry;
    FParsed: Boolean;
  private
    FParamDelimiter: AnsiChar;                          //1
    FRecordDelimiter: AnsiChar;                         //2
    FSendingSysProdID: string; //project name          //3
    FFileName: string;                                //4
    FNativeSysID: string;                             //5
    FPreprocessorID: string;                          //6
    FIntLength: Integer; //�������ֳ�                 //7
    FSinglePowerBase10: Integer; //��������10Ϊ���ݵĴ�С   //8
    FSingleSignDigits: Integer; //��������Ч����λ��  //9
    FDoublePowerBase10: Integer; //˫������10Ϊ�׵������ //10
    FDoubleSignDigits: Integer; //����ϵͳ��˫��������ֳ�//11
    FRevevieSysProdID: string; //����ϵͳ�Ĳ�ƷID         //12
    FModelSpaceScale: Real; //ģ�Ϳռ����ű���            //13
    FUnitsFlag: Integer; //��λ���                       //14
    FUnitsName: string; //��λ����                         //15
    FMaxLineWeight: Integer; //����߿��𣬲μ�Ŀ¼�β���12 //16
    FMaxLineWeightInUnits: Real; //����λ������߿��μ�dir 12 //17
    FFileGenerationTime: string;//�ļ�����ʱ��                  //18
    FModelMinGranularity: Real; //������14�涨����С�ֱ��ʻ����� //19
    FAprMaxCoordValue: real; //a������14����ĵ�λ���������ֵ   //20
    FAuthorName: string; //������                                //21
    FAuthorOrg: string; //����������֯��                         //22
    FFileVersionFlag: Integer; //�ļ���׼��־ֵ                  //23
    FFileDraftFlag: Integer; //����о����ļ����Ʊ�׼�ı�־ֵ    //24
    FFileModifiedTime: string; //�ļ�����������޸ĵ�ʱ��        //25
    FMore: string; //����о���Ӧ��Э�顢Ӧ���Ӽ������ù淶���û������Э����Ӽ��������� //26
  public
    constructor Create;
    function AddDataSeg(AData: TAnsiCharAry): Boolean;
    function ParseData: Boolean;
    procedure ClearData; override;
  public
    property  ParamDelimiter: AnsiChar read  FParamDelimiter;
    property  RecordDelimiter: AnsiChar read  FRecordDelimiter;
    property  SendingSysProdID: string read  FSendingSysProdID;
    property  FileName: string read  FFileName;
    property  NativeSysID: string read  FNativeSysID;
    property  PreprocessorID: string read  FPreprocessorID;
    property  IntLength: Integer read  FIntLength;
    property  SinglePowerBase10: Integer read  FSinglePowerBase10;
    property  SingleSignDigits: Integer read  FSingleSignDigits;
    property  DoublePowerBase10: Integer read  FDoublePowerBase10;
    property  DoubleSignDigits: Integer read  FDoubleSignDigits;
    property  RevevieSysProdID: string read  FRevevieSysProdID;
    property  ModelSpaceScale: Real read  FModelSpaceScale;
    property  UnitsFlag: Integer read  FUnitsFlag;
    property  UnitsName: string read  FUnitsName;
    property  MaxLineWeight: Integer read  FMaxLineWeight;
    property  MaxLineWeightInUnits: Real read  FMaxLineWeightInUnits;
    property  FileGenerationTime: string read  FFileGenerationTime;
    property  ModelMinGranularity: Real read  FModelMinGranularity;
    property  AprMaxCoordValue: real read  FAprMaxCoordValue;
    property  AuthorName: string read  FAuthorName;
    property  AuthorOrg: string read  FAuthorOrg;
    property  FileVersionFlag: Integer read  FFileVersionFlag;
    property  FileDraftFlag: Integer read  FFileDraftFlag;
    property  FileModifiedTime: string read  FFileModifiedTime;
    property  MoreInf: string read  FMore;
  end;

  TDirectorySection = class(TBaseSection)
  private
    FField: TList<TDirCell>;
  public
    constructor Create;
    destructor Destroy; override;
    function AddData(S: TDirCell): Boolean;
    procedure ClearData; override;
  public
    property Field: TList<TDirCell> read FField;
  end;

  TParamDataSection = class(TBaseSection) //�����λ��ǰ��н�����洢
  private
    FData: TList<TPrmCell>;
  public
    constructor Create;
    destructor Destroy; override;
    function AddData(S: TPrmCell): Boolean;
  public
    property Data: TList<TPrmCell> read Fdata;
  end;

  TTeminateSection = class(TBaseSection)
  private
    FS, FG, FD, FP: Integer;
  public
    function AddData(S: TAnsiCharAry): Boolean;
  public
    property S: Integer read FS;
    property G: Integer read FG;
    property D: Integer read FD;
    property P: Integer read FP;
  end;

  TIGSFileCode = (tFixed, tCompressed);

  TIGSFile = class
  private
    FFileCode: TIGSFileCode;

    FFlagSection: TFlagSection;
    FStartSection: TStartSection;
    FGlobalSection: TGlobalSection;
    FDirSection: TDirectorySection;
    FParamSection: TParamDataSection;
    FTeminateSection: TTeminateSection;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(FileName: string): Boolean;
  public
    property FileCode: TIGSFileCode read FFileCode;
    property FlagSection: TFlagSection read FFlagSection;
    property StartSection: TStartSection read FStartSection;
    property GlobalSection: TGlobalSection read FGlobalSection;
    property DirSection: TDirectorySection read FDirSection;
    property ParamSection: TParamDataSection read FParamSection;
    property TeminateSection: TTeminateSection read FTeminateSection;
  end;

const
  GFlagUnits: array[1..11] of string = ('����', '����', '', 'Ӣ��', 'Ӣ��', '��',
          '����', '�ܶ���0.0254���ף�', '΢��', '����', '΢Ӣ��');
  GVersionFlag: array[1..11] of string = ('IGES 1.0', 'ANSI Y14.26M -1981', 'IGES 2.0', 'IGES 3.0', 'ASME/ANSI Y14.2M -1987',
          'IGES 4.0', 'ASME Y14.26M -1989', 'IGES 5.0', 'IGES 5.1', 'USPRO/IPO100 IGES5.2', 'IGES 5.3');
  GDraftStandardFlag: array[0.. 9] of string = ('�� û�й涨�ı�׼(ȱʡ)', 'ISO ���ʱ�׼����֯', 'AFNOR ������׼��Э��',
          'ANSI �������ұ�׼��ѧ��', 'BSI Ӣ����׼ѧ��', 'CSA ���ô��׼Э��', 'DIN �¹���׼��ѧ��', 'JIS �ձ���׼��ѧ��',
          'SAC ���ұ�׼������ίԱ��', '�� �������ұ�׼');

implementation

{ TIGSFile }
type
  TXX = array[1..82] of AnsiChar;

constructor TIGSFile.Create;
begin
  FFlagSection := TFlagSection.Create;
  FStartSection := TStartSection.Create;
  FGlobalSection := TGlobalSection.Create;
  FDirSection := TDirectorySection.Create;
  FParamSection := TParamDataSection.Create;
  FTeminateSection := TTeminateSection.Create;
end;

destructor TIGSFile.Destroy;
begin
  FFlagSection.Free;
  FStartSection.Free;
  FGlobalSection.Free;
  FDirSection.Free;
  FParamSection.Free;
  FTeminateSection.Free;

  inherited;
end;

function TIGSFile.LoadFromFile(FileName: string): Boolean;
var
  ft: file;
  ansis: AnsiString;
  s: string;
  I: Integer;
  anc, ancD2: TAnsiCharAry;
  numread: Integer;

  function TransAnsiTo10String(S, S2: TAnsiCharAry): TDirCell;
  var
    Asni: AnsiString;
    function GetS(index: Integer; fs: TAnsiCharAry; Count: Integer = 8): string;
    var
      I: Integer;
    begin
      I := 0;
      Asni := '';
      while I < Count do
      begin
        Asni := Asni + fs[I + index];
        inc(I);
      end;
      Result := Unicodestring(Asni);
    end;

    function StrToInt2(Str: string): Integer;
    begin
      if not TryStrToInt(Str, Result) then
        Result := 0;
    end;
  begin
    Result.EntityType := StrToInt(GetS(0, S));
    if Result.EntityType <> StrToInt(GetS(0, S2)) then
      Assert('�����������');
    Result.SequenceNumber := StrToInt(gets(73, S, 7));
    if Result.SequenceNumber + 1 <> StrToInt(gets(73, S2, 7)) then
      Assert('�����������');

    Result.ParamData := StrToInt2(gets(8, S));
    Result.Structure := StrToInt2(gets(16, S));
    Result.LineFontPattern := StrToInt2(gets(24, S));
    Result.Level := StrToInt2(gets(32, S));
    Result.View := StrToInt2(gets(40, S));
    Result.TransformationMatrix := StrToInt2(gets(48, S));
    Result.LabelDisplayAssoc := StrToInt2(gets(56, S));
    Result.StatusNumber := StrToInt2(gets(64, S));

    Result.LineWeightNumber := StrToInt2(gets(8, S2));
    Result.ColorNumber := StrToInt2(gets(16, S2));
    Result.ParameterLineCount := StrToInt2(gets(24, S2));
    Result.FormNumber := StrToInt2(gets(32, S2));
    Result.Field16 := GetS(40, S2);
    Result.Field17 := GetS(48, S2);
    Result.EntityLabel := gets(56, S2);
    Result.EntitySubscriptNumber := StrToInt2(gets(64, S2));
  end;

  function TransANSIStoPrmCell(S: TAnsiCharAry): TPrmCell;
  var
    I, J: Integer;
    curs: AnsiString;
  begin
    if Length(S) <> 82 then
      Assert('��ȡ����');
    curs := '';
    SetLength(Result.SplitedStr, 0);
    for I := 0 to 64 do
    begin
      if S[I] = FGlobalSection.ParamDelimiter then
      begin
        J := Length(Result.SplitedStr);
        SetLength(Result.SplitedStr, J + 1);
        Result.SplitedStr[J] := Unicodestring(curs);
        curs := '';
      end
      else
      if S[I] = FGlobalSection.RecordDelimiter then
      begin
        J := Length(Result.SplitedStr);
        SetLength(Result.SplitedStr, J + 1);
        Result.SplitedStr[J] := Unicodestring(curs);
        Break;
      end
      else
      begin
        if (S[I] = 'D') or (S[I] = 'd') then
          curs := curs + 'E'
        else
          curs := curs + S[I];
      end;
    end;
    curs := '';
    for I := 65 to 71 do
      curs := curs + S[I];
    if TryStrToInt(Unicodestring(curs), J) then
      Result.DirIndex := J;
    curs := '';
    for I := 73 to 79 do
      curs := curs + S[I];
    if TryStrToInt(Unicodestring(curs), J) then
      Result.LineNum := J;
  end;
begin
  AssignFile(ft, FileName);
  Reset(ft, 1);

  SetLength(anc, 82);
  SetLength(ancD2, 82);
  FGlobalSection.ClearData;
  //ֻ��ȡ���β��ҽ����ݷֿ�
  while not Eof(ft) do
  begin
    try
      BlockRead(ft, anc[0], SizeOf(ansichar) * 82, numread);
      case UpCase(anc[72]) of
      'G':
        begin
          FGlobalSection.AddDataSeg(anc);
        end;
      'D':
        begin
          try
            BlockRead(ft, ancD2[0], SizeOf(ansichar) * 82, numread);
            if (numread = 82) and (UpCase(ancD2[72]) = 'D') then
            begin
              FDirSection.AddData(TransAnsiTo10String(anc, ancD2))
            end
            else
            begin
              Assert('�ļ���');
            end;
          except

          end;
        end;
      'P':
        begin
          if not FGlobalSection.FParsed then
            FGlobalSection.ParseData;
          FParamSection.AddData(TransANSIStoPrmCell(anc));
        end;
      'T':
        begin
          FTeminateSection.AddData(anc);
          Break;
        end;
      end;
    finally

    end;
  end;

  ansis := '';
  for I := 0 to Length(FGlobalSection.FData) - 1 do
    ansis := ansis + FGlobalSection.FData[I];
  s := Unicodestring(ansis);

  CloseFile(ft);

  result := True;
end;

{ TGlobalSection }

function TGlobalSection.AddDataSeg(AData: TAnsiCharAry): Boolean;
var
  OldLength, NewLength: Integer;
begin
  OldLength := Length(FData);
  NewLength := 72;
  SetLength(FData, OldLength + NewLength);
  CopyMemory(@(FData[OldLength]), AData, NewLength * SizeOf(AnsiChar));
  Result := True;
end;

procedure TGlobalSection.ClearData;
begin
  SetLength(FData, 0);
  FParsed := False;
end;

constructor TGlobalSection.Create;
begin
  SetLength(FData, 0);
  FParsed := False;

  FParamDelimiter := ',';
  FRecordDelimiter := ';';
  FModelSpaceScale := 1;
  FUnitsFlag := 1;
  FUnitsName := 'Inches';
  FMaxLineWeight := 1;
  FAprMaxCoordValue := 0;
  FAuthorName := '';
  FAuthorOrg := '';
  FFileVersionFlag := 3;
  FFileDraftFlag := 0;
  FFileModifiedTime := '';
  FMore := '';
end;

function TGlobalSection.ParseData: Boolean;
var
  GI: Integer;
  CurAnsiS: AnsiString;
  SLen: Integer;
  SS: TList<AnsiString>;
  Added: Boolean;
  Dv: Double;
  function ParseString(Count: Integer): AnsiString;
  var
    I: Integer;
  begin
    Result := '';
    I := 0;
    while I < Count do
    begin
      Result := Result + FData[GI + I];
      Inc(I);
    end;
    GI := GI + Count - 1;
  end;
begin
  SS := TList<AnsiString>.Create;
  GI := 0;
  Added := False;
  while GI < Length(FData) do
  begin
    if FData[GI] = 'H' then
    begin
      if TryStrToInt(Unicodestring(CurAnsiS), SLen) then
      begin
        Inc(GI);
        SS.Add(ParseString(SLen));
        if (SS.Count = 1) and (Length(SS[0]) > 0) then
          FParamDelimiter := SS[0][1]
        else
        if (SS.Count = 2) and (Length(SS[1]) > 0) then
          FRecordDelimiter := SS[1][1];
      end
      else
        Assert('XX');
      Added := True;
    end
    else
    if FData[GI] = FParamDelimiter then
    begin
      if not Added then
        SS.Add(CurAnsiS);
      CurAnsiS := '';
      Added := False;
    end
    else
    if FData[GI] = FRecordDelimiter then
      Break
    else
    begin
      if (FData[GI] = 'D') or (FData[GI] = 'd') then
        CurAnsiS := CurAnsiS + 'E'      //E��ʾ�����ȣ�D��ʾ˫���ȡ�С���㶼��.��
      else
        CurAnsiS := CurAnsiS + FData[GI];
    end;
    Inc(GI);
  end;

  if SS.Count > 24 then
  begin
    FSendingSysProdID := UnicodeString(SS[2]);
    FFileName := UnicodeString(SS[3]);
    FNativeSysID := UnicodeString(SS[4]);
    FPreprocessorID := UnicodeString(SS[5]);
    if TryStrToInt(Unicodestring(SS[6]), SLen) then
      FIntLength := SLen
    else
      Assert('����');
    if TryStrToInt(Unicodestring(SS[7]), SLen) then
      FSinglePowerBase10 := SLen
    else
      Assert('����');
    if TryStrToInt(Unicodestring(SS[8]), SLen) then
      FSingleSignDigits := SLen
    else
      Assert('����');
    if TryStrToInt(Unicodestring(SS[9]), SLen) then
      FDoublePowerBase10 := SLen
    else
      Assert('����');
    if TryStrToInt(Unicodestring(SS[10]), SLen) then
      FDoubleSignDigits := SLen
    else
      Assert('����');
    FRevevieSysProdID := UnicodeString(SS[11]);
    if TryStrToFloat(Unicodestring(SS[12]), Dv) then
      FModelSpaceScale := Dv
    else
      Assert('����');
    if TryStrToInt(Unicodestring(SS[13]), SLen) then
      FUnitsFlag := SLen
    else
      Assert('����');

    FUnitsName := UnicodeString(SS[14]);
    if TryStrToInt(Unicodestring(SS[15]), SLen) then
      FMaxLineWeight := SLen
    else
      Assert('����');
    if TryStrToFloat(Unicodestring(SS[16]), Dv) then
      FMaxLineWeightInUnits := Dv
    else
      Assert('����');
    FFileGenerationTime := UnicodeString(SS[17]);
    if TryStrToFloat(Unicodestring(SS[18]), Dv) then
      FModelMinGranularity := Dv
    else
      Assert('����');
    if TryStrToFloat(Unicodestring(SS[19]), Dv) then
      FAprMaxCoordValue := Dv
    else
      Assert('����');


    FAuthorName := UnicodeString(SS[20]);
    FAuthorOrg := UnicodeString(SS[21]);
    if TryStrToInt(Unicodestring(SS[22]), SLen) then
      FFileVersionFlag := SLen
    else
      Assert('����');
    if TryStrToInt(Unicodestring(SS[23]), SLen) then
      FFileDraftFlag := SLen
    else
      Assert('����');

    FFileModifiedTime := UnicodeString(SS[24]);
    if SS.Count = 26 then
      FMore := UnicodeString(SS[25]);
    Result := True;
  end
  else
    Result := False;
  SS.Free;
  FParsed := Result;
end;

{ TDirectorySection }

function TDirectorySection.AddData(S: TDirCell): Boolean;
begin
  FField.Add(S);
  Result := True;
end;

procedure TDirectorySection.ClearData;
begin
  FField.Clear;
end;

constructor TDirectorySection.Create;
begin
  FField := TList<TDirCell>.Create;
end;

destructor TDirectorySection.Destroy;
begin
  FField.Free;
  inherited;
end;

{ TBaseSection }

procedure TBaseSection.ClearData;
begin

end;

{ TParamDataSection }

function TParamDataSection.AddData(S: TPrmCell): Boolean;
begin
  if S.LineNum <> FData.Count + 1 then
  begin
    Result := False;
    Assert('���������˳�򲻶�');
  end
  else
  begin
    FData.Add(S);
    Result := True;
  end;
end;

constructor TParamDataSection.Create;
begin
  FData := TList<TPrmCell>.Create;
end;

destructor TParamDataSection.Destroy;
begin
  FData.Free;

  inherited;
end;

{ TTeminateSection }

function TTeminateSection.AddData(S: TAnsiCharAry): Boolean;
  function GetD(Index: Integer): Integer;
  var
    Ans: AnsiString;
    I: Integer;
  begin
    Ans := '';
    for I := Index to Index + 6 do
      Ans := Ans + S[I];
    if not TryStrToInt(UnicodeString(Ans), Result) then
      Result := 0;
  end;
begin
  FS := GetD(1);
  FG := GetD(9);
  FD := GetD(17);
  FP := GetD(25);
  Result := True;
end;

end.
