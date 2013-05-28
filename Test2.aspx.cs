using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Test2 : System.Web.UI.Page
{
  // Selection criteria parameters
  string startYear;
  string endYear;
  string[] residenceCodes;
  string[] originCodes;

  // Column display parameter
  protected bool displayRES = true;
  protected bool displayOGN = true;
  protected bool displayREF = true;
  protected bool displayASY = true;
  protected bool displayRET = true;
  protected bool displayIDP = true;
  protected bool displayRDP = true;
  protected bool displaySTA = true;
  protected bool displayOOC = true;
  protected bool displayPOC = true;

  void UnpackQueryString()
  {
    // Extract selection criteria parameters from query string.
    startYear = Request.QueryString["SYR"];
    endYear = Request.QueryString["EYR"];
    if (Request.QueryString["RES"] != null)
    {
      residenceCodes = Request.QueryString["RES"].ToUpper().Split(',').Distinct().ToArray();
    }
    if (Request.QueryString["OGN"] != null)
    {
      originCodes = Request.QueryString["OGN"].ToUpper().Split(',').Distinct().ToArray();
    }

    // Extract column display parameters from query string.
    if (Request.QueryString["DRES"] != null)
    {
      displayRES = (Request.QueryString["DRES"].ToUpper() == "Y");
    }
    if (Request.QueryString["DOGN"] != null)
    {
      displayOGN = (Request.QueryString["DOGN"].ToUpper() == "Y");
    }
    if (Request.QueryString["DREF"] != null)
    {
      displayREF = (Request.QueryString["DREF"].ToUpper() == "Y");
    }
    if (Request.QueryString["DASY"] != null)
    {
      displayASY = (Request.QueryString["DASY"].ToUpper() == "Y");
    }
    if (Request.QueryString["DRET"] != null)
    {
      displayRET = (Request.QueryString["DRET"].ToUpper() == "Y");
    }
    if (Request.QueryString["DIDP"] != null)
    {
      displayIDP = (Request.QueryString["DIDP"].ToUpper() == "Y");
    }
    if (Request.QueryString["DRDP"] != null)
    {
      displayRDP = (Request.QueryString["DRDP"].ToUpper() == "Y");
    }
    if (Request.QueryString["DSTA"] != null)
    {
      displaySTA = (Request.QueryString["DSTA"].ToUpper() == "Y");
    }
    if (Request.QueryString["DOOC"] != null)
    {
      displayOOC = (Request.QueryString["DOOC"].ToUpper() == "Y");
    }
    if (Request.QueryString["DPOC"] != null)
    {
      displayPOC = (Request.QueryString["DPOC"].ToUpper() == "Y");
    }
  }

  void ConstructSelectStatement()
  {
    var selectStatement =
      new StringBuilder("select ASR_YEAR, COU_NAME_RESIDENCE_EN, COU_NAME_ORIGIN_EN, " +
        "REFPOP_VALUE, ASYPOP_VALUE, REFRTN_VALUE, IDPHPOP_VALUE, IDPHRTN_VALUE, STAPOP_VALUE, " +
        "OOCPOP_VALUE, TPOC_VALUE from (select ASR_YEAR, ",
        1000);

    var countryCodePattern = new Regex("^[A-Z]{3}$");  // Regular expression to validate ISO country codes

    selectStatement.Append((displayRES ? "" : "null as ") + "COU_NAME_RESIDENCE_EN, ");
    selectStatement.Append((displayOGN ? "" : "null as ") + "COU_NAME_ORIGIN_EN, ");
    selectStatement.Append((displayREF ? "sum(REFPOP_VALUE)" : "null") + " as REFPOP_VALUE, ");
    selectStatement.Append((displayASY ? "sum(ASYPOP_VALUE)" : "null") + " as ASYPOP_VALUE, ");
    selectStatement.Append((displayRET ? "sum(REFRTN_VALUE)" : "null") + " as REFRTN_VALUE, ");
    selectStatement.Append((displayIDP ? "sum(IDPHPOP_VALUE)" : "null") + " as IDPHPOP_VALUE, ");
    selectStatement.Append((displayRDP ? "sum(IDPHRTN_VALUE)" : "null") + " as IDPHRTN_VALUE, ");
    selectStatement.Append((displaySTA ? "sum(STAPOP_VALUE)" : "null") + " as STAPOP_VALUE, ");
    selectStatement.Append((displayOOC ? "sum(OOCPOP_VALUE)" : "null") + " as OOCPOP_VALUE, ");
    selectStatement.Append((displayPOC ?
        "sum(nvl(REFPOP_VALUE,0) + nvl(ASYPOP_VALUE,0) + nvl(REFRTN_VALUE,0) + " +
          "nvl(IDPHPOP_VALUE,0) + nvl(IDPHRTN_VALUE,0) + nvl(STAPOP_VALUE,0) + nvl(OOCPOP_VALUE,0))" :
        "null") +
      " as TPOC_VALUE from QRY_ASR_POC_SUMMARY_EN where ASR_YEAR between :START_YEAR and :END_YEAR ");
    if (residenceCodes != null)
    {
      selectStatement.Append("and COU_CODE_RESIDENCE in ('");
      foreach (string code in residenceCodes)
      {
        if (countryCodePattern.IsMatch(code))
        {
          selectStatement.Append("','" + code);
        }
      }
      selectStatement.Append("') ");
    }
    if (originCodes != null)
    {
      selectStatement.Append("and COU_CODE_ORIGIN in ('");
      foreach (string code in originCodes)
      {
        if (countryCodePattern.IsMatch(code))
        {
          selectStatement.Append("','" + code);
        }
      }
      selectStatement.Append("') ");
    }
    selectStatement.Append("group by ASR_YEAR");
    if (displayRES)
    {
      selectStatement.Append(", COU_NAME_RESIDENCE_EN");
    }
    if (displayOGN)
    {
      selectStatement.Append(", COU_NAME_ORIGIN_EN");
    }
    selectStatement.Append(") where coalesce(REFPOP_VALUE, ASYPOP_VALUE, REFRTN_VALUE, " +
      "IDPHPOP_VALUE, IDPHRTN_VALUE, STAPOP_VALUE, OOCPOP_VALUE, TPOC_VALUE) is not null " +
      "order by ASR_YEAR desc");
    if (displayRES)
    {
      selectStatement.Append(", COU_NAME_RESIDENCE_EN");
    }
    if (displayOGN)
    {
      selectStatement.Append(", COU_NAME_ORIGIN_EN");
    }

    dsQRY_ASR_POC_SUMMARY.SelectCommand = selectStatement.ToString();
    
    foreach (Parameter param in dsQRY_ASR_POC_SUMMARY.SelectParameters)
    {
      switch (param.Name)
      {
        case "START_YEAR":
          param.DefaultValue = startYear;
          break;
        case "END_YEAR":
          param.DefaultValue = endYear;
          break;
      }
    }

    //Label1.Text = dsQRY_ASR_POC_SUMMARY.SelectCommand + "<br />" + startYear + " / " + endYear;
  }

  protected void Page_Load(object sender, EventArgs e)
  {
    UnpackQueryString();
    ConstructSelectStatement();
    //if (this.IsPostBack)
    //{
    //}
    //else
    //{
    //  // Get query parameters from query string if present, otherwise display selection dialog.
    //  if (Request.QueryString.Count > 0)
    //  {
    //    UnpackQueryString();
    //    ConstructSelectStatement();
    //  }
    //  else
    //  {
    //    // Display selection dialog
    //  }

    //  // Debugging code
    //  //var countryCodePattern = new Regex("^[A-Z]{3}$");  // Regular expression to validate ISO country codes
    //  //Label1.Text = startYear + "<br />" + endYear + "<br />";
    //  //if (residenceCodes != null)
    //  //{
    //  //  Label1.Text += "and COU_CODE_RESIDENCE in ('";
    //  //  foreach (string code in residenceCodes)
    //  //  {
    //  //    if (countryCodePattern.IsMatch(code))
    //  //    {
    //  //      Label1.Text += "','" + code;
    //  //    }
    //  //  }
    //  //  Label1.Text += "') ";
    //  //}
    //  //Label1.Text += "<br />";
    //  //if (originCodes != null)
    //  //{
    //  //  Label1.Text += "and COU_CODE_ORIGIN in ('";
    //  //  foreach (string code in originCodes)
    //  //  {
    //  //    if (countryCodePattern.IsMatch(code))
    //  //    {
    //  //      Label1.Text += "','" + code;
    //  //    }
    //  //  }
    //  //  Label1.Text += "') ";
    //  //}
    //  //Label1.Text += "<br />";
    //  //Label1.Text += displayRES.ToString() + " / ";
    //  //Label1.Text += displayOGN.ToString() + " / ";
    //  //Label1.Text += displayREF.ToString() + " / ";
    //  //Label1.Text += displayASY.ToString() + " / ";
    //  //Label1.Text += displayRET.ToString() + " / ";
    //  //Label1.Text += displayIDP.ToString() + " / ";
    //  //Label1.Text += displayRDP.ToString() + " / ";
    //  //Label1.Text += displaySTA.ToString() + " / ";
    //  //Label1.Text += displayOOC.ToString() + " / ";
    //  //Label1.Text += displayPOC.ToString();
    //  //Label1.Text += "<br />";
    //  // End of debugging code
    //}
  }
}