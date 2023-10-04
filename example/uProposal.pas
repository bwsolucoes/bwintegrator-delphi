unit uProposal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw,
  Data.Bind.Controls, Vcl.Buttons, Vcl.Bind.Navigator, Vcl.Grids, Vcl.WinXCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.WinXPanels;

type
  TProposalForm = class(TForm)
    WebBrowser: TWebBrowser;
    NavPanel: TPanel;
    CompleteButton: TButton;
    CloseButton: TButton;
    procedure CloseButtonClick(Sender: TObject);
    procedure CompleteButtonClick(Sender: TObject);
  private
    { Private declarations }
    FLeadId: Integer;
    procedure LoadDocument(const ADocument: String);
  public
    { Public declarations }
    procedure LoadProposal(ALeadId: Integer; const ADocument: String);
  end;

var
  ProposalForm: TProposalForm;

implementation

{$R *.dfm}

uses{>>BWIntegrator U} bwIntegrator, {BWIntegrator U>>}
  uDataMod;

procedure TProposalForm.CompleteButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(94); try try {BWIntegrator>>}
  DM.CompleteProposal(FLeadId);
  Close;
{>>BWIntegrator} finally IntegratorExitProcess(94); end; except on e: Exception do begin IntegratorHandleException(94, e); end; end; {BWIntegrator>>}end;

procedure TProposalForm.CloseButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(95); try try {BWIntegrator>>}
  Close;
{>>BWIntegrator} finally IntegratorExitProcess(95); end; except on e: Exception do begin IntegratorHandleException(95, e); end; end; {BWIntegrator>>}end;

procedure TProposalForm.LoadProposal(ALeadId: Integer; const ADocument: String);
begin{>>BWIntegrator} IntegratorEnterProcess(96); try try {BWIntegrator>>}
  FLeadId := ALeadId;
  LoadDocument(ADocument);
{>>BWIntegrator} finally IntegratorExitProcess(96); end; except on e: Exception do begin IntegratorHandleException(96, e); end; end; {BWIntegrator>>}end;

procedure TProposalForm.LoadDocument(const ADocument: String);
var
  LDoc: Variant;
begin{>>BWIntegrator} IntegratorEnterProcess(97); try try {BWIntegrator>>}
  if not Assigned(WebBrowser.Document) then
    WebBrowser.Navigate('about:blank');

  LDoc := WebBrowser.Document;
  LDoc.Clear;
  LDoc.Write(ADocument);
  LDoc.Close;
{>>BWIntegrator} finally IntegratorExitProcess(97); end; except on e: Exception do begin IntegratorHandleException(97, e); end; end; {BWIntegrator>>}end;

end.
