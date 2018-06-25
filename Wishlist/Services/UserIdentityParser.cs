using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;

namespace Wishlist.Services
{
    public static class UserIdentityParser
    {
            public static string GetDomain(this IIdentity identity)
            {
                string s = identity.Name;
                int stop = s.IndexOf("\\");
                return (stop > -1) ? s.Substring(0, stop) : string.Empty;
            }

            public static string GetLogin(this IIdentity identity)
            {
                string s = identity.Name;
                int stop = s.IndexOf("\\");
                return (stop > -1) ? s.Substring(stop + 1, s.Length - stop - 1) : string.Empty;
            }
    }
}