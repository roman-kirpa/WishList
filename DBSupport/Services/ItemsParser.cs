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
                    Owner = x.First().UserName,
                    PriceDetails = x.Select(y => new PriceDetail
                    {
                        Price = y.Cost,
                        DateTimeNow = y.DateTimeNow
                    }).OrderByDescending(s => s.DateTimeNow).ToList()
                }).ToList();

            return items;
        }

        public List<ProductDTO> MakeDtoItemList(List<UserEntity> listUsers, List<PriceEntity> listCosts, List<ProductEntity> listProduct)
        {
            var listProductDTO = new List<ProductDTO>();
            foreach (var user in listUsers)
            {
                foreach (var product in listProduct.Where(_ => _.user_id == user.Id))
                {
                    listProductDTO.Add(makeDTOItem(product, listCosts, user));
                }
            }
            return listProductDTO;
        }

        private ProductDTO makeDTOItem(ProductEntity product, List<PriceEntity> listCosts, UserEntity user)
        {
            var productDTO = new ProductDTO()
            {
                Id = product.Id,
                Title = product.Title,
                Url = product.Url,
                PriceDetails = listCosts.Where(l => l.Item_Id == product.Id).Select(_ => new PriceDetail { Price = _.Price, DateTimeNow = _.DateTime }).OrderByDescending(s => s.DateTimeNow).ToList(),
                Owner = user.Name
            };
            return productDTO;
        }
    }
}