using DBSupport;
using PageSupport.Interfaces;
using PageSupport.Services;
using PageSupport.SiteParsers;
using Quartz;
using SimpleLogger;
using System;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using Wishlist.Services;

namespace ProductUpdaterService.Jobs
{
    public class PriceCheckJob : IJob
    {
        private PageService _pageService = new PageService();
        private readonly string _account = ConfigurationManager.AppSettings["account"];
        private readonly string _password = ConfigurationManager.AppSettings["password"];

        public async Task Execute(IJobExecutionContext context)
        {
            var repo = new UserItemsRepository();
            var items = await repo.GetItems();

            foreach (var item in items)
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
                            SendMail(item.Owner, price, item.Title, item.Url);
                        }
                    });
                }
                catch (Exception ex)
                {
                    await Logger.Log(ex);
                }
            }
        }

        private void SendMail(string userName, decimal newPrice, string Title, string Url)
        {
            
                SmtpClient client = new SmtpClient();
                client.Port = 587;
                client.Host = "smtp.gmail.com";
                client.EnableSsl = true;
                client.Timeout = 10000;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;
                client.Credentials = new System.Net.NetworkCredential(_account, _password);
                
                MailMessage mm = new MailMessage(_account, userName + "@eleks.com", "Price updated", string.Format("Your product:{0} has new prise:{1}", "<html><head></head><body><div><a href=" + Url + ">" + Title + "</a></div></body></html>", newPrice));
                mm.BodyEncoding = UTF8Encoding.UTF8;
                mm.IsBodyHtml = true;
                mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

                client.Send(mm);
        }
    }
}
