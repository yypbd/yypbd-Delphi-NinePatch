unit NinePatch.PNGUtil;

interface

uses
  Classes, SysUtils, GR32, PngImage;

type
  TPNGUtil = record
    class function IsNinePatchFileName(const AFileName: string): Boolean; static;
    class function GetAlpha( AColor: TColor32 ): Byte; static;
    class function PNGFileLoadAndAlphaToBitmap32(const AFileName: String; ABitmap32: TBitmap32): Boolean; overload; static;
    class function PNGFileLoadAndAlphaToBitmap32(AStream: TStream; ABitmap32: TBitmap32): Boolean; overload; static;
  end;

implementation

{ TPNGUtil }

class function TPNGUtil.PNGFileLoadAndAlphaToBitmap32(
  const AFileName: String; ABitmap32: TBitmap32): Boolean;
var
  Stream: TMemoryStream;
begin
  Result := False;

  if not FileExists( AFileName ) then Exit;

  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile( AFileName );
    Result := PNGFileLoadAndAlphaToBitmap32( Stream, ABitmap32 );
  finally
    Stream.Free;
  end;
end;

class function TPNGUtil.GetAlpha(AColor: TColor32): Byte;
var
  A, R, G, B: Byte;
begin
  Color32ToRGBA( AColor, R, G, B, A );
  Result := A;
end;

class function TPNGUtil.IsNinePatchFileName(const AFileName: string): Boolean;
begin
  Result := LowerCase( Copy( AFileName, Length(AFileName) - 6 + 1, 6 ) ) = '.9.png';
end;

class function TPNGUtil.PNGFileLoadAndAlphaToBitmap32(AStream: TStream;
  ABitmap32: TBitmap32): Boolean;
type
  TRGBByte = record
    B, G, R: byte;
  end;

  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..0] of TRGBByte;
var
  Png: TPngImage;
  X, Y: Integer;
  AlphaScanLine: PByteArray;
  ScanLine: PRGBArray;
  Alpha: Byte;
begin
  Png := TPngImage.Create;
  try
    try
      Png.LoadFromStream( AStream );

      ABitmap32.SetSize(Png.Width, Png.Height);

      ABitmap32.Clear(SetAlpha(clWhite32, 0));

      for Y := 0 to ABitmap32.Height - 1 do
      begin
        AlphaScanLine := Png.AlphaScanline[Y];
        ScanLine := Png.Scanline[Y];

        if not Assigned(ScanLine) then Continue;

        for X := 0 to ABitmap32.Width - 1 do
        begin
          Alpha := 255;
          if Assigned(AlphaScanLine) then Alpha := AlphaScanLine[X];

          if Alpha <= 0 then Continue;

          ABitmap32.Pixel[X,Y] := Color32(ScanLine[X].R, ScanLine[X].G, ScanLine[X].B, Alpha);
        end;
      end;
      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(Png);
  end;
end;

end.
