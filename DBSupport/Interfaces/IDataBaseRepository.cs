using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBSupport.Interfaces
{
   public interface IDataBaseRepository
    {
        Task SetUserIfNotExist(string name);
        Task SetItem(Item item);
        Task<List<Item>> GetItemsByUser(string nameUser);
        Task<List<Item>> GetItems();
        Task AddNewCostToItem(int idItem, decimal Cost);

    }
}
