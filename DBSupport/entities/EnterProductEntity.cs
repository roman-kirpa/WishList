using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBSupport
{
    public class EnterProductEntity
    {
        public int ItemId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string Url { get; set; }
        public string Title { get; set; }
        public decimal Cost { get; set; }
        public DateTime DateTimeNow { get; set; }
    }
}
