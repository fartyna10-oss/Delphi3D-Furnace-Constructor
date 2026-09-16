unit MathUtils;

interface

uses
  System.SysUtils, System.Math;

type
  TVector3D = record
    X, Y, Z: Double;
    procedure Add(const AV: TVector3D);
    procedure Subtract(const AV: TVector3D);
    function Magnitude: Double;
    procedure Normalize;
  end;

  TMatrix3D = record
    M: array[0..3, 0..3] of Double;
    procedure Identity;
    procedure Translate(AX, AY, AZ: Double);
    procedure RotateX(AAngle: Double);
    procedure RotateY(AAngle: Double);
    procedure RotateZ(AAngle: Double);
  end;

implementation

procedure TVector3D.Add(const AV: TVector3D);
begin
  X := X + AV.X;
  Y := Y + AV.Y;
  Z := Z + AV.Z;
end;

procedure TVector3D.Subtract(const AV: TVector3D);
begin
  X := X - AV.X;
  Y := Y - AV.Y;
  Z := Z - AV.Z;
end;

function TVector3D.Magnitude: Double;
begin
  Result := Sqrt(X * X + Y * Y + Z * Z);
end;

procedure TVector3D.Normalize;
var
  LMag: Double;
begin
  LMag := Magnitude;
  if LMag <> 0 then
  begin
    X := X / LMag;
    Y := Y / LMag;
    Z := Z / LMag;
  end;
end;

procedure TMatrix3D.Identity;
var
  I, J: Integer;
begin
  for I := 0 to 3 do
    for J := 0 to 3 do
      if I = J then
        M[I, J] := 1.0
      else
        M[I, J] := 0.0;
end;

procedure TMatrix3D.Translate(AX, AY, AZ: Double);
begin
  Identity;
  M[0, 3] := AX;
  M[1, 3] := AY;
  M[2, 3] := AZ;
end;

procedure TMatrix3D.RotateX(AAngle: Double);
var
  LCos, LSin: Double;
begin
  Identity;
  LCos := Cos(AAngle);
  LSin := Sin(AAngle);
  
  M[1, 1] := LCos;
  M[1, 2] := -LSin;
  M[2, 1] := LSin;
  M[2, 2] := LCos;
end;

procedure TMatrix3D.RotateY(AAngle: Double);
var
  LCos, LSin: Double;
begin
  Identity;
  LCos := Cos(AAngle);
  LSin := Sin(AAngle);
  
  M[0, 0] := LCos;
  M[0, 2] := LSin;
  M[2, 0] := -LSin;
  M[2, 2] := LCos;
end;

procedure TMatrix3D.RotateZ(AAngle: Double);
var
  LCos, LSin: Double;
begin
  Identity;
  LCos := Cos(AAngle);
  LSin := Sin(AAngle);
  
  M[0, 0] := LCos;
  M[0, 1] := -LSin;
  M[1, 0] := LSin;
  M[1, 1] := LCos;
end;

end.