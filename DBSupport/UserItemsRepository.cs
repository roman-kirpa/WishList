using DBSupport.entities;
using DBSupport.Interfaces;
using DBSupport.Services;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Wishlist.Services;

namespace DBSupport
{
    public class UserItemsRepository : IUserItemsRepository
    {
        private string _connectionString = ConfigurationManager.ConnectionStrings["WishList"].ConnectionString;

        public async Task<bool> SetItem(EnterProductEntity item)
        {
            bool result;
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("dbo.spSetNewItem", connection))
            {
                await connection.OpenAsync();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("NameUser", item.UserName);
                command.Parameters.AddWithValue("Title", item.Title);
                command.Parameters.AddWithValue("Url", item.Url);
                command.Parameters.AddWithValue("DateTime", item.DateTimeNow);
                command.Parameters.AddWithValue("Cost", item.Cost);
                result = await command.ExecuteNonQueryAsync() > 0;
            }
            return result;
        }

        public Task<List<ProductDTO>> GetItemsByUserName(string nameUser)
        {
            var items = GetItemListAsync("dbo.spSelectAllItemsUser", nameUser);
            return items;
        }

        public Task<List<ProductDTO>> GetItems()
        {
            var items = GetItemListAsync("dbo.spSelectAllItems");
            return items;
        }

        public async Task<bool> AddNewCostToItem(int idItem, decimal Cost)
        {
            bool result;
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("dbo.spAddNewCost", connection))
            {
                await connection.OpenAsync();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("Cost", Cost);
                command.Parameters.AddWithValue("DateTime", DateTime.Now);
                command.Parameters.AddWithValue("ItemId", idItem);
                result = await command.ExecuteNonQueryAsync() > 0;
            }
            return result;
        }

        private async Task<List<ProductDTO>> GetItemListAsync(string procedureName, string userName = "")
        {
            var listItems = new List<ProductDTO>();
            var parser = new ItemsParser();
            var comandBuilder = new CommandBuilderService();
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand(procedureName, connection))
            {
                await connection.OpenAsync();

                command.CommandType = CommandType.StoredProcedure;
                comandBuilder.SetCommand(command, userName);
                SqlDataReader reader = command.ExecuteReader();

                var listUsers = new List<UserEntity>();
                var listProduct = new List<ProductEntity>();
                var listCosts = new List<PriceEntity>();
                while (reader.Read())
                {
                   listUsers.Add(UserEntity.CreateFromReader(reader));
                }
                reader.NextResult();

                while (reader.Read())
                {
                    listProduct.Add(ProductEntity.CreateFromReader(reader));
                }
                reader.NextResult();

                while (reader.Read())
                {
                    listCosts.Add(PriceEntity.CreateFromReader(reader));
                }
                reader.NextResult();
                listItems = parser.MakeDtoItemList(listUsers, listCosts, listProduct);
            }
            return listItems;
        }
    }
}
