using ItemsCheckerService.Jobs;
using Quartz;
using Quartz.Impl;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ItemsCheckerService
{
  public class Service
    {
        public void Start()
        {
            Task.Run(() => UrlsChecker());
        }

        public void Stop()
        {

        }

        private async void UrlsChecker()
        {
            int interval;

            if (!int.TryParse(ConfigurationManager.AppSettings["Interval"], out interval))
            {
                throw new InvalidOperationException("Invalid interval in web.config");
            }

            IScheduler scheduler = await StdSchedulerFactory.GetDefaultScheduler();
            await scheduler.Start();
            IJobDetail job = JobBuilder.Create<CostsCheck>().Build();
         

            ITrigger trigger = TriggerBuilder.Create()
                .WithIdentity("trigger", "group")
                .StartNow()
                .WithSimpleSchedule(x => x
                .WithIntervalInSeconds(interval)
                //.WithRepeatCount(4))
                .RepeatForever())
                .Build();
            await scheduler.ScheduleJob(job, trigger);
        }
    }
}
