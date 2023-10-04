unit bwStatsdEventClient;

interface

uses
  System.Classes,
//  bwStatsdClient,
  bwConfigFileHandler,
  bwStatsdClient,
  bwStatsdClientImpl,
  bwStatsdClientSender,
  bwStatsdClientSenderImpl,
  bwStatsdService,
  bwStatsdType,
  bwStatsdEvent;

type
//  TStatsdEventClient = class(TInterfacedObject, IStatsdClient)
  TStatsdEventClient = class(TObject)
  private
//    FSender: IDataDogStatsClientSender;
//    procedure Send(const config: TConfigFile; const content: String);
  public
    constructor Create; overload;
    constructor Create(const config: TConfigFile); overload;
    destructor Destroy; override;
    procedure Execute(const config: TConfigFile; const exceptionPoint, exceptionClass, exceptionMsg: String);
  end;

implementation

uses
  System.SysUtils,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetConsts;

var
  service: TStatsdService;
  statsdClientSender: IStatsdClientSender;
  statsdClient: IStatsdClient;
  eTags: String;

{ TStatsdEventClient }

constructor TStatsdEventClient.Create;
begin
  inherited Create;
  service := TStatsdService.Create;
  statsdClientSender := TStatsdClientSender.Create(service);
  statsdClient := TStatsdClient.Create(statsdClientSender);
end;

constructor TStatsdEventClient.Create(const config: TConfigFile);
var
  token: TStringList;
  i: Integer;
begin
  service := TStatsdService.Create;
  statsdClientSender := TStatsdClientSender.Create(service);
  statsdClient := TStatsdClient.Create(statsdClientSender);

  token := TStringList.Create;
  eTags := '';

  try
    if config.ETags <> EmptyStr then
    begin
      token.Clear;
      ExtractStrings([','], [], PChar(config.ETags), token);

      for i := 0 to token.Count - 1 do
        if token[i] <> EmptyStr then
          eTags := eTags + '"' + token[i] + '", ';

      eTags := Copy(eTags, 1, eTags.Length - 2);
    end;
  finally
    token.Free;
  end;
end;

destructor TStatsdEventClient.Destroy;
begin
//  datadogService.Destroy;
  inherited;
end;

procedure TStatsdEventClient.Execute(const config: TConfigFile; const exceptionPoint, exceptionClass, exceptionMsg: String);
var
  event: TEvent;
begin
  event := TEvent.Create;
  event.Title := 'BWIntegrator.' + config.Service + '.' + exceptionPoint + ': ' + exceptionClass;
  event.Text := exceptionMsg;
  event.Priority := epLow;
  event.AlertType := eatError;

  statsdClient.RecordEvent(event, TTags.Create('source:delphi', 'hostname:' + config.Hostname, 'os:' + config.OS, 'service:' + config.Service, eTags, config.CTags));
  event.Free;
end;

end.

