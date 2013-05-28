using System;
using System.Drawing;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Test1 : System.Web.UI.Page
{
  protected void Page_Load(object sender, EventArgs e)
  {
    if (this.IsPostBack)
    {
      //Get query parameters from page controls
    }
    else
    {
      //Get query parameters from query string if present, otherwise display selection dialog
    }
  }

  protected void btnSubmit_Click(object sender, EventArgs e)
  {
    string msg = "where ID in ";
    string sep = "(";
    foreach (ListItem li in lbxCOUNTRY.Items)
    {
      if (li.Selected)
      {
        msg += sep + li.Value;
        sep = ", ";
      }
    }
    msg += ")";
    Label1.Text = msg;
  }
  protected void lbxCOUNTRY_DataBound(object sender, EventArgs e)
  {
    //lbxCOUNTRY.Items.Insert(0, new ListItem("All countries", "0"));
    //lbxCOUNTRY.Items[0].Selected = true;
    lbxCOUNTRY.Items.Insert(0, new ListItem { Text = "All countries", Value = "0", Selected = false });
  }
}