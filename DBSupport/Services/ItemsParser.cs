using DBSupport;
using DBSupport.entities;
using System.Collections.Generic;
using System.Linq;

namespace Wishlist.Services
{
    public class ItemsParser
    {
        public List<ProductDTO> ParseDTOItems(List<Product> itemsDTO)
        {
            var items = itemsDTO.GroupBy(_ => _.ItemId).
                Select(x => new ProductDTO
                {
                   Id = x.First().ItemId,
                   Title = x.First().Title,
                   Url = x.First().Url,
                   PriceDetails = x.Select(y => new PriceDetail
                   {
                       Price = y.Cost,
                       DateTimeNow = y.DateTimeNow
                   }).OrderByDescending(s => s.DateTimeNow).ToList()
                }).ToList();
           
            return items;
        }
    }
}