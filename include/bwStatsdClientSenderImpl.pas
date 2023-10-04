unit bwStatsdClientSenderImpl;

interface

uses
	System.SyncObjs,
  System.Classes,
  IdUDPClient,
	bwStatsdService,
  bwStatsdEvent,
  bwStatsdClientSender;

type
  TStatsdClientSender = class(TInterfacedObject, IStatsdClientSender)
  private

  type
    TThreadSender = class(TThread)
    private
      FUDPCom: TIdUDPClient;
      FRcMessages: TCriticalSection;
      FMessages: TStringList;
      FService: TStatsdService;
    protected
      procedure Execute; override;
      procedure SendMessages;
      procedure ConfigureUDP;
      function GetMessagesToSend: TStringList;
    public
      constructor Create(Service: TStatsdService);
      destructor Destroy; override;
      procedure Send(Content: String);
    end;

  private
    FSender: TThreadSender;
  public
    constructor Create(Service: TStatsdService);
    destructor Destroy; override;
    procedure Send(Content: String);
  end;

implementation

{ TStatsdClientSender }

constructor TStatsdClientSender.Create(Service: TStatsdService);
begin
  inherited Create;
  FSender := TThreadSender.Create(Service);
  FSender.Start;
end;

destructor TStatsdClientSender.Destroy;
begin
  FSender.Terminate;
  inherited;
end;

procedure TStatsdClientSender.Send(Content: string);
begin
  FSender.Send(Content);
end;

{ TStatsdClientSender.TThreadSender }

procedure TStatsdClientSender.TThreadSender.ConfigureUDP;
begin
  FUDPCom.Port := FService.Port;
  FUDPCom.Host := FService.Hostname;
end;

constructor TStatsdClientSender.TThreadSender.Create(Service: TStatsdService);
begin
  inherited Create(True);
  FreeOnTerminate := True;

  FRcMessages := TCriticalSection.Create;
  FService := Service;
  FMessages := TStringList.Create;
  FUDPCom := TIdUDPClient.Create(nil);
end;

destructor TStatsdClientSender.TThreadSender.Destroy;
begin
  FUDPCom.Free;
  FMessages.Free;
  FRcMessages.Free;
  inherited;
end;

procedure TStatsdClientSender.TThreadSender.Execute;
begin
  while not Terminated do
  begin
    if FMessages.Count > 0 then
      SendMessages;
    Sleep(500);
  end;
end;

function TStatsdClientSender.TThreadSender.GetMessagesToSend: TStringList;
begin
  FRcMessages.Acquire;
  try
    Result := FMessages;
    FMessages := TStringList.Create;
  finally
    FRcMessages.Release;
  end;
end;

procedure TStatsdClientSender.TThreadSender.Send(Content: string);
begin
  FRcMessages.Acquire;
  try
    FMessages.Add(Content);
  finally
    FRcMessages.Release;
  end;
end;

procedure TStatsdClientSender.TThreadSender.SendMessages;
var
  MessagensToSend: TStringList;
  MessageTxt: string;
begin
  ConfigureUDP;
  MessagensToSend := GetMessagesToSend;
  try
    for MessageTxt in MessagensToSend do
      FUDPCom.Send(MessageTxt);
  finally
    MessagensToSend.Free;
  end;
end;

end.

