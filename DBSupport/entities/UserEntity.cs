using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBSupport.entities
{
   public class UserEntity
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public static UserEntity CreateFromReader(SqlDataReader reader)
        {
            var user = new UserEntity();
            user.Id = reader.GetInt32(reader.GetOrdinal("Id")); 
            user.Name = reader.GetString(reader.GetOrdinal("Name")); 
            return user;
        }
    }
}
