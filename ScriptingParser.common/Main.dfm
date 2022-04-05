object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Pascal To Wiki Parser'
  ClientHeight = 648
  ClientWidth = 818
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    818
    648)
  PixelsPerInch = 96
  TextHeight = 13
  object btnReyKMR: TButton
    Left = 712
    Top = 16
    Width = 33
    Height = 33
    Caption = 'Rey KMR'
    TabOrder = 0
    WordWrap = True
    OnClick = btnReyKMRClick
  end
  object btnKromKP: TButton
    Left = 776
    Top = 16
    Width = 33
    Height = 33
    Caption = 'Krom KP'
    TabOrder = 1
    WordWrap = True
    OnClick = btnKromKPClick
  end
  object btnGenerateWiki: TButton
    Left = 712
    Top = 56
    Width = 98
    Height = 49
    Anchors = [akTop, akRight]
    Caption = 'Generate Wiki'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    WordWrap = True
    OnClick = btnGenerateWikiClick
  end
  object btnGenerateXML: TButton
    Left = 712
    Top = 104
    Width = 98
    Height = 49
    Anchors = [akTop, akRight]
    Caption = 'Generate XML'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 3
    WordWrap = True
    OnClick = btnGenerateXMLClick
  end
  object gbSettings: TGroupBox
    Left = 8
    Top = 8
    Width = 697
    Height = 145
    Anchors = [akLeft, akTop, akRight]
    Caption = ' Settings '
    TabOrder = 4
    object Label1: TLabel
      Left = 11
      Top = 35
      Width = 39
      Height = 13
      Caption = 'Actions:'
    end
    object Label2: TLabel
      Left = 11
      Top = 62
      Width = 37
      Height = 13
      Caption = 'Events:'
    end
    object Label3: TLabel
      Left = 12
      Top = 116
      Width = 24
      Height = 13
      Caption = 'Utils:'
    end
    object Label8: TLabel
      Left = 12
      Top = 89
      Width = 35
      Height = 13
      Caption = 'States:'
    end
    object Label4: TLabel
      Left = 155
      Top = 13
      Width = 43
      Height = 13
      Caption = 'Input file'
    end
    object Label5: TLabel
      Left = 371
      Top = 13
      Width = 52
      Height = 13
      Caption = 'Header file'
    end
    object Label6: TLabel
      Left = 571
      Top = 13
      Width = 51
      Height = 13
      Caption = 'Output file'
    end
    object edtActionsFile: TEdit
      Left = 55
      Top = 32
      Width = 250
      Height = 21
      TabOrder = 0
      OnChange = edtOnTextChange
    end
    object edtEventsFile: TEdit
      Left = 55
      Top = 59
      Width = 250
      Height = 21
      TabOrder = 1
      OnChange = edtOnTextChange
    end
    object edtStatesFile: TEdit
      Left = 55
      Top = 86
      Width = 250
      Height = 21
      TabOrder = 2
      OnChange = edtOnTextChange
    end
    object edtOutputFileActions: TEdit
      Left = 492
      Top = 32
      Width = 200
      Height = 21
      TabOrder = 4
      OnChange = edtOnTextChange
    end
    object edtOutputFileEvents: TEdit
      Left = 492
      Top = 59
      Width = 200
      Height = 21
      TabOrder = 5
      OnChange = edtOnTextChange
    end
    object edtOutputFileStates: TEdit
      Left = 492
      Top = 86
      Width = 200
      Height = 21
      TabOrder = 6
      OnChange = edtOnTextChange
    end
    object edtOutputFileUtils: TEdit
      Left = 492
      Top = 113
      Width = 200
      Height = 21
      TabOrder = 7
      OnChange = edtOnTextChange
    end
    object edtUtilsFile: TEdit
      Left = 55
      Top = 113
      Width = 250
      Height = 21
      TabOrder = 3
      OnChange = edtOnTextChange
    end
    object edtHeaderFileActions: TEdit
      Left = 311
      Top = 32
      Width = 175
      Height = 21
      TabOrder = 8
      OnChange = edtOnTextChange
    end
    object edtHeaderFileEvents: TEdit
      Left = 311
      Top = 59
      Width = 175
      Height = 21
      TabOrder = 9
      OnChange = edtOnTextChange
    end
    object edtHeaderFileStates: TEdit
      Left = 311
      Top = 86
      Width = 175
      Height = 21
      TabOrder = 10
      OnChange = edtOnTextChange
    end
    object edtHeaderFileUtils: TEdit
      Left = 311
      Top = 113
      Width = 175
      Height = 21
      TabOrder = 11
      OnChange = edtOnTextChange
    end
  end
  object TabControl1: TTabControl
    Left = 8
    Top = 159
    Width = 802
    Height = 481
    TabOrder = 5
    Tabs.Strings = (
      'Actions'
      'Events'
      'States'
      'Utils')
    TabIndex = 0
    OnChange = TabControl1Change
    DesignSize = (
      802
      481)
    object txtParserOutput: TMemo
      Left = 3
      Top = 27
      Width = 790
      Height = 451
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      OnKeyPress = txtParserOutputKeyPress
    end
  end
  object btnKromKMR: TButton
    Left = 744
    Top = 16
    Width = 33
    Height = 33
    Caption = 'Krom KMR'
    TabOrder = 6
    WordWrap = True
    OnClick = btnKromKMRClick
  end
end
