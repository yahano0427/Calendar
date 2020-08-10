//
//  EventViewController.swift
//  Calendar
//
//  Created by 矢羽野裕介 on 2020/08/10.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit

//ディスプレイサイズ取得
let w2 = UIScreen.main.bounds.size.width
let h2 = UIScreen.main.bounds.size.height
//スケジュール内容入力テキスト
let eventText = UITextView(frame: CGRect(x: (w2 - 300) / 2, y: 100, width: 300, height: 200))

//日付フォーム(UIDatePickerを使用)
let y = UIDatePicker(frame: CGRect(x: 0, y: 300, width: w2, height: 300))
//日付表示
let y_text = UILabel(frame: CGRect(x: (w2 - 300) / 2, y: 570, width: 300, height: 20))
class EventViewController: UIViewController {
    var date: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        //スケジュール内容入力テキスト設定
        eventText.text = ""
        eventText.layer.borderColor = UIColor.gray.cgColor
        eventText.layer.borderWidth = 1.0
        eventText.layer.cornerRadius = 10.0
        view.addSubview(eventText)

        //日付フォーム設定
        y.datePickerMode = UIDatePicker.Mode.date
        y.timeZone = NSTimeZone.local
        y.addTarget(self, action: #selector(picker(_:)), for: .valueChanged)
        view.addSubview(y)

        //日付表示設定
        y_text.backgroundColor = .white
        y_text.textAlignment = .center
        view.addSubview(y_text)

        //「書く!」ボタン
        let eventInsert = UIButton(frame: CGRect(x: (w2 - 200) / 2, y: 600, width: 200, height: 50))
        eventInsert.setTitle("書く！", for: UIControl.State())
        eventInsert.setTitleColor(.white, for: UIControl.State())
        eventInsert.backgroundColor = .orange
        eventInsert.addTarget(self, action: #selector(saveEvent(_:)), for: .touchUpInside)
        view.addSubview(eventInsert)

        //「戻る!」ボタン
        let backBtn = UIButton(frame: CGRect(x: (w - 200) / 2, y: h - 50, width: 200, height: 30))
        backBtn.setTitle("戻る", for: UIControl.State())
        backBtn.setTitleColor(.orange, for: UIControl.State())
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 10.0
        backBtn.layer.borderColor = UIColor.orange.cgColor
        backBtn.layer.borderWidth = 1.0
        backBtn.addTarget(self, action: #selector(onbackClick(_:)), for: .touchUpInside)
        view.addSubview(backBtn)

    }
    

    //画面遷移(カレンダーページ)
    @objc func onbackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //日付フォーム
    @objc func picker(_ sender:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        y_text.text = formatter.string(from: sender.date)
        view.addSubview(y_text)
    }
    
    @objc func saveEvent(_ : UIButton){
    print("データ書き込み開始")
    

        //前のページに戻る
        dismiss(animated: true, completion: nil)

    }

}
