unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Bind.Controls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.StdCtrls, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, Vcl.Bind.Navigator,
  Vcl.Grids, Vcl.WinXCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.ComCtrls,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, Vcl.Bind.Grid, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Vcl.WinXCalendars, FireDAC.Stan.StorageBin,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML,
  Vcl.WinXPanels, System.Actions, Vcl.ActnList, Vcl.Themes,
  Vcl.BaseImageCollection, Vcl.ImageCollection, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.VirtualImage, System.IOUtils, Vcl.TitleBarCtrls;

type
  TMainForm = class(TForm)
    pnlToolbar: TPanel;
    SplitView: TSplitView;
    NavPanel: TPanel;
    NewLeadsSG: TStringGrid;
    BindNavigator1: TBindNavigator;
    lblTitle: TLabel;
    PageControl: TPageControl;
    LeadsTab: TTabSheet;
    CalendarTab: TTabSheet;
    Panel2: TPanel;
    Label1: TLabel;
    LeadsBindNewSourceDB: TBindSourceDB;
    BindingsList1: TBindingsList;
    Image5: TImage;
    CalendarView1: TCalendarView;
    LeadsSearchBox: TSearchBox;
    Panel4: TPanel;
    Label3: TLabel;
    DashboardTab: TTabSheet;
    Panel5: TPanel;
    Label4: TLabel;
    ImportLeadsDialog: TOpenDialog;
    ExportLeadsDialog: TSaveDialog;
    FlowPanel1: TFlowPanel;
    RelativePanel1: TRelativePanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    RelativePanel2: TRelativePanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    RelativePanel3: TRelativePanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    RelativePanel4: TRelativePanel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    RelativePanel5: TRelativePanel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    RelativePanel6: TRelativePanel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    SalesTab: TTabSheet;
    Panel6: TPanel;
    Label23: TLabel;
    SalesSearchBox: TSearchBox;
    ProposalStringGrid: TStringGrid;
    BindNavigator3: TBindNavigator;
    AccountsTab: TTabSheet;
    Panel7: TPanel;
    Label24: TLabel;
    AcctSearchBox: TSearchBox;
    AccountsSG: TStringGrid;
    BindNavigator4: TBindNavigator;
    UsersTab: TTabSheet;
    Panel8: TPanel;
    Label25: TLabel;
    SearchBox7: TSearchBox;
    UsersSG: TStringGrid;
    UsersBindSourceDB: TBindSourceDB;
    LinkGridToDataSourceUsersBindSourceDB: TLinkGridToDataSource;
    BindNavigator5: TBindNavigator;
    ProposalBindSourceDB: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB5: TLinkGridToDataSource;
    UsernameComboBox: TComboBox;
    LinkListControlToField1: TLinkListControlToField;
    AcctBindSourceDB: TBindSourceDB;
    MarketingTab: TTabSheet;
    Panel3: TPanel;
    Label2: TLabel;
    EmailsSearchBox: TSearchBox;
    StringGrid2: TStringGrid;
    EmailsBindSourceDB: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB4: TLinkGridToDataSource;
    SaveEmailsDialog: TSaveDialog;
    NewLeadsPanel: TPanel;
    Splitter1: TSplitter;
    Label27: TLabel;
    ActiveLeadsSG: TStringGrid;
    ActiveLeadsPanel: TPanel;
    Label28: TLabel;
    Splitter2: TSplitter;
    ProposalSentPanel: TPanel;
    ProposalSentLeadsSG: TStringGrid;
    Label29: TLabel;
    Splitter3: TSplitter;
    ClosedPanel: TPanel;
    ClosedLeadsSG: TStringGrid;
    Label30: TLabel;
    LinkGridToDataSourceLeadsBindSourceDB: TLinkGridToDataSource;
    LeadsBindActiveSourceDB: TBindSourceDB;
    LinkGridToDataSourceLeadsBindActiveSourceDB: TLinkGridToDataSource;
    LeadsBindSourceDB: TBindSourceDB;
    LeadsBindProposalSentSourceDB: TBindSourceDB;
    LeadsBindClosedSourceDB: TBindSourceDB;
    LinkGridToDataSourceLeadsBindClosedSourceDB: TLinkGridToDataSource;
    TitleBarPanel1: TTitleBarPanel;
    VCLStylesCB: TComboBox;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    ViewLeadButton: TSpeedButton;
    CreateLeadButton: TSpeedButton;
    ExportLeadsButton: TSpeedButton;
    LeadsRelativePanel: TRelativePanel;
    AcctsRelativePanel: TRelativePanel;
    ExportAcctsButton: TSpeedButton;
    RemoveAcctButton: TSpeedButton;
    CreateAcctButton: TSpeedButton;
    ProposalsRelativePanel: TRelativePanel;
    CancelProposalButton: TSpeedButton;
    CompleteProposalButton: TSpeedButton;
    MarketingRelativePanel: TRelativePanel;
    ExportEmailsButton: TSpeedButton;
    UsersRelativePanel: TRelativePanel;
    CreateUserButton: TSpeedButton;
    RemoveUserButton: TSpeedButton;
    DashboardButton: TButton;
    AcctsButton: TButton;
    LeadsButton: TButton;
    SalesButton: TButton;
    MarketingButton: TButton;
    CalendarButton: TButton;
    UsersButton: TButton;
    LinkGridToDataSourceAcctBindSourceDB: TLinkGridToDataSource;
    ExportAcctsDialog: TSaveDialog;
    LinkGridToDataSourceLeadsBindProposalSentSourceDB: TLinkGridToDataSource;
    VirtualImage1: TVirtualImage;
    VirtualImage2: TVirtualImage;
    VirtualImage3: TVirtualImage;
    VirtualImage4: TVirtualImage;
    VirtualImage5: TVirtualImage;
    VirtualImage6: TVirtualImage;
    VirtualImage7: TVirtualImage;
    MenuVirtualImage: TVirtualImage;
    NewTotalBindSourceDB: TBindSourceDB;
    LinkPropertyToFieldCaption: TLinkPropertyToField;
    ActiveTotalBindSourceDB: TBindSourceDB;
    LinkPropertyToFieldCaption2: TLinkPropertyToField;
    ProposalTotalBindSourceDB: TBindSourceDB;
    LinkPropertyToFieldCaption3: TLinkPropertyToField;
    ClosedTotalBindSourceDB: TBindSourceDB;
    LinkPropertyToFieldCaption4: TLinkPropertyToField;
    InactiveTotalBindSourceDB: TBindSourceDB;
    LinkPropertyToFieldCaption5: TLinkPropertyToField;
    AllTotalBindSourceDB: TBindSourceDB;
    LinkPropertyToFieldCaption6: TLinkPropertyToField;
    VirtualImage9: TVirtualImage;
    VirtualImage10: TVirtualImage;
    VirtualImage11: TVirtualImage;
    VirtualImage12: TVirtualImage;
    VirtualImage13: TVirtualImage;
    VirtualImage14: TVirtualImage;
    cbMetrics: TComboBox;
    procedure CalendarView1DrawDayItem(Sender: TObject;
      DrawParams: TDrawViewInfoParams; CalendarViewViewInfo: TCellItemViewInfo);
    procedure AcctSearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure LeadsSearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure SalesSearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure EmailsSearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure NewLeadsSGEnter(Sender: TObject);
    procedure ActiveLeadsSGEnter(Sender: TObject);
    procedure ProposalSentLeadsSGEnter(Sender: TObject);
    procedure ClosedLeadsSGEnter(Sender: TObject);
    procedure NewLeadsSGDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure NewLeadsSGDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure NewLeadsSGMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VCLStylesCBChange(Sender: TObject);
    procedure LeadsRelativePanelResize(Sender: TObject);
    procedure AcctsRelativePanelResize(Sender: TObject);
    procedure ProposalsRelativePanelResize(Sender: TObject);
    procedure MarketingRelativePanelResize(Sender: TObject);
    procedure UsersRelativePanelResize(Sender: TObject);
    procedure CreateLeadButtonClick(Sender: TObject);
    procedure ExportLeadsButtonClick(Sender: TObject);
    procedure ViewLeadButtonClick(Sender: TObject);
    procedure ExportEmailsButtonClick(Sender: TObject);
    procedure SplitViewOpening(Sender: TObject);
    procedure SplitViewClosing(Sender: TObject);
    procedure CreateAcctButtonClick(Sender: TObject);
    procedure DashboardButtonClick(Sender: TObject);
    procedure AccountsTabResize(Sender: TObject);
    procedure RemoveAcctButtonClick(Sender: TObject);
    procedure ExportAcctsButtonClick(Sender: TObject);
    procedure CreateUserButtonClick(Sender: TObject);
    procedure RemoveUserButtonClick(Sender: TObject);
    procedure UsersTabResize(Sender: TObject);
    procedure CancelProposalButtonClick(Sender: TObject);
    procedure CompleteProposalButtonClick(Sender: TObject);
    procedure MenuVirtualImageClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure UsernameComboBoxKeyPress(Sender: TObject; var Key: Char);
    procedure UsernameComboBoxChange(Sender: TObject);
    procedure NewLeadsSGDblClick(Sender: TObject);
    procedure ActiveLeadsSGDblClick(Sender: TObject);
    procedure VCLStylesCBKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure cbMetricsChange(Sender: TObject);
  private
    { Private declarations }
    FRanOnce: Boolean;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure RefreshGrids;
    procedure UpdateNavButtons;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses{>>BWIntegrator U} bwIntegrator, {BWIntegrator U>>} uDataMod, uLeads, uDraftProposal, uProposal;

