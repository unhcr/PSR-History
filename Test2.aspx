<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test2.aspx.cs" Inherits="Test2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Test 2</title>
  <link href="~/Styles/PSR.css" rel="stylesheet" type="text/css" />
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
  <style type="text/css">
    .hide-RES { <%= (!displayRES) ? "display: none;" : "" %> }
    <% if (!displayOGN) { %>.hide-OGN { display:none; } <% } %>
    <% if (!displayREF) { %>.hide-REF { display:none; } <% } %>
    <% if (!displayASY) { %>.hide-ASY { display:none; } <% } %>
    <% if (!displayRET) { %>.hide-RET { display:none; } <% } %>
    <% if (!displayIDP) { %>.hide-IDP { display:none; } <% } %>
    <% if (!displayRDP) { %>.hide-RDP { display:none; } <% } %>
    <% if (!displaySTA) { %>.hide-STA { display:none; } <% } %>
    <% if (!displayOOC) { %>.hide-OOC { display:none; } <% } %>
    <% if (!displayPOC) { %>.hide-POC { display:none; } <% } %>
  </style>
</head>
<body>
  <form id="form1" runat="server">
    <asp:SqlDataSource id="dsQRY_ASR_POC_SUMMARY" runat="server"
      ConnectionString="<%$ ConnectionStrings:PSR %>" 
      ProviderName="<%$ ConnectionStrings:PSR.ProviderName %>">
      <SelectParameters>
        <asp:Parameter Name="START_YEAR" Type="String" DefaultValue="0000" />
        <asp:Parameter Name="END_YEAR" Type="String" DefaultValue="9999" />
      </SelectParameters>
    </asp:SqlDataSource>

    <div class="container">
      <div class="main-body">

        <asp:Label id="Label1" runat="server"/>

        <asp:ListView ID="lvQRY_ASR_POC_SUMMARY" runat="server" DataSourceID="dsQRY_ASR_POC_SUMMARY"
          ItemPlaceholderID="itemPlaceholder">
          <LayoutTemplate>
            <div class="centred" style="margin-bottom: 5px;">
              <asp:DataPager ID="DataPager1" runat="server">
                <Fields>
                  <asp:NextPreviousPagerField ButtonType="Button"
                    ShowFirstPageButton="true" FirstPageText="&lt;&lt;" 
                    ShowLastPageButton="true" LastPageText="&gt;&gt;"
                    NextPageText="&gt;" PreviousPageText="&lt;" />
                </Fields>
              </asp:DataPager>
            </div>
            <table class="standard-table">
              <colgroup>
                <col class="year" />
                <col class="hide-RES" />
                <col class="hide-OGN" />
                <col class="digits-9 hide-REF" />
                <col class="digits-9 hide-ASY" />
                <col class="digits-9 hide-RET" />
                <col class="digits-9 hide-IDP" />
                <col class="digits-9 hide-RDP" />
                <col class="digits-9 hide-STA" />
                <col class="digits-9 hide-OOC" />
                <col class="digits-9 hide-POC" />
              </colgroup>
              <thead>
                <tr>
                  <th>Year</th>
                  <th class="hide-RES">Country / territory of residence</th>
                  <th class="hide-OGN">Origin / Returned from</th>
                  <th class="numeric hide-REF">Refugees and people in a refugee-<wbr />like situation</th>
                  <th class="numeric hide-ASY">Asylum-seekers (pending cases)</th>
                  <th class="numeric hide-RET">Returned refugees</th>
                  <th class="numeric hide-IDP">IDPs protected / assisted by UNHCR</th>
                  <th class="numeric hide-RDP">Returned IDPs</th>
                  <th class="numeric hide-STA" title="Persons under UNHCR statelessness mandate">Stateless *</th>
                  <th class="numeric hide-OOC">Others of concern</th>
                  <th class="numeric hide-POC">Total population of concern</th>
                </tr>
              </thead>
              <tbody>
                <tr id="itemPlaceholder" runat="server">
                </tr>
              </tbody>
            </table>
            <div class="centred" style="margin-top: 5px;">
              <asp:DataPager ID="dpQRY_ASR_POC_SUMMARY" runat="server" PageSize="30">
                <Fields>
                  <asp:NumericPagerField ButtonCount="10" ButtonType="Button" /> 
                </Fields>
              </asp:DataPager>
            </div>
          </LayoutTemplate>
          <ItemTemplate>
            <tr>
              <td class="year">
                <asp:Label id="lblASR_YEAR" runat="server" Text='<%# Eval("ASR_YEAR") %>' />
              </td>
              <td class="hide-RES">
                <asp:Label id="lblCOU_NAME_RESIDENCE_EN" runat="server" Text='<%# Eval("COU_NAME_RESIDENCE_EN") %>' />
              </td>
              <td class="hide-OGN ">
                <asp:Label id="lblCOU_NAME_ORIGIN_EN" runat="server" Text='<%# Eval("COU_NAME_ORIGIN_EN") %>' />
              </td>
              <td class="numeric hide-REF">
                <asp:Label id="lblREFPOP_VALUE" runat="server" Text='<%# Eval("REFPOP_VALUE", "{0:N0}") %>' />
              </td>
              <td class="numeric hide-ASY">
                <asp:Label id="lblASYPOP_VALUE" runat="server" Text='<%# Eval("ASYPOP_VALUE", "{0:N0}") %>' />
              </td>
              <td class="numeric hide-RET">
                <asp:Label id="lblREFRTN_VALUE" runat="server" Text='<%# Eval("REFRTN_VALUE", "{0:N0}") %>' />
              </td>
              <td class="numeric hide-IDP">
                <asp:Label id="lblIDPHPOP_VALUE" runat="server" Text='<%# Eval("IDPHPOP_VALUE", "{0:N0}") %>' />
              </td>
              <td class="numeric hide-RDP">
                <asp:Label id="lblIDPHRTN_VALUE" runat="server" Text='<%# Eval("IDPHRTN_VALUE", "{0:N0}") %>' />
              </td>
              <td class="numeric hide-STA">
                <asp:Label id="lblSTAPOP_VALUE" runat="server" Text='<%# Eval("STAPOP_VALUE", "{0:N0}") %>' />
              </td>
              <td class="numeric hide-OOC">
                <asp:Label id="lblOOCPOP_VALUE" runat="server" Text='<%# Eval("OOCPOP_VALUE", "{0:N0}") %>' />
              </td>
              <td class="numeric hide-POC">
                <asp:Label id="lblTPOC_VALUE" runat="server" Text='<%# Eval("TPOC_VALUE", "{0:N0}") %>' />
              </td>
            </tr>
          </ItemTemplate>
        </asp:ListView>

      </div> <!-- /.main-body -->
    </div> <!-- /.container -->
  </form>

  <script type="text/javascript" src="Scripts/jquery.js"></script>
  <script type="text/javascript" src="Scripts/QRY1.js"></script>
</body>
</html>
