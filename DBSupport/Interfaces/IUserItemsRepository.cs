using System.Collections.Generic;
using System.Threading.Tasks;

namespace DBSupport.Interfaces
{
    public interface IUserItemsRepository
    {
        Task<bool> SetItem(Product item);
        Task<bool> AddNewCostToItem(int idItem, decimal Cost);
        Task<List<Product>> GetItems();
        Task<List<Product>> GetItemsByUserName(string userName);
    }
}
