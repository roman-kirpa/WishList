using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using DBSupport.Interfaces;

namespace DBSupport
{
    public class SQLRepository : IDataBaseRepository
    {
        private SqlConnection _connection;
        private SqlCommand _command;

        public SQLRepository(string connectionString)
        {
            _connection = new SqlConnection(connectionString);
        }

        public async Task SetUserIfNotExist(string name)
        {
            using (_connection)
            {
               await _connection.OpenAsync();
                _command = new SqlCommand("dbo.spSetUserIfNotExist", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                _command.Parameters.Add(new SqlParameter("@name", SqlDbType.NVarChar, 0, "Name"));
                _command.Parameters[0].Value = name;
                _command.ExecuteNonQuery();
                _connection.Close();
            }
        }

        public async Task SetItem(Item item)
        {
            using (_connection)
            {
               await _connection.OpenAsync();
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

        public Task<List<Item>> GetItemsByUser(string nameUser)
        {
            var items = GetListItemsAsync("dbo.spSelectAllItemsUser", nameUser);
            return items;
        }
        public Task<List<Item>> GetItems()
        {
            var items = GetListItemsAsync("dbo.spSelectAllItems", string.Empty);
            return items;
        }

        public async Task AddNewCostToItem(int idItem, decimal Cost)
        {
            using (_connection)
            {
                await _connection.OpenAsync();
                _command = new SqlCommand("dbo.spAddNewCost", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                _command.Parameters.Add(new SqlParameter("@Cost", SqlDbType.Float, 0, "Cost")).Value = Cost;
                _command.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.DateTime, 0, "DateTIme")).Value = DateTime.Now;
                _command.Parameters.Add(new SqlParameter("@Item_Id", SqlDbType.Float, 0, "Cost")).Value = idItem;
                _command.ExecuteNonQuery();
                _connection.Close();
            }
        }

        private async Task<List<Item>> GetListItemsAsync(string procedureName, string userName)
        {
            List<Item> listItems = new List<Item>();
            Item item;

            using (_connection)
            {
               await _connection.OpenAsync();

                _command = new SqlCommand(procedureName, _connection);
                _command.CommandType = CommandType.StoredProcedure;
                if (!string.IsNullOrEmpty(userName))
                {
                    SqlParameter idParam = new SqlParameter
                    {
                        ParameterName = "@Name",
                        SqlDbType = SqlDbType.NVarChar,
                    };
                    _command.Parameters.Add(idParam).Value = userName;
                }

                SqlDataReader reader = _command.ExecuteReader();

                while (reader.Read())
                {
                    item = new Item();
                    item.ItemId = int.Parse(reader["ItemId"].ToString());
                    item.UserId = int.Parse(reader["UserId"].ToString());
                    item.Url = reader["Url"].ToString();
                    item.Title = reader["Title"].ToString();
                    item.UserName = reader["Name"].ToString();
                    item.Cost = decimal.Parse(reader["Cost"].ToString());
                    item.DateTimeNow = DateTime.Parse(reader["DateTime"].ToString());
                    listItems.Add(item);
                }

                _connection.Close();
                return listItems;
            }
        }
    }
}
