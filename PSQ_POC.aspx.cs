using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

[Serializable]
public class SelectionCriteriaPOC
{
  public string StartYear { get; set; }
  public string EndYear { get; set; }

  List<string> residenceCodes = new List<string>();
  public List<string> ResidenceCodes
  {
    get { return residenceCodes; }
    set { residenceCodes = value; }
  }

  List<string> originCodes = new List<string>();
  public List<string> OriginCodes
  {
    get { return originCodes; }
    set { originCodes = value; }
  }

  public bool ShowRES { get; set; }
  public bool ShowOGN { get; set; }
  public bool ShowREF { get; set; }
  public bool ShowASY { get; set; }
  public bool ShowRET { get; set; }
  public bool ShowIDP { get; set; }
  public bool ShowRDP { get; set; }
  public bool ShowSTA { get; set; }
  public bool ShowOOC { get; set; }
  public bool ShowPOC { get; set; }

  static Regex countryCodePattern = new Regex("^[A-Z]{3}$");  // Regular expression to validate ISO country codes

  public SelectionCriteriaPOC()
  {
    StartYear = "1950";
    EndYear = "9999";
    ResidenceCodes = new List<string>();
    OriginCodes = new List<string>();
    ShowRES = true;
    ShowOGN = true;
    ShowREF = true;
    ShowASY = true;
    ShowRET = true;
    ShowIDP = true;
    ShowRDP = true;
    ShowSTA = true;
    ShowOOC = true;
    ShowPOC = true;
  }

  public SelectionCriteriaPOC(string startYear, string endYear,
    ListItemCollection residenceCodes, ListItemCollection originCodes,
    bool showRES, bool showOGN, bool showREF, bool showASY, bool showRET,
    bool showIDP, bool showRDP, bool showSTA, bool showOOC, bool showPOC)
  {
    StartYear = startYear;
    EndYear = endYear;
    foreach (ListItem item in residenceCodes)
    {
      if (item.Selected && countryCodePattern.IsMatch(item.Value))
      {
        this.AddResidenceCode(item.Value);
      }
    }
    foreach (ListItem item in originCodes)
    {
      if (item.Selected && countryCodePattern.IsMatch(item.Value))
      {
        this.AddOriginCode(item.Value);
      }
    }
    ShowRES = showRES;
    ShowOGN = showOGN;
    ShowREF = showREF;
    ShowASY = showASY;
    ShowRET = showRET;
    ShowIDP = showIDP;
    ShowRDP = showRDP;
    ShowSTA = showSTA;
    ShowOOC = showOOC;
    ShowPOC = showPOC;
  }

  public void AddResidenceCode(string code)
  {
    if (countryCodePattern.IsMatch(code))
    {
      residenceCodes.Add(code);
    }
  }

  public void AddOriginCode(string code)
  {
    if (countryCodePattern.IsMatch(code))
    {
      originCodes.Add(code);
    }
  }
}

public partial class PSQ_POC : System.Web.UI.Page
{
  protected SelectionCriteriaPOC selectionCriteria = new SelectionCriteriaPOC();

  protected bool selectionMode = false;

  void SaveToViewState()
  {
    ViewState["SelectionCriteria"] = selectionCriteria;
  }

  void RestoreFromViewState()
  {
    selectionCriteria = (SelectionCriteriaPOC)ViewState["SelectionCriteria"];
  }
  
  void UnpackQueryString()
  {
    // Extract selection criteria parameters from query string.
    if (Request.QueryString["SYR"] != null)
    {
      selectionCriteria.StartYear = Request.QueryString["SYR"];
    }
    if (Request.QueryString["EYR"] != null)
    {
      selectionCriteria.EndYear = Request.QueryString["EYR"];
    }

    if (Request.QueryString["RES"] != null)
    {
      foreach (string code in Request.QueryString["RES"].ToUpper().Split(',').Distinct())
      {
        selectionCriteria.AddResidenceCode(code);
      }
    }
    if (Request.QueryString["OGN"] != null)
    {
      foreach (string code in Request.QueryString["OGN"].ToUpper().Split(',').Distinct())
      {
        selectionCriteria.AddOriginCode(code);
      }
    }

    // Extract column display parameters from query string.
    if (Request.QueryString["DRES"] != null)
    {
      selectionCriteria.ShowRES = (Request.QueryString["DRES"].ToUpper() != "N");
    }
    if (Request.QueryString["DOGN"] != null)
    {
      selectionCriteria.ShowOGN = (Request.QueryString["DOGN"].ToUpper() != "N");
    }
    if (Request.QueryString["DREF"] != null)
    {
      selectionCriteria.ShowREF = (Request.QueryString["DREF"].ToUpper() != "N");
    }
    if (Request.QueryString["DASY"] != null)
    {
      selectionCriteria.ShowASY = (Request.QueryString["DASY"].ToUpper() != "N");
    }
    if (Request.QueryString["DRET"] != null)
    {
      selectionCriteria.ShowRET = (Request.QueryString["DRET"].ToUpper() != "N");
    }
    if (Request.QueryString["DIDP"] != null)
    {
      selectionCriteria.ShowIDP = (Request.QueryString["DIDP"].ToUpper() != "N");
    }
    if (Request.QueryString["DRDP"] != null)
    {
      selectionCriteria.ShowRDP = (Request.QueryString["DRDP"].ToUpper() != "N");
    }
    if (Request.QueryString["DSTA"] != null)
    {
      selectionCriteria.ShowSTA = (Request.QueryString["DSTA"].ToUpper() != "N");
    }
    if (Request.QueryString["DOOC"] != null)
    {
      selectionCriteria.ShowOOC = (Request.QueryString["DOOC"].ToUpper() != "N");
    }
    if (Request.QueryString["DPOC"] != null)
    {
      selectionCriteria.ShowPOC = (Request.QueryString["DPOC"].ToUpper() != "N");
    }
  }

