unit bwStatsdType;

interface

type
  TTag = String;
  TAspect = String;
  TTags = TArray<TTag>;
  TEventPriority = (epLow, epNormal);
  TEventAlertType = (eatError, eatWarning, eatInfo, eatSuccess, eatUndefined);
  TServiceStatus = (ssOK = 0, ssWarning = 1, ssCritical = 2, ssUnknown = 3, ssUndefined = 4);

implementation

end.

