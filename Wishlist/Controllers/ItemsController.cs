using DBSupport;
using DBSupport.Interfaces;
using PageSupport.CustomExceptions;
using PageSupport.Interfaces;
using PageSupport.Services;
using PageSupport.SiteParsers;
using System;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web.Mvc;
using Wishlist.Services;
using SimpleLogger;

namespace Wishlist.Controllers
{
    public class ItemsController : Controller
    {
        private IUserItemsRepository _db;

        public ItemsController(IUserItemsRepository db)
        {
            this._db = db;
        }

        [HttpGet]
        public async Task<ActionResult> Set(string url)
        {
            try
            {
                var pageService = new PageService();
                var validUrl = pageService.IsUrlValid(url);
                if (!validUrl)
                {
                    return View("../Items/WrongUrl");
                }
                var html = pageService.GetPageHtml(url);

                try
                {
                    IPageParser parser = PageParserSetter.GerParser(url, html);

                    var item = new Product()
                    {
                        UserName = UserIdentityParser.GetLogin(User.Identity),
                        DateTimeNow = DateTime.Now,
                        Title = parser.GetTitle(),
                        Cost = System.Convert.ToDecimal(parser.GetCost()),
                        Url = url
                    };

                    if (await _db.SetItem(item)) {
                        return View("../Home/Index");
                    }
                    else
                    {
                        return View("../Items/NotSupportedSite");
                    }
                   
                }
                catch (SiteNotSupported ex)
                {
                    return View("../Items/NotSupportedSite");
                }
                
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627)
                {
                    return View("../Items/DublicateItem"); ;
                }
                else return View("../Items/WrongUrl");
            }
            catch (Exception ex)
            {
                await Logger.Log(ex);
                return View("../Items/WrongUrl");
            }
        }

        public async Task<ActionResult> GetItems()
        {
            var name = UserIdentityParser.GetLogin(User.Identity);
            var _itemPraser = new ItemsParser();
            var list = await _db.GetItemsByUserName(name);
            var listDTO =  _itemPraser.ParseDTOItems(list);
            ViewBag.ListItems = listDTO;
            return View();
        }
    }
}