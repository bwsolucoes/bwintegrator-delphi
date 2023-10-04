unit bwAPIMetricClient;

interface

uses
  System.Classes,
//  bwAPIClient,
  bwConfigFileHandler;

type
//  TAPIMetricClient = class(TInterfacedObject, IAPIClient)
  TAPIMetricClient = class(TObject)
  private
//    FSender: IDataDogStatsClientSender;
    procedure Send(const config: TConfigFile; const content: String);
  public
    constructor Create; overload;
    constructor Create(const config: TConfigFile); overload;
    destructor Destroy; override;
    procedure Execute(const config: TConfigFile; const metricName, metricType: String; const metricValue, timestamp: Int64);
  end;

implementation

uses
  System.SysUtils,
//  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetConsts;

var
  mTags: String;

{ TAPIMetricClient }

constructor TAPIMetricClient.Create;
begin
  inherited Create;
end;

constructor TAPIMetricClient.Create(const config: TConfigFile);
var
  token: TStringList;
  i: Integer;
begin
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
      mTags := ', ' + mTags;
    end;
  finally
    token.Free;
  end;
end;

destructor TAPIMetricClient.Destroy;
begin
  inherited;
end;

//procedure TAPIMetricClient.Send(const config: TConfigFile; const content: String);
//var
//  httpClient: TIdHTTP;
//  requestContent: TStringStream;
////  responseContent: String;
//begin
//  httpClient := TIdHTTP.Create;
//  try
//    httpClient.Request.Accept := 'application/json';
//    httpClient.Request.ContentType := 'application/json';
//    httpClient.Request.CustomHeaders.AddValue('DD-API-KEY', config.ApiKey);
//
//    requestContent := TStringStream.Create(content, TEncoding.UTF8);
//    try
////      responseContent := httpClient.Post(config.MEndpoint, requestContent);
//      httpClient.Post(config.MEndpoint, requestContent);
//    finally
//      requestContent.Free;
//    end;
//  finally
//    httpClient.Free;
//  end;
//end;

procedure TAPIMetricClient.Send(const config: TConfigFile; const content: String);
var
  HttpClient: THTTPClient;
  RequestContent: TStringStream;
//  ResponseContent: String;
begin
  HttpClient := THTTPClient.Create;
  try
    HttpClient.Accept := 'application/json';
    HttpClient.ContentType := 'application/json';
    HttpClient.CustomHeaders['DD-API-KEY'] := config.ApiKey;

    RequestContent := TStringStream.Create(content, TEncoding.UTF8);
    try
//      ResponseContent := HttpClient.Post(config.MEndpoint, RequestContent).ContentAsString();
      HttpClient.Post(config.MEndpoint, RequestContent);
    finally
      RequestContent.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

procedure TAPIMetricClient.Execute(const config: TConfigFile; const metricName, metricType: String; const metricValue, timestamp: Int64);
var
  token: TStringList;
  cTags: String;
  strUnit: String;
  strClass: String;
  strMethod: String;
  content: String;
  i: Integer;
begin
  token := TStringList.Create;
  cTags := '';

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

  if config.CTags <> EmptyStr then
    cTags := ', ' + config.CTags;

  content := '{' +
    '"series": [' +
      '{' +
        '"metric": "' + 'BWIntegrator.' + metricType + '", ' +
        '"points": [' +
          '{' +
            '"timestamp": ' + IntToStr(timestamp) + ', ' +
            '"value": ' + IntToStr(metricValue) +
          '}' +
        '], ' +
        '"tags": [' +
          '"source:delphi", ' +
          '"hostname:' + config.Hostname + '", ' +
          '"os:' + config.OS + '", ' +
          '"service:' + config.Service + '", ' +
          '"unit:' + strUnit + '", ' +
          '"class:' + strClass + '", ' +
          '"method:' + strMethod + '", ' +
          '"type:' + metricType + '"' +
          mTags + // acrescenta mais tags pelo arquivo .ini
          cTags + // acrescenta mais tags pelo envio da aplicação
        '], ' +
        '"type": 1, ' +
        '"interval": 1' +
      '}' +
    ']' +
  '}';

  Send(config, content);
end;

end.

