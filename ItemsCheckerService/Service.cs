using ItemsCheckerService.Jobs;
using Quartz;
using Quartz.Impl;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ItemsCheckerService
{
  public class Service
    {
        public void Start()
        {
            Task.Run(() => UrlsChaker());
        }
        public void StartForDebug()
        {
            Task.Run(() => UrlsChaker());
            Console.ReadLine();
        }

        public void Stop()
        {

        }

        private async void UrlsChaker()
        {
            IScheduler scheduler = await StdSchedulerFactory.GetDefaultScheduler();
            await scheduler.Start();

            IJobDetail job = JobBuilder.Create<TestJob>().Build();

            ITrigger trigger = TriggerBuilder.Create()
                .WithIdentity("trigger1", "group1")
                .StartNow()
                .WithSimpleSchedule(x => x
                .WithIntervalInSeconds(10)
                //.WithRepeatCount(4))
                .RepeatForever())
                .Build();

            await scheduler.ScheduleJob(job, trigger);
        }
    }
}
