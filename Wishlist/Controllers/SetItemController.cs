using DBSupport;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Wishlist.Interfaces;
using Wishlist.Services;
using Wishlist.Services.SIteParsers;

namespace Wishlist.Controllers
{
    public class SetItemController : Controller
    {
        private PageService pageService = new PageService();
        private DBWorker db;
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        public ActionResult Set(string url)
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
                db = new DBWorker(connectionString);
                var item = new Item()
                {
                    UserName = UserIdentityParser.GetLogin(User.Identity),
                    DateTimeNow = DateTime.Now,
                    Title = parser.GetTitle(),
                    Cost = System.Convert.ToDecimal(parser.GetCost()),
                    Url = url
                };

                db.SetItem(item);
                return View("../Home/Index");
            }
            catch (Exception ex)
            {
                return View("../Home/WrongUrl");
            }
        }
    }
}