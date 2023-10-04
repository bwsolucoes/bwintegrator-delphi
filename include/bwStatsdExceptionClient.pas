unit bwStatsdExceptionClient;

interface

uses
  System.Classes,
//  bwStatsdClient,
  bwConfigFileHandler;

type
//  TStatsdExceptionClient = class(TInterfacedObject, IStatsdClient)
  TStatsdExceptionClient = class(TObject)
  private
//    FSender: IDataDogStatsClientSender;
//    procedure Send(const config: TConfigFile; const content: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(const config: TConfigFile; const exceptionPoint: String; const exceptObject: TObject);
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  bwStatsdMetricClient,
  bwStatsdEventClient;

var
  statsdMetricClient: TStatsdMetricClient;
  statsdEventClient: TStatsdEventClient;

{ TStatsdExceptionClient }

constructor TStatsdExceptionClient.Create;
begin
  inherited Create;
  statsdMetricClient := TStatsdMetricClient.Create;
  statsdEventClient := TStatsdEventClient.Create;
end;

destructor TStatsdExceptionClient.Destroy;
begin
  statsdMetricClient.Destroy;
  statsdEventClient.Destroy;
  inherited;
end;

//procedure TStatsdExceptionClient.Send(const config: TConfigFile; const content: String);
//begin
//  //
//end;

procedure TStatsdExceptionClient.Execute(const config: TConfigFile; const exceptionPoint: String; const exceptObject: TObject);
var
  exceptionClass: String;
  exceptionMsg: String;
  timestamp: Int64;
begin
  exceptionClass := Exception(ExceptObject).ClassName;
  exceptionMsg := Exception(ExceptObject).Message;
  timestamp := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now));

  // Envio do evento de anormalidade (excecoes) via statsD
  try
    statsdEventClient.Execute(config, exceptionPoint, exceptionClass, exceptionMsg);
  except
    on peException: Exception do
      writeln(peException.ClassName, ': ', peException.Message);
  end;

  // Envio da metrica de anormalidade (excecoes) via statsD
  try
    statsdMetricClient.Execute(config, exceptionClass, 'count', 1, timestamp);
  except
    on pmException: Exception do
      writeln(pmException.ClassName, ': ', pmException.Message);
  end;
end;

end.

