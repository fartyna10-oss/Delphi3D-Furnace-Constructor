unit FurnaceComponents;

interface

uses
  System.SysUtils, System.Classes;

type
  TComponentType = (ctChamber, ctWall, ctFloor, ctDoor, ctVent);

  TFurnaceComponent = class(TObject)
  private
    FComponentType: TComponentType;
    FWidth: Double;
    FHeight: Double;
    FDepth: Double;
    FPosX: Double;
    FPosY: Double;
    FPosZ: Double;
    FRotX: Double;
    FRotY: Double;
    FRotZ: Double;
    FTemperature: Double;
    FMaterial: String;
  public
    constructor Create;
    destructor Destroy; override;
    
    property ComponentType: TComponentType read FComponentType write FComponentType;
    property Width: Double read FWidth write FWidth;
    property Height: Double read FHeight write FHeight;
    property Depth: Double read FDepth write FDepth;
    property PosX: Double read FPosX write FPosX;
    property PosY: Double read FPosY write FPosY;
    property PosZ: Double read FPosZ write FPosZ;
    property RotX: Double read FRotX write FRotX;
    property RotY: Double read FRotY write FRotY;
    property RotZ: Double read FRotZ write FRotZ;
    property Temperature: Double read FTemperature write FTemperature;
    property Material: String read FMaterial write FMaterial;
  end;

implementation

constructor TFurnaceComponent.Create;
begin
  inherited Create;
  FComponentType := ctChamber;
  FWidth := 1.0;
  FHeight := 1.0;
  FDepth := 1.0;
  FPosX := 0;
  FPosY := 0;
  FPosZ := 0;
  FRotX := 0;
  FRotY := 0;
  FRotZ := 0;
  FTemperature := 20;
  FMaterial := 'Concrete';
end;

destructor TFurnaceComponent.Destroy;
begin
  inherited Destroy;
end;

end.