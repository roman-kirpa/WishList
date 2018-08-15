using CsQuery;
using PageSupport.Interfaces;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace PageSupport.SiteParsers
{
    public class PromUaParser : IPageParser
    {
        private CQ _htmlObjects;
        public PromUaParser(string html)
        {
            _htmlObjects = new CQ(html);
        }

        public string GetCost()
        {
            return _htmlObjects.Find("span").Where(_ => _.HasAttribute("itemprop") && _.GetAttribute("itemprop") == "price").FirstOrDefault().InnerText;
        }

        public string GetTitle()
        {
            var titleTag = _htmlObjects.Find("h1").Where(_ => _.ClassName == "x-title" && _.HasAttribute("itemprop") && _.GetAttribute("itemprop") == "name").FirstOrDefault().InnerText;
            var firstFilter = Regex.Replace(titleTag, @"<[^>]+>|&nbsp;", "").Trim();
            var secondFilter = Regex.Replace(firstFilter, @"\s{2,}", " ");
            return HttpUtility.HtmlDecode(secondFilter);
        }
    }
}