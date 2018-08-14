using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBSupport
{
    public class Product
    {
        public int ItemId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string Url { get; set; }
        public string Title { get; set; }
        public decimal Cost { get; set; }
        public DateTime DateTimeNow { get; set; }

        public static Product CreateFromReader(SqlDataReader reader)
        {
            //var stringOrdinal = reader.GetOrdinal("ItemId");
            //reader.GetString(stringOrdinal);
            var product = new Product();
            product.ItemId = int.Parse(reader["ItemId"].ToString());
            product.UserId = int.Parse(reader["UserId"].ToString());
            product.Url = reader["Url"].ToString();
            product.Title = reader["Title"].ToString();
            product.UserName = reader["Name"].ToString();
            product.Cost = decimal.Parse(reader["Cost"].ToString());
            product.DateTimeNow = DateTime.Parse(reader["DateTime"].ToString());
            return product;
        }
    }
}
