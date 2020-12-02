using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Windows.Forms;

namespace WinForm_NewsClassify
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            DataTable tt = null;
            string dbname = DBName_Text.Text;
            string spname = SPName_Text.Text;

            using (SqlConnection cnn = new SqlConnection())
            {
                SqlConnectionStringBuilder scsb = new SqlConnectionStringBuilder();
                scsb.DataSource = "localhost";
                scsb.InitialCatalog = dbname;
                scsb.IntegratedSecurity = true;
                cnn.ConnectionString = scsb.ConnectionString;
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cnn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = spname;

                    cmd.Parameters.Add("@NewsContent", SqlDbType.NVarChar).Value = textBox1.Text;

                    cnn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.HasRows)
                    {
                        tt = new DataTable();
                        tt.Load(dr);
                    }
                    dr.Close();
                    cmd.Dispose();
                    cnn.Close();
                }
            }

            if (tt != null)            
                dataGridView1.DataSource = tt;            
            else
                dataGridView1.DataSource = null;
        }
    }
}
