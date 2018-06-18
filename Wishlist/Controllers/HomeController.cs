using CsQuery;
using DBSupport;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Principal;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using Wishlist.Interfaces;
using Wishlist.Services;
using Wishlist.Services.SIteParsers;

namespace Wishlist.Controllers
{
    public class HomeController : Controller
    {
        private PageService pageService = new PageService();
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetPage(string url)
        {
            try
            {
                var validUrl = pageService.ValidUrl(url);
                if (!validUrl)
                {
                    return View("../Home/WrongUrl");
                }
                var html = pageService.GetPageHtml(url);
                IPageParser parser = PageParserSetter.GerParser(url, html);
                ViewBag.titleItem = parser.GetTitle();
                ViewBag.price = parser.GetCost();
                return View();
            }
            catch(Exception ex)
            {
                return View("../Home/WrongUrl");
            }
        }

    }
}