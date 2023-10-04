unit uDataMod;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.DApt, System.Variants,
  FireDAC.Phys.SQLiteVDataSet, FireDAC.Comp.BatchMove.Text, System.IOUtils,
  FireDAC.Comp.BatchMove, FireDAC.Comp.BatchMove.DataSet, System.StrUtils,
  FireDAC.Phys.SQLiteWrapper.Stat;

type
  TDM = class(TDataModule)
    LeadsFDMemTable: TFDMemTable;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDStanStorageXMLLink1: TFDStanStorageXMLLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    StatusFDMemTable: TFDMemTable;
    AcctFDMemTable: TFDMemTable;
    UsersFDMemTable: TFDMemTable;
    DocsFDMemTable: TFDMemTable;
    ProposalFDMemTable: TFDMemTable;
    ProposalStatusFDMemTable: TFDMemTable;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDConnection1: TFDConnection;
    FDLocalSQL1: TFDLocalSQL;
    FDEmailsQuery: TFDQuery;
    FDBatchMove1: TFDBatchMove;
    FDBatchMoveDataSetReader1: TFDBatchMoveDataSetReader;
    FDBatchMoveTextWriter1: TFDBatchMoveTextWriter;
    FDAccountsQuery: TFDQuery;
    FDLeadsQueryNew: TFDQuery;
    FDProposalsQuery: TFDQuery;
    FDLeadsQueryActive: TFDQuery;
    FDLeadsQueryProposalSent: TFDQuery;
    FDLeadsQueryClosed: TFDQuery;
    LineItemsFDMemTable: TFDMemTable;
    DraftProposalFDMemTable: TFDMemTable;
    LineItemsTotalQuery: TFDQuery;
    FDQueryNewTotal: TFDQuery;
    FDQueryActiveTotal: TFDQuery;
    FDQueryProposalTotal: TFDQuery;
    FDQueryClosedTotal: TFDQuery;
    FDQueryTotal: TFDQuery;
    FDQueryInactiveTotal: TFDQuery;
    LeadsFDTable: TFDTable;
    FDSQLiteSecurity1: TFDSQLiteSecurity;
    DocsFDTable: TFDTable;
    UsersFDTable: TFDTable;
    AcctFDTable: TFDTable;
    ProposalsFDTable: TFDTable;
    FDDocsQuery: TFDQuery;
    FDLeadsQueryAll: TFDQuery;
    procedure FDLeadsQueryNewAfterScroll(DataSet: TDataSet);
    procedure LeadsFDTableAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitializeTable(ATable: TFDTable; AMemTable: TFDMemTable);
    procedure InitializeDatabase;
    procedure CompleteProposal(ALeadId: Integer);
    procedure SetUserQuery(const AUsername: string; AQuery: TFDQuery);
    procedure UpdateProposalStatus(ALeadId: Integer; const AStatus: string);
    procedure ExportEmails(const AFilename: String);
    procedure SearchQuery(const ASQL: String; AQuery: TFDQuery);
    procedure SearchAccounts(const ASearch: String);
    procedure SearchLeadsSubQuery(const ASearch: string; AQuery: TFDQuery);
    procedure SearchLeads(const ASearch: String);
    procedure SearchProposals(const ASearch: string);
    procedure SearchEmails(const ASearch: string);
    procedure SetUser(const AUsername: String);
 end;
  const
    DB_FILENAME = 'w10crmdemo.sdb';
    DB_PASSWORD = 'SecretPassword';
    DB_ENCRYPTION = 'aes-256';
    DB_LEADSTABLE = 'Leads';
    DB_ACCTSTABLE = 'Accounts';
    DB_USERSTABLE = 'Users';
    DB_DOCSTABLE = 'Docs';
    DB_PROPOSALSTABLE = 'Proposals';

var
  DM: TDM;

implementation{>>BWIntegrator U} uses bwIntegrator; {BWIntegrator U>>}

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDM.InitializeTable(ATable: TFDTable; AMemTable: TFDMemTable);
begin{>>BWIntegrator} IntegratorEnterProcess(1); try try {BWIntegrator>>}
  ATable.FieldDefs.Clear;
  ATable.FieldDefs.Assign(AMemTable.FieldDefs);
  ATable.CreateTable(False);
  ATable.CopyDataSet(AMemTable, [coStructure, coRestart, coAppend]);
{>>BWIntegrator} finally IntegratorExitProcess(1); end; except on e: Exception do begin IntegratorHandleException(1, e); end; end; {BWIntegrator>>}end;

