//
//  LeftViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/20.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //サイドメニュー
    let MENU = ["プロフィール", "ログアウト"]

    //セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MENU.count
    }
    
    //セルの値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //セルに表示する値を設定
        cell.textLabel!.text = MENU[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
