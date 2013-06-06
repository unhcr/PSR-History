<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/PSQ.master" 
  Title="UNHCR Population Statistics" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderPlaceHolder" Runat="Server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyPlaceHolder" Runat="Server">

  <asp:SqlDataSource ID="dsCOUNTRY" runat="server" 
    ConnectionString="<%$ ConnectionStrings:PSR %>" 
    ProviderName="<%$ ConnectionStrings:PSR.ProviderName %>"
    SelectCommand=
      "select distinct COU_CODE_RESIDENCE, COU_NAME_RESIDENCE_EN
       from ASR_POC_SUMMARY_EN
       where COU_CODE_RESIDENCE not in ('TCD','CHN','DEU','IRN','JOR','KEN','PAK','SYR','GBR','TZA','USA')
       order by COU_NAME_RESIDENCE_EN" />

  <asp:SqlDataSource ID="dsORIGIN" runat="server" 
    ConnectionString="<%$ ConnectionStrings:PSR %>" 
    ProviderName="<%$ ConnectionStrings:PSR.ProviderName %>"
    SelectCommand=
      "select distinct COU_CODE_ORIGIN, COU_NAME_ORIGIN_EN
       from ASR_POC_SUMMARY_EN
       where COU_CODE_ORIGIN not in ('AFG','BDI','COL','COD','ERI','IRQ','PSE','SOM','SYR','TUR','VNM')
       order by COU_NAME_ORIGIN_EN" />

  <div class="main-body">
    <h1>Frequently Requested Statistics: Quick Queries</h1>
    <div class="frs">
    <div class="residing">
      <h2>By country / territory of asylum</h2>
      <h3>Refugees residing in:</h3>
      <ul>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=TCD&POPT=RF&DRES=N&DPOPT=N" target="_blank">Chad</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=CHN&POPT=RF&DRES=N&DPOPT=N" target="_blank">China</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=DEU&POPT=RF&DRES=N&DPOPT=N" target="_blank">Germany</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=IRN&POPT=RF&DRES=N&DPOPT=N" target="_blank">Islamic Republic of Iran</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=JOR&POPT=RF&DRES=N&DPOPT=N" target="_blank">Jordan</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=KEN&POPT=RF&DRES=N&DPOPT=N" target="_blank">Kenya</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=PAK&POPT=RF&DRES=N&DPOPT=N" target="_blank">Pakistan</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=SYR&POPT=RF&DRES=N&DPOPT=N" target="_blank">Syrian Arab Republic</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=GBR&POPT=RF&DRES=N&DPOPT=N" target="_blank">United Kingdom</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=TZA&POPT=RF&DRES=N&DPOPT=N" target="_blank">United Republic of Tanzania</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&RES=USA&POPT=RF&DRES=N&DPOPT=N" target="_blank">United States</a></li>
        <li>
          <asp:DropDownList ID="lbxCOUNTRY" runat="server" ViewStateMode="Disabled" 
            DataSourceID="dsCOUNTRY" DataTextField="COU_NAME_RESIDENCE_EN" DataValueField="COU_CODE_RESIDENCE" 
            OnDataBound="lbxCOUNTRY_DataBound" CssClass="country" />
        </li>
      </ul>
    </div>
    <div class="origin">
      <h2>By origin</h2>
      <h3>Refugees from:</h3>
      <ul>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=AFG&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Afghanistan</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=BDI&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Burundi</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=COL&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Colombia</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=COD&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Democratic Republic of the Congo</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=ERI&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Eritrea</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=IRQ&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Iraq</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=PSE&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Occupied Palestinian Territory</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=SOM&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Somalia</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=SYR&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Syrian Arab Republic</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=TUR&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Turkey</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&OGN=VNM&POPT=RF&DOGN=N&DPOPT=N" target="_blank">Viet Nam</a></li>
        <li>
          <asp:DropDownList ID="lbxORIGIN" runat="server" ViewStateMode="Disabled" 
            DataSourceID="dsORIGIN" DataTextField="COU_NAME_ORIGIN_EN" DataValueField="COU_CODE_ORIGIN" 
            OnDataBound="lbxORIGIN_DataBound" CssClass="origin" />
        </li>
      </ul>
    </div>
    <div class="others">
      <ul>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&POPT=ID&DOGN=N&DPOPT=N" target="_blank">Internally displaced persons protected/assisted by UNHCR</a></li>
        <li><a href="PSQ_TMS.aspx?SYR=2000&EYR=2012&POPT=ST&DOGN=N&DPOPT=N" target="_blank">Persons falling under UNHCR's statelessness mandate</a></li>
      </ul>
    </div>
  </div>
  </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptPlaceHolder" Runat="Server">
  <script type="text/javascript" src="Scripts/PSQ.js"></script>
</asp:Content>