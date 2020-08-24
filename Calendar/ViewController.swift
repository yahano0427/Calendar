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
import Firebase
import GoogleMobileAds

//NotificationCenterを使うための設定(cf: https://qiita.com/ryo-ta/items/2b142361996657463e5f)
//extension Notification.Name {
    //static let notifyName = Notification.Name("notifyName")
//}

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance, GADBannerViewDelegate{
    
    //バナー広告インスタンス
    var bannerView: GADBannerView!
    
    //ログインユーザー
    let currentUser = Auth.auth().currentUser
    
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
    
    //左上サイドメニューボタン(左からフリックでも開閉可能)
    @IBAction func openSlideView(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
        print(currentUser)
        
        title = "Schedule"
        
        //カレンダーのデリゲート設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.calendar.placeholderType = .none
        
        //バナー広告のデリゲート設定
        //bannerView.delegate = self
        
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
        Firestore.firestore().collection("users").document(currentUser!.uid).collection("schedule").getDocuments() {
            (QuerySnapshot, err) in
            if let err = err {
                print("ログインユーザーのスケジュールデータ取得時にエラーが発生しました:\(err)")
            
                
            } else {
                print("ログインユーザー:\(self.currentUser!.email)")
                print("ログインユーザーのスケジュールデータ取得に成功しました")
                
                
                for document in QuerySnapshot!.documents {
                    //日付をkeyにmemoをvalueにしてshceduleに格納
                    //Any?型で格納しているためにdateValue()メソッドが使えない、そのためTimestamp型に置き換えてからdateValueでdate型に変更する
                    let timestamp: Timestamp = document.get("date") as! Timestamp
                    let memo: String = document.get("memo") as! String
                    
                    let date = timestamp.dateValue()
                    self.scheduleDate.append(date)
                    self.scheduleMemo.append([date:memo])
                }
            }
        }
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
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
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bottomLayoutGuide,
                            attribute: .top,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
    
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
   
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if(scheduleDate.contains(date)) {
            Firestore.firestore().collection("users").document(currentUser!.uid).collection("schedule").whereField("date", isEqualTo: date).getDocuments() { (QuerySnapshot, err) in
                if let err = err {
                    print("削除するスケジュールデータ取得中にエラーが発生しました:\(err)")
                } else {
                    for document in QuerySnapshot!.documents {
                        Firestore.firestore().collection("users").document(self.currentUser!.uid).collection("schedule").document(document.documentID).delete()
                    }
                    
                    self.scheduleDate = self.scheduleDate.filter() {$0 != date}
                   print("スケジュール削除に成功しました")
                }
            }
        } else {
            //Scheduleコレクションにデータ投入
            Firestore.firestore().collection("users").document(self.currentUser!.uid).collection("schedule").document().setData(["memo": "test", "date": date])
            
            self.scheduleDate.append(date)
            print("スケジュール作成に成功しました")
        }
    }
}
