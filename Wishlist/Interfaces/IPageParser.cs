using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Wishlist.Interfaces
{
    public interface IPageParser
    {
        string GetCost();
        string GetTitle();
    }
}