procedure TDM.InitializeDatabase;
begin{>>BWIntegrator} IntegratorEnterProcess(2); try try {BWIntegrator>>}
  FDConnection1.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, DB_FILENAME);

  LeadsFDTable.TableName := DB_LEADSTABLE;
  AcctFDTable.TableName := DB_ACCTSTABLE;
  UsersFDTable.TableName := DB_USERSTABLE;
  DocsFDTable.TableName := DB_DOCSTABLE;
  ProposalsFDTable.TableName := DB_PROPOSALSTABLE;
  if TFile.Exists(FDConnection1.Params.Values['Database'])=True then
    begin
      FDSQLiteSecurity1.Database := FDConnection1.Params.Values['Database'];
    end
  else
    begin
      FDConnection1.Open;
      try
        InitializeTable(DocsFDTable,DocsFDMemTable);
        InitializeTable(LeadsFDTable,LeadsFDMemTable);
        InitializeTable(AcctFDTable,AcctFDMemTable);
        InitializeTable(UsersFDTable,UsersFDMemTable);
        InitializeTable(ProposalsFDTable,ProposalFDMemTable);
      finally
        FDConnection1.Close;
      end;
      FDSQLiteSecurity1.Database := FDConnection1.Params.Values['Database'];
      FDSQLiteSecurity1.Password := DB_ENCRYPTION + ':' + DB_PASSWORD;
      FDSQLiteSecurity1.SetPassword;
    end;

  FDConnection1.Params.Values['Encrypt'] := DB_ENCRYPTION;
  FDConnection1.Params.Password := DB_PASSWORD;
  FDConnection1.Open;

  DocsFDTable.Open;
  LeadsFDTable.Open;
  AcctFDTable.Open;
  UsersFDTable.Open;
  ProposalsFDTable.Open;

  SetUser(UsersFDMemTable.FieldByName('Username').AsString);

  FDAccountsQuery.Open;

  LeadsFDMemTable.Free;
  AcctFDMemTable.Free;
  UsersFDMemTable.Free;
  DocsFDMemTable.Free;
  ProposalFDMemTable.Free;
{>>BWIntegrator} finally IntegratorExitProcess(2); end; except on e: Exception do begin IntegratorHandleException(2, e); end; end; {BWIntegrator>>}end;

procedure TDM.CompleteProposal(ALeadId: Integer);
begin{>>BWIntegrator} IntegratorEnterProcess(3); try try {BWIntegrator>>}
    DM.UpdateProposalStatus(ALeadId,'Accepted');
{>>BWIntegrator} finally IntegratorExitProcess(3); end; except on e: Exception do begin IntegratorHandleException(3, e); end; end; {BWIntegrator>>}end;

procedure TDM.UpdateProposalStatus(ALeadId: Integer; const AStatus: string);
begin{>>BWIntegrator} IntegratorEnterProcess(4); try try {BWIntegrator>>}
  if ProposalsFDTable.Locate('LeadId',VarArrayOf([ALeadId]),[]) then
  begin
    ProposalsFDTable.Edit;
    ProposalsFDTable.FieldByName('Status').AsString := AStatus;
    if AStatus = 'Accepted' then ProposalsFDTable.FieldByName('DateCompleted').AsDateTime := Now;
    ProposalsFDTable.Post;
    FDProposalsQuery.Close;
    FDProposalsQuery.Open;
    FDProposalsQuery.Locate('ProposalId',VarArrayOf([ProposalsFDTable.FieldByName('ProposalId').AsInteger]),[]);
  end;
{>>BWIntegrator} finally IntegratorExitProcess(4); end; except on e: Exception do begin IntegratorHandleException(4, e); end; end; {BWIntegrator>>}end;

procedure TDM.SetUserQuery(const AUsername: string; AQuery: TFDQuery);
begin{>>BWIntegrator} IntegratorEnterProcess(5); try try {BWIntegrator>>}
  AQuery.Close;
  AQuery.ParamByName('Username').AsString := AUsername;
  AQuery.Open;
{>>BWIntegrator} finally IntegratorExitProcess(5); end; except on e: Exception do begin IntegratorHandleException(5, e); end; end; {BWIntegrator>>}end;


procedure TDM.SetUser(const AUsername: String);
begin{>>BWIntegrator} IntegratorEnterProcess(6); try try {BWIntegrator>>}
  SetUserQuery(AUsername, FDEmailsQuery);
  SetUserQuery(AUsername, FDLeadsQueryAll);
  SetUserQuery(AUsername, FDLeadsQueryNew);
  SetUserQuery(AUsername, FDProposalsQuery);
  SetUserQuery(AUsername, FDDocsQuery);
  SetUserQuery(AUsername, FDLeadsQueryActive);
  SetUserQuery(AUsername, FDLeadsQueryProposalSent);
  SetUserQuery(AUsername, FDLeadsQueryClosed);
  SetUserQuery(AUsername, FDQueryNewTotal);
  SetUserQuery(AUsername, FDQueryActiveTotal);
  SetUserQuery(AUsername, FDQueryProposalTotal);
  SetUserQuery(AUsername, FDQueryClosedTotal);
  SetUserQuery(AUsername, FDQueryTotal);
  SetUserQuery(AUsername, FDQueryInactiveTotal);
{>>BWIntegrator} finally IntegratorExitProcess(6); end; except on e: Exception do begin IntegratorHandleException(6, e); end; end; {BWIntegrator>>}end;

