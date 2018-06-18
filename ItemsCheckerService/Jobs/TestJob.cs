using Quartz;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ItemsCheckerService.Jobs
{
    class TestJob : IJob
    {
        public async Task Execute(IJobExecutionContext context)
        {
            Console.WriteLine("I'am a live");
        }
    }
}
