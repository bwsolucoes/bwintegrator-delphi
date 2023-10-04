unit bwStatsdService;

interface

uses
	bwStatsdType;

type
  TStatsdService = class(TObject)
  private
    FName: String;
    FHostName: String;
    FPort: Integer;
    FStatus: TServiceStatus;
    FMessageText: String;
    FRunId: Integer;
    FTimeStamp: Cardinal;
    FTags: TTags;
    procedure SetHostname(const value: String);
    procedure SetPort(const value: Integer);
  public
    constructor Create;
    function ToStatsdString: String;
    function GetHostName: String;
    property Name: String read FName write FName;
    property HostName: String read FHostName write SetHostName;
    property Port: Integer read FPort write SetPort;
    property Status: TServiceStatus read FStatus write FStatus;
    property MessageText: String read FMessageText write FMessageText;
    property RunId: Integer read FRunId write FRunId;
    property TimeStamp: Cardinal read FTimeStamp write FTimeStamp;
    property Tags: TTags read FTags write FTags;
  end;

implementation

uses
	System.SysUtils,
  Winapi.Windows,
  bwStatsdUtil;

const
  STAND_PORT = 8125;

{ TStatsdService }

constructor TStatsdService.Create;
begin
  FHostname := GetHostname;
  FPort := STAND_PORT;
  FStatus := ssUndefined;
end;

procedure TStatsdService.SetHostName(const value: String);
begin
  if value = EmptyStr then
    FHostName := GetHostName
  else
    FHostName := value;
end;

procedure TStatsdService.SetPort(const value: Integer);
begin
  if value = 0 then
    FPort := STAND_PORT
  else
    FPort := value;
end;

function TStatsdService.ToStatsdString: String;
var
  statsdString: TStringBuilder;
begin
  statsdString := TStringBuilder.Create;

  try
    statsdString.Append(Format('_sc|%s|%d', [Name, Ord(Status)]));

    if (TimeStamp > 0) then
      statsdString.Append(Format('|d:%d', [TimeStamp]));

    if not (HostName = EmptyStr) then
      statsdString.Append(Format('|h:%s', [HostName]));

    statsdString.Append(DataTagsToText(tags));

    if (MessageText <> EmptyStr) then
      statsdString.Append(Format('|m:%s', [EscapedMessage(MessageText)]));

    result := statsdString.ToString;
  finally
    statsdString.Free;
  end;
end;

function TStatsdService.GetHostName;
var
  computerName: array [0 .. 256] of Char;
  size: DWORD;
begin
  size := 256;
  GetComputerName(computerName, size);
  result := computerName;
end;

end.