procedure TDM.LeadsFDTableAfterScroll(DataSet: TDataSet);
begin{>>BWIntegrator} IntegratorEnterProcess(7); try try {BWIntegrator>>}
  FDDocsQuery.Close;
  FDDocsQuery.ParamByName('LeadId').AsInteger := LeadsFDTable.FieldByName('LeadId').AsInteger;
  FDDocsQuery.Open;
{>>BWIntegrator} finally IntegratorExitProcess(7); end; except on e: Exception do begin IntegratorHandleException(7, e); end; end; {BWIntegrator>>}end;


procedure TDM.ExportEmails(const AFilename: string);
begin{>>BWIntegrator} IntegratorEnterProcess(8); try try {BWIntegrator>>}
  FDBatchMoveTextWriter1.FileName := AFilename;
  FDBatchMove1.Execute;
{>>BWIntegrator} finally IntegratorExitProcess(8); end; except on e: Exception do begin IntegratorHandleException(8, e); end; end; {BWIntegrator>>}end;

procedure TDM.SearchQuery(const ASQL: string; AQuery: TFDQuery);
begin{>>BWIntegrator} IntegratorEnterProcess(9); try try {BWIntegrator>>}
  AQuery.Close;
  AQuery.MacroByName('Where').AsRaw := ASQL;
  AQuery.Open;
{>>BWIntegrator} finally IntegratorExitProcess(9); end; except on e: Exception do begin IntegratorHandleException(9, e); end; end; {BWIntegrator>>}end;

procedure TDM.FDLeadsQueryNewAfterScroll(DataSet: TDataSet);
begin{>>BWIntegrator} IntegratorEnterProcess(10); try try {BWIntegrator>>}
  LeadsFDTable.Locate('LeadId',VarArrayOf([DataSet.FieldByName('LeadId').AsInteger]),[]);
{>>BWIntegrator} finally IntegratorExitProcess(10); end; except on e: Exception do begin IntegratorHandleException(10, e); end; end; {BWIntegrator>>}end;

procedure TDM.SearchAccounts(const ASearch: string);
begin{>>BWIntegrator} IntegratorEnterProcess(11); try try {BWIntegrator>>}
  SearchQuery(IfThen(ASearch <> '', 'UPPER(AccountName) LIKE ''%' +
    UpperCase(ASearch) + '%''', ''), FDAccountsQuery);
{>>BWIntegrator} finally IntegratorExitProcess(11); end; except on e: Exception do begin IntegratorHandleException(11, e); end; end; {BWIntegrator>>}end;

procedure TDM.SearchLeadsSubQuery(const ASearch: string; AQuery: TFDQuery);
begin{>>BWIntegrator} IntegratorEnterProcess(12); try try {BWIntegrator>>}
  SearchQuery(IfThen(ASearch <> '', 'AND UPPER(Name) LIKE ''%' + UpperCase(ASearch)
    + '%'' OR UPPER(AccountName) LIKE ''%' + UpperCase(ASearch) +
    '%'' OR UPPER(OfficePhone) LIKE ''%' + UpperCase(ASearch) +
    '%'' OR UPPER(Email) LIKE ''%' + UpperCase(ASearch) + '%''', ''),
     AQuery);
{>>BWIntegrator} finally IntegratorExitProcess(12); end; except on e: Exception do begin IntegratorHandleException(12, e); end; end; {BWIntegrator>>}end;

procedure TDM.SearchLeads(const ASearch: string);
begin{>>BWIntegrator} IntegratorEnterProcess(13); try try {BWIntegrator>>}
  SearchLeadsSubQuery(ASearch,FDLeadsQueryNew);
  SearchLeadsSubQuery(ASearch,FDLeadsQueryActive);
  SearchLeadsSubQuery(ASearch,FDLeadsQueryProposalSent);
  SearchLeadsSubQuery(ASearch,FDLeadsQueryClosed);
{>>BWIntegrator} finally IntegratorExitProcess(13); end; except on e: Exception do begin IntegratorHandleException(13, e); end; end; {BWIntegrator>>}end;

procedure TDM.SearchProposals(const ASearch: string);
begin{>>BWIntegrator} IntegratorEnterProcess(14); try try {BWIntegrator>>}
  SearchQuery(IfThen(ASearch <> '', 'AND UPPER(ProposalName) LIKE ''%' +
    UpperCase(ASearch) + '%''', ''), FDProposalsQuery);
{>>BWIntegrator} finally IntegratorExitProcess(14); end; except on e: Exception do begin IntegratorHandleException(14, e); end; end; {BWIntegrator>>}end;

procedure TDM.SearchEmails(const ASearch: string);
begin{>>BWIntegrator} IntegratorEnterProcess(15); try try {BWIntegrator>>}
  SearchQuery(IfThen(ASearch <> '', 'AND UPPER(Email) LIKE ''%' +
    UpperCase(ASearch) + '%''', ''), FDEmailsQuery);
{>>BWIntegrator} finally IntegratorExitProcess(15); end; except on e: Exception do begin IntegratorHandleException(15, e); end; end; {BWIntegrator>>}end;

end.
