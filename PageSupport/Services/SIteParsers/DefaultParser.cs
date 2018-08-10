using CsQuery;
using PageSupport.Interfaces;
using System;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace PageSupport.SiteParsers
{
    public class DefaultParser : IPageParser
    {
        private CQ htmlObjects;
        public DefaultParser(string html)
        {
            htmlObjects = CQ.Create(html);
        }
        public string GetCost()
        {
            return htmlObjects.Find("font").Where(_ => _.ClassName == "price").FirstOrDefault().InnerText;
        }

        public string GetTitle()
        {
            var titleTag = htmlObjects.Find("H1").Where(_ => _.ClassName == "title").FirstOrDefault().InnerText;
            var firstFilter = Regex.Replace(titleTag, @"<[^>]+>|&nbsp;", "").Trim();
            var secondFilter = Regex.Replace(firstFilter, @"\s{2,}", " ");
            return HttpUtility.HtmlDecode(secondFilter);
        }
    }
}