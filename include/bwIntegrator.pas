{$R-,C-,Q-,O+,H+}

unit bwIntegrator;

interface
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}

uses
  System.Classes,
  System.Generics.Collections;

procedure IntegratorEnterProcess(const procId: Integer);
procedure IntegratorExitProcess(const procId: Integer);
procedure IntegratorHandleException(const procId: Integer; const exceptObject: TObject);
procedure IntegratorSendLogMessage(const msg: String);
procedure IntegratorSendCustomTags(const tags: String);
procedure IntegratorSendEnableSign(const sign: Boolean);

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.IniFiles,
  System.StrUtils,
  TlHelp32,
  Vcl.Forms,
  Winapi.Windows,
//  System.NetEncoding,
  bwTraceClient,
  bwAPIMetricClient,
  bwAPIEventClient,
  bwAPILogClient,
  bwAPIExceptionClient,
  bwStatsdMetricClient,
  bwStatsdEventClient,
  bwStatsdLogClient,
  bwStatsdExceptionClient,
  bwProcessHandler,
  bwConfigFileHandler;

var
  process: TProcess;
  config: TConfigFile;
  traceClient: TTraceClient;
  apiMetricClient: TAPIMetricClient;
  apiEventClient: TAPIEventClient;
  apiExceptionClient: TAPIExceptionClient;
//  apiLogClient: TAPILogClient;
  statsdMetricClient: TStatsdMetricClient;
  statsdEventClient: TStatsdEventClient;
  statsdExceptionClient: TStatsdExceptionClient;
//  statsdLogClient: TStatsdLogClient; // StatsD nao manda logs
  stack: TStack<Integer>;

procedure IntegratorEnterProcess(const procId: Integer);
var
  index: Integer;
begin
  if process.Enabled then
  begin
    index := process.Id.IndexOf(procId);
    process.StartTime[index] := 0;
    process.StopTime[index] := 0;
    process.Timestamp[index] := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now));

    if procId > 0 then
    begin
      // Inicio do calculo do tempo de execucao
      process.StartTime[index] := MillisecondOfTheDay(Now);

//      // TODO: ***** Retirar - Apenas para teste
//      Sleep(Random(100));

      // Insercao do identificador na pilha
      if config.TEnabled then
        stack.Push(procId);
    end;
  end;
end;

procedure IntegratorExitProcess(const procId: Integer);
var
  index: Integer;
  childId: Integer;
  parentId: Integer;
begin
  if process.Enabled then
  begin
    if procId > 0 then
    begin
      index := process.Id.IndexOf(procId);
      // Termino do calculo do tempo de execucao
      process.StopTime[index] := MillisecondOfTheDay(Now);

      // Envio por traces
      if config.TEnabled then
      begin
        if stack.Count = 1 then
          parentId := 0
        else
        begin
          childId := stack.Pop;
          parentId := stack.Peek;
          stack.Push(childId);
        end;

        traceClient.Execute(config, process.Name[index], process.Id[index], parentId, process.StopTime[index] - process.StartTime[index], process.Timestamp[index], nil);

        // Remocao do identificador da pilha
        stack.Pop;
      end
      else // envio por metricas
      begin
        // Envio das metricas via API
        if config.MIntegrationType = 'api' then
        begin
          try
            TThread.CreateAnonymousThread(
              procedure
              begin
                apiMetricClient.Execute(config, process.Name[index], 'count', 1, process.Timestamp[index]);
              end).Start;

            TThread.CreateAnonymousThread(
              procedure
              begin
                apiMetricClient.Execute(config, process.Name[index], 'time', process.StopTime[index] - process.StartTime[index], process.Timestamp[index]);
              end).Start;
          except
            on e: Exception do
              apiExceptionClient.Execute(config, process.Name[index], e);
          end;
        end;

        // Envio das metricas via statsD
        if config.MIntegrationType = 'statsd' then
        begin
            statsdMetricClient.Execute(config, process.Name[index], 'count', 1, process.Timestamp[index]);
            statsdMetricClient.Execute(config, process.Name[index], 'time', process.StopTime[index] - process.StartTime[index], process.Timestamp[index]);
        end;
      end;
    end;
  end;
end;

procedure IntegratorHandleException(const procId: Integer; const exceptObject: TObject);
var
  index: Integer;
  childId: Integer;
  parentId: Integer;
begin
  if process.Enabled then
  begin
    if procId > 0 then
    begin
      index := process.Id.IndexOf(procId);

      // Envio por traces
      if config.TEnabled then
      begin
        if stack.Count = 1 then
          parentId := 0
        else
        begin
          childId := stack.Pop;
          parentId := stack.Peek;
          stack.Push(childId);
        end;

        traceClient.Execute(config, process.Name[index], process.Id[index], parentId, process.StopTime[index] - process.StartTime[index], process.Timestamp[index], exceptObject);

        // Remocao do identificador da pilha
        stack.Pop;
      end
      else // envio por metricas
      begin
        if config.MIntegrationType = 'api' then // envio via API
          apiExceptionClient.Execute(config, process.Name[index], exceptObject);
        if config.MIntegrationType = 'statsd' then // envio via statsD
          statsdExceptionClient.Execute(config, process.Name[index], exceptObject);
      end;
    end;
  end;
end;

