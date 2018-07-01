using DBSupport;
using System.Configuration;
using System.Web.Mvc;
using Wishlist.Services;

namespace Wishlist.Controllers
{
    public class HomeController : Controller
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        public ActionResult Index()
        {
            var db = new DBWorker(connectionString);
            if (User.Identity.IsAuthenticated)
            {
                var name = UserIdentityParser.GetLogin(User.Identity);
                db.SetUserIfNotExist(name);
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