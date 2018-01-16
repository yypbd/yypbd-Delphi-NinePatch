unit NinePatch.Image;

interface

uses
  Windows, Classes, SysUtils, GR32;

// https://developer.android.com/guide/topics/graphics/2d-graphics.html#nine-patch

type
  TRectHelper = record helper for TRect
    procedure ToLog;
  end;

  TNinePatch = class
  private
    FBitmap: TBitmap32;

    FLeftStart, FLeftEnd: Integer;         // Stretchable area - X
    FTopStart, FTopEnd: Integer;           // Stretchable area - Y
    FRightStart, FRightEnd: Integer;       // Padding box area(optional) - X
    FBottomStart, FBottomEnd: Integer;     // Padding box area(optional) - Y

    procedure AnalyseNinePatchPoint;
  public
    constructor Create;
    destructor Destroy; override;

    function LoadFromPNGFile( const AFileName: string ): Boolean;
    function DrawTo( ABitmap: TBitmap32 ): Boolean;
    function GetContentRect( AWidth, AHeight: Integer ): TRect;

    function ToString: string; override;
    
    property LeftStart: Integer read FLeftStart;
    property LeftEnd: Integer read FLeftEnd;
    property TopStart: Integer read FTopStart;
    property TopEnd: Integer read FTopEnd;
    property RightStart: Integer read FRightStart;
    property RightEnd: Integer read FRightEnd;
    property BottomStart: Integer read FBottomStart;
    property BottomEnd: Integer read FBottomEnd;
  end;

implementation

uses
  NinePatch.PNGUtil;

{ TNinePatch }

procedure TNinePatch.AnalyseNinePatchPoint;
var
  X, Y: Integer;
  Color: TColor32;
begin
  // find Stretchable area
  FLeftStart := -1;
  for Y := 0 to FBitmap.Height - 1 do
  begin
    Color := FBitmap.Pixel[0, Y];

    if FLeftStart = -1 then
    begin
      if Color = clBlack32 then
//      if TPNGUtil.GetAlpha( Color ) = 255 then
        FLeftStart := Y;
    end
    else
    begin
      if Color <> clBlack32 then
//      if TPNGUtil.GetAlpha( Color ) <> 255 then
      begin
        FLeftEnd := Y;
        Break;
      end;
    end;
  end;

  FTopStart := -1;
  for X := 0 to FBitmap.Width - 1 do
  begin
    Color := FBitmap.Pixel[X, 0];

    if FTopStart = -1 then
    begin
      if Color = clBlack32 then
//      if TPNGUtil.GetAlpha(Color) = 255 then
        FTopStart := X;
    end
    else
    begin
      if Color <> clBlack32 then
//      if TPNGUtil.GetAlpha(Color) <> 255 then
      begin
        FTopEnd := X;
        Break;
      end;
    end;
  end;

  // find Padding box area(optional)
  FRightStart := -1;
  for Y := 0 to FBitmap.Height - 1 do
  begin
    Color := FBitmap.Pixel[FBitmap.Width - 1, Y];

    if FRightStart = -1 then
    begin
      if Color = clBlack32 then
//      if TPNGUtil.GetAlpha( Color ) = 255 then
        FRightStart := Y;
    end
    else
    begin
      if Color <> clBlack32 then
//      if TPNGUtil.GetAlpha( Color ) <> 255 then
      begin
        FRightEnd := Y;
        Break;
      end;
    end;
  end;

  FBottomStart := -1;
  for X := 0 to FBitmap.Width - 1 do
  begin
    Color := FBitmap.Pixel[X, FBitmap.Height - 1];

    if FBottomStart = -1 then
    begin
      if Color = clBlack32 then
//      if TPNGUtil.GetAlpha(Color) = 255 then
        FBottomStart := X;
    end
    else
    begin
      if Color <> clBlack32 then
//      if TPNGUtil.GetAlpha(Color) <> 255 then
      begin
        FBottomEnd := X;
        Break;
      end;
    end;
  end;
end;

constructor TNinePatch.Create;
begin
  FBitmap := TBitmap32.Create;
end;

destructor TNinePatch.Destroy;
begin
  FBitmap.Free;

  inherited;
end;

