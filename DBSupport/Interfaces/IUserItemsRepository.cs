using DBSupport.entities;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DBSupport.Interfaces
{
    public interface IUserItemsRepository
    {
        Task<bool> SetItem(EnterProductEntity item);
        Task<bool> AddNewCostToItem(int idItem, decimal Cost);
        Task<List<ProductDTO>> GetItems();
        Task<List<ProductDTO>> GetItemsByUserName(string userName);
    }
}
