using DBSupport.Interfaces;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBSupport
{
    public class UserRepository : IUserRepository
    {
        private string _connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        public async Task SetUserIfNotExist(string name)
        {
            SqlCommand _command;
            var _connection = new SqlConnection(_connectionString);

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
    }
}
