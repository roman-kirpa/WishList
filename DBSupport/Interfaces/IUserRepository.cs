using System.Collections.Generic;
using System.Threading.Tasks;

namespace DBSupport.Interfaces
{
    public interface IUserRepository
    {
        Task SetUserIfNotExist(string name);
        //Task<List<Item>> GetItemsByUserName(string userName);
    }
}
