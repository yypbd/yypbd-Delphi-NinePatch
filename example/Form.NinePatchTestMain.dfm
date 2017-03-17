object FormNinePatchTestMain: TFormNinePatchTestMain
  Left = 0
  Top = 0
  Caption = 'FormNinePatchTestMain'
  ClientHeight = 642
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MemoLog: TMemo
    Left = 20
    Top = 60
    Width = 445
    Height = 109
    TabOrder = 0
  end
  object Image32Board: TImage32
    Left = 20
    Top = 184
    Width = 677
    Height = 401
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 1
  end
  object ButtonDraw: TButton
    Left = 20
    Top = 13
    Width = 133
    Height = 25
    Caption = 'Draw Nine-patch Png'
    TabOrder = 2
    OnClick = ButtonDrawClick
  end
  object CheckBoxShowContentArea: TCheckBox
    Left = 212
    Top = 17
    Width = 161
    Height = 17
    Caption = 'ShowContentArea'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 528
    Top = 17
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    OnClick = Button1Click
  end
  object OpenDialogPNG: TOpenDialog
    DefaultExt = '.png'
    Filter = 'PNG Image|*.png'
    Left = 384
    Top = 12
  end
end
