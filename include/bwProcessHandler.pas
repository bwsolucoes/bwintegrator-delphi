unit bwProcessHandler;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TProcess = class(TObject)
  private
    FInstrumentationEnabled: Boolean;
    FId: TList<Integer>;
    FName: TList<String>;
    FStartTime: TList<Int64>;
    FStopTime: TList<Int64>;
    FTimestamp: TList<Int64>;
  public
    constructor Create;
    destructor Destroy; override;
    property InstrumentationEnabled: Boolean read FInstrumentationEnabled write FInstrumentationEnabled;
    property Id: TList<Integer> read FId write FId;
    property Name: TList<String> read FName write FName;
    property StartTime: TList<Int64> read FStartTime write FStartTime;
    property StopTime: TList<Int64> read FStopTime write FStopTime;
    property Timestamp: TList<Int64> read FTimestamp write FTimestamp;
  end;

implementation

uses
  System.SysUtils;

{ TProcess }

constructor TProcess.Create;
begin
  inherited Create;
  FInstrumentationEnabled := true;
  FId := TList<Integer>.Create;
  FName := TList<String>.Create;
  FStartTime := TList<Int64>.Create;
  FStopTime := TList<Int64>.Create;
  FTimestamp := TList<Int64>.Create;
end;

destructor TProcess.Destroy;
begin
  FId.Free;
  FName.Free;
  FStartTime.Free;
  FStopTime.Free;
  FTimestamp.Free;
  inherited;
end;

end.

