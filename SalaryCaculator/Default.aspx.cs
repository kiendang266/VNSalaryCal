using System;
using System.Xml;

namespace SalaryCaculator
{
    public partial class _Default : System.Web.UI.Page
    {
        public string ExchangeRate = string.Empty;
        public string RateUpdatedTime = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            var xmlRate = new XmlDocument();
            xmlRate.Load("http://vietcombank.com.vn/ExchangeRates/ExrateXML.aspx");
            var root = xmlRate.DocumentElement;
            if (root == null) return;

            foreach (XmlNode node in root)
            {
                if (node.Name == "DateTime")
                    RateUpdatedTime = DateTime.Parse(node.InnerText).ToString("dd/MM/yyyy H:mm:ss");
                if (node.Attributes != null && node.Attributes.Count > 0)
                    if (node.Attributes["CurrencyCode"].Value == "USD")
                        ExchangeRate = node.Attributes["Sell"].Value;
            }
        }
    }
}
