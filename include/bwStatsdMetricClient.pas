unit bwStatsdMetricClient;

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
//  TStatsdMetricClient = class(TInterfacedObject, IStatsdClient)
  TStatsdMetricClient = class(TObject)
  private
//    FSender: IDataDogStatsClientSender;
//    procedure Send(const config: TConfigFile; const content: String);
  public
    constructor Create; overload;
    constructor Create(const config: TConfigFile); overload;
    destructor Destroy; override;
    procedure Execute(const config: TConfigFile; const metricName, metricType: String; const metricValue, timestamp: Int64);
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
  mTags: String;

{ TStatsdMetricClient }

constructor TStatsdMetricClient.Create;
begin
  inherited Create;
  service := TStatsdService.Create;
  statsdClientSender := TStatsdClientSender.Create(service);
  statsdClient := TStatsdClient.Create(statsdClientSender);
end;

constructor TStatsdMetricClient.Create(const config: TConfigFile);
var
  token: TStringList;
  i: Integer;
begin
  service := TStatsdService.Create;
  statsdClientSender := TStatsdClientSender.Create(service);
  statsdClient := TStatsdClient.Create(statsdClientSender);

  token := TStringList.Create;
  mTags := '';

  try
    if config.MTags <> EmptyStr then
    begin
      token.Clear;
      ExtractStrings([','], [], PChar(config.MTags), token);

      for i := 0 to token.Count - 1 do
        if token[i] <> EmptyStr then
          mTags := mTags + '"' + token[i] + '", ';

      mTags := Copy(mTags, 1, mTags.Length - 2);
    end;
  finally
    token.Free;
  end;
end;

destructor TStatsdMetricClient.Destroy;
begin
//  datadogService.Destroy;
  inherited;
end;

procedure TStatsdMetricClient.Execute(const config: TConfigFile; const metricName, metricType: String; const metricValue, timestamp: Int64);
var
  token: TStringList;
  strUnit: String;
  strClass: String;
  strMethod: String;
  i: Integer;
begin
  token := TStringList.Create;

  try
    token.Clear;
    ExtractStrings(['.'], [], PChar(metricName), token);
    for i := 0 to token.Count - 1 do
    begin
      case i of
        0: strUnit := token[i];
        1: strClass := token[i];
        2: strMethod := token[i];
      else
        break;
      end;
    end;
  finally
    token.Free;
  end;

  statsdClient.Count('BWIntegrator.' + metricType, metricValue, timestamp, TTags.Create('source:delphi', 'hostname:' + config.Hostname, 'os:' + config.OS, 'service:' + config.Service, 'unit:' + strUnit, 'class:' + strClass, 'method:' + strMethod, 'type:' + metricType, mTags, config.CTags));
end;

end.

