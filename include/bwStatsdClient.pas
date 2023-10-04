unit bwStatsdClient;

interface

uses
  bwStatsdType,
//  bwStatsdService,
  bwStatsdEvent;

type
  IStatsdClient = interface(IInterface)
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
    function GetPrefix: String;
    procedure SetPrefix(value: String);
  end;

implementation

end.

