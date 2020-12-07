using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Globalization;


public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]

  
    public static string useTaiwanLC(DateTime date)
    {
        string TeanGean = "甲乙丙丁戊己庚辛壬癸";
        string DeGe = "子丑寅卯辰巳午未申酉戌亥";
        string CAnimal = "鼠牛虎兔龍蛇馬羊猴雞狗豬";

        TaiwanLunisolarCalendar Tlc = new TaiwanLunisolarCalendar();
        //DateTime dtNow = new DateTime.Now();//拿今年的日期
        //DateTime.Now.AddYears;


        int lun60Year = Tlc.GetSexagenaryYear(date.AddYears(0));
      //  int lun60Year = Tlc.GetSexagenaryYear(DateTime.Now.AddYears(0));
        int TeanGeanYear = Tlc.GetCelestialStem(lun60Year) - 1;
        int DeGeYear = Tlc.GetTerrestrialBranch(lun60Year) - 1;

        int lunMonth = Tlc.GetMonth(DateTime.Now.AddYears(0));
        int leapMonth = Tlc.GetLeapMonth(Tlc.GetYear(DateTime.Now.AddYears(0)));
        if (leapMonth > 0 && lunMonth >= leapMonth)
        {
            //lunMonth = lunMonth - 1;
            lunMonth -= 1;
        }
        int lunDay = Tlc.GetDayOfMonth(DateTime.Now.AddYears(0));
        //Console.WriteLine("debug" + TeanGean[TeanGeanYear] + DeGe[DeGeYear] + CAnimal[DeGeYear]);
        Console.WriteLine("驗算網頁 : http://tlcheng.twbbs.org/Model/Online/LunarCalendar/Default.aspx");
        Console.WriteLine("參考資料 : http://anita-lo.blogspot.com/2008/03/net_20.html");
        Console.WriteLine("查表法   : http://chmis.cca.gov.tw/chmp/blog/a571024/myBlogArticleAction.do?method=doListArticleByPk&articleId=3213");
        Console.WriteLine("參考資料 : http://www.fushantang.com/1003/c1007.html");
        //return String.Format("農曆:{0}年{1}月{2}日", TeanGean[TeanGeanYear] & DeGe[DeGeYear], lunMonth, lunDay);
        //return String.Format("農曆:{0}年{1}月{2}日 今年的生肖: {3}",Tlc.GetYear(DateTime.Now).ToString(), lunMonth, lunDay, CAnimal[DeGeYear].ToString());
        return String.Format("{0}", CAnimal[DeGeYear].ToString());
    }
}

