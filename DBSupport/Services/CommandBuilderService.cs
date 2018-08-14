using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBSupport.Services
{
    class CommandBuilderService
    {
        public SqlCommand SetCommand(SqlCommand command, string userName)
        {
            if (!string.IsNullOrEmpty(userName))
            {
               command.Parameters.AddWithValue("Name", userName);
               return command;
            }
            else return command;
        }
    }
}
