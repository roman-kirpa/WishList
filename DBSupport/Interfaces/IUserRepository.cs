using System.Collections.Generic;
using System.Threading.Tasks;

namespace DBSupport.Interfaces
{
    public interface IUserRepository
    {
        Task SetUserIfNotExist(string userName);
    }
}