  SelectionCriteriaPOC GetSelectionDialog()
  {
    return new SelectionCriteriaPOC(ddlSTART_YEAR.Text, ddlEND_YEAR.Text,
      lbxCOUNTRY.Items, lbxORIGIN.Items,
      cbxRES.Checked, cbxOGN.Checked, cbxREF.Checked, cbxASY.Checked, cbxRET.Checked,
      cbxIDP.Checked, cbxRDP.Checked, cbxSTA.Checked, cbxOOC.Checked, cbxPOC.Checked);
  }

  void SetSelectionDialog()
  {
    ddlSTART_YEAR.SelectedValue = selectionCriteria.StartYear;
    ddlEND_YEAR.SelectedValue = selectionCriteria.EndYear;
    cbxRES.Checked = selectionCriteria.ShowRES;
    cbxOGN.Checked = selectionCriteria.ShowOGN;
    cbxREF.Checked = selectionCriteria.ShowREF;
    cbxASY.Checked = selectionCriteria.ShowASY;
    cbxRET.Checked = selectionCriteria.ShowRET;
    cbxIDP.Checked = selectionCriteria.ShowIDP;
    cbxRDP.Checked = selectionCriteria.ShowRDP;
    cbxSTA.Checked = selectionCriteria.ShowSTA;
    cbxOOC.Checked = selectionCriteria.ShowOOC;
    cbxPOC.Checked = selectionCriteria.ShowPOC;
  }

