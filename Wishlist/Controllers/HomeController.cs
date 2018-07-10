using DBSupport;
using DBSupport.Interfaces;
using System.Configuration;
using System.Threading.Tasks;
using System.Web.Mvc;
using Wishlist.Services;


namespace Wishlist.Controllers
{
    public class HomeController : Controller
    {
        private IDataBaseRepository _db;
        public HomeController(IDataBaseRepository db)
        {
            this._db = db;
        }
        public async Task<ActionResult> Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                var name = UserIdentityParser.GetLogin(User.Identity);
               await  _db.SetUserIfNotExist(name);
                ViewBag.UserName = name;
                return View();
            }
            else
            {
                return View("../Home/ErrorWindowsAuthentication");
            }
        }
    }
}