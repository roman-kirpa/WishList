using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Wishlist.Interfaces;

namespace Wishlist.Services.SIteParsers
{
    public static class PageParserSetter
    {
        public static IPageParser GerParser(string url, string html)
        {
            if (url.Contains("prom.ua"))
            {
                return new PromUaParser(html);
            }
            else if (url.Contains("rozetka.com.ua/"))
            {
                return new RozetkaParser(html);
            }
            else return new DefaultParser();
        }
    }
}