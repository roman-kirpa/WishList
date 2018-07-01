using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBSupport.entities
{
   public class Item
    {
       // public string Id { get; set; }
        public string UserName { get; set; }
        public string Url { get; set; }
        public string Title { get; set; }
        public List<CostDetail> CostDetails { get; set; }
    }
}
