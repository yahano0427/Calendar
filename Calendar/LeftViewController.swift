//
//  LeftViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/20.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LeftViewController: UIViewController {
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()! }}
    
    @IBAction func logout(_ sender: Any) {
        do {
            //そのまま記述すると'Call can throw, but it is not marked with 'try' and the error is not handled'と怒られるのでエラーハンドリング
            try authUI.signOut()
        } catch {
            print(error)
        }

        //上のauthUI.signOut()でログアウトが完了しているためnilが返る
        Auth.auth().addStateDidChangeListener{(auth, user) in
            print("ログアウトが完了しました(現在のログインユーザー:\(user?.email))")
        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "authId") as! AuthViewController
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    /*
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
 */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