  void ConstructSelectStatement()
  {
    var selectStatement =
      new StringBuilder("select ASR_YEAR, COU_NAME_RESIDENCE_EN, COU_NAME_ORIGIN_EN, " +
        "REFPOP_VALUE, ASYPOP_VALUE, REFRTN_VALUE, IDPHPOP_VALUE, IDPHRTN_VALUE, STAPOP_VALUE, " +
        "OOCPOP_VALUE, TPOC_VALUE from (select ASR_YEAR, ",
        1000);

    selectStatement.Append((selectionCriteria.ShowRES ? String.Empty : "null as ") + "COU_NAME_RESIDENCE_EN, ");
    selectStatement.Append((selectionCriteria.ShowOGN ? String.Empty : "null as ") + "COU_NAME_ORIGIN_EN, ");
    selectStatement.Append((selectionCriteria.ShowREF ? "sum(REFPOP_VALUE)" : "null") + " as REFPOP_VALUE, ");
    selectStatement.Append((selectionCriteria.ShowASY ? "sum(ASYPOP_VALUE)" : "null") + " as ASYPOP_VALUE, ");
    selectStatement.Append((selectionCriteria.ShowRET ? "sum(REFRTN_VALUE)" : "null") + " as REFRTN_VALUE, ");
    selectStatement.Append((selectionCriteria.ShowIDP ? "sum(IDPHPOP_VALUE)" : "null") + " as IDPHPOP_VALUE, ");
    selectStatement.Append((selectionCriteria.ShowRDP ? "sum(IDPHRTN_VALUE)" : "null") + " as IDPHRTN_VALUE, ");
    selectStatement.Append((selectionCriteria.ShowSTA ? "sum(STAPOP_VALUE)" : "null") + " as STAPOP_VALUE, ");
    selectStatement.Append((selectionCriteria.ShowOOC ? "sum(OOCPOP_VALUE)" : "null") + " as OOCPOP_VALUE, ");
    selectStatement.Append((selectionCriteria.ShowPOC ?
        "sum(nvl(REFPOP_VALUE,0) + nvl(ASYPOP_VALUE,0) + nvl(REFRTN_VALUE,0) + " +
          "nvl(IDPHPOP_VALUE,0) + nvl(IDPHRTN_VALUE,0) + nvl(STAPOP_VALUE,0) + nvl(OOCPOP_VALUE,0))" :
        "null") + " as TPOC_VALUE ");
    selectStatement.Append("from QRY_ASR_POC_SUMMARY_EN where ASR_YEAR between :START_YEAR and :END_YEAR ");
    if (selectionCriteria.ResidenceCodes != null && selectionCriteria.ResidenceCodes.Count > 0)
    {
      selectStatement.Append("and COU_CODE_RESIDENCE in ('");
      foreach (string code in selectionCriteria.ResidenceCodes)
      {
        selectStatement.Append("','" + code);
      }
      selectStatement.Append("') ");
    }
    if (selectionCriteria.OriginCodes != null && selectionCriteria.OriginCodes.Count > 0)
    {
      selectStatement.Append("and COU_CODE_ORIGIN in ('");
      foreach (string code in selectionCriteria.OriginCodes)
      {
        selectStatement.Append("','" + code);
      }
      selectStatement.Append("') ");
    }
    selectStatement.Append("group by ASR_YEAR");
    if (selectionCriteria.ShowRES)
    {
      selectStatement.Append(", COU_NAME_RESIDENCE_EN");
    }
    if (selectionCriteria.ShowOGN)
    {
      selectStatement.Append(", COU_NAME_ORIGIN_EN");
    }
    selectStatement.Append(") where coalesce(REFPOP_VALUE, ASYPOP_VALUE, REFRTN_VALUE, " +
      "IDPHPOP_VALUE, IDPHRTN_VALUE, STAPOP_VALUE, OOCPOP_VALUE, TPOC_VALUE) is not null " +
      "order by ASR_YEAR desc");
    if (selectionCriteria.ShowRES)
    {
      selectStatement.Append(", COU_NAME_RESIDENCE_EN");
    }
    if (selectionCriteria.ShowOGN)
    {
      selectStatement.Append(", COU_NAME_ORIGIN_EN");
    }

    dsQRY_ASR_POC_SUMMARY.SelectCommand = selectStatement.ToString();

    foreach (Parameter param in dsQRY_ASR_POC_SUMMARY.SelectParameters)
    {
      switch (param.Name)
      {
        case "START_YEAR":
          param.DefaultValue = selectionCriteria.StartYear;
          break;
        case "END_YEAR":
          param.DefaultValue = selectionCriteria.EndYear;
          break;
      }
    }

    //Label1.Text = selectStatement.ToString() + "<br />" +
    //  selectionCriteria.StartYear + " / " + selectionCriteria.EndYear + "<br />" +
    //  DateTime.Now;
  }

  protected void Page_Load(object sender, EventArgs e)
  {
    if (IsPostBack)
    {
      RestoreFromViewState();
    }
    else if (Request.QueryString.Count > 0)
    {
      UnpackQueryString();
    }
    else
    {
      selectionMode = true;
    }
  }

  protected void Page_PreRender(Object sender, EventArgs e)
  {
    SaveToViewState();
    if (!selectionMode)
    {
      ConstructSelectStatement();
    }
  }

  protected void ddlPageRows_SelectedIndexChanged(Object sender, EventArgs e)
  {
    if (ddlPageRows.SelectedValue == "0")
    {
      // Switch off paging. Note that 966367641 is the largest page size accepted without misbehaviour of the DataPager.
      dpgQRY_ASR_POC_SUMMARY1.PageSize = 966367641;
      dpgQRY_ASR_POC_SUMMARY2.PageSize = 966367641;
    }
    else
    {
      dpgQRY_ASR_POC_SUMMARY1.PageSize = Convert.ToInt32(ddlPageRows.SelectedValue);
      dpgQRY_ASR_POC_SUMMARY2.PageSize = Convert.ToInt32(ddlPageRows.SelectedValue);
    }
  }
  
  protected void btnSubmit_Click(object sender, EventArgs e)
  {
    selectionCriteria = GetSelectionDialog();

    dpgQRY_ASR_POC_SUMMARY1.SetPageProperties(0, Convert.ToInt32(ddlPageRows.SelectedValue), true);
    dpgQRY_ASR_POC_SUMMARY2.SetPageProperties(0, Convert.ToInt32(ddlPageRows.SelectedValue), true);
    
    selectionMode = false;
  }