procedure TMainForm.RefreshGrids;
begin{>>BWIntegrator} IntegratorEnterProcess(16); try try {BWIntegrator>>}
  LeadsBindClosedSourceDB.DataSet.Refresh;
  LeadsBindActiveSourceDB.DataSet.Refresh;
  LeadsBindNewSourceDB.DataSet.Refresh;
  LeadsBindProposalSentSourceDB.DataSet.Refresh;
{>>BWIntegrator} finally IntegratorExitProcess(16); end; except on e: Exception do begin IntegratorHandleException(16, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.RemoveAcctButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(17); try try {BWIntegrator>>}
  AcctBindSourceDB.DataSet.Delete;
{>>BWIntegrator} finally IntegratorExitProcess(17); end; except on e: Exception do begin IntegratorHandleException(17, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.RemoveUserButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(18); try try {BWIntegrator>>}
  UsersBindSourceDB.DataSet.Delete;
{>>BWIntegrator} finally IntegratorExitProcess(18); end; except on e: Exception do begin IntegratorHandleException(18, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.AcctSearchBoxKeyPress(Sender: TObject; var Key: Char);
begin{>>BWIntegrator} IntegratorEnterProcess(19); try try {BWIntegrator>>}
  DM.SearchAccounts(AcctSearchBox.Text);
{>>BWIntegrator} finally IntegratorExitProcess(19); end; except on e: Exception do begin IntegratorHandleException(19, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.CalendarView1DrawDayItem(Sender: TObject;
  DrawParams: TDrawViewInfoParams; CalendarViewViewInfo: TCellItemViewInfo);
begin{>>BWIntegrator} IntegratorEnterProcess(20); try try {BWIntegrator>>}
  if DayOfWeek(CalendarViewViewInfo.Date) in [1, 7] then
  begin
    DrawParams.Font.Style := [fsBold];
  end;
{>>BWIntegrator} finally IntegratorExitProcess(20); end; except on e: Exception do begin IntegratorHandleException(20, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.CancelProposalButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(21); try try {BWIntegrator>>}
  if ProposalBindSourceDB.DataSet.RecordCount>0 then
  begin
    DM.UpdateProposalStatus(ProposalBindSourceDB.DataSet.FieldByName('LeadId').AsInteger,'Canceled');
  end;
{>>BWIntegrator} finally IntegratorExitProcess(21); end; except on e: Exception do begin IntegratorHandleException(21, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.cbMetricsChange(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(22); try try {BWIntegrator>>}
  if cbMetrics.ItemIndex = 0 then
    IntegratorSendEnableSign(true)
  else
    IntegratorSendEnableSign(false);
{>>BWIntegrator} finally IntegratorExitProcess(22); end; except on e: Exception do begin IntegratorHandleException(22, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.PageControlChange(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(23); try try {BWIntegrator>>}
  if PageControl.ActivePageIndex=0 then
    begin
      DM.FDQueryNewTotal.Refresh;
      DM.FDQueryActiveTotal.Refresh;
      DM.FDQueryProposalTotal.Refresh;
      DM.FDQueryInactiveTotal.Refresh;
      DM.FDQueryClosedTotal.Refresh;
      DM.FDQueryTotal.Refresh;
    end;
  case PageControl.ActivePageIndex of
    0: DashboardButton.SetFocus;
    1: AcctsButton.SetFocus;
    2: LeadsButton.SetFocus;
    3: SalesButton.SetFocus;
    4: begin
      MarketingButton.SetFocus;
      EmailsBindSourceDB.DataSet.Refresh;
    end;
    5: CalendarButton.SetFocus;
    6: UsersButton.SetFocus;
  end;

{>>BWIntegrator} finally IntegratorExitProcess(23); end; except on e: Exception do begin IntegratorHandleException(23, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.SalesSearchBoxKeyPress(Sender: TObject; var Key: Char);
begin{>>BWIntegrator} IntegratorEnterProcess(24); try try {BWIntegrator>>}
  DM.SearchProposals(SalesSearchBox.Text);
{>>BWIntegrator} finally IntegratorExitProcess(24); end; except on e: Exception do begin IntegratorHandleException(24, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.SplitViewClosing(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(25); try try {BWIntegrator>>}
  DashboardButton.Caption := '';
  AcctsButton.Caption := '';
  LeadsButton.Caption := '';
  SalesButton.Caption := '';
  MarketingButton.Caption := '';
  CalendarButton.Caption := '';
  UsersButton.Caption := '';
{>>BWIntegrator} finally IntegratorExitProcess(25); end; except on e: Exception do begin IntegratorHandleException(25, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.SplitViewOpening(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(26); try try {BWIntegrator>>}
  DashboardButton.Caption := '          '+DashboardButton.Hint;
  AcctsButton.Caption := '          '+AcctsButton.Hint;
  LeadsButton.Caption := '          '+LeadsButton.Hint;
  SalesButton.Caption := '          '+SalesButton.Hint;
  MarketingButton.Caption := '          '+MarketingButton.Hint;
  CalendarButton.Caption := '          '+CalendarButton.Hint;
  UsersButton.Caption := '          '+UsersButton.Hint;
{>>BWIntegrator} finally IntegratorExitProcess(26); end; except on e: Exception do begin IntegratorHandleException(26, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.AccountsTabResize(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(27); try try {BWIntegrator>>}
  LinkGridToDataSourceAcctBindSourceDB.Columns[1].Width := AccountsSG.Width - LinkGridToDataSourceAcctBindSourceDB.Columns[0].Width;
{>>BWIntegrator} finally IntegratorExitProcess(27); end; except on e: Exception do begin IntegratorHandleException(27, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.UsersTabResize(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(28); try try {BWIntegrator>>}
  LinkGridToDataSourceUsersBindSourceDB.Columns[1].Width := UsersSG.Width - LinkGridToDataSourceUsersBindSourceDB.Columns[0].Width;

{>>BWIntegrator} finally IntegratorExitProcess(28); end; except on e: Exception do begin IntegratorHandleException(28, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.UsernameComboBoxChange(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(29); try try {BWIntegrator>>}
  LeadsForm.Close;
  DraftProposalForm.Close;
  ProposalForm.Close;
  DM.SetUser(UsernameComboBox.Text);
{>>BWIntegrator} finally IntegratorExitProcess(29); end; except on e: Exception do begin IntegratorHandleException(29, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.UsernameComboBoxKeyPress(Sender: TObject; var Key: Char);
begin{>>BWIntegrator} IntegratorEnterProcess(30); try try {BWIntegrator>>}
  Key := #0;
{>>BWIntegrator} finally IntegratorExitProcess(30); end; except on e: Exception do begin IntegratorHandleException(30, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.UsersRelativePanelResize(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(31); try try {BWIntegrator>>}
  if UsersRelativePanel.Width<=436 then
  begin
    CreateUserButton.Caption := '';
    CreateUserButton.Width := 40;
    RemoveUserButton.Caption := '';
    RemoveUserButton.Width := 40;
  end
  else
  begin
    CreateUserButton.Caption := CreateUserButton.Hint;
    CreateUserButton.Width := 121;
    RemoveUserButton.Caption := RemoveUserButton.Hint;
    RemoveUserButton.Width := 121;
  end;
{>>BWIntegrator} finally IntegratorExitProcess(31); end; except on e: Exception do begin IntegratorHandleException(31, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.VCLStylesCBChange(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(32); try try {BWIntegrator>>}
  MainForm.WindowState := TWindowState.wsMaximized;
  TStyleManager.TrySetStyle(VCLStylesCB.Text);
  UpdateNavButtons;
{>>BWIntegrator} finally IntegratorExitProcess(32); end; except on e: Exception do begin IntegratorHandleException(32, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.VCLStylesCBKeyPress(Sender: TObject; var Key: Char);
begin{>>BWIntegrator} IntegratorEnterProcess(33); try try {BWIntegrator>>}
  Key := #0;
{>>BWIntegrator} finally IntegratorExitProcess(33); end; except on e: Exception do begin IntegratorHandleException(33, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.ViewLeadButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(34); try try {BWIntegrator>>}
  LeadsForm.Show;
{>>BWIntegrator} finally IntegratorExitProcess(34); end; except on e: Exception do begin IntegratorHandleException(34, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.MenuVirtualImageClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(35); try try {BWIntegrator>>}
  SplitView.Opened := not SplitView.Opened;
{>>BWIntegrator} finally IntegratorExitProcess(35); end; except on e: Exception do begin IntegratorHandleException(35, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.AcctsRelativePanelResize(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(36); try try {BWIntegrator>>}
  if AcctsRelativePanel.Width<=634 then
  begin

    ExportAcctsButton.Caption := '';
    ExportAcctsButton.Width := 40;
    CreateAcctButton.Caption := '';
    CreateAcctButton.Width := 40;
    RemoveAcctButton.Caption := '';
    RemoveAcctButton.Width := 40;
  end
  else
  begin
    ExportAcctsButton.Caption := ExportAcctsButton.Hint;
    ExportAcctsButton.Width := 112;
    CreateAcctButton.Caption := CreateAcctButton.Hint;
    CreateAcctButton.Width := 112;
    RemoveAcctButton.Caption := RemoveAcctButton.Hint;
    RemoveAcctButton.Width := 112;
  end;
{>>BWIntegrator} finally IntegratorExitProcess(36); end; except on e: Exception do begin IntegratorHandleException(36, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.ActiveLeadsSGDblClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(37); try try {BWIntegrator>>}
  ViewLeadButtonClick(Sender);
{>>BWIntegrator} finally IntegratorExitProcess(37); end; except on e: Exception do begin IntegratorHandleException(37, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.ActiveLeadsSGEnter(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(38); try try {BWIntegrator>>}
  LeadsForm.LocateLead(LeadsBindActiveSourceDB.DataSet.FieldByName('LeadId').AsInteger);
  BindNavigator1.DataSource := LeadsBindActiveSourceDB;
{>>BWIntegrator} finally IntegratorExitProcess(38); end; except on e: Exception do begin IntegratorHandleException(38, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.ProposalSentLeadsSGEnter(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(39); try try {BWIntegrator>>}
  LeadsForm.LocateLead(LeadsBindProposalSentSourceDB.DataSet.FieldByName('LeadId').AsInteger);
  BindNavigator1.DataSource := LeadsBindProposalSentSourceDB;
{>>BWIntegrator} finally IntegratorExitProcess(39); end; except on e: Exception do begin IntegratorHandleException(39, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.ProposalsRelativePanelResize(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(40); try try {BWIntegrator>>}
  if ProposalsRelativePanel.Width<=436 then
  begin
    CompleteProposalButton.Caption := '';
    CompleteProposalButton.Width := 40;
    CancelProposalButton.Caption := '';
    CancelProposalButton.Width := 40;
  end
  else
  begin
    CompleteProposalButton.Caption := CompleteProposalButton.Hint;
    CompleteProposalButton.Width := 121;
    CancelProposalButton.Caption := CancelProposalButton.Hint;
    CancelProposalButton.Width := 121;
  end;
{>>BWIntegrator} finally IntegratorExitProcess(40); end; except on e: Exception do begin IntegratorHandleException(40, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.ClosedLeadsSGEnter(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(41); try try {BWIntegrator>>}
  LeadsForm.LocateLead(LeadsBindClosedSourceDB.DataSet.FieldByName('LeadId').AsInteger);
  BindNavigator1.DataSource := LeadsBindClosedSourceDB;
{>>BWIntegrator} finally IntegratorExitProcess(41); end; except on e: Exception do begin IntegratorHandleException(41, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.CompleteProposalButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(42); try try {BWIntegrator>>}
  if ProposalBindSourceDB.DataSet.RecordCount>0 then
  begin
    DM.UpdateProposalStatus(ProposalBindSourceDB.DataSet.FieldByName('LeadId').AsInteger,'Accepted');
    ProposalBindSourceDB.DataSet.Refresh;
  end;
{>>BWIntegrator} finally IntegratorExitProcess(42); end; except on e: Exception do begin IntegratorHandleException(42, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.CreateAcctButtonClick(Sender: TObject);
var
LNewAccount: String;
begin{>>BWIntegrator} IntegratorEnterProcess(43); try try {BWIntegrator>>}
  LNewAccount := InputBox('Create New Account', 'Account Name', 'New Account');
  AcctBindSourceDB.DataSet.DisableControls;
  AcctBindSourceDB.DataSet.AppendRecord([nil,LNewAccount]);
  AcctBindSourceDB.DataSet.EnableControls;
  LinkGridToDataSourceAcctBindSourceDB.Active := False;
  LinkGridToDataSourceAcctBindSourceDB.Active := True;

{>>BWIntegrator} finally IntegratorExitProcess(43); end; except on e: Exception do begin IntegratorHandleException(43, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.CreateLeadButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(44); try try {BWIntegrator>>}
  LeadsBindNewSourceDB.DataSet.Append;
  LeadsBindNewSourceDB.DataSet.FieldByName('LeadId').AsString := '';
  LeadsBindNewSourceDB.DataSet.FieldByName('Status').AsString := 'New';
  LeadsBindNewSourceDB.DataSet.FieldByName('Name').AsString := 'First Last';
  LeadsBindNewSourceDB.DataSet.FieldByName('User').AsString := UsernameCombobox.Text;
  LeadsBindNewSourceDB.DataSet.FieldByName('DateCreated').AsDateTime := Now;
  LeadsBindNewSourceDB.DataSet.Post;
  LeadsBindSourceDB.DataSet.Locate('LeadId',VarArrayOf([LeadsBindNewSourceDB.DataSet.FieldByName('LeadId').AsInteger]),[]);
  BindNavigator1.DataSource := LeadsBindNewSourceDB;
  LeadsForm.Show;
{>>BWIntegrator} finally IntegratorExitProcess(44); end; except on e: Exception do begin IntegratorHandleException(44, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.CreateUserButtonClick(Sender: TObject);
var
LNewUser: String;
begin{>>BWIntegrator} IntegratorEnterProcess(45); try try {BWIntegrator>>}
  LNewUser := InputBox('Create New User', 'User Name', 'user');
  if UsersBindSourceDB.DataSet.Lookup('Username', VarArrayOf([LNewUser]),'Username')<>LNewUser then
  begin
    UsersBindSourceDB.DataSet.Append;
    UsersBindSourceDB.DataSet.FieldByName('UserId').AsInteger := 0;
    UsersBindSourceDB.DataSet.FieldByName('Username').AsString := LNewUser;
    UsersBindSourceDB.DataSet.Post;
    DM.UsersFDTable.Refresh;
  end
  else
  begin
    ShowMessage('A user with that username already exists.');
  end;
{>>BWIntegrator} finally IntegratorExitProcess(45); end; except on e: Exception do begin IntegratorHandleException(45, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.DashboardButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(46); try try {BWIntegrator>>}
  PageControl.ActivePageIndex := TButton(Sender).Tag;
{>>BWIntegrator} finally IntegratorExitProcess(46); end; except on e: Exception do begin IntegratorHandleException(46, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.LeadsRelativePanelResize(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(47); try try {BWIntegrator>>}
  if LeadsRelativePanel.Width<=781 then
  begin

    ExportLeadsButton.Caption := '';
    ExportLeadsButton.Width := 40;
    CreateLeadButton.Caption := '';
    CreateLeadButton.Width := 40;
    ViewLeadButton.Caption := '';
    ViewLeadButton.Width := 40;
  end
  else
  begin
    ExportLeadsButton.Caption := ExportLeadsButton.Hint;
    ExportLeadsButton.Width := 153;
    CreateLeadButton.Caption := CreateLeadButton.Hint;
    CreateLeadButton.Width := 153;
    ViewLeadButton.Caption := ViewLeadButton.Hint;
    ViewLeadButton.Width := 153;
  end;
{>>BWIntegrator} finally IntegratorExitProcess(47); end; except on e: Exception do begin IntegratorHandleException(47, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.LeadsSearchBoxKeyPress(Sender: TObject; var Key: Char);
begin{>>BWIntegrator} IntegratorEnterProcess(48); try try {BWIntegrator>>}
  DM.SearchLeads(LeadsSearchBox.Text);
{>>BWIntegrator} finally IntegratorExitProcess(48); end; except on e: Exception do begin IntegratorHandleException(48, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.MarketingRelativePanelResize(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(49); try try {BWIntegrator>>}
  if MarketingRelativePanel.Width<=320 then
  begin
    ExportEmailsButton.Caption := '';
    ExportEmailsButton.Width := 40;
  end
  else
  begin
    ExportEmailsButton.Caption := ExportEmailsButton.Hint;
    ExportEmailsButton.Width := 121;
  end;
{>>BWIntegrator} finally IntegratorExitProcess(49); end; except on e: Exception do begin IntegratorHandleException(49, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.NewLeadsSGDblClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(50); try try {BWIntegrator>>}
  ViewLeadButtonClick(Sender);
{>>BWIntegrator} finally IntegratorExitProcess(50); end; except on e: Exception do begin IntegratorHandleException(50, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.NewLeadsSGDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  LStatus: String;
  LIndex: Integer;
  LDataSet: TDataSet;
  LDateField: String;
begin{>>BWIntegrator} IntegratorEnterProcess(51); try try {BWIntegrator>>}
  LIndex := -1;

  if Source = Sender then
  begin

  end
  else
  begin

    case TStringGrid(Sender).Parent.Tag of
      1:
        begin
          LStatus := 'New';
          LDateField := 'DateCreated';
          LDataSet := LeadsBindNewSourceDB.DataSet;
        end;
      2:
        begin
          LStatus := 'Active';
          LDateField := 'DateContacted';
          LDataSet := LeadsBindActiveSourceDB.DataSet;
        end;
      3:
        begin
          LStatus := 'Proposal Sent';
          LDateField := 'DateDrafted';
          LDataSet := LeadsBindProposalSentSourceDB.DataSet;
        end;
      4:
        begin
          LStatus := 'Closed';
          LDateField := 'DateClosed';
          LDataSet := LeadsBindClosedSourceDB.DataSet;
        end;
      else
       LDataSet := LeadsBindNewSourceDB.DataSet;
    end;

    case TStringGrid(Source).Parent.Tag of
      1:
        begin
          if LeadsBindNewSourceDB.DataSet.RecordCount > 0 then
          begin
            LIndex := LeadsBindNewSourceDB.DataSet.FieldByName('LeadId').AsInteger;
            if LeadsBindSourceDB.DataSet.Locate('LeadId',VarArrayOf([LIndex]),[]) then
            begin
              LeadsBindSourceDB.DataSet.Edit;
              LeadsBindSourceDB.DataSet.FieldByName('Status').AsString := LStatus;
              if LeadsBindSourceDB.DataSet.FieldByName(LDateField).AsDateTime=0 then LeadsBindSourceDB.DataSet.FieldByName(LDateField).AsDateTime := Now;
              LeadsBindSourceDB.DataSet.Post;
            end;
            LDataSet.Locate('LeadId',VarArrayOf([LIndex]),[]);
          end;
        end;
      2:
        begin
          if LeadsBindActiveSourceDB.DataSet.RecordCount > 0 then
          begin
            LIndex := LeadsBindActiveSourceDB.DataSet.FieldByName('LeadId').AsInteger;
            if LeadsBindSourceDB.DataSet.Locate('LeadId',VarArrayOf([LIndex]),[]) then
            begin
              LeadsBindSourceDB.DataSet.Edit;
              LeadsBindSourceDB.DataSet.FieldByName('Status').AsString := LStatus;
              if LeadsBindSourceDB.DataSet.FieldByName(LDateField).AsDateTime=0 then LeadsBindSourceDB.DataSet.FieldByName(LDateField).AsDateTime := Now;
              LeadsBindSourceDB.DataSet.Post;
            end;
            LDataSet.Locate('LeadId',VarArrayOf([LIndex]),[]);
          end;
        end;
      3:
        begin
          if LeadsBindProposalSentSourceDB.DataSet.RecordCount > 0 then
          begin
            LIndex := LeadsBindProposalSentSourceDB.DataSet.FieldByName('LeadId').AsInteger;
            if LeadsBindSourceDB.DataSet.Locate('LeadId',VarArrayOf([LIndex]),[]) then
            begin
              LeadsBindSourceDB.DataSet.Edit;
              LeadsBindSourceDB.DataSet.FieldByName('Status').AsString := LStatus;
              if LeadsBindSourceDB.DataSet.FieldByName(LDateField).AsDateTime=0 then LeadsBindSourceDB.DataSet.FieldByName(LDateField).AsDateTime := Now;
              LeadsBindSourceDB.DataSet.Post;
            end;
            LDataSet.Locate('LeadId',VarArrayOf([LIndex]),[]);
          end;
        end;
      4:
        begin
          if LeadsBindClosedSourceDB.DataSet.RecordCount > 0 then
          begin
            LIndex := LeadsBindClosedSourceDB.DataSet.FieldByName('LeadId').AsInteger;
            if LeadsBindSourceDB.DataSet.Locate('LeadId',VarArrayOf([LIndex]),[]) then
            begin
              LeadsBindSourceDB.DataSet.Edit;
              LeadsBindSourceDB.DataSet.FieldByName('Status').AsString := LStatus;
              if LeadsBindSourceDB.DataSet.FieldByName(LDateField).AsDateTime=0 then LeadsBindSourceDB.DataSet.FieldByName(LDateField).AsDateTime := Now;
              LeadsBindSourceDB.DataSet.Post;
            end;
            LDataSet.Locate('LeadId',VarArrayOf([LIndex]),[]);
          end;
        end;
    end;

    RefreshGrids;

    LDataSet.Locate('LeadId',VarArrayOf([LIndex]),[]);
  end;
{>>BWIntegrator} finally IntegratorExitProcess(51); end; except on e: Exception do begin IntegratorHandleException(51, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.NewLeadsSGDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin{>>BWIntegrator} IntegratorEnterProcess(52); try try {BWIntegrator>>}
  Accept := Source is TStringGrid;
{>>BWIntegrator} finally IntegratorExitProcess(52); end; except on e: Exception do begin IntegratorHandleException(52, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.NewLeadsSGEnter(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(53); try try {BWIntegrator>>}
  LeadsForm.LocateLead(LeadsBindNewSourceDB.DataSet.FieldByName('LeadId').AsInteger);
  BindNavigator1.DataSource := LeadsBindNewSourceDB;
{>>BWIntegrator} finally IntegratorExitProcess(53); end; except on e: Exception do begin IntegratorHandleException(53, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.NewLeadsSGMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin{>>BWIntegrator} IntegratorEnterProcess(54); try try {BWIntegrator>>}
  if Button = mbLeft then
     TStringGrid(Sender).BeginDrag(False,4);
{>>BWIntegrator} finally IntegratorExitProcess(54); end; except on e: Exception do begin IntegratorHandleException(54, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.EmailsSearchBoxKeyPress(Sender: TObject; var Key: Char);
begin{>>BWIntegrator} IntegratorEnterProcess(55); try try {BWIntegrator>>}
  DM.SearchEmails(EmailsSearchBox.Text);
{>>BWIntegrator} finally IntegratorExitProcess(55); end; except on e: Exception do begin IntegratorHandleException(55, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.ExportAcctsButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(56); try try {BWIntegrator>>}
  if ExportAcctsDialog.Execute then
  begin
    DM.AcctFDTable.SaveToFile(ExportAcctsDialog.FileName);
  end;
{>>BWIntegrator} finally IntegratorExitProcess(56); end; except on e: Exception do begin IntegratorHandleException(56, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.ExportEmailsButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(57); try try {BWIntegrator>>}
  if SaveEmailsDialog.Execute then
  begin
    DM.ExportEmails(SaveEmailsDialog.FileName);
  end;
{>>BWIntegrator} finally IntegratorExitProcess(57); end; except on e: Exception do begin IntegratorHandleException(57, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.ExportLeadsButtonClick(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(58); try try {BWIntegrator>>}
  if ExportLeadsDialog.Execute then
  begin
    DM.LeadsFDTable.SaveToFile(ExportLeadsDialog.FileName);
  end;
{>>BWIntegrator} finally IntegratorExitProcess(58); end; except on e: Exception do begin IntegratorHandleException(58, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.AppIdle(Sender: TObject; var Done: Boolean);
begin{>>BWIntegrator} IntegratorEnterProcess(59); try try {BWIntegrator>>}
  if not FRanOnce then
  begin
    FRanOnce := True;

    DM.InitializeDatabase;

    DashboardButton.SetFocus;
  end;
{>>BWIntegrator} finally IntegratorExitProcess(59); end; except on e: Exception do begin IntegratorHandleException(59, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.FormActivate(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(60); try try {BWIntegrator>>}
  if FRanOnce then
  begin
    if LeadsBindSourceDB.DataSet.State = TDataSetState.dsEdit then
      LeadsBindSourceDB.DataSet.Post;
    TBindSourceDB(BindNavigator1.DataSource).DataSet.Refresh;
  end;
{>>BWIntegrator} finally IntegratorExitProcess(60); end; except on e: Exception do begin IntegratorHandleException(60, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  StyleName: string;
begin{>>BWIntegrator} IntegratorEnterProcess(61); try try {BWIntegrator>>}
  Application.OnIdle := AppIdle;

  for StyleName in TStyleManager.StyleNames do
    VCLStylesCB.Items.Add(StyleName);

  VCLStylesCB.ItemIndex := VCLStylesCB.Items.IndexOf(TStyleManager.ActiveStyle.Name);

  UpdateNavButtons;
{>>BWIntegrator} finally IntegratorExitProcess(61); end; except on e: Exception do begin IntegratorHandleException(61, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.UpdateNavButtons;
var
  LStyle: Dword;
begin{>>BWIntegrator} IntegratorEnterProcess(62); try try {BWIntegrator>>}
  LStyle := GetWindowLong(DashboardButton.Handle, GWL_STYLE);
  SetWindowLong(DashboardButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  DashboardButton.Caption := '          '+DashboardButton.Hint;
  SetWindowLong(AcctsButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  AcctsButton.Caption := '          '+AcctsButton.Hint;
  SetWindowLong(LeadsButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  LeadsButton.Caption := '          '+LeadsButton.Hint;
  SetWindowLong(SalesButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  SalesButton.Caption := '          '+SalesButton.Hint;
  SetWindowLong(MarketingButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  MarketingButton.Caption := '          '+MarketingButton.Hint;
  SetWindowLong(CalendarButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  CalendarButton.Caption := '          '+CalendarButton.Hint;
  SetWindowLong(UsersButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  UsersButton.Caption := '          '+UsersButton.Hint;
{>>BWIntegrator} finally IntegratorExitProcess(62); end; except on e: Exception do begin IntegratorHandleException(62, e); end; end; {BWIntegrator>>}end;

procedure TMainForm.FormResize(Sender: TObject);
begin{>>BWIntegrator} IntegratorEnterProcess(63); try try {BWIntegrator>>}
  if MainForm.Width<=640 then
  begin
    if SplitView.Opened=True then SplitView.Opened := False;
  end
  else
  begin
    if SplitView.Opened=False then SplitView.Opened := True;
  end;
{>>BWIntegrator} finally IntegratorExitProcess(63); end; except on e: Exception do begin IntegratorHandleException(63, e); end; end; {BWIntegrator>>}end;

end.
