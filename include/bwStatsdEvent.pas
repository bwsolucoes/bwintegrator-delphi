unit bwStatsdEvent;

interface

uses
	bwStatsdType;

type
  TEvent = class(TObject)
  private
    FTitle: String;
    FText: String;
    FMillisSinceEpoch: Int64;
    FHostName: String;
    FAggregationKey: String;
    FPriority: TEventPriority;
    FSourceTypeName: String;
    FAlertType: TEventAlertType;
  public
    function ToMap: String;
    property Title: String read FTitle write FTitle;
    property Text: String read FText write FText;
    property MillisSinceEpoch: Int64 read FMillisSinceEpoch write FMillisSinceEpoch;
    property HostName: String read FHostName write FHostName;
    property AggregationKey: String read FAggregationKey write FAggregationKey;
    property Priority: TEventPriority read FPriority write FPriority;
    property SourceTypeName: String read FSourceTypeName write FSourceTypeName;
    property AlertType: TEventAlertType read FAlertType write FAlertType;
  end;

implementation

uses
	System.SysUtils,
  bwStatsdUtil;

{ TEvent }

function TEvent.ToMap: String;
var
  mapParams: TStringBuilder;
  doubleResult: Double;
  priorityText: String;
  alertText: String;
begin
  mapParams := TStringBuilder.Create;

  try
    if (MillisSinceEpoch <> 0) then
    begin
      doubleResult := MillisSinceEpoch / 1000;
      mapParams.Append('|d:').Append(doubleResult);
    end;

    if (HostName <> EmptyStr) then
      mapParams.Append('|h:').Append(HostName);

    if (AggregationKey <> EmptyStr) then
      mapParams.Append('|k:').Append(AggregationKey);

    priorityText := DataTagsEventPriorityToText(Priority);

    if (priorityText <> EmptyStr) then
      mapParams.Append('|p:').Append(priorityText);

    alertText := DataTagsEventAlertToText(AlertType);

    if (alertText <> EmptyStr) then
      mapParams.Append('|t:').Append(alertText);

    result := mapParams.ToString;
  finally
    mapParams.Free;
  end;
end;

end.

