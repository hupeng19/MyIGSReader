unit IGS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, Grids, uSection, uIGSEntityReader,
  uIGSEntityile, ExtCtrls, uPaintWnd;

type
  TForm3 = class(TForm)
    dlgOpenFile: TOpenDialog;
    mmMain: TMainMenu;
    open1: TMenuItem;
    sddf1: TMenuItem;
    pgc1: TPageControl;
    tv1: TTreeView;
    tsEdit: TTabSheet;
    tsShow: TTabSheet;
    redt1: TRichEdit;
    tsFileInf: TTabSheet;
    StringGrid1: TStringGrid;
    splTreeAndPage: TSplitter;
    tsEntityInf: TTabSheet;
    procedure open1Click(Sender: TObject);
    procedure sddf1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    FViewFrame: TViewFrame;
  public
    { Public declarations }
    procedure PrintFileInf(Ft: TIGSFile);
    procedure PrintInTree(Reader: TIGSEntityReader);
    procedure UpDateView(Reader: TIGSEntityReader);
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
  redt1.SelLength := 0;

  FViewFrame := TVIewframe.Create(tsShow);
  FViewframe.Parent := tsShow;
  FViewframe.Align := alClient;
end;

procedure TForm3.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  Pot:TPoint;
begin
  Pot := ScreenToClient(MousePos);
  if (Pot.X > pgc1.Left) and (Pot.Y < pgc1.Left + pgc1.Width) then
//  if (PtInRect(pgc1.ClientRect, MousePos)) and (pgc1.ActivePage = tsShow) then
  begin
    FViewFrame.GLSceneViewer1MouseWheel(Sender, Shift, WheelDelta, MousePos, Handled);
  end;
end;

procedure TForm3.open1Click(Sender: TObject);
{var
  IGSFile: TIGSFile;
begin
  if dlgOpenFile.Execute then
  begin
    IGSFile :=  TIGSFile.Create;
    with IGSFile do
    begin
      LoadFromFile(dlgOpenFile.FileName);
      redt1.Lines.LoadFromFile(dlgOpenFile.FileName);
      PrintFileInf(IGSFile);
      Free;
    end;
  end;
end;  }
var
  IGSreader: TIGSEntityReader;
begin
  if dlgOpenFile.Execute then
  begin
    IGSreader := TIGSEntityReader.Create;
    with IGSreader do
    begin
      LoadFromFile(dlgOpenFile.FileName);
      redt1.Lines.LoadFromFile(dlgOpenFile.FileName);
      PrintFileInf(IGSFile);
      PrintInTree(IGSreader);
      FViewFrame.Reader := IGSreader;
      FViewFrame.InitRender;
      Free;
    end;
  end;
end;

procedure TForm3.PrintFileInf(Ft: TIGSFile);
  function TransDateTime(OriS: string): string;
  begin
    Result := '';
    case Length(OriS) of
    15: Result := OriS[1] + OriS[2] + OriS[3] + OriS[4] + '-'+
                        OriS[5] + OriS[6] + '-' +
                        OriS[7] + OriS[8] + ' ' +
                        OriS[10] + OriS[11] + ':' +
                        OriS[12] + OriS[13] + ':' +
                        OriS[14] + OriS[15];
    13: Result :=  OriS[1] + OriS[2] + '-' +
                        OriS[3] + OriS[4] + '-' +
                        OriS[5] + OriS[6] + ' ' +
                        OriS[8] + OriS[9] + ':' +
                        OriS[10] + OriS[11] + ':' +
                        OriS[12] + OriS[13];
    end;
  end;
begin
  StringGrid1.DefaultColWidth := StringGrid1.Width div 2 - 10;
  with StringGrid1 do
  begin
    StringGrid1.Cells[0, 0] := '����';
    StringGrid1.Cells[1, 0] := 'ֵ';

    Cells[0, 1] := '�����ֽ��';
    Cells[1, 1] := UnicodeString(Ft.GlobalSection.ParamDelimiter);

    Cells[0, 2] := '��¼�ֽ��';
    cells[1, 2] := UnicodeString(Ft.GlobalSection.RecordDelimiter);

    Cells[0, 3] := '�����ߵĲ�Ʒ��ʶ';
    cells[1, 3] := Ft.GlobalSection.SendingSysProdID;

    Cells[0, 4] := '�ļ���';
    cells[1, 4] := Ft.GlobalSection.FileName;

    Cells[0, 5] := 'ԭϵͳ��ʶ��';
    cells[1, 5] := Ft.GlobalSection.NativeSysID;

    Cells[0, 6] := 'ǰ�ô������汾';
    cells[1, 6] := Ft.GlobalSection.PreprocessorID;

    Cells[0, 7] := '�����Ķ�����λ��';
    cells[1, 7] := IntToStr(Ft.GlobalSection.IntLength);

    Cells[0, 8] := '�����ȸ�����������';
    cells[1, 8] := Format('%d  (1.0E%d)', [Ft.GlobalSection.SinglePowerBase10, Ft.GlobalSection.SinglePowerBase10]);

    Cells[0, 9] := '�����ȸ�������λ��';
    cells[1, 9] := Inttostr(Ft.GlobalSection.SingleSignDigits);

    Cells[0, 10] := '˫���ȸ�����������';
    cells[1, 10] := Format('%d  (1.0E%d)', [Ft.GlobalSection.DoublePowerBase10, Ft.GlobalSection.DoublePowerBase10]);

    Cells[0, 11] := '˫���ȸ�������λ��';
    cells[1, 11] := Inttostr(Ft.GlobalSection.DoubleSignDigits);

    Cells[0, 12] := '�����ߵĲ�Ʒ��ʶ';
    cells[1, 12] := Ft.GlobalSection.RevevieSysProdID;

    Cells[0, 13] := 'ģ�Ϳռ�ı���';
    cells[1, 13] := FloatToStr(Ft.GlobalSection.ModelSpaceScale);

    Cells[0, 14] := '��λ��־';
    cells[1, 14] := Format('%d (' + GFlagUnits[Ft.GlobalSection.UnitsFlag]+')', [Ft.GlobalSection.UnitsFlag]);

    Cells[0, 15] := '��λ����';
    cells[1, 15] := ft.GlobalSection.UnitsName;

    Cells[0, 16] := '�߿�����ּ���';
    cells[1, 16] := IntToStr(Ft.GlobalSection.MaxLineWeight);

    Cells[0, 17] := '����λ������߿�';
    cells[1, 17] := FloatToStr(Ft.GlobalSection.MaxLineWeightInUnits);

    Cells[0, 18] := '�����ļ����ɵ����ں�ʱ��';
    Cells[1, 18] := TransDateTime(ft.GlobalSection.FileGenerationTime);

    Cells[0, 19] := '�û�ָ����С�ֱ���(��Ϊ�غ�)';
    cells[1, 19] := FloatToStr(ft.GlobalSection.ModelMinGranularity);

    Cells[0, 20] := '���Ƶ��������ֵ';
    cells[1, 20] := FloatToStr(ft.GlobalSection.AprMaxCoordValue);

    Cells[0, 21] := '������';
    cells[1, 21] := Ft.GlobalSection.AuthorName;

    Cells[0, 22] := '������������֯';
    cells[1, 22] := Ft.GlobalSection.AuthorOrg;

    Cells[0, 23] := '�汾��־';
    cells[1, 23] := GVersionFlag[Ft.GlobalSection.FileVersionFlag];

    Cells[0, 24] := '��ͼ��ע��־';
    cells[1, 24] := GDraftStandardFlag[Ft.GlobalSection.FileDraftFlag];

    Cells[0, 25] := '�������޸�ģ�͵�������ʱ��';
    Cells[1, 25] := TransDateTime(Ft.GlobalSection.FileModifiedTime);

    Cells[0, 26] := 'Ӧ��Э��/�Ӽ���ʶ��';
    if ft.GlobalSection.MoreInf <> '' then
    begin

    end;
  end;
end;

procedure TForm3.PrintInTree(Reader: TIGSEntityReader);
var
  Node: TTreeNode;
begin
  tv1.Items.Clear;

  tv1.Items.BeginUpdate;
  Node := tv1.Items.AddFirst(nil, '����');
  with Reader.ReadedEntitiesDic.GetEnumerator do
  begin
    while MoveNext do
    begin
      if Current.Value <> nil then
        tv1.Items.AddChild(Node, Current.Value.ClassName + '('+ IntToStr(Current.Key)+')')
      else
        tv1.Items.AddChild(Node, 'nil'+ '('+ IntToStr(Current.Key)+')')
    end;
    Free;
  end;
  tv1.Items.EndUpdate;
end;

procedure TForm3.sddf1Click(Sender: TObject);
var
  ancA, ancB, ancC, ancD: AnsiChar;
  S: string;
begin
  ancA := 'a';
  ancB := 'a';
  ancC := 'a';
  ancD := 'a';
  S := ancA + ancB + ancC + ancD;
  OutputDebugString(PChar(Format('����ĸ��%d', [Integer(@(S[4])) - Integer(@(S[1]))])));
  S := '���ұ���';
  OutputDebugString(PChar(Format('�����֣�%d', [Integer(@S[4]) - Integer(@S[1])])));
  S := 'ab����';
  OutputDebugString(PChar(Format('������ĸ��%d', [Integer(@S[4]) - Integer(@S[1])])));
end;

procedure TForm3.UpDateView(Reader: TIGSEntityReader);
begin

end;

end.
