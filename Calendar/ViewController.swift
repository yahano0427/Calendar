//
//  ViewController.swift
//  Calendar
//
//  Created by 矢羽野裕介 on 2020/08/05.
//  Copyright © 2020 矢羽野. All rights reserved.
//    comment

import UIKit
import FSCalendar
import CalculateCalendarLogic

// ディスプレイサイズ取得
let w = UIScreen.main.bounds.size.width
let h = UIScreen.main.bounds.size.height


class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    
    @IBOutlet weak var calendar: FSCalendar!

    @IBOutlet weak var date: UILabel!
    
    
   
        // デリゲートの設定(デリゲートとは->参考:https://qiita.com/st43/items/9f9990d76cefa1909ef4)
        
        //スケジュール内容
        let labelDate = UILabel(frame: CGRect(x: 5, y: 740, width: 400, height: 50))
        //「主なスケジュール」の表示
        let labelTitle = UILabel(frame: CGRect(x: 0, y: 720, width: 180, height: 20))
        //カレンダー部分
        let dateView = FSCalendar(frame: CGRect(x: 0, y: 30, width: w, height: 400))
        //日付の表示
        let Date = UILabel(frame: CGRect(x: 5, y: 650, width: 200, height: 100))
      
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
            
            
        //日付表示設定
        Date.text = ""
        Date.font = UIFont.systemFont(ofSize: 20.0)
        Date.textColor = .black
        view.addSubview(Date)

        //「主なスケジュール」表示設定
        labelTitle.text = ""
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont.systemFont(ofSize: 14.0)
        view.addSubview(labelTitle)

        //スケジュール内容表示設定
        labelDate.text = ""
        labelDate.font = UIFont.systemFont(ofSize: 15.0)
        view.addSubview(labelDate)
        
        //カレンダー処理(スケジュール表示処理)
        

            labelTitle.text = "主なスケジュール"
            labelTitle.backgroundColor = .orange
            view.addSubview(labelTitle)

            //予定がある場合、スケジュールをDBから取得・表示する。
            //無い場合、「スケジュールはありません」と表示。
            labelDate.text = "スケジュールはありません"
            labelDate.textColor = .lightGray
            view.addSubview(labelDate)

            let tmpDate = Calendar(identifier: .gregorian)
            let year = tmpDate.component(.year, from: date)
            let month = tmpDate.component(.month, from: date)
            let day = tmpDate.component(.day, from: date)
            let m = String(format: "%02d", month)
            let d = String(format: "%02d", day)

            let da = "\(year)/\(m)/\(d)"

            //クリックしたら、日付が表示される。
            Date.text = "\(m)/\(d)"
            view.addSubview(Date)
            
            
        
        }
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
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
    
    
}