procedure IntegratorSendLogMessage(const msg: String);
//var
//  callMessage: String;
begin
//  if process.InstrumentationEnabled then
//  begin
//    // TODO: *****
//    callMessage := 'IntegratorSendMessage' + ';;;' + msg;
//    CallResource(callMessage);
//  end;
end;

procedure IntegratorSendCustomTags(const tags: String);
var
  token: TStringList;
  cTags: String;
  i: Integer;
begin
  token := TStringList.Create;
  cTags := '';

  try
    if tags <> EmptyStr then
    begin
      token.Clear;
      ExtractStrings([','], [], PChar(tags), token);

      for i := 0 to token.Count - 1 do
        if token[i] <> EmptyStr then
          cTags := cTags + '"' + token[i] + '", ';

      cTags := Copy(cTags, 1, cTags.Length - 2);
    end;

    config.CTags := cTags;
  finally
    token.Free;
  end;
end;

procedure IntegratorSendEnableSign(const sign: Boolean);
begin
  process.Enabled := sign;
end;

procedure Initialize;
begin
  process := TProcess.Create;
  config := TConfigFile.Create;
  traceClient := TTraceClient.Create(config);
  apiMetricClient := TAPIMetricClient.Create(config);
  apiEventClient := TAPIEventClient.Create(config);
  apiExceptionClient := TAPIExceptionClient.Create;
//  apiLogClient := TAPILogClient.Create(config);
  statsdMetricClient := TStatsdMetricClient.Create(config);
  statsdEventClient := TStatsdEventClient.Create(config);
  statsdExceptionClient := TStatsdExceptionClient.Create;
//  statsdLogClient := TStatsdLogClient.Create; // StatsD nao manda logs
  stack := TStack<Integer>.Create;
  Randomize;
end;

procedure Finalize;
begin
  stack.Free;
  traceClient.Destroy;
  apiMetricClient.Destroy;
  apiEventClient.Destroy;
  apiExceptionClient.Destroy;
//  apiLogClient.Destroy;
  statsdMetricClient.Destroy;
  statsdEventClient.Destroy;
  statsdExceptionClient.Destroy;
//  statsdLogClient.Destroy; // StatsD nao manda logs
  config.Destroy;
  process.Destroy;
end;

function getCurrentModulePath: String;
var
  buffer: array [0..255] of Char;
begin
  GetModuleFileName(HInstance, buffer, 256);
  result := buffer;
end;

function getCurrentModuleName: String;
begin
  result := getCurrentModulePath;
  result := ChangeFileExt(ExtractFileName(result), '');
end;

procedure LoadProcess;
var
//  Base64: TBase64Encoding;
  fTxt: TextFile;
  fileName: String;
  text: String;
begin
  fileName := ExtractFilePath(getCurrentModulePath) + 'bwIntegrator.gpt';
  try
    if not FileExists(fileName) then
      // TODO: Colocar uma caixa de dialogo informando
      raise EFileNotFoundException.Create('Arquivo de instrumentacao "' + fileName + '" nao encontrado.')
    else
    begin
      try
        assignfile(fTxt, fileName);
        reset(fTxt);
        while not Eof(fTxt) do
        begin
          readln(fTxt, text);
          process.Id.Add(StrToInt(text));
          readln(fTxt, text);
          process.Name.Add(text);
          process.StartTime.Add(0);
          process.StopTime.Add(0);
          process.Timestamp.Add(0);
        end;
{
        Base64 := TBase64Encoding.Create(0);
        assignfile(fTxt, fileName);
        reset(fTxt);
        while not Eof(fTxt) do
        begin
          readln(fTxt, text);
//          process.Id.Add(StrToInt(Base64.Decode(Base64.Decode(Base64.Decode(UTF8Decode(text))))));
//          process.Id.Add(StrToInt(UTF8Decode(Base64.Decode(Base64.Decode(Base64.Decode(text))))));
          process.Id.Add(StrToInt(Base64.Decode(Base64.Decode(Base64.Decode(text)))));
          readln(fTxt, text);
//          process.Name.Add(Base64.Decode(Base64.Decode(Base64.Decode(UTF8Decode(text)))));
//          process.Name.Add(UTF8Decode(Base64.Decode(Base64.Decode(Base64.Decode(text)))));
          process.Name.Add(Base64.Decode(Base64.Decode(Base64.Decode(text))));
          process.StartTime.Add(0);
          process.StopTime.Add(0);
          process.Timestamp.Add(0);
        end;
}
      finally
        closefile(fTxt);
      end;
    end;
  except
    on e: Exception do
    begin
      // Capturar e tratar eventuais excecoes
      if config.MIntegrationType = 'api' then // envio via API
        apiExceptionClient.Execute(config, 'BWIntegrator.bwIntegrator.LoadProcess', e);
      if config.MIntegrationType = 'statsd' then // envio via statsD
        statsdExceptionClient.Execute(config, 'BWIntegrator.bwIntegrator.LoadProcess', e);
      // Abortar a execucao, nao pode ser continuada sem os dados
      Application.Terminate;
    end;
  end;
end;

initialization
  // Criar as estruturas utilizadas
  Initialize;
  // Carregar os objetos indexados pela instrumentacao previa
  LoadProcess;

finalization
  // Liberar as estruturas utilizadas
  Finalize;

end.

