object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Pascal To Wiki Parser'
  ClientHeight = 648
  ClientWidth = 945
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
    945
    648)
  PixelsPerInch = 96
  TextHeight = 13
  object btnReyKMR: TButton
    Left = 840
    Top = 16
    Width = 33
    Height = 33
    Anchors = [akTop, akRight]
    Caption = 'Rey KMR'
    TabOrder = 0
    WordWrap = True
    OnClick = btnReyKMRClick
  end
  object btnKromKP: TButton
    Left = 904
    Top = 16
    Width = 33
    Height = 33
    Anchors = [akTop, akRight]
    Caption = 'Krom KP'
    TabOrder = 1
    WordWrap = True
    OnClick = btnKromKPClick
  end
  object btnGenerateWiki: TButton
    Left = 838
    Top = 56
    Width = 98
    Height = 49
    Anchors = [akTop]
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
    Left = 838
    Top = 152
    Width = 98
    Height = 49
    Anchors = [akTop]
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
    TabOrder = 3
    WordWrap = True
    OnClick = btnGenerateXMLClick
  end
  object gbSettings: TGroupBox
    Left = 8
    Top = 8
    Width = 825
    Height = 169
    Caption = ' Settings '
    TabOrder = 4
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
      Top = 104
      Width = 24
      Height = 13
      Caption = 'Utils:'
    end
    object Label8: TLabel
      Left = 8
      Top = 80
      Width = 35
      Height = 13
      Caption = 'States:'
    end
    object Label4: TLabel
      Left = 144
      Top = 16
      Width = 43
      Height = 13
      Caption = 'Input file'
    end
    object Label5: TLabel
      Left = 344
      Top = 16
      Width = 61
      Height = 13
      Caption = 'Template file'
    end
    object Label6: TLabel
      Left = 528
      Top = 16
      Width = 51
      Height = 13
      Caption = 'Output file'
    end
    object Label7: TLabel
      Left = 8
      Top = 128
      Width = 33
      Height = 13
      Caption = 'Types:'
    end
    object Label9: TLabel
      Left = 704
      Top = 16
      Width = 39
      Height = 13
      Caption = 'Verify in'
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
      Top = 80
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
      Top = 80
      Width = 193
      Height = 21
      TabOrder = 6
      OnChange = edtOnTextChange
    end
    object edUtilsOut: TEdit
      Left = 464
      Top = 104
      Width = 193
      Height = 21
      TabOrder = 7
      OnChange = edtOnTextChange
    end
    object edUtilsIn: TEdit
      Left = 48
      Top = 104
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
      Top = 80
      Width = 153
      Height = 21
      TabOrder = 10
      OnChange = edtOnTextChange
    end
    object edUtilsTemplate: TEdit
      Left = 304
      Top = 104
      Width = 153
      Height = 21
      TabOrder = 11
      OnChange = edtOnTextChange
    end
    object edTypesOut: TEdit
      Left = 464
      Top = 128
      Width = 193
      Height = 21
      TabOrder = 12
      OnChange = edtOnTextChange
    end
    object edTypesIn: TEdit
      Left = 48
      Top = 128
      Width = 249
      Height = 21
      TabOrder = 13
      OnChange = edtOnTextChange
    end
    object edTypesTemplate: TEdit
      Left = 304
      Top = 128
      Width = 153
      Height = 21
      TabOrder = 14
      OnChange = edtOnTextChange
    end
    object edActionsVerify: TEdit
      Left = 664
      Top = 32
      Width = 153
      Height = 21
      TabOrder = 15
      OnChange = edtOnTextChange
    end
    object edEventsVerify: TEdit
      Left = 664
      Top = 56
      Width = 153
      Height = 21
      TabOrder = 16
      OnChange = edtOnTextChange
    end
    object edStatesVerify: TEdit
      Left = 664
      Top = 80
      Width = 153
      Height = 21
      TabOrder = 17
      OnChange = edtOnTextChange
    end
    object edUtilsVerify: TEdit
      Left = 664
      Top = 104
      Width = 153
      Height = 21
      TabOrder = 18
      OnChange = edtOnTextChange
    end
    object edTypesVerify: TEdit
      Left = 664
      Top = 128
      Width = 153
      Height = 21
      TabOrder = 19
      OnChange = edtOnTextChange
    end
  end
  object btnKromKMR: TButton
    Left = 872
    Top = 16
    Width = 33
    Height = 33
    Anchors = [akTop, akRight]
    Caption = 'Krom KMR'
    TabOrder = 5
    WordWrap = True
    OnClick = btnKromKMRClick
  end
  object btnGenerateCode: TButton
    Left = 838
    Top = 104
    Width = 98
    Height = 49
    Anchors = [akTop]
    Caption = 'Generate Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 6
    WordWrap = True
    OnClick = btnGenerateCodeClick
  end
  object meLog: TMemo
    Left = 8
    Top = 184
    Width = 825
    Height = 457
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'meLog')
    TabOrder = 7
  end
end
