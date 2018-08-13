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
            SqlCommand _command;
            var _connection = new SqlConnection(_connectionString);

            using (_connection)
            {
                await _connection.OpenAsync();
                _command = new SqlCommand("dbo.spSetUserIfNotExist", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                _command.Parameters.AddWithValue("@name", userName);
                _command.ExecuteNonQuery();
            }
        }
    }
}
