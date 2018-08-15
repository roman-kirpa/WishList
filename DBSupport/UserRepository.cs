using DBSupport.Interfaces;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace DBSupport
{
    public class UserRepository : IUserRepository
    {
        private string _connectionString = ConfigurationManager.ConnectionStrings["WishList"].ConnectionString;

        public async Task SetUserIfNotExist(string userName)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("dbo.spSetUserIfNotExist", connection))
            {
                await connection.OpenAsync();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("Name", userName);
                await command.ExecuteNonQueryAsync();
            }
        }
    }
}
