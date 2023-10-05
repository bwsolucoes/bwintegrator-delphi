program Windows10CRMDemo;

uses
  Vcl.Forms,
  uDataMod in 'uDataMod.pas' {DM: TDataModule},
  uMainForm in 'uMainForm.pas' {MainForm},
  uLeads in 'uLeads.pas' {LeadsForm},
  uDraftProposal in 'uDraftProposal.pas' {DraftProposalForm},
  uProposal in 'uProposal.pas' {ProposalForm},
  Vcl.Themes,
  Vcl.Styles,
  bwAPIEventClient in '..\include\bwAPIEventClient.pas',
  bwAPIExceptionClient in '..\include\bwAPIExceptionClient.pas',
  bwAPILogClient in '..\include\bwAPILogClient.pas',
  bwAPIMetricClient in '..\include\bwAPIMetricClient.pas',
  bwConfigFileHandler in '..\include\bwConfigFileHandler.pas',
  bwIntegrator in '..\include\bwIntegrator.pas',
  bwProcessHandler in '..\include\bwProcessHandler.pas',
  bwStatsdClient in '..\include\bwStatsdClient.pas',
  bwStatsdClientImpl in '..\include\bwStatsdClientImpl.pas',
  bwStatsdClientSender in '..\include\bwStatsdClientSender.pas',
  bwStatsdClientSenderImpl in '..\include\bwStatsdClientSenderImpl.pas',
  bwStatsdEvent in '..\include\bwStatsdEvent.pas',
  bwStatsdEventClient in '..\include\bwStatsdEventClient.pas',
  bwStatsdExceptionClient in '..\include\bwStatsdExceptionClient.pas',
  bwStatsdLogClient in '..\include\bwStatsdLogClient.pas',
  bwStatsdMetricClient in '..\include\bwStatsdMetricClient.pas',
  bwStatsdService in '..\include\bwStatsdService.pas',
  bwStatsdType in '..\include\bwStatsdType.pas',
  bwStatsdUtil in '..\include\bwStatsdUtil.pas',
  bwTraceClient in '..\include\bwTraceClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Randomize;
  IntegratorSendCustomTags('appName:Demo,appVersion:1.0-SNAPSHOT,clientId:198423');
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Blue');
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDraftProposalForm, DraftProposalForm);
  Application.CreateForm(TProposalForm, ProposalForm);
  Application.CreateForm(TLeadsForm, LeadsForm);
  Application.Run;
end.
