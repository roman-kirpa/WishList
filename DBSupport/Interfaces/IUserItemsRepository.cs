using System.Collections.Generic;
using System.Threading.Tasks;

namespace DBSupport.Interfaces
{
    public interface IUserItemsRepository
    {
        Task SetItem(Item item);
        Task<List<Item>> GetItems();
        Task AddNewCostToItem(int idItem, decimal Cost);
        Task<List<Item>> GetItemsByUserName(string userName);
    }
}
