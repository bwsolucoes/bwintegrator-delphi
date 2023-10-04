unit bwAPILogClient;

interface

uses
  System.Classes,
//  bwAPIClient,
  bwConfigFileHandler;

type
//  TAPILogClient = class(TInterfacedObject, IAPIClient)
  TAPILogClient = class(TObject)
  private
//    FSender: IDataDogStatsClientSender;
    procedure Send(const config: TConfigFile; const content: String);
  public
    constructor Create; overload;
    constructor Create(const config: TConfigFile); overload;
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

var
  lTags: String;
  cTags: String;

{ TAPILogClient }

constructor TAPILogClient.Create;
begin
  inherited Create;
end;

constructor TAPILogClient.Create(const config: TConfigFile);
var
  token: TStringList;
  i: Integer;
begin
  token := TStringList.Create;
  lTags := '';
  cTags := '';

  try
    if config.LTags <> EmptyStr then
    begin
      token.Clear;
      ExtractStrings([','], [], PChar(config.LTags), token);

      for i := 0 to token.Count - 1 do
        if token[i] <> EmptyStr then
          lTags := lTags + '"' + token[i] + '", ';

      lTags := Copy(lTags, 1, lTags.Length - 2);
      lTags := ', ' + lTags;
    end;

    if config.CTags <> EmptyStr then
      cTags := ', ' + config.CTags;
  finally
    token.Free;
  end;
end;

destructor TAPILogClient.Destroy;
begin
  inherited;
end;

//procedure TAPILogClient.Send(const config: TConfigFile; const content: String);
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

procedure TAPILogClient.Send(const config: TConfigFile; const content: String);
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

procedure TAPILogClient.Execute(const config: TConfigFile);
var
  content: String;
  line: String;
  cTags: String;
begin
  line := StringReplace(line, '\', '\\', [rfReplaceAll]);
  line := StringReplace(line, '"', '\"', [rfReplaceAll]);

  content := '[{' +
    '"ddsource": "delphi", ' +
    '"hostname": "' + config.Hostname + '", ' +
    '"os": "' + config.OS + '", ' +
    '"service": "' + 'BWIntegrator.' + config.Service + '", ' +
    '"message": "' + line + '", ' +
    '"ddtags": ' +

      // *****TODO: Precisa tratar isso, tá errado (")
      config.LTags + // acrescenta mais tags pelo arquivo .ini
      lTags + // acrescenta mais tags pelo arquivo .ini
      config.CTags + // acrescenta mais tags pelo envio da aplicação
      cTags + // acrescenta mais tags pelo envio da aplicação
  '}]';

  Send(config, content);
end;

//procedure TAPILogClient.ReadLogFile(const config: TConfigFile);
//var
//  fileStream: TFileStream;
//  streamReader: TStreamReader;
//  lastPosition: Int64;
//  changeNotification: THandle;
//  changeEvents: array [0..1] of THandle;
//begin
//  try
//    if not FileExists(config.LogFile) then
//    begin
//      // TODO: Colocar uma caixa de dialogo informando
//      raise EFileNotFoundException.Create('Arquivo de logs "' + config.LogFile + '" não encontrado.')
//    end;
//  except
//    on e: Exception do
//    begin
////      Exit;
//      // Capturar e tratar eventuais excecoes
//      apiExceptionClient.Execute(config, 'BWIntegrator.bwLogHandler.ReadLogsFile', e);
//      raise e;
////      // Abortar a execucao, nao pode ser continuada sem os dados
////      Application.Terminate;
//    end;
//  end;
//
//  // Envio dos logs via API
//  if config.MIntegrationType = 'api' then
//  begin
//    changeNotification := FindFirstChangeNotification(PChar(ExtractFilePath(config.LogFile)), False,
//      FILE_NOTIFY_CHANGE_LAST_WRITE);
//    changeEvents[0] := changeNotification;
//    changeEvents[1] := CreateEvent(nil, False, False, nil);
//
//    try
//      fileStream := TFileStream.Create(config.LogFile, fmOpenRead or fmShareDenyNone);
//      lastPosition := fileStream.Size;
//      try
//        fileStream.Seek(lastPosition, TSeekOrigin.soBeginning);
//        streamReader := TStreamReader.Create(fileStream);
//        try
//          while not streamReader.EndOfStream do
//          begin
//            line := streamReader.ReadLine;
//            if (line <> EmptyStr) then
//              Execute(config);
//          end;
//        finally
//          streamReader.Free;
//        end;
//      finally
//        fileStream.Free;
//      end;
//
//      while True do
//      begin
//        case WaitForMultipleObjects(2, @changeEvents, False, INFINITE) of
//          WAIT_OBJECT_0:
//          begin
//            if FindNextChangeNotification(changeNotification) then
//            begin
//              fileStream := TFileStream.Create(config.LogFile, fmOpenRead or fmShareDenyNone);
//              try
//                fileStream.Seek(lastPosition, TSeekOrigin.soBeginning);
//                streamReader := TStreamReader.Create(fileStream);
//                try
//                  while not streamReader.EndOfStream do
//                  begin
//                    line := streamReader.ReadLine;
//                    if (line <> EmptyStr) then
//                      Execute(config);
//                  end;
//                finally
//                  streamReader.Free;
//                end;
//              finally
//                fileStream.Free;
//              end;
//              lastPosition := fileStream.Size;
//            end;
//          end;
//          WAIT_OBJECT_0 + 1:
//            Break;
//        end;
//      end;
//    finally
//      FindCloseChangeNotification(changeNotification);
//      CloseHandle(changeEvents[1]);
//    end;
//  end;
//
//  // Envio dos logs via statsD
//  if config.MIntegrationType = 'statsd' then
//  begin
//    // TODO
//  end;
//end;

end.

