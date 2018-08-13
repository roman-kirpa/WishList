using DBSupport.Interfaces;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace DBSupport
{
    public class UserItemsRepository : IUserItemsRepository
    {
        private string _connectionString = ConfigurationManager.ConnectionStrings["WishList"].ConnectionString;
        private SqlCommand _command;

        public async Task<bool> SetItem(Product item)
        {
            bool result;
            var _connection = new SqlConnection(_connectionString);
            using (_connection)
            {
                await _connection.OpenAsync();
                _command = new SqlCommand("dbo.spSetNewItem", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                _command.Parameters.AddWithValue("@NameUser", item.UserName);
                _command.Parameters.AddWithValue("@Title", item.Title);
                _command.Parameters.AddWithValue("@Url", item.Url);
                _command.Parameters.AddWithValue("@DateTime", item.DateTimeNow);
                _command.Parameters.AddWithValue("@Cost", item.Cost);
                result = await _command.ExecuteNonQueryAsync() > 0 ? true : false;
            }
            return result;
        }

        public Task<List<Product>> GetItemsByUserName(string nameUser)
        {
            var items = GetItemListAsync("dbo.spSelectAllItemsUser", nameUser);
            return items;
        }
        public Task<List<Product>> GetItems()
        {
            var items = GetItemListAsync("dbo.spSelectAllItems", string.Empty);
            return items;
        }

        public async Task<bool> AddNewCostToItem(int idItem, decimal Cost)
        {
            bool result;
            var _connection = new SqlConnection(_connectionString);
            using (_connection)
            {
                await _connection.OpenAsync();
                _command = new SqlCommand("dbo.spAddNewCost", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                _command.Parameters.AddWithValue("@Cost", Cost);
                _command.Parameters.AddWithValue("@DateTime", DateTime.Now);
                _command.Parameters.AddWithValue("@Item_Id", idItem);
                result = await _command.ExecuteNonQueryAsync() > 0 ? true : false;
            }
            return result;
        }

        private async Task<List<Product>> GetItemListAsync(string procedureName, string userName)
        {
            List<Product> listItems = new List<Product>();

            var _connection = new SqlConnection(_connectionString);
            using (_connection)
            {
                await _connection.OpenAsync();

                _command = new SqlCommand(procedureName, _connection);
                _command.CommandType = CommandType.StoredProcedure;
                if (!string.IsNullOrEmpty(userName)) // to do R.K.  move this to busines logic
                {
                    _command.Parameters.AddWithValue("@Name", userName);
                }

                SqlDataReader reader = _command.ExecuteReader();

                while (reader.Read())
                {
                    listItems.Add(Product.CreateFromReader(reader));
                }
            }
            return listItems;

        }
    }
}
