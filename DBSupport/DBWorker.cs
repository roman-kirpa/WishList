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
                _command = new SqlCommand("dbo.usr_insert", _connection);
                _command.CommandType = CommandType.StoredProcedure;
                _command.Parameters.Add(new SqlParameter("@name", SqlDbType.NVarChar, 0, "Name"));
                _command.Parameters[0].Value = name;
                _command.ExecuteNonQuery();
                _connection.Close();
            }
        }
        
        public void CheckUser(string name)
        {
            throw new NotImplementedException();
        }

        public void SetItem(Item item)
        {
            throw new NotImplementedException();
        }

        public List<Item> GetItems(string name)
        {
            throw new NotImplementedException();
        }
       public void DeleteItem(int id)
        {
            throw new NotImplementedException();
        }
    }
}
