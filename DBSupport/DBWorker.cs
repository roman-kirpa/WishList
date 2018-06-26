using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace DBSupport
{
    public class DBWorker
    {
        private SqlConnection _connection;
        private SqlCommand _command;

        public DBWorker(string connectionString)
        {
            _connection = new SqlConnection(connectionString);
        }

        public void SetUserIfNotExist(string name)
        {
            using (_connection)
            {
                _connection.OpenAsync();
                _command = new SqlCommand("dbo.spSetUserIfNotExist", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                _command.Parameters.Add(new SqlParameter("@name", SqlDbType.NVarChar, 0, "Name"));
                _command.Parameters[0].Value = name;
                _command.ExecuteNonQuery();
                _connection.Close();
            }
        }

        public void SetItem(Item item)
        {
            using (_connection)
            {
                _connection.OpenAsync();
                _command = new SqlCommand("dbo.spSetNewItem", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                _command.Parameters.Add(new SqlParameter("@NameUser", SqlDbType.NVarChar, 0, "NameUser")).Value = item.UserName;
                _command.Parameters.Add(new SqlParameter("@Title", SqlDbType.NVarChar, 0, "Title")).Value = item.Title;
                _command.Parameters.Add(new SqlParameter("@Url", SqlDbType.NVarChar, 0, "Url")).Value = item.Url;
                _command.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.DateTime, 0, "DateTIme")).Value = item.DateTimeNow;
                _command.Parameters.Add(new SqlParameter("@Cost", SqlDbType.Float, 0, "Cost")).Value = item.Cost;
                _command.ExecuteNonQuery();
                _connection.Close();
            }
        }

        public List<Item> GetItems(string nameUser)
        {
            List<Item> ItemsList = new List<Item>();
            Item item;
            using (_connection)
            {
                _command = new SqlCommand("dbo.spSelectAllItemsUser", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                SqlParameter idParam = new SqlParameter
                {
                    ParameterName = "@Name",
                    SqlDbType = SqlDbType.NVarChar,
                };
                _command.Parameters.Add(idParam).Value = nameUser;

                _connection.Open();

                SqlDataReader reader = _command.ExecuteReader();

                while (reader.Read())
                {
                    item = new Item();
                    item.Url = reader["Url"].ToString();
                    item.Title = reader["Title"].ToString();
                    item.UserName = reader["Name"].ToString();
                    item.Cost = decimal.Parse(reader["Cost"].ToString()); 
                    item.DateTimeNow = DateTime.Parse(reader["DateTime"].ToString());
                    ItemsList.Add(item);
                }
               
                _connection.Close();
            }
            return ItemsList;
        }

        public void AddNewCostToItem()
        {
            throw new NotImplementedException();
        }
    }
}
