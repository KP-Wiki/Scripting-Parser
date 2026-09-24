object fmScriptingParser: TfmScriptingParser
  Left = 0
  Top = 0
  Caption = 'KMR/KP Scripting Parser'
  ClientHeight = 649
  ClientWidth = 961
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    961
    649)
  TextHeight = 13
  object btnReyKMR: TButton
    Left = 696
    Top = 8
    Width = 81
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Rey KMR'
    TabOrder = 0
    WordWrap = True
    OnClick = btnReyKMRClick
  end
  object btnKromKP: TButton
    Left = 872
    Top = 8
    Width = 81
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Krom KP'
    TabOrder = 1
    WordWrap = True
    OnClick = btnKromKPClick
  end
  object gbScripting: TGroupBox
    Left = 8
    Top = 40
    Width = 945
    Height = 185
    Caption = ' Scripting '
    TabOrder = 2
    DesignSize = (
      945
      185)
    object Label1: TLabel
      Left = 8
      Top = 32
      Width = 39
      Height = 13
      Caption = 'Actions:'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 37
      Height = 13
      Caption = 'Events:'
    end
    object Label3: TLabel
      Left = 8
      Top = 128
      Width = 24
      Height = 13
      Caption = 'Utils:'
    end
    object Label8: TLabel
      Left = 8
      Top = 104
      Width = 35
      Height = 13
      Caption = 'States:'
    end
    object Label4: TLabel
      Left = 48
      Top = 16
      Width = 103
      Height = 13
      Caption = 'Source code input file'
    end
    object Label5: TLabel
      Left = 304
      Top = 16
      Width = 81
      Height = 13
      Caption = 'Wiki template file'
    end
    object Label6: TLabel
      Left = 464
      Top = 16
      Width = 71
      Height = 13
      Caption = 'Wiki output file'
    end
    object Label7: TLabel
      Left = 8
      Top = 152
      Width = 33
      Height = 13
      Caption = 'Types:'
    end
    object Label9: TLabel
      Left = 664
      Top = 16
      Width = 111
      Height = 13
      Caption = 'Source code output file'
    end
    object edActionsIn: TEdit
      Left = 48
      Top = 32
      Width = 249
      Height = 21
      TabOrder = 0
      OnChange = edtOnTextChange
    end
    object edEventsIn: TEdit
      Left = 48
      Top = 56
      Width = 249
      Height = 21
      TabOrder = 1
      OnChange = edtOnTextChange
    end
    object edStatesIn: TEdit
      Left = 48
      Top = 104
      Width = 249
      Height = 21
      TabOrder = 2
      OnChange = edtOnTextChange
    end
    object edActionsOut: TEdit
      Left = 464
      Top = 32
      Width = 193
      Height = 21
      TabOrder = 4
      OnChange = edtOnTextChange
    end
    object edEventsOut: TEdit
      Left = 464
      Top = 56
      Width = 193
      Height = 21
      TabOrder = 5
      OnChange = edtOnTextChange
    end
    object edStatesOut: TEdit
      Left = 464
      Top = 104
      Width = 193
      Height = 21
      TabOrder = 6
      OnChange = edtOnTextChange
    end
    object edUtilsOut: TEdit
      Left = 464
      Top = 128
      Width = 193
      Height = 21
      TabOrder = 7
      OnChange = edtOnTextChange
    end
    object edUtilsIn: TEdit
      Left = 48
      Top = 128
      Width = 249
      Height = 21
      TabOrder = 3
      OnChange = edtOnTextChange
    end
    object edActionsTemplate: TEdit
      Left = 304
      Top = 32
      Width = 153
      Height = 21
      TabOrder = 8
      OnChange = edtOnTextChange
    end
    object edEventsTemplate: TEdit
      Left = 304
      Top = 56
      Width = 153
      Height = 21
      TabOrder = 9
      OnChange = edtOnTextChange
    end
    object edStatesTemplate: TEdit
      Left = 304
      Top = 104
      Width = 153
      Height = 21
      TabOrder = 10
      OnChange = edtOnTextChange
    end
    object edUtilsTemplate: TEdit
      Left = 304
      Top = 128
      Width = 153
      Height = 21
      TabOrder = 11
      OnChange = edtOnTextChange
    end
    object edTypesOut: TEdit
      Left = 464
      Top = 152
      Width = 193
      Height = 21
      TabOrder = 12
      OnChange = edtOnTextChange
    end
    object edTypesIn: TEdit
      Left = 48
      Top = 152
      Width = 249
      Height = 21
      TabOrder = 13
      OnChange = edtOnTextChange
    end
    object edTypesTemplate: TEdit
      Left = 304
      Top = 152
      Width = 153
      Height = 21
      TabOrder = 14
      OnChange = edtOnTextChange
    end
    object edActionsCode: TEdit
      Left = 664
      Top = 32
      Width = 153
      Height = 21
      TabOrder = 15
      OnChange = edtOnTextChange
    end
    object edEventsCode: TEdit
      Left = 664
      Top = 56
      Width = 153
      Height = 21
      TabOrder = 16
      OnChange = edtOnTextChange
    end
    object edStatesCode: TEdit
      Left = 664
      Top = 104
      Width = 153
      Height = 21
      TabOrder = 17
      OnChange = edtOnTextChange
    end
    object edUtilsCode: TEdit
      Left = 664
      Top = 128
      Width = 153
      Height = 21
      TabOrder = 18
      OnChange = edtOnTextChange
    end
    object edTypesCode: TEdit
      Left = 664
      Top = 152
      Width = 153
      Height = 21
      TabOrder = 19
      OnChange = edtOnTextChange
    end
    object edEventsCode2: TEdit
      Left = 664
      Top = 80
      Width = 153
      Height = 21
      TabOrder = 20
      OnChange = edtOnTextChange
    end
    object btnCheckMessages: TButton
      Left = 832
      Top = 96
      Width = 97
      Height = 41
      Anchors = [akTop, akRight]
      Caption = 'Check messages'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 21
      WordWrap = True
      OnClick = btnCheckMessagesClick
    end
    object btnGenerateCode: TButton
      Left = 832
      Top = 56
      Width = 97
      Height = 41
      Anchors = [akTop, akRight]
      Caption = 'Generate Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 22
      WordWrap = True
      OnClick = btnGenerateCodeClick
    end
    object btnGenerateWiki: TButton
      Left = 832
      Top = 16
      Width = 97
      Height = 41
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
      TabOrder = 23
      WordWrap = True
      OnClick = btnGenerateWikiClick
    end
    object btnGenerateXML: TButton
      Left = 832
      Top = 136
      Width = 97
      Height = 41
      Anchors = [akTop, akRight]
      Caption = 'Generate XML'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 24
      WordWrap = True
      OnClick = btnGenerateXMLClick
    end
  end
  object btnKromKMR: TButton
    Left = 784
    Top = 8
    Width = 81
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Krom KMR'
    TabOrder = 3
    WordWrap = True
    OnClick = btnKromKMRClick
  end
  object meLog: TMemo
    Left = 8
    Top = 304
    Width = 945
    Height = 337
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 4
  end
  object gbModding: TGroupBox
    Left = 8
    Top = 232
    Width = 945
    Height = 65
    Caption = ' Modding '
    TabOrder = 5
    DesignSize = (
      945
      65)
    object Label10: TLabel
      Left = 8
      Top = 32
      Width = 22
      Height = 13
      Caption = 'Res:'
    end
    object Label14: TLabel
      Left = 48
      Top = 16
      Width = 103
      Height = 13
      Caption = 'Source code input file'
    end
    object Label15: TLabel
      Left = 304
      Top = 16
      Width = 81
      Height = 13
      Caption = 'Wiki template file'
    end
    object Label16: TLabel
      Left = 464
      Top = 16
      Width = 71
      Height = 13
      Caption = 'Wiki output file'
    end
    object edResIn: TEdit
      Left = 48
      Top = 32
      Width = 249
      Height = 21
      TabOrder = 0
      OnChange = edtOnTextChange
    end
    object edResOut: TEdit
      Left = 464
      Top = 32
      Width = 193
      Height = 21
      TabOrder = 1
      OnChange = edtOnTextChange
    end
    object edResTemplate: TEdit
      Left = 304
      Top = 32
      Width = 153
      Height = 21
      TabOrder = 2
      OnChange = edtOnTextChange
    end
    object btnGenerateResWiki: TButton
      Left = 832
      Top = 16
      Width = 97
      Height = 41
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
      TabOrder = 3
      WordWrap = True
      OnClick = btnCheckMessagesClick
    end
  end
end
