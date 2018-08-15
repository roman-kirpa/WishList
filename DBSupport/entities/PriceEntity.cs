using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SimpleLogger;

namespace DBSupport.entities
{
    public class PriceEntity
    {
        public decimal Price { get; set; }
        public DateTime DateTime { get; set; }
        public int Item_Id { get; set; }

        public static PriceEntity CreateFromReader(SqlDataReader reader)
        {
           
                var priseDetile = new PriceEntity();
                priseDetile.Price = reader.GetDecimal(reader.GetOrdinal("Cost"));
                priseDetile.DateTime = reader.GetDateTime(reader.GetOrdinal("DateTime"));
                priseDetile.Item_Id = reader.GetInt32(reader.GetOrdinal("Item_Id"));
                return priseDetile;
         
        }
    }
}
