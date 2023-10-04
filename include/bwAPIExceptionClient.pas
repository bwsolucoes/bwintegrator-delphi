unit bwAPIExceptionClient;

interface

uses
  System.Classes,
//  bwAPIClient,
  bwConfigFileHandler;

type
//  TAPIExceptionClient = class(TInterfacedObject, IAPIClient)
  TAPIExceptionClient = class(TObject)
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
  bwAPIMetricClient,
  bwAPIEventClient;

var
  apiMetricClient: TAPIMetricClient;
  apiEventClient: TAPIEventClient;

{ TAPIExceptionClient }

constructor TAPIExceptionClient.Create;
begin
  inherited Create;
  apiMetricClient := TAPIMetricClient.Create;
  apiEventClient := TAPIEventClient.Create;
end;

destructor TAPIExceptionClient.Destroy;
begin
  apiMetricClient.Destroy;
  apiEventClient.Destroy;
  inherited;
end;

//procedure TAPIExceptionClient.Send(const config: TConfigFile; const content: String);
//begin
//  //
//end;

procedure TAPIExceptionClient.Execute(const config: TConfigFile; const exceptionPoint: String; const exceptObject: TObject);
var
  exceptionClass: String;
  exceptionMsg: String;
  timestamp: Int64;
begin
  exceptionClass := Exception(ExceptObject).ClassName;
  exceptionMsg := Exception(ExceptObject).Message;
  timestamp := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now));

  // Envio do evento de anormalidade (excecoes) via API
  try
    TThread.CreateAnonymousThread(
      procedure
      begin
        apiEventClient.Execute(config, exceptionPoint, exceptionClass, exceptionMsg);
      end).Start;
  except
    on peException: Exception do
      writeln(peException.ClassName, ': ', peException.Message);
  end;

  // Envio da metrica de anormalidade (excecoes) via API
  try
    TThread.CreateAnonymousThread(
      procedure
      begin
        apiMetricClient.Execute(config, exceptionClass, 'count', 1, timestamp);
      end).Start;
  except
    on pmException: Exception do
      writeln(pmException.ClassName, ': ', pmException.Message);
  end;
end;

end.

