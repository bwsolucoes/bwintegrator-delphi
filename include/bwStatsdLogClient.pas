unit bwStatsdLogClient;

interface

uses
  System.Classes,
//  bwStatsdClient,
  bwConfigFileHandler;

type
//  TStatsdLogClient = class(TInterfacedObject, IStatsdClient)
  TStatsdLogClient = class(TObject)
  private
//    FSender: IDataDogStatsClientSender;
    procedure Send(const config: TConfigFile; const content: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(const config: TConfigFile);
//    procedure ReadLogFile(const config: TConfigFile);
  end;

implementation

uses
  System.SysUtils,
//  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetConsts,
  Vcl.Forms,
  Winapi.Windows;

{ TStatsdLogClient }

constructor TStatsdLogClient.Create;
begin
  inherited Create;
end;

destructor TStatsdLogClient.Destroy;
begin
  inherited;
end;

//procedure TStatsdLogClient.Send(const config: TConfigFile; const content: String);
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
////      responseContent := httpClient.Post(config.LEndpoint, requestContent);
//      httpClient.Post(config.LEndpoint, requestContent);
//    finally
//      requestContent.Free;
//    end;
//  finally
//    httpClient.Free;
//  end;
//end;

procedure TStatsdLogClient.Send(const config: TConfigFile; const content: String);
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
//      ResponseContent := HttpClient.Post(config.LEndpoint, RequestContent).ContentAsString();
      HttpClient.Post(config.LEndpoint, RequestContent);
    finally
      RequestContent.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

procedure TStatsdLogClient.Execute(const config: TConfigFile);
var
  content: String;
  line: String;
  cTags: String;
begin
  line := StringReplace(line, '\', '\\', [rfReplaceAll]);
  line := StringReplace(line, '"', '\"', [rfReplaceAll]);
  cTags := '';

  if config.CTags <> EmptyStr then
    cTags := ',' + config.CTags;

  content := '[{' +
    '"ddsource": "delphi", ' +
    '"hostname": "' + config.Hostname + '", ' +
    '"os": "' + config.OS + '", ' +
    '"service": "' + 'BWIntegrator.' + config.Service + '", ' +
    '"message": "' + line + '", ' +
    '"ddtags": ' +
      config.LTags + // acrescenta mais tags pelo arquivo .ini

      // *****TODO: Precisa tratar isso, tá errado (")
      config.CTags + '"' + // acrescenta mais tags pelo envio da aplicação
  '}]';

  Send(config, content);
end;

//procedure TStatsdLogClient.ReadLogFile(const config: TConfigFile);
//begin
//  //
//end;

end.

