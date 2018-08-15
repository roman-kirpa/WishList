using CsQuery;
using PageSupport.Interfaces;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace PageSupport.SiteParsers
{
    public class RozetkaParser : IPageParser
    {
        private CQ _htmlObjects;
        public RozetkaParser(string html)
        {
            _htmlObjects = CQ.Create(html);
        }

        public string GetCost()
        {
            return _htmlObjects.Find("meta").Where(_ => _.HasAttribute("itemprop") && _.GetAttribute("itemprop") == "price").FirstOrDefault().GetAttribute("content");
        }

        public string GetTitle()
        {
            var titleTag = _htmlObjects.Find("H1").Where(_ => _.ClassName == "detail-title").FirstOrDefault().InnerText;
            var firstFilter = Regex.Replace(titleTag, @"<[^>]+>|&nbsp;", "").Trim();
            var secondFilter = Regex.Replace(firstFilter, @"\s{2,}", " ");
            return HttpUtility.HtmlDecode(secondFilter);
        }

    }
}