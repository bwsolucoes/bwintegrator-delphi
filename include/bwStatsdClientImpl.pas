unit bwStatsdClientImpl;

interface

uses
  bwStatsdType,
//  bwStatsdService,
  bwStatsdEvent,
	bwStatsdClient,
  bwStatsdClientSender;

type
  TStatsdClient = class(TInterfacedObject, IStatsdClient)
  private
    FPrefix: String;
    FSender: IStatsdClientSender;
    procedure Send(content: String);
    function IsInvalidSample(sample: Double): Boolean;
    function GetPrefix: String;
    procedure SetPrefix(value: String);
  public
    constructor Create(var sender: IStatsdClientSender);
    destructor Destroy; override;
    procedure Count(aspect: TAspect; delta: Int64; tags: TTags); overload;
    procedure Count(aspect: TAspect; delta: Int64; sampleRate: Double; tags: TTags); overload;
//    procedure IncrementCounter(aspect: TAspect; tags: TTags); overload;
//    procedure IncrementCounter(aspect: TAspect; sampleRate: Double; tags: TTags); overload;
//    procedure Increment(aspect: TAspect; tags: TTags); overload;
//    procedure Increment(aspect: TAspect; sampleRate: Double; tags: TTags); overload;
//    procedure DecrementCounter(aspect: TAspect; tags: TTags); overload;
//    procedure DecrementCounter(aspect: TAspect; sampleRate: Double; tags: TTags); overload;
//    procedure Decrement(aspect: TAspect; tags: TTags); overload;
//    procedure Decrement(aspect: TAspect; sampleRate: Double; tags: TTags); overload;
//    procedure RecordGaugeValue(aspect: TAspect; value: Double; tags: TTags); overload;
//    procedure RecordGaugeValue(aspect: TAspect; value: Double; sampleRate: Double; tags: TTags); overload;
//    procedure Gauge(aspect: TAspect; value: Double; tags: TTags); overload;
//    procedure Gauge(aspect: TAspect; value: Double; sampleRate: Double; tags: TTags); overload;
//    procedure RecordGaugeValue(aspect: TAspect; value: Int64; tags: TTags); overload;
//    procedure RecordGaugeValue(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags); overload;
//    procedure Gauge(aspect: TAspect; value: Int64; tags: TTags); overload;
//    procedure Gauge(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags); overload;
//    procedure RecordExecutionTime(aspect: TAspect; timeInMs: Int64; tags: TTags); overload;
//    procedure RecordExecutionTime(aspect: TAspect; timeInMs: Int64; sampleRate: Double; tags: TTags); overload;
//    procedure Time(aspect: TAspect; value: Int64; tags: TTags); overload;
//    procedure Time(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags); overload;
//    procedure RecordHistogramValue(aspect: TAspect; value: Double; tags: TTags); overload;
//    procedure RecordHistogramValue(aspect: TAspect; value: Double; sampleRate: Double; tags: TTags); overload;
//    procedure Histogram(aspect: TAspect; value: Double; tags: TTags); overload;
//    procedure Histogram(aspect: TAspect; value: Double; sampleRate: Double; tags: TTags); overload;
//    procedure RecordHistogramValue(aspect: TAspect; value: Int64; tags: TTags); overload;
//    procedure RecordHistogramValue(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags); overload;
//    procedure Histogram(aspect: TAspect; value: Int64; tags: TTags); overload;
//    procedure Histogram(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags); overload;
//    procedure RecordSetValue(aspect: TAspect; value: String; tags: TTags); overload;
    procedure RecordEvent(event: TEvent; tags: TTags); overload;
    property Prefix: String read GetPrefix write SetPrefix;
  end;

implementation

uses
	System.SysUtils,
  bwStatsdUtil;

//var
//  formatSettings: TFormatSettings;

{ TStatsdClient }

procedure TStatsdClient.Send(content: String);
begin
  FSender.Send(content);
end;

function TStatsdClient.IsInvalidSample(sample: Double): Boolean;
begin
  result := true;
end;

function TStatsdClient.GetPrefix: String;
begin
  result := FPrefix;
end;

procedure TStatsdClient.SetPrefix(value: String);
begin
  FPrefix := value;
end;

constructor TStatsdClient.Create(var sender: IStatsdClientSender);
begin
  FSender := sender;
end;

destructor TStatsdClient.Destroy;
begin
  inherited;
end;

procedure TStatsdClient.Count(aspect: TAspect; delta: Int64; tags: TTags);
begin
  Send(Format('%s%s:%d|c%s', [Prefix, aspect, delta, DataTagsToText(tags)]));
end;

procedure TStatsdClient.Count(aspect: TAspect; delta: Int64; sampleRate: Double; tags: TTags);
begin
	if not (IsInvalidSample(sampleRate)) then
    Exit;

  Send(Format('%s%s:%d|c|%f%s', [Prefix, aspect, delta, sampleRate, DataTagsToText(tags)]));
end;

//procedure TStatsdClient.IncrementCounter(aspect: TAspect; tags: TTags);
//begin
//  Count(aspect, 1, tags);
//end;
//
//procedure TStatsdClient.IncrementCounter(aspect: TAspect; sampleRate: Double; tags: TTags);
//begin
//  Count(aspect, 1, sampleRate, tags);
//end;
//
//procedure TStatsdClient.Increment(aspect: TAspect; tags: TTags);
//begin
//  IncrementCounter(aspect, tags);
//end;
//
//procedure TStatsdClient.Increment(aspect: TAspect; sampleRate: Double; tags: TTags);
//begin
//  IncrementCounter(aspect, sampleRate, tags);
//end;
//
//procedure TStatsdClient.DecrementCounter(aspect: TAspect; tags: TTags);
//begin
//  Count(aspect, -1, tags);
//end;
//
//procedure TStatsdClient.DecrementCounter(aspect: TAspect; sampleRate: Double; tags: TTags);
//begin
//  Count(aspect, -1, sampleRate, tags);
//end;
//
//procedure TStatsdClient.Decrement(aspect: TAspect; tags: TTags);
//begin
//  DecrementCounter(aspect, tags);
//end;
//
//procedure TStatsdClient.Decrement(aspect: TAspect; sampleRate: Double; tags: TTags);
//begin
//  DecrementCounter(aspect, sampleRate, tags);
//end;
//
//procedure TStatsdClient.RecordGaugeValue(aspect: TAspect; value: Double; tags: TTags);
//begin
//  Send(Format('%s%s:%s|g%s', [Prefix, aspect, FloatToStr(value, formatSettings), DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.RecordGaugeValue(aspect: TAspect; value: Double; sampleRate: Double; tags: TTags);
//begin
//  Send(Format('%s%s:%s|g|%f%s', [Prefix, aspect, FloatToStr(value, formatSettings), sampleRate, DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.Gauge(aspect: TAspect; value: Double; tags: TTags);
//begin
//  RecordGaugeValue(aspect, value, tags);
//end;
//
//procedure TStatsdClient.Gauge(aspect: TAspect; value: Double; sampleRate: Double; tags: TTags);
//begin
//  RecordGaugeValue(aspect, value, sampleRate, tags);
//end;
//
//procedure TStatsdClient.RecordGaugeValue(aspect: TAspect; value: Int64; tags: TTags);
//begin
//  Send(Format('%s%s:%d|g%s', [Prefix, aspect, value, DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.RecordGaugeValue(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags);
//begin
//  if not (IsInvalidSample(sampleRate)) then
//    Exit;
//
//  Send(Format('%s%s:%d|g|%f%s', [Prefix, aspect, value, sampleRate, DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.Gauge(aspect: TAspect; value: Int64; tags: TTags);
//begin
//  Send(Format('%s%s:%d|g%s', [Prefix, aspect, value, DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.Gauge(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags);
//begin
//  RecordGaugeValue(aspect, value, sampleRate, tags);
//end;
//
//procedure TStatsdClient.RecordExecutionTime(aspect: TAspect; timeInMs: Int64; tags: TTags);
//begin
//  Send(Format('%s%s:%d|ms%s', [Prefix, aspect, timeInMs, DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.RecordExecutionTime(aspect: TAspect; timeInMs: Int64; sampleRate: Double; tags: TTags);
//begin
//	if not (IsInvalidSample(sampleRate)) then
//    Exit;
//
//  Send(Format('%s%s:%d|ms|%f%s', [Prefix, aspect, timeInMs, sampleRate, DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.Time(aspect: TAspect; value: Int64; tags: TTags);
//begin
//  RecordExecutionTime(aspect, value, tags);
//end;
//
//procedure TStatsdClient.Time(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags);
//begin
//  RecordExecutionTime(aspect, value, sampleRate, tags);
//end;
//
//procedure TStatsdClient.RecordHistogramValue(aspect: TAspect; value: Double; tags: TTags);
//begin
//  Send(Format('%s%s:%s|h%s', [Prefix, aspect, FloatToStr(value, formatSettings), DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.RecordHistogramValue(aspect: TAspect; value: Double; sampleRate: Double; tags: TTags);
//begin
//  if (IsInvalidSample(sampleRate)) then
//    Exit;
//
//  Send(Format('%s%s:%s|h|%f%s', [Prefix, aspect, FloatToStr(value, formatSettings), sampleRate, DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.Histogram(aspect: TAspect; value: Double; tags: TTags);
//begin
//  RecordHistogramValue(aspect, value, tags);
//end;
//
//procedure TStatsdClient.Histogram(aspect: TAspect; value: Double; sampleRate: Double; tags: TTags);
//begin
//  RecordHistogramValue(aspect, value, sampleRate, tags);
//end;
//
//procedure TStatsdClient.RecordHistogramValue(aspect: TAspect; value: Int64; tags: TTags);
//begin
//  Send(Format('%s%s:%d|h%s', [Prefix, aspect, value, DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.RecordHistogramValue(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags);
//begin
//  if (isInvalidSample(sampleRate)) then
//    Exit;
//
//  Send(Format('%s%s:%d|h|%f%s', [Prefix, aspect, value, sampleRate, DataTagsToText(tags)]));
//end;
//
//procedure TStatsdClient.Histogram(aspect: TAspect; value: Int64; tags: TTags);
//begin
//  RecordHistogramValue(aspect, value, tags);
//end;
//
//procedure TStatsdClient.Histogram(aspect: TAspect; value: Int64; sampleRate: Double; tags: TTags);
//begin
//  RecordHistogramValue(aspect, value, sampleRate, tags);
//end;
//
//procedure TStatsdClient.RecordSetValue(aspect: TAspect; value: String; tags: TTags);
//begin
//  Send(Format('%s%s:%s|s%s', [Prefix, aspect, value, DataTagsToText(tags)]));
//end;

procedure TStatsdClient.RecordEvent(event: TEvent; tags: TTags);
var
  title: String;
  text: String;
begin
  title := EscapedMessage(Prefix + event.Title);
  text := EscapedMessage(event.Text);

  Send(Format('_e{%d,%d}:%s|%s%s%s', [title.Length, text.Length, title, text, event.ToMap, DataTagsToText(tags)]));
end;

end.