function TNinePatch.DrawTo(ABitmap: TBitmap32): Boolean;
var
  LeftStartDest, LeftEndDest: Integer;
  TopStartDest, TopEndDest: Integer;
begin
  LeftStartDest := LeftStart - 1;
  LeftEndDest := ABitmap.Height - (FBitmap.Height - 2 - (LeftEnd)) - 1;

  TopStartDest := TopStart - 1;
  TopEndDest := ABitmap.Width - (FBitmap.Width - 2 - (TopEnd)) - 1;

  {
  1 2 3
  4 5 6
  7 8 9
  }

  // using TBitmap32.Draw

  // 1
  ABitmap.Draw(
    Rect(0, 0, TopStartDest, LeftStartDest),
    Rect(1, 1, TopStart, LeftStart),
    FBitmap );

  // 2
  ABitmap.Draw(
    Rect(TopStartDest, 0, TopEndDest, LeftStartDest),
    Rect(TopStart, 1, TopEnd, LeftStart),
    FBitmap );

  // 3
  ABitmap.Draw(
    Rect(TopEndDest, 0, ABitmap.Width, LeftStartDest),
    Rect(TopEnd, 1, FBitmap.Width - 1, LeftStart),
    FBitmap
  );


  // 4
  ABitmap.Draw(
    Rect(0, LeftStartDest, TopStartDest, LeftEndDest),
    Rect(1, LeftStart, TopStart, LeftEnd),
    FBitmap
  );

  // 5
  ABitmap.Draw(
    Rect(TopStartDest, LeftStartDest, TopEndDest, LeftEndDest),
    Rect(TopStart, LeftStart, TopEnd, LeftEnd),
    FBitmap
  );

  // 6
  ABitmap.Draw(
    Rect(TopEndDest, LeftStartDest, ABitmap.Width, LeftEndDest),
    Rect(TopEnd, LeftStart, FBitmap.Width - 1, LeftEnd),
    FBitmap
  );


  // 7
  ABitmap.Draw(
    Rect( 0, LeftEndDest, TopStartDest, ABitmap.Height ),
    Rect( 1, LeftEnd, TopStart, FBitmap.Height - 1 ),
    FBitmap
  );

  // 8
  ABitmap.Draw(
    Rect(TopStartDest, LeftEndDest, TopEndDest, ABitmap.Height),
    Rect(TopStart, LeftEnd, TopEnd, FBitmap.Height - 1),
    FBitmap
  );

  // 9
  ABitmap.Draw(
    Rect(TopEndDest, LeftEndDest, ABitmap.Width, ABitmap.Height),
    Rect(TopEnd, LeftEnd, FBitmap.Width - 1, FBitmap.Height - 1),
    FBitmap
  );

  Result := True;
end;

function TNinePatch.GetContentRect(AWidth, AHeight: Integer): TRect;
begin
  Result.Left := FBottomStart - 1;
  Result.Top := FRightStart - 1;
  Result.Right := FBottomEnd + ( AWidth - (FBitmap.Width - 1) );
  Result.Bottom := FRightEnd + ( AHeight - (FBitmap.Height - 1) );
end;

function TNinePatch.LoadFromPNGFile(const AFileName: string): Boolean;
begin
  Result := False;

  if not TPNGUtil.IsNinePatch( AFileName ) then
    Exit;

  if TPNGUtil.PNGFileLoadAndAlphaToBitmap32( AFileName, FBitmap ) then
  begin
    AnalyseNinePatchPoint;
    Result := True;
  end;
end;

function TNinePatch.ToString: string;
begin
  Result := Format( 'W: %d, H: %d, Left S: %d E: %d, Top S: %d E: %d, Right S: %d E: %d, Bottom S: %d E: %d',
    [FBitmap.Width, FBitmap.Height, LeftStart, LeftEnd, TopStart, TopEnd, RightStart, RightEnd, BottomStart, BottomEnd] );
end;

{ TRectHelper }

procedure TRectHelper.ToLog;
begin
  OutputDebugString( PChar(Format('Left: %d,  Top: %d,  Right: %d,  Bottom: %d,  Width: %d,  Height: %d', [Left, Top, Right, Bottom, Width, Height])) );
end;

end.
