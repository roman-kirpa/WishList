using System.Collections.Generic;

namespace DBSupport.entities
{
    public class ProductDTO
    {
        public int Id { get; set; }
        public string Url { get; set; }
        public string Title { get; set; }
        public List<PriceDetail> PriceDetails { get; set; }
    }
}
