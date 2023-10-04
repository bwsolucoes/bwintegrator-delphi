unit bwAPIEventClient;

interface

uses
  System.Classes,
//  bwAPIClient,
  bwConfigFileHandler;

type
//  TAPIEventClient = class(TInterfacedObject, IAPIClient)
  TAPIEventClient = class(TObject)
  private
//    FSender: IDataDogStatsClientSender;
    procedure Send(const config: TConfigFile; const content: String);
  public
    constructor Create; overload;
    constructor Create(const config: TConfigFile); overload;
    destructor Destroy; override;
    procedure Execute(const config: TConfigFile; const exceptionPoint, exceptionClass, exceptionMsg: String);
  end;

implementation

uses
  System.SysUtils,
//  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetConsts;

var
  eTags: String;

{ TAPIEventClient }

constructor TAPIEventClient.Create;
begin
  inherited Create;
end;

constructor TAPIEventClient.Create(const config: TConfigFile);
var
  token: TStringList;
  i: Integer;
begin
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
      eTags := ', ' + eTags;
    end;
  finally
    token.Free;
  end;
end;

destructor TAPIEventClient.Destroy;
begin
  inherited;
end;

//procedure TAPIEventClient.Send(const config: TConfigFile; const content: String);
//var
//  httpClient: TIdHTTP;
//  requestContent: TStringStream;
////  responseContent: String;
//begin
//  httpClient := TIdHTTP.Create(nil);
//  try
//    httpClient.Request.Accept := 'application/json';
//    httpClient.Request.ContentType := 'application/json';
//    httpClient.Request.CustomHeaders.AddValue('DD-API-KEY', config.ApiKey);
//
//    requestContent := TStringStream.Create(content, TEncoding.UTF8);
//    try
////      responseContent := httpClient.Post(config.EEndpoint, requestContent);
//      httpClient.Post(config.EEndpoint, requestContent);
//    finally
//      requestContent.Free;
//    end;
//  finally
//    httpClient.Free;
//  end;
//end;

procedure TAPIEventClient.Send(const config: TConfigFile; const content: String);
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
//      ResponseContent := HttpClient.Post(config.EEndpoint, RequestContent).ContentAsString();
      HttpClient.Post(config.EEndpoint, RequestContent);
    finally
      RequestContent.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

procedure TAPIEventClient.Execute(const config: TConfigFile; const exceptionPoint, exceptionClass, exceptionMsg: String);
var
  content: String;
  cTags: String;
begin
  cTags := '';

  if config.CTags <> EmptyStr then
    cTags := ', ' + config.cTags;

  content := '{' +
    '"title": "BWIntegrator.' + config.Service + '.' + exceptionPoint + ': ' + exceptionClass + '", ' +
    '"text": "' + exceptionMsg + '", ' +
    '"tags": [' +
      '"source:delphi", ' +
      '"hostname:' + config.Hostname + '", ' +
      '"os:' + config.OS + '", ' +
      '"service:' + config.Service + '"' +
      eTags + // acrescenta mais tags pelo arquivo .ini
      cTags + // acrescenta mais tags pelo envio da aplicação
    ']' +
  '}';

  Send(config, content);
end;

end.

