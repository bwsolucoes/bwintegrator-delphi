unit bwStatsdUtil;

interface

uses
	bwStatsdType;

function DataTagsToText(tags: TTags): String;
function DataTagsEventPriorityToText(priority: TEventPriority): String;
function DataTagsEventAlertToText(alertType: TEventAlertType): String;
function EscapedMessage(title: String): String;

implementation

uses
	System.SysUtils;

function DataTagsToText(tags: TTags): String;
var
  tag: String;
begin
  result := '';

  if Length(tags) = 0 then
    Exit;

  for tag in tags do
  begin
    if result = EmptyStr then
      result := tag
    else
      result := result + ',' + tag
  end;

  result := '|#' + result;
end;

function DataTagsEventPriorityToText(priority: TEventPriority): String;
begin
  case priority of
    epLow:
      result := 'low';
    epNormal:
      result := 'normal';
  end;
end;

function DataTagsEventAlertToText(alertType: TEventAlertType): String;
begin
  case alertType of
    eatError:
      result := 'error';
    eatWarning:
      result := 'warning';
    eatInfo:
      result := 'info';
    eatSuccess:
      result := 'success';
    eatUndefined:
      result := '';
  end;
end;

function EscapedMessage(title: String): String;
begin
  result := StringReplace(title, '\n', '\\n', [rfReplaceAll]);
end;

end.

