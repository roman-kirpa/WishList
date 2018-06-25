using CsQuery;
using DBSupport;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
        private DBWorker db;
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        public ActionResult Index()
        {
            db = new DBWorker(connectionString);
            if (User.Identity.IsAuthenticated)
            {
                db.SetUserIfNotExist(UserIdentityParser.GetLogin(User.Identity));
                return View();
            }
            else
            {
                return View("../Home/ErrorWindowsAuthentication");
            }
        }
    }
}