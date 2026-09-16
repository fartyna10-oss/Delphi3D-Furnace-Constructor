unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Spin,
  Rendering3D, FurnaceComponents, FurnaceEngine, MathUtils;

type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    HelpMenu: TMenuItem;
    ExitItem: TMenuItem;
    AboutItem: TMenuItem;
    Panel3D: TPanel;
    ControlPanel: TPanel;
    ComponentListBox: TListBox;
    AddComponentButton: TButton;
    RemoveComponentButton: TButton;
    PropertiesPanel: TPanel;
    Label1: TLabel;
    WidthSpinEdit: TSpinEdit;
    HeightSpinEdit: TSpinEdit;
    DepthSpinEdit: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RotationXSpinEdit: TSpinEdit;
    RotationYSpinEdit: TSpinEdit;
    RotationZSpinEdit: TSpinEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TemperatureSpinEdit: TSpinEdit;
    Label9: TLabel;
    ApplyButton: TButton;
    ResetButton: TButton;
    SimulateButton: TButton;
    SaveButton: TButton;
    LoadButton: TButton;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Panel3DPaint(Sender: TObject);
    procedure AddComponentButtonClick(Sender: TObject);
    procedure RemoveComponentButtonClick(Sender: TObject);
    procedure ComponentListBoxClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure SimulateButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FRenderer: T3DRenderer;
    FFurnaceEngine: TFurnaceEngine;
    FSelectedComponent: Integer;
    procedure UpdatePropertiesPanel;
    procedure UpdateComponentList;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FRenderer := T3DRenderer.Create(Panel3D.Handle, Panel3D.Width, Panel3D.Height);
  FFurnaceEngine := TFurnaceEngine.Create;
  FSelectedComponent := -1;
  
  StatusBar1.SimpleText := 'Ready';
  UpdateComponentList;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FRenderer.Free;
  FFurnaceEngine.Free;
end;

procedure TFormMain.FormPaint(Sender: TObject);
begin
  if Assigned(FRenderer) then
    FRenderer.Render(FFurnaceEngine.Components);
end;

procedure TFormMain.Panel3DPaint(Sender: TObject);
begin
  if Assigned(FRenderer) then
    FRenderer.Render(FFurnaceEngine.Components);
end;

procedure TFormMain.AddComponentButtonClick(Sender: TObject);
var
  LComponent: TFurnaceComponent;
begin
  LComponent := TFurnaceComponent.Create;
  LComponent.ComponentType := ctChamber;
  LComponent.Width := 1.0;
  LComponent.Height := 1.0;
  LComponent.Depth := 1.0;
  LComponent.PosX := 0;
  LComponent.PosY := 0;
  LComponent.PosZ := 0;
  
  FFurnaceEngine.AddComponent(LComponent);
  UpdateComponentList;
  StatusBar1.SimpleText := 'Component added';
end;

procedure TFormMain.RemoveComponentButtonClick(Sender: TObject);
begin
  if FSelectedComponent >= 0 then
  begin
    FFurnaceEngine.RemoveComponent(FSelectedComponent);
    FSelectedComponent := -1;
    UpdateComponentList;
    UpdatePropertiesPanel;
    StatusBar1.SimpleText := 'Component removed';
  end;
end;

procedure TFormMain.ComponentListBoxClick(Sender: TObject);
begin
  FSelectedComponent := ComponentListBox.ItemIndex;
  UpdatePropertiesPanel;
end;

procedure TFormMain.UpdateComponentList;
var
  I: Integer;
begin
  ComponentListBox.Clear;
  for I := 0 to FFurnaceEngine.Components.Count - 1 do
    ComponentListBox.Items.Add('Component ' + IntToStr(I + 1));
end;

procedure TFormMain.UpdatePropertiesPanel;
var
  LComponent: TFurnaceComponent;
begin
  if FSelectedComponent >= 0 and FSelectedComponent < FFurnaceEngine.Components.Count then
  begin
    LComponent := TFurnaceComponent(FFurnaceEngine.Components[FSelectedComponent]);
    WidthSpinEdit.Value := Round(LComponent.Width * 100);
    HeightSpinEdit.Value := Round(LComponent.Height * 100);
    DepthSpinEdit.Value := Round(LComponent.Depth * 100);
    RotationXSpinEdit.Value := Round(LComponent.RotX);
    RotationYSpinEdit.Value := Round(LComponent.RotY);
    RotationZSpinEdit.Value := Round(LComponent.RotZ);
    TemperatureSpinEdit.Value := Round(LComponent.Temperature);
    PropertiesPanel.Enabled := True;
  end
  else
  begin
    PropertiesPanel.Enabled := False;
  end;
end;

procedure TFormMain.ApplyButtonClick(Sender: TObject);
var
  LComponent: TFurnaceComponent;
begin
  if FSelectedComponent >= 0 and FSelectedComponent < FFurnaceEngine.Components.Count then
  begin
    LComponent := TFurnaceComponent(FFurnaceEngine.Components[FSelectedComponent]);
    LComponent.Width := WidthSpinEdit.Value / 100;
    LComponent.Height := HeightSpinEdit.Value / 100;
    LComponent.Depth := DepthSpinEdit.Value / 100;
    LComponent.RotX := RotationXSpinEdit.Value;
    LComponent.RotY := RotationYSpinEdit.Value;
    LComponent.RotZ := RotationZSpinEdit.Value;
    LComponent.Temperature := TemperatureSpinEdit.Value;
    
    Invalidate;
    StatusBar1.SimpleText := 'Properties applied';
  end;
end;

procedure TFormMain.ResetButtonClick(Sender: TObject);
begin
  FFurnaceEngine.ClearComponents;
  FSelectedComponent := -1;
  UpdateComponentList;
  UpdatePropertiesPanel;
  Invalidate;
  StatusBar1.SimpleText := 'Reset completed';
end;

procedure TFormMain.SimulateButtonClick(Sender: TObject);
begin
  FFurnaceEngine.SimulateHeatTransfer;
  Invalidate;
  StatusBar1.SimpleText := 'Simulation running...';
end;

procedure TFormMain.SaveButtonClick(Sender: TObject);
begin
  FFurnaceEngine.SaveToFile('furnace_project.fcp');
  StatusBar1.SimpleText := 'Project saved';
end;

procedure TFormMain.LoadButtonClick(Sender: TObject);
begin
  FFurnaceEngine.LoadFromFile('furnace_project.fcp');
  UpdateComponentList;
  Invalidate;
  StatusBar1.SimpleText := 'Project loaded';
end;

procedure TFormMain.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.AboutItemClick(Sender: TObject);
begin
  ShowMessage('3D Furnace Constructor v1.0' + #13#10 +
             'Delphi 12 OpenGL Edition' + #13#10 +
             '© 2026 fartyna10-oss');
end;

end.