unit bwStatsdClientSender;

interface

type
  IStatsdClientSender = interface(IInterface)
    procedure Send(Content: String);
  end;

implementation

end.

