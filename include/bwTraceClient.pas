unit bwTraceClient;

interface

uses
  System.Classes,
//  bwAPIClient,
  bwConfigFileHandler;

type
//  TTraceClient = class(TInterfacedObject, IAPIClient)
  TTraceClient = class(TObject)
  private
//    FSender: IDataDogStatsClientSender;
    procedure Send(const config: TConfigFile; const content: String);
  public
    constructor Create; overload;
    constructor Create(const config: TConfigFile); overload;
    destructor Destroy; override;
    procedure Execute(const config: TConfigFile; const traceName: String; const traceId, parentId: Integer; const traceValue, timestamp: Int64; const exceptObject: TObject);
  end;

implementation

uses
  System.SysUtils,
//  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetConsts;

var
  tTags: String;

{ TTraceClient }

constructor TTraceClient.Create;
begin
  inherited Create;
end;

constructor TTraceClient.Create(const config: TConfigFile);
var
  token: TStringList;
  i: Integer;
begin
  token := TStringList.Create;
  tTags := '';

  try
    if config.TTags <> EmptyStr then
    begin
      token.Clear;
      ExtractStrings([','], [], PChar(config.TTags), token);

      for i := 0 to token.Count - 1 do
        if token[i] <> EmptyStr then
          tTags := tTags + '"' + token[i] + '", ';

      tTags := Copy(tTags, 1, tTags.Length - 2);
      tTags := StringReplace(tTags, ':', '": "', [rfReplaceAll]);
      tTags := ', ' + tTags;
    end;
  finally
    token.Free;
  end;
end;

destructor TTraceClient.Destroy;
begin
  inherited;
end;

//procedure TTraceClient.Send(const config: TConfigFile; const content: String);
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
////      responseContent := httpClient.Post(config.TEndpoint, requestContent);
//      httpClient.Post(config.TEndpoint, requestContent);
//    finally
//      requestContent.Free;
//    end;
//  finally
//    httpClient.Free;
//  end;
//end;

procedure TTraceClient.Send(const config: TConfigFile; const content: String);
var
  HttpClient: THTTPClient;
  RequestContent: TStringStream;
//  ResponseContent: String;
//  tempFile: TextFile;
begin
  HttpClient := THTTPClient.Create;
  try
    HttpClient.Accept := 'application/json';
    HttpClient.ContentType := 'application/json';
    HttpClient.CustomHeaders['DD-API-KEY'] := config.ApiKey;

//    // TODO: ***** Retirar - Apenas para teste
//    assignfile(tempFile, 'C:\Users\\Alisson Tomé\\Desktop\\Content.dat');
//    append(tempFile);
//    writeln(tempFile, content);
//    closefile(tempFile);

    RequestContent := TStringStream.Create(content, TEncoding.UTF8);
    try
//      ResponseContent := HttpClient.Post(config.TEndpoint, RequestContent).ContentAsString();
      HttpClient.Post(config.TEndpoint, RequestContent);
    finally
      RequestContent.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

procedure TTraceClient.Execute(const config: TConfigFile; const traceName: String; const traceId, parentId: Integer; const traceValue, timestamp: Int64; const exceptObject: TObject);
var
  token: TStringList;
  cTags: String;
  strUnit: String;
  strClass: String;
  strMethod: String;
  content: String;
  i: Integer;
  exceptionClass: String;
  exceptionMsg: String;
begin
  token := TStringList.Create;
  cTags := '';

  try
    token.Clear;
    ExtractStrings(['.'], [], PChar(traceName), token);
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
  begin
    cTags := StringReplace(config.cTags, ':', '": "', [rfReplaceAll]);
    cTags := ', ' + cTags;
  end;

  if exceptObject = nil then
  begin
    content := '[[{' +
      '"duration": ' + IntToStr(traceValue) + ', ' +
      '"error": 0, ' +
      '"meta": {' +
//        '"env": "devel", ' +
//        '"source": "Delphi", ' +
        '"language": "delphi", ' +
        '"http.method": "' + 'POST' + '", ' +
        '"http.status_code": "' + '200' + '", ' +
        '"network.host.name": "' + config.Hostname + '", ' +
        '"network.destination.name": "' + config.Hostname + '", ' +
        '"network.destination.port": "' + IntToStr(8126) + '", ' +
        '"network.destination.transport": "' + 'REST' + '", ' +
        '"os": "' + config.OS + '", ' +
        '"unit": "' + strUnit + '", ' +
        '"class": "' + strClass + '", ' +
        '"method": "' + strMethod + '"' +
        tTags + // acrescenta mais tags pelo arquivo .ini
        cTags + // acrescenta mais tags pelo envio da aplicação
      '}, ' +
      '"name": "' + traceName + '", ' +
//      '"name": "' + {'BWIntegrator.' +} config.Service + '", ' +
      '"parent_id": ' + IntToStr(parentId) + ', ' +
      '"resource": "' + traceName + '", ' +
      '"service": "' + config.Service + '", ' +
      '"span_id": ' + IntToStr(Random(999999)) + ', ' +
      '"start": ' + IntToStr(timestamp) + ', ' +
      '"trace_id": ' + IntToStr(traceId) + ', ' +
      '"type": "custom"' +
    '}]]';
  end
  else
  begin
    exceptionClass := Exception(ExceptObject).ClassName;
    exceptionMsg := Exception(ExceptObject).Message;

    content := '[[{' +
      '"duration": ' + IntToStr(traceValue) + ', ' +
      '"error": 1, ' +
      '"meta": {' +
//        '"env": "devel", ' +
//        '"source": "Delphi", ' +
        '"language": "delphi", ' +
        '"error.type": "' + exceptionClass + '", ' +
        '"error.message": "' + exceptionMsg + '", ' +
        '"error.stack": "' + 'BWIntegrator.' + config.Service + '.' + traceName + '", ' +
        '"http.method": "' + 'POST' + '", ' +
        '"http.status_code": "' + '400' + '", ' +
        '"network.host.name": "' + config.Hostname + '", ' +
        '"network.destination.name": "' + config.Hostname + '", ' +
        '"network.destination.port": "' + IntToStr(8126) + '", ' +
        '"network.destination.transport": "' + 'REST' + '", ' +
        '"os": "' + config.OS + '", ' +
        '"unit": "' + strUnit + '", ' +
        '"class": "' + strClass + '", ' +
        '"method": "' + strMethod + '"' +
        tTags + // acrescenta mais tags pelo arquivo .ini
        cTags + // acrescenta mais tags pelo envio da aplicação
      '}, ' +
      '"name": "' + traceName + '", ' +
//      '"name": "' + {'BWIntegrator.' +} config.Service + '", ' +
      '"parent_id": ' + IntToStr(parentId) + ', ' +
      '"resource": "' + traceName + '", ' +
      '"service": "' + config.Service + '", ' +
      '"span_id": ' + IntToStr(Random(999999)) + ', ' +
      '"start": ' + IntToStr(timestamp) + ', ' +
      '"trace_id": ' + IntToStr(traceId) + ', ' +
      '"type": "custom"' +
    '}]]';
  end;

  Send(config, content);
end;

end.

