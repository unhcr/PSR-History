<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test1.aspx.cs" Inherits="Test1" %>

<!DOCTYPE html>

<html>
<head runat="server">
  <title>Test 1</title>
  <link href="~/Styles/PSR.css" rel="stylesheet" type="text/css" />
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
</head>
<body>
  <form id="form1" runat="server">

    <asp:SqlDataSource ID="dsASR_YEAR" runat="server" 
      ConnectionString="<%$ ConnectionStrings:PSR %>" 
      ProviderName="<%$ ConnectionStrings:PSR.ProviderName %>" 
      SelectCommand="select distinct ASR_YEAR from QRY_ASR_POC_SUMMARY_EN order by ASR_YEAR desc">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="dsCOUNTRY" runat="server" 
      ConnectionString="<%$ ConnectionStrings:PSR %>" 
      ProviderName="<%$ ConnectionStrings:PSR.ProviderName %>" 
      SelectCommand=
       "select distinct COU_CODE_RESIDENCE, COU_NAME_RESIDENCE_EN, 2 as SEQ
        from QRY_ASR_POC_SUMMARY_EN
        where ASR_YEAR between :START_YEAR and :END_YEAR/*
        union all
        select 'XXXX' as COU_CODE_RESIDENCE, 'All countries' as COU_NAME_RESIDENCE_EN, 1 as SEQ
        from DUAL*/
        order by SEQ, COU_NAME_RESIDENCE_EN">
      <SelectParameters>
        <asp:ControlParameter Name="START_YEAR" ControlID="ddlSTART_YEAR" PropertyName="SelectedValue" />
        <asp:ControlParameter Name="END_YEAR" ControlID="ddlEND_YEAR" PropertyName="SelectedValue" />
      </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="dsORIGIN" runat="server" 
      ConnectionString="<%$ ConnectionStrings:PSR %>" 
      ProviderName="<%$ ConnectionStrings:PSR.ProviderName %>" 
      SelectCommand=
       "select distinct COU_CODE_ORIGIN, COU_NAME_ORIGIN_EN, 2 as SEQ
        from QRY_ASR_POC_SUMMARY_EN
        where ASR_YEAR between :START_YEAR and :END_YEAR
        union all
        select 'XXXX' as COU_CODE_ORIGIN, 'All countries' as COU_NAME_ORIGIN_EN, 1 as SEQ
        from DUAL
        order by SEQ, COU_NAME_ORIGIN_EN">
      <SelectParameters>
        <asp:ControlParameter Name="START_YEAR" ControlID="ddlSTART_YEAR" PropertyName="SelectedValue" />
        <asp:ControlParameter Name="END_YEAR" ControlID="ddlEND_YEAR" PropertyName="SelectedValue" />
      </SelectParameters>
    </asp:SqlDataSource>

    <div class="selection-box">
      <fieldset>
        <legend>Selection criteria</legend>
        <div class="date-range-selection">
          <label>Date range:</label>
          <asp:DropDownList ID="ddlSTART_YEAR" runat="server"
            DataSourceID="dsASR_YEAR" DataTextField="ASR_YEAR" DataValueField="ASR_YEAR"
            CssClass="year start-year" />
          <label>to</label>
          <asp:DropDownList ID="ddlEND_YEAR" runat="server"
            DataSourceID="dsASR_YEAR" DataTextField="ASR_YEAR" DataValueField="ASR_YEAR"
            CssClass="year end-year" />
        </div>
        <div class="country-selection">
          <label>Country of residence</label>
          <asp:ListBox ID="lbxCOUNTRY" runat="server"
            DataSourceID="dsCOUNTRY" DataTextField="COU_NAME_RESIDENCE_EN" DataValueField="COU_CODE_RESIDENCE"
            Rows="5" SelectionMode="Multiple"
            CssClass="country" ondatabound="lbxCOUNTRY_DataBound">
          </asp:ListBox>
        </div>
        <div class="country-selection">
          <label>Origin / Returned from</label>
          <asp:ListBox ID="lbxORIGIN" runat="server"
            DataSourceID="dsORIGIN" DataTextField="COU_NAME_ORIGIN_EN" DataValueField="COU_CODE_ORIGIN"
            Rows="5"
            CssClass="origin" />
        </div>
      </fieldset>
      <fieldset class="column-selection">
        <legend>Columns to display</legend>
        <div class="dimensions">
          <label><asp:CheckBox ID="cbxCOUNTRY_OF_RESIDENCE" runat="server" Checked="true" />Country of residence</label>
          <label><asp:CheckBox ID="cbxORIGIN" runat="server" Checked="true" />Origin / Returned from</label>
        </div>
        <div class="values">
          <label><asp:CheckBox ID="cbxALL_POP_TYPES" runat="server" Checked="true"/>All population types</label>
          <label><asp:CheckBox ID="cbxREF" runat="server" Checked="true" />Refugees</label>
          <label><asp:CheckBox ID="cbxASY" runat="server" Checked="true" />Asylum-seekers</label>
          <label><asp:CheckBox ID="cbxRET" runat="server" Checked="true" />Returned refugees</label>
          <label><asp:CheckBox ID="cbxIDP" runat="server" Checked="true" />IDPs</label>
          <label><asp:CheckBox ID="cbxRDP" runat="server" Checked="true" />Returned IDPs</label>
          <label><asp:CheckBox ID="cbxSTA" runat="server" Checked="true" />Stateless</label>
          <label><asp:CheckBox ID="cbxOOC" runat="server" Checked="true" />Others of concern</label>
          <label><asp:CheckBox ID="cbxALL" runat="server" Checked="true" />All persons of concern</label>
        </div>
      </fieldset>
      <div class="buttons">
        <button type="button" id="cancel">Cancel</button>
        <asp:Button ID="btnSubmit" runat="server" Text="Submit" onclick="btnSubmit_Click" />
      </div>
    </div>

    <asp:Label id="Label1" runat="server"/>

  </form>
  <script type="text/javascript" src="Scripts/jquery.js"></script>
  <script type="text/javascript" src="Scripts/QRY1.js"></script>
</body>
</html>
