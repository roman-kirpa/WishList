using System;
using Topshelf;

namespace ProductUpdaterService
{
    static class Program
    {
        static void Main()
        {
         #if DEBUG 
           
                Service myService = new Service();
                myService.Start();
                Console.ReadLine();
          
         #else
            
            HostFactory.Run(configure =>
                {
                    configure.Service<Service>(service =>
                    {
                        service.ConstructUsing(s => new Service());
                        service.WhenStarted(s => s.Start());
                        service.WhenStopped(s => s.Stop());
                    });
                    //Setup Account that window service use to run.  
                    configure.RunAsLocalSystem();
                    configure.SetServiceName("ProductPriceCheckService");
                    configure.SetDisplayName("ProductPriceCheckService");
                    configure.SetDescription("service for check all urls");
                });
         #endif
           
        }
    }
}
