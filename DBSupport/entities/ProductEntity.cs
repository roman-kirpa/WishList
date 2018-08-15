using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBSupport.entities
{
    public class ProductEntity
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Url { get; set; }
        public int UserId { get; set; }

        public static ProductEntity CreateFromReader(SqlDataReader reader)
        {
            var product = new ProductEntity();
            product.Id = reader.GetInt32(reader.GetOrdinal("Id")); 
            product.Title = reader.GetString(reader.GetOrdinal("Title"));
            product.Url = reader.GetString(reader.GetOrdinal("Url"));
            product.UserId = reader.GetInt32(reader.GetOrdinal("UserId")); 
            return product;
        }
    }
}
