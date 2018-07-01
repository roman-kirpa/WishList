using DBSupport;
using DBSupport.entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wishlist.Services
{
    public class ItemsParser
    {
        public List<Item> ParseDTOItems(List<ItemDTO> itemsDTO)
        {
            List<Item> items = new List<Item>();
            List<int> uniqueIdItems = new List<int>();
            uniqueIdItems = itemsDTO.Select(_ => _.ItemId).Distinct().ToList();
            foreach (var id in uniqueIdItems)
            {
                var dto = itemsDTO.Where(_ => _.ItemId == id);
                var item = new Item()
                {
                    Title = dto.First().Title,
                    Url = dto.First().Url,
                    CostDetails = new List<CostDetail>()
                };
                foreach (var costAndDate in dto)
                {
                    var costs = new CostDetail() { Cost = costAndDate.Cost, DateTimeNow = costAndDate.DateTimeNow };
                    item.CostDetails.Add(costs);
                }
                items.Add(item);
            }
            return items;
        }
    }
}