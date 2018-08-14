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
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["WishList"].ConnectionString))
            using (var command = new SqlCommand("dbo.spLogExceptions", connection))
            {
                await connection.OpenAsync();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Message", ex.Message);
                command.Parameters.AddWithValue("@StackTrace", ex.StackTrace);
                command.Parameters.AddWithValue("@DateTime", DateTime.UtcNow);
                await command.ExecuteNonQueryAsync();
            }
        }
    }
}
