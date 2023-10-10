unit bwConfigFileHandler;

interface

uses
  System.Classes;

type
  TConfigFile = class(TObject)
  private
    FApiKey: String;
    FTEnabled: Boolean;
    FTEndpoint: String;
    FTTags: String;
    FMIntegrationType: String;
    FMEndpoint: String;
    FMTags: String;
    FEIntegrationType: String;
    FEEndpoint: String;
    FETags: String;
    FLIntegrationType: String;
    FLEndpoint: String;
    FLTags: String;
    FHostname: String;
    FOS: String;
    FService: String;
    FCTags: String;
    function GetHostname: String;
    function GetOS: String;
    function GetService: String;
    procedure LoadConfigFile;
    function getCurrentModulePath: String;
    function getCurrentModuleName: String;
  public
    constructor Create;
    destructor Destroy; override;
    property ApiKey: String read FApiKey write FApiKey;
    property TEnabled: Boolean read FTEnabled write FTEnabled;
    property TEndpoint: String read FTEndpoint write FTEndpoint;
    property TTags: String read FTTags write FTTags;
    property MIntegrationType: String read FMIntegrationType write FMIntegrationType;
    property MEndpoint: String read FMEndpoint write FMEndpoint;
    property MTags: String read FMTags write FMTags;
    property EIntegrationType: String read FEIntegrationType write FEIntegrationType;
    property EEndpoint: String read FEEndpoint write FEEndpoint;
    property ETags: String read FETags write FETags;
    property LIntegrationType: String read FLIntegrationType write FLIntegrationType;
    property LEndpoint: String read FLEndpoint write FLEndpoint;
    property LTags: String read FLTags write FLTags;
    property Hostname: String read FHostname write FHostname;
    property OS: String read FOS write FOS;
    property Service: String read FService write FService;
    property CTags: String read FCTags write FCTags;
  end;

implementation

uses
  System.SysUtils,
  System.IniFiles,
  System.StrUtils,
  TlHelp32,
  Vcl.Forms,
  Winapi.Windows;

{ TConfigFile }

constructor TConfigFile.Create;
begin
  inherited Create;
  FHostname := GetHostname;
  FOS := GetOS;
  FService := GetService;
  // Carregar a configuracao inicial de traces, metricas, eventos e logs da aplicacao
  LoadConfigFile;
end;

destructor TConfigFile.Destroy;
begin
  inherited;
end;

function TConfigFile.GetHostname: String;
var
  buffer: array [0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  size: DWORD;
begin
  size := Length(buffer);
  if GetComputerName(buffer, size) then
    result := buffer
  else
    result := '';
end;

function TConfigFile.GetOS: String;
var
  buffer: String;
begin
  buffer := TOSVersion.ToString;
  if buffer <> '' then
    result := buffer
  else
    result := '';
end;

function TConfigFile.GetService: String;
begin
  result := ExtractFileName(ParamStr(0));
  result := ChangeFileExt(result, '');
end;

procedure TConfigFile.LoadConfigFile;
var
  auxTag: String;
  ini: String;
  i: Integer;
begin
  ini := ExtractFilePath(getCurrentModulePath) + 'bwIntegrator.ini';
  try
    if not FileExists(ini) then
      // TODO: Colocar uma caixa de dialogo informando
      raise EFileNotFoundException.Create('Arquivo de inicialização "' + ini + '" não encontrado.')
    else begin
      with TIniFile.Create(ini) do
      begin
        try
          ApiKey := ReadString('General', 'ApiKey', '');
          TEnabled := ReadBool('Traces', 'Enabled', true);
          TEndpoint := StringReplace(ReadString('Traces', 'Endpoint', 'http://' + FHostname + ':8126/v0.3/traces'), 'hostname', FHostname, [rfReplaceAll]);
          auxTag := '';
          for i := 1 to 5 do
          begin
            auxTag := ReadString('Traces', 'Tag' + IntToStr(i), '');
            if auxTag <> '' then
              TTags := TTags + auxTag + ','
          end;
          TTags := Copy(FTTags, 1, FTTags.Length - 1);
          MIntegrationType := ReadString('Metrics', 'IntegrationType', 'api');
          MEndpoint := ReadString('Metrics', 'Endpoint', 'https://api.datadoghq.com/api/v2/series');
          auxTag := '';
          for i := 1 to 5 do
          begin
            auxTag := ReadString('Metrics', 'Tag' + IntToStr(i), '');
            if auxTag <> '' then
              MTags := MTags + auxTag + ','
          end;
          MTags := Copy(FMTags, 1, FMTags.Length - 1);
          EIntegrationType := ReadString('Events', 'IntegrationType', 'api');
          EEndpoint := ReadString('Events', 'Endpoint', 'https://api.datadoghq.com/api/v1/events');
          auxTag := '';
          for i := 1 to 5 do
          begin
            auxTag := ReadString('Events', 'Tag' + IntToStr(i), '');
            if auxTag <> '' then
              ETags := ETags + auxTag + ','
          end;
          ETags := Copy(FETags, 1, FETags.Length - 1);
          LIntegrationType := ReadString('Logs', 'IntegrationType', 'api');
          LEndpoint := ReadString('Logs', 'Endpoint', 'https://http-intake.logs.datadoghq.com/api/v2/logs');
          auxTag := '';
          for i := 1 to 5 do
          begin
            auxTag := ReadString('Logs', 'Tag' + IntToStr(i), '');
            if auxTag <> '' then
              LTags := LTags + auxTag + ',';
          end;
          LTags := Copy(FLTags, 1, FLTags.Length - 1);
        finally
          Free;
        end;
      end;
    end;
  except
    on e: Exception do
    begin
      // Abortar a execucao, nao pode ser continuada sem os dados
//      Application.Terminate;
    end;
  end;
end;

function TConfigFile.getCurrentModulePath: String;
var
  buffer: array [0..255] of Char;
begin
  GetModuleFileName(HInstance, buffer, 256);
  result := buffer;
end;

function TConfigFile.getCurrentModuleName: String;
begin
  result := getCurrentModulePath;
  result := ChangeFileExt(ExtractFileName(result), '');
end;

end.

