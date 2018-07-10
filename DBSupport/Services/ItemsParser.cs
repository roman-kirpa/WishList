using DBSupport;
using DBSupport.entities;
using System.Collections.Generic;
using System.Linq;

namespace Wishlist.Services
{
    public class ItemsParser
    {
        public List<ItemDTO> ParseDTOItems(List<Item> itemsDTO)
        {
            var items = itemsDTO.GroupBy(_ => _.ItemId).
                Select(x => new ItemDTO
                {
                   Id = x.First().ItemId,
                   Title = x.First().Title,
                   Url = x.First().Url,
                   CostDetails = x.Select(y => new CostDetail
                   {
                       Cost = y.Cost,
                       DateTimeNow = y.DateTimeNow
                   }).OrderByDescending(s => s.DateTimeNow).ToList()
                }).ToList();
           
            return items;
        }
    }
}