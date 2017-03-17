unit Form.NinePatchTestMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GR32, PngImage, Vcl.StdCtrls,
  GR32_Image;

type
  TRectHelper = record helper for TRect
  public
    function ToString: string;
  end;

  TFormNinePatchTestMain = class(TForm)
    MemoLog: TMemo;
    Image32Board: TImage32;
    ButtonDraw: TButton;
    OpenDialogPNG: TOpenDialog;
    CheckBoxShowContentArea: TCheckBox;
    Button1: TButton;
    procedure ButtonDrawClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormNinePatchTestMain: TFormNinePatchTestMain;

implementation

uses
  NinePatch.Image;

{$R *.dfm}

{ TRectHelper }

function TRectHelper.ToString: string;
begin
  Result := Format( 'Left: %d, Top: %d, Right: %d, Bottom: %d', [Left, Top, Right, Bottom] );
end;

{ TFormNinePatchTestMain }

procedure TFormNinePatchTestMain.Button1Click(Sender: TObject);
var
  FileName: string;
  NinePatch: TNinePatch;
  I: Integer;
  Bitmap: TBitmap32;
  Tick: DWORD;
begin
  if OpenDialogPNG.Execute then
  begin
    FileName := OpenDialogPNG.FileName;

    NinePatch := TNinePatch.Create;
    Bitmap := TBitmap32.Create;
    try
      MemoLog.Lines.Clear;

      if NinePatch.LoadFromPNGFile( FileName ) then
      begin
        Bitmap.SetSize( 500, 500 );

        Tick := GetTickCount;
        for I := 1 to 5000 do
        begin
          NinePatch.DrawTo( Bitmap );
        end;
        MemoLog.Lines.Add( Format( 'Using BitBlt - elapses tick : %d', [GetTickCount- Tick] ) );

        Tick := GetTickCount;
        for I := 1 to 5000 do
        begin
          NinePatch.DrawTo2( Bitmap );
        end;
        MemoLog.Lines.Add( Format( 'Using TBitmap32.Draw - elapses tick : %d', [GetTickCount- Tick] ) );
      end;
    finally
      NinePatch.free;
      Bitmap.Free;
    end;
  end;
end;

procedure TFormNinePatchTestMain.ButtonDrawClick(Sender: TObject);
var
  FileName: string;
  NinePatch: TNinePatch;
  Bitmap: TBitmap32;
  ContentRect: TRect;

  procedure DrawNinePatchImage( AWidth, AHeight, AX, AY: Integer );
  begin
    Bitmap.SetSize( AWidth, AHeight );
    NinePatch.DrawTo2( Bitmap );

    ContentRect := NinePatch.GetContentRect( Bitmap.Width, Bitmap.Height );
    MemoLog.Lines.Add( Format( '[Content Area Info Width: %d Height: %d]', [AWidth, AHeight]) );
    MemoLog.Lines.Add( ContentRect.ToString );
    if CheckBoxShowContentArea.Checked then
      Bitmap.FillRect( ContentRect.Left, ContentRect.Top, ContentRect.Right, ContentRect.Bottom, clBlack32 );

    Bitmap.DrawMode := dmBlend;
    Bitmap.DrawTo(Image32Board.Bitmap, AX, AY);
  end;
begin
  if OpenDialogPNG.Execute then
  begin
    FileName := OpenDialogPNG.FileName;

    NinePatch := TNinePatch.Create;
    try
      if NinePatch.LoadFromPNGFile( FileName ) then
      begin
        MemoLog.Clear;

        Bitmap := TBitmap32.Create;
        try
          // Clear Board
          Image32Board.Bitmap.Width := Image32Board.Width;
          Image32Board.Bitmap.Height := Image32Board.Height;
          Image32Board.Bitmap.FillRect(0, 0, Image32Board.Bitmap.Width, Image32Board.Bitmap.Height, clRed32);

          MemoLog.Lines.Add( '[Nine-patch Info]' );
          MemoLog.Lines.Add( NinePatch.ToString );

          // Draw Test1
          DrawNinePatchImage( 100, 100, 0, 0 );

          // Draw Test2
          DrawNinePatchImage( 200, 100, 0, 150 );

          // Draw Test3
          DrawNinePatchImage( 100, 200, 250, 150 );
        finally
          Bitmap.Free;
        end;
      end;
    finally
      NinePatch.Free;
    end;
  end;
end;

procedure TFormNinePatchTestMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
end;

end.
