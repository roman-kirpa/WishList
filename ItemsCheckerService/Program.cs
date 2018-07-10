using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using Topshelf;

namespace ItemsCheckerService
{
    static class Program
    {
        static void Main()
        {
            if (Environment.UserInteractive) // debug
            {
                Service myService = new Service();
                myService.Start();
                Console.ReadLine();
            }
            else // release
            {
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
                    configure.SetServiceName("UrlCheckService");
                    configure.SetDisplayName("UrlCheckService");
                    configure.SetDescription("service for check all urls");
                });
            }
        }
    }
}
