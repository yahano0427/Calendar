//
//  FollowUserCalendarViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/20.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import Firebase

class FollowUserCalendarViewController: UIViewController {
   //ログインユーザー
   let currentUser = Auth.auth().currentUser

    //表示ユーザー
    var selectedUser = [String:Any]()
       
       //カレンダー
    @IBOutlet weak var calendar: FSCalendar!
    
       //スケジュール日
       var scheduleDate = [Date]() {
           didSet{
               calendar.reloadData()
           }
       }
       
       //スケジュールメモ
       var scheduleMemo = [Dictionary<Date, String>]()
       
       override func viewDidLoad() {
              super.viewDidLoad()
           
           title = "Follow"
           
           self.calendar.placeholderType = .none
           
           //        年月を日本語表示
            self.calendar.appearance.headerDateFormat = "YYYY年MM月"
           
           //    曜日を日本語で表示
           self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
           self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
           self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
           self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
           self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
           self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
           self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
           
           //スケジュールデータを取得
        Firestore.firestore().collection("users").document(selectedUser["uid"] as! String).collection("schedule").getDocuments() {
               (QuerySnapshot, err) in
               if let err = err {
                   print("フォローユーザーのスケジュールデータ取得時にエラーが発生しました:\(err)")
               
                   
               } else {
                   print("フォローユーザーのスケジュールデータ取得に成功しました")
                   
                   for document in QuerySnapshot!.documents {
                       //日付をkeyにmemoをvalueにしてshceduleに格納
                       //Any?型で格納しているためにdateValue()メソッドが使えない、そのためTimestamp型に置き換えてからdateValueでdate型に変更する
                       let timestamp: Timestamp = document.get("date") as! Timestamp
                       let memo: String = document.get("memo") as! String
                       
                       let date = timestamp.dateValue()
                       self.scheduleDate.append(date)
                       self.scheduleMemo.append([date:memo])
                       
                       //let data = ["date": date, "memo": memo]
                       //self.schedules.append(data as [String : Any])
                       
                   }
               }
           }
       }

       override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
       }

       fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
       fileprivate var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "YYYY-MM-DD"
           return formatter
       }()

       // 祝日判定を行い結果を返すメソッド(True:祝日)
       func judgeHoliday(_ date : Date) -> Bool {
           //祝日判定用のカレンダークラスのインスタンス
           let tmpCalendar = Calendar(identifier: .gregorian)

           // 祝日判定を行う日にちの年、月、日を取得
           let year = tmpCalendar.component(.year, from: date)
           let month = tmpCalendar.component(.month, from: date)
           let day = tmpCalendar.component(.day, from: date)

           // CalculateCalendarLogic()：祝日判定のインスタンスの生成
           let holiday = CalculateCalendarLogic()

           return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
       }
    
       // date型 -> 年月日をIntで取得
       func getDay(_ date:Date) -> (Int,Int,Int){
           let tmpCalendar = Calendar(identifier: .gregorian)
           let year = tmpCalendar.component(.year, from: date)
           let month = tmpCalendar.component(.month, from: date)
           let day = tmpCalendar.component(.day, from: date)
           return (year,month,day)
       }

       //曜日判定(日曜日:1 〜 土曜日:7)
       func getWeekIdx(_ date: Date) -> Int{
           let tmpCalendar = Calendar(identifier: .gregorian)
           return tmpCalendar.component(.weekday, from: date)
       }

       // 土日や祝日の日の文字色を変える
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
           //祝日判定をする（祝日は赤色で表示する）
           if self.judgeHoliday(date){
               return UIColor.red
           }

           //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
           let weekday = self.getWeekIdx(date)
           if weekday == 1 {   //日曜日
               return UIColor.red
           }
           else if weekday == 7 {  //土曜日
               return UIColor.blue
           }

           return nil
       }
       
       //予定が存在するかどうか判断
       //return 予定の個数
       func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
           if(scheduleDate.contains(date)) {
               return 1
           }
    
           return 0
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
