using DBSupport;
using DBSupport.entities;
using System.Collections.Generic;
using System.Linq;

namespace Wishlist.Services
{
    public class ItemsParser
    {
        public List<Item> ParseDTOItems(List<ItemDTO> itemsDTO)
        {
            var items = itemsDTO.GroupBy(_ => _.ItemId).
                Select(x => new Item
                {
                   Title = x.First().Title,
                   Url = x.First().Url,
                   CostDetails = x.Select(y => new CostDetail
                   {
                       Cost = y.Cost,
                       DateTimeNow = y.DateTimeNow
                   }).ToList()
                }).ToList();
           
            return items;
        }
    }
}