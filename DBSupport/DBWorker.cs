using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

        public void SetNewUser(string name)
        {
            using (_connection)
            {
                _connection.Open();
                SqlCommand command = new SqlCommand("dbo.usr_insert", _connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@name", SqlDbType.NVarChar, 0, "Name"));
                command.Parameters[0].Value = name;
                command.ExecuteNonQuery();
                _connection.Close();
            }
        }

        public void CheckUser(string name)
        {
            throw new NotImplementedException();
        }

        public void UpdateDB() { }
        public void GetFromDB()
        {
            string sqlExpression = "INSERT INTO Users (Name, Age) VALUES ('Tom', 18)";
        }
        public void DeleteFromDB() { }
    }
}
