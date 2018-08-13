using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SimpleLogger
{
    public class Logger
    {
        public static async Task Log(Exception ex)
        {

            var _connection = new SqlConnection(ConfigurationManager.ConnectionStrings["WishList"].ConnectionString);
            SqlCommand _command;

            using (_connection)
            {
                await _connection.OpenAsync();
                _command = new SqlCommand("dbo.spLogExceptions", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                _command.Parameters.AddWithValue("@Message", ex.Message);
                _command.Parameters.AddWithValue("@StackTrace", ex.StackTrace);
                _command.Parameters.AddWithValue("@DateTime", DateTime.UtcNow);
                await _command.ExecuteNonQueryAsync();
            }
        }
    }
}
