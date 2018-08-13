using ProductUpdaterService.Jobs;
using Quartz;
using Quartz.Impl;
using System;
using System.Configuration;
using System.Threading.Tasks;

namespace ProductUpdaterService
{
    public class Service
    {
        public void Start()
        {
            try
            {
                Task.Run(() => PriceChecker()); // todo cath exception
            }
            catch (Exception ex)
            {
               SimpleLogger.Logger.Log(ex);
            }
        }

        public void Stop()
        {
        }

        private async void PriceChecker()
        {
            int interval;

            if (!int.TryParse(ConfigurationManager.AppSettings["Interval"], out interval))
            {
                throw new InvalidOperationException("Invalid interval in web.config");
            }

            IScheduler scheduler = await StdSchedulerFactory.GetDefaultScheduler();
            await scheduler.Start();
            IJobDetail job = JobBuilder.Create<PriceCheckJob>().Build();
         

            ITrigger trigger = TriggerBuilder.Create()
               // .WithIdentity("trigger", "group")
                .StartNow()
                .WithSimpleSchedule(x => x
                .WithIntervalInMinutes(interval)
                .RepeatForever())
                .Build();
            await scheduler.ScheduleJob(job, trigger);
        }
    }
}
