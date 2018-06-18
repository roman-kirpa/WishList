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
using Wishlist.Services;

namespace Wishlist.Controllers
{
    public class HomeController : Controller
    {

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetPage(string url)
        {
           // var url = "https://rozetka.com.ua/apple_iphone_x_64gb_silver/p22726294/";
            var rozetka = new RozetkaParser(url);

            ViewBag.titleItem = rozetka.GetTitle();
            ViewBag.price = rozetka.GetCost();
            return View();
        }

    }
}