using DBSupport;
using DBSupport.Interfaces;
using PageSupport.Interfaces;
using PageSupport.Services;
using PageSupport.SiteParsers;
using System;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web.Mvc;
using Wishlist.Services;

namespace Wishlist.Controllers
{
    public class ItemsController : Controller
    {
        private IDataBaseRepository _db;
        public ItemsController(IDataBaseRepository db)
        {
            this._db = db;
        }

        public async Task<ActionResult> Set(string url)
        {
            try
            {
                var pageService = new PageService();
                var validUrl = pageService.ValidUrl(url);
                if (!validUrl)
                {
                    return View("../Items/WrongUrl");
                }
                var html = pageService.GetPageHtml(url);
                IPageParser parser = PageParserSetter.GerParser(url, html);
            
                var item = new Item()
                {
                    UserName = UserIdentityParser.GetLogin(User.Identity),
                    DateTimeNow = DateTime.Now,
                    Title = parser.GetTitle(),
                    Cost = System.Convert.ToDecimal(parser.GetCost()),
                    Url = url
                };

               await  _db.SetItem(item);
                return View("../Home/Index");
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
                return View("../Items/WrongUrl");
            }
        }

        public async Task<ActionResult> GetItems()
        {
            var name = UserIdentityParser.GetLogin(User.Identity);
            var _itemPraser = new ItemsParser();
            var list = await _db.GetItemsByUser(name);
            var listDTO =  _itemPraser.ParseDTOItems(list);
            ViewBag.ListItems = listDTO;
            return View();
        }
    }
}