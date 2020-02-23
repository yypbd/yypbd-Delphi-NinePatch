object FormNinePatchTestMain: TFormNinePatchTestMain
  Left = 0
  Top = 0
  Caption = 'FormNinePatchTestMain'
  ClientHeight = 743
  ClientWidth = 1002
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 130
  TextHeight = 18
  object Image32Board: TImage32
    Left = 0
    Top = 200
    Width = 1002
    Height = 543
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
  end
  object pnlTopbar: TPanel
    Left = 0
    Top = 0
    Width = 1002
    Height = 49
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      AlignWithMargins = True
      Left = 480
      Top = 5
      Width = 104
      Height = 39
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
    object ButtonDraw: TButton
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 237
      Height = 39
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'Draw Nine-patch Png From File'
      TabOrder = 1
      OnClick = ButtonDrawClick
    end
    object CheckBoxShowContentArea: TCheckBox
      AlignWithMargins = True
      Left = 250
      Top = 5
      Width = 222
      Height = 39
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'ShowContentArea'
      TabOrder = 2
    end
  end
  object MemoLog: TMemo
    Left = 0
    Top = 49
    Width = 1002
    Height = 151
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object OpenDialogPNG: TOpenDialog
    DefaultExt = '.png'
    Filter = 'PNG Image|*.png'
    Left = 696
    Top = 84
  end
end
