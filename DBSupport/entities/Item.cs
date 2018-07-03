using System.Collections.Generic;

namespace DBSupport.entities
{
    public class Item
    {
       // public string UserName { get; set; }
        public string Url { get; set; }
        public string Title { get; set; }
        public List<CostDetail> CostDetails { get; set; }
    }
}
