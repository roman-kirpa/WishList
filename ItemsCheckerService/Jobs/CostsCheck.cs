using DBSupport;
using DBSupport.entities;
using PageSupport.Interfaces;
using PageSupport.Services;
using PageSupport.SiteParsers;
using Quartz;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Wishlist.Services;

namespace ItemsCheckerService.Jobs
{
    public class CostsCheck : IJob
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        private PageService pageService = new PageService();
        private ItemsParser _itemPraser = new ItemsParser();
        public async Task Execute(IJobExecutionContext context)
        {
            var dBWorker = new SQLRepository(connectionString);
            var items = await dBWorker.GetItems();
            var listAllItems = _itemPraser.ParseDTOItems(items);
            var listForUpdateItems = new List<ItemDTO>();

            foreach (var item in listAllItems)
            {
                Task.Run(() =>
                 {
                     Debug.WriteLine(item.Title);
                     var html = pageService.GetPageHtml(item.Url);
                     IPageParser parser = PageParserSetter.GerParser(item.Url, html);
                     var price = Convert.ToDecimal(parser.GetCost());
                     if (price != item.CostDetails.FirstOrDefault().Cost)
                     {
                         dBWorker.AddNewCostToItem(item.Id, price);
                     }
                 });
                Task.WaitAll();
            }
        }
    }
}
