using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WinLoadNews
{
    public partial class Form1 : Form
    {
        SqlConnection cnn;

        public Form1()
        {
            InitializeComponent();
        }

        private void CreateSqlConnection()
        {

            SqlConnectionStringBuilder scsb = new SqlConnectionStringBuilder();
            scsb.DataSource = ServerName_Text.Text;
            scsb.InitialCatalog = DBName_Text.Text;

            if (this.WinValid_Radio.Checked)
            {
                scsb.IntegratedSecurity = true;
            }
            else
            {
                scsb.IntegratedSecurity = false;
                scsb.UserID = UserName_Text.Text;
                scsb.Password = Pass_Text.Text;
            }

            this.cnn = null;
            this.cnn = new SqlConnection();
            this.cnn.ConnectionString = scsb.ConnectionString;

        }

        private void SQLValid_Radio_CheckedChanged(object sender, EventArgs e)
        {
            if (SQLValid_Radio.Checked)
            {
                UserName_Text.Enabled = true;
                Pass_Text.Enabled = true;
            }
            else
            {
                UserName_Text.Enabled = false;
                Pass_Text.Enabled = false;
            }
        }

        private void TestConnect_Btn_Click(object sender, EventArgs e)
        {
            this.CreateSqlConnection();

            try
            {
                cnn.Open();
                MessageBox.Show("連線成功！", "成功", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show("連線出問題！", "失敗", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                this.cnn.Close();
            }
        }

        private void PickFolder_Btn_Click(object sender, EventArgs e)
        {
            FBD1.RootFolder = Environment.SpecialFolder.MyComputer;
            FBD1.ShowNewFolderButton = false;
            if (FBD1.ShowDialog() == DialogResult.OK)
            {
                this.FolderPath_Label.Text = FBD1.SelectedPath;
            }
        }

        private void ViewFileStatus_Btn_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(FolderPath_Label.Text))
            {
                MessageBox.Show("請選擇新聞的資料夾！", "錯誤", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            DirectoryInfo di = null;
            di = new DirectoryInfo(FolderPath_Label.Text);

            StringBuilder sb = new StringBuilder();
            foreach (FileInfo fi in di.GetFiles("*.*", SearchOption.AllDirectories))
            {             
                sb.Append(fi.FullName).Append("\r\n");
            }
            textBox1.Text = sb.ToString();
        }


        
        private void Upload_Btn_Click(object sender, EventArgs e)
        {
            this.CreateSqlConnection();

            string tb_name = TableName_Text.Text;
            string class_id = NewsClassifyID_Text.Text;

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = this.cnn;
            cmd.CommandText = "INSERT INTO "+tb_name+"([Label],[News]) VALUES(@ll,@nn)";
            cmd.Parameters.Add("@ll", SqlDbType.NVarChar);
            cmd.Parameters.Add("@nn", SqlDbType.Text);

            DirectoryInfo di = null;
            di = new DirectoryInfo(FolderPath_Label.Text);

            this.cnn.Open();
            foreach (FileInfo fi in di.GetFiles("*.*", SearchOption.AllDirectories))
            {
                Encoding encoding1;

                if (radioButton1.Checked)
                    encoding1 = Encoding.Unicode;
                else if (radioButton2.Checked)
                    encoding1 = Encoding.UTF8;
                else
                    encoding1 = Encoding.Default;

                string ss = File.ReadAllText(fi.FullName, encoding1);
                cmd.Parameters["@ll"].Value = class_id;
                cmd.Parameters["@nn"].Value = ss;
                cmd.ExecuteNonQuery();
            }
            cmd.Dispose();
            this.cnn.Close();

            MessageBox.Show("檔案已上傳成功！", "成功", MessageBoxButtons.OK, MessageBoxIcon.Information);
            
        }
    }
}