  protected void btnNewQuery_Click(object sender, EventArgs e)
  {
    SetSelectionDialog();
    selectionMode = true;
  }

  protected void btnCSV_Click(object sender, EventArgs e)
  {
    StringBuilder csv = new StringBuilder();

    csv.Append("Year");
    if (selectionCriteria.ShowRES)
    {
      csv.Append(",Country/territory of residence");
    }
    if (selectionCriteria.ShowOGN)
    {
      csv.Append(",Origin / Returned from");
    }
    if (selectionCriteria.ShowREF)
    {
      csv.Append(",Refugees");
    }
    if (selectionCriteria.ShowASY)
    {
      csv.Append(",Asylum seekers");
    }
    if (selectionCriteria.ShowRET)
    {
      csv.Append(",Returned refugees");
    }
    if (selectionCriteria.ShowIDP)
    {
      csv.Append(",IDPs");
    }
    if (selectionCriteria.ShowRDP)
    {
      csv.Append(",Returned IDPs");
    }
    if (selectionCriteria.ShowSTA)
    {
      csv.Append(",Stateless");
    }
    if (selectionCriteria.ShowOOC)
    {
      csv.Append(",Others of concern");
    }
    if (selectionCriteria.ShowPOC)
    {
      csv.Append(",Total population");
    }
    csv.AppendLine();

    ConstructSelectStatement();

    foreach (DataRow row in ((DataView)dsQRY_ASR_POC_SUMMARY.Select(DataSourceSelectArguments.Empty)).ToTable().Rows)
    {
      csv.Append(row.ItemArray[0]);
      if (selectionCriteria.ShowRES)
      {
        if (((String)(row.ItemArray[1])).Contains(","))
        {
          csv.Append(",\"" + ((String)(row.ItemArray[1])).Replace("\"", "\"\"") + "\"");
        }
        else
        {
          csv.Append("," + row.ItemArray[1]);
        }
      }
      if (selectionCriteria.ShowOGN)
      {
        if (((String)(row.ItemArray[2])).Contains(","))
        {
          csv.Append(",\"" + ((String)(row.ItemArray[2])).Replace("\"", "\"\"") + "\"");
        }
        else
        {
          csv.Append("," + row.ItemArray[2]);
        }
      }
      if (selectionCriteria.ShowREF)
      {
        csv.Append("," + row.ItemArray[3]);
      }
      if (selectionCriteria.ShowASY)
      {
        csv.Append("," + row.ItemArray[4]);
      }
      if (selectionCriteria.ShowRET)
      {
        csv.Append("," + row.ItemArray[5]);
      }
      if (selectionCriteria.ShowIDP)
      {
        csv.Append("," + row.ItemArray[6]);
      }
      if (selectionCriteria.ShowRDP)
      {
        csv.Append("," + row.ItemArray[7]);
      }
      if (selectionCriteria.ShowSTA)
      {
        csv.Append("," + row.ItemArray[8]);
      }
      if (selectionCriteria.ShowOOC)
      {
        csv.Append("," + row.ItemArray[9]);
      }
      if (selectionCriteria.ShowPOC)
      {
        csv.Append("," + row.ItemArray[10]);
      }
      csv.AppendLine();
    }

    Response.Clear();
    Response.AddHeader("content-disposition", "attachment; filename=PSQ_POC.csv");
    Response.ContentType = "application/csv";
    Response.ContentEncoding = Encoding.UTF8;
    Response.BinaryWrite(Encoding.UTF8.GetPreamble());
    Response.Write(csv.ToString());
    Response.End();
  }

  protected void lbxCOUNTRY_DataBound(object sender, EventArgs e)
  {
    lbxCOUNTRY.Items.Insert(0, new ListItem { Text = "All countries / territories", Value = "0", Selected = true });
  }

  protected void lbxORIGIN_DataBound(object sender, EventArgs e)
  {
    lbxORIGIN.Items.Insert(0, new ListItem { Text = "All origins", Value = "0", Selected = true });
  }

  protected void lvwQRY_ASR_POC_SUMMARY_DataBound(object sender, EventArgs e)
  {
    lblNoData.Visible = (dpgQRY_ASR_POC_SUMMARY1.TotalRowCount == 0);
    lblPager.Visible = (dpgQRY_ASR_POC_SUMMARY1.TotalRowCount > 0);
    btnCSV.Visible = (dpgQRY_ASR_POC_SUMMARY1.TotalRowCount > 0);
    dpgQRY_ASR_POC_SUMMARY2.Visible = (dpgQRY_ASR_POC_SUMMARY2.TotalRowCount > dpgQRY_ASR_POC_SUMMARY2.PageSize);
  }

}