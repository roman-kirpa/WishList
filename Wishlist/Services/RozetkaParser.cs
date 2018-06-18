using CsQuery;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using Wishlist.Interfaces;

namespace Wishlist.Services
{
    public class RozetkaParser : IPageParser
    {
        private string _html;
        private RESTService rest = new RESTService();
        private CQ htmlObjects;
        // "https://rozetka.com.ua/apple_iphone_x_64gb_silver/p22726294/";
        public RozetkaParser(string url)
        {
            this._html = rest.GetPageHtml(url);
            htmlObjects = CQ.Create(_html);
        }

        public string GetCost()
        {
           return htmlObjects.Find("meta").Where(_ => _.HasAttribute("itemprop") && _.GetAttribute("itemprop") == "price").FirstOrDefault().GetAttribute("content");
        }

        public string GetTitle()
        {
            var titleTag = htmlObjects.Find("H1").Where(_ => _.ClassName == "detail-title").FirstOrDefault().InnerText;
            var firstFilter = Regex.Replace(titleTag, @"<[^>]+>|&nbsp;", "").Trim();
            var secondFilter = Regex.Replace(firstFilter, @"\s{2,}", " ");
            return HttpUtility.HtmlDecode(secondFilter);
        }

    }
}