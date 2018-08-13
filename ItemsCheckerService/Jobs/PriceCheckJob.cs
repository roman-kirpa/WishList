using DBSupport;
using PageSupport.Interfaces;
using PageSupport.Services;
using PageSupport.SiteParsers;
using Quartz;
using SimpleLogger;
using System;
using System.Linq;
using System.Threading.Tasks;
using Wishlist.Services;

namespace ProductUpdaterService.Jobs
{
    public class PriceCheckJob : IJob
    {
        private PageService _pageService = new PageService();
        private ItemsParser _itemPraser = new ItemsParser();
        public async Task Execute(IJobExecutionContext context)
        {
            var repo = new UserItemsRepository();
            var items = await repo.GetItems();
            var listAllItems = _itemPraser.ParseDTOItems(items);

            foreach (var item in listAllItems)
            {
                try
                {
                    Task.Run(() =>
                    {
                        var html = _pageService.GetPageHtml(item.Url);
                        IPageParser parser = PageParserSetter.GerParser(item.Url, html);
                        var price = Convert.ToDecimal(parser.GetCost());
                        if (price != item.PriceDetails.FirstOrDefault().Price)
                        {
                            repo.AddNewCostToItem(item.Id, price); 
                        }
                    });
                }
                catch (Exception ex)
                {
                    await Logger.Log(ex);
                }
            }
        }
    }
}
