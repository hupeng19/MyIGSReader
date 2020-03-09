object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 555
  ClientWidth = 890
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMain
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object splTreeAndPage: TSplitter
    Left = 121
    Top = 0
    Height = 555
  end
  object pgc1: TPageControl
    Left = 124
    Top = 0
    Width = 766
    Height = 555
    ActivePage = tsShow
    Align = alClient
    TabOrder = 0
    object tsEdit: TTabSheet
      Caption = 'IGES'#25991#20214#20840#25991
      object redt1: TRichEdit
        Left = 0
        Top = 0
        Width = 758
        Height = 527
        Align = alClient
        Color = clCream
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        Lines.Strings = (
          'abc'
          #30002)
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object tsShow: TTabSheet
      Caption = #19977#32500#26174#31034
      ImageIndex = 1
    end
    object tsFileInf: TTabSheet
      Caption = #20840#23616#27573#20449#24687
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object StringGrid1: TStringGrid
        Left = 0
        Top = 0
        Width = 758
        Height = 527
        Align = alClient
        ColCount = 2
        RowCount = 27
        TabOrder = 0
        RowHeights = (
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24)
      end
    end
    object tsEntityInf: TTabSheet
      Caption = #23454#20307#20449#24687
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object tv1: TTreeView
    Left = 0
    Top = 0
    Width = 121
    Height = 555
    Align = alLeft
    Indent = 19
    TabOrder = 1
    Items.NodeData = {
      03010000001E0000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      00000000000100}
  end
  object dlgOpenFile: TOpenDialog
    Left = 64
    Top = 136
  end
  object mmMain: TMainMenu
    Left = 64
    Top = 72
    object open1: TMenuItem
      Caption = 'open'
      OnClick = open1Click
    end
    object sddf1: TMenuItem
      Caption = 'sddf'
      OnClick = sddf1Click
    end
  end
end
