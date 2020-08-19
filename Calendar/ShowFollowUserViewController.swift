//
//  showFollowUserViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/11.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import Firebase

class ShowFollowUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //ログインユーザー
    let currentUser = Auth.auth().currentUser
    
    //フォローユーザーまたはフォロワーユーザー
    var searchedUsers = [Dictionary<String, Any>]()
    //var searchedUser = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "follow"
    }
    
    //セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedUsers.count
    }
    
    //セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "followUser")
        cell.textLabel!.text = searchedUsers[indexPath.row]["name"] as! String
        return cell
    }
    
    var selectedUser = [String: Any]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //prepareにユーザーデータを引き継ぐためにselectedUserに格納
        selectedUser = self.searchedUsers[indexPath.row]
        
        //ボタンを押すとユーザー画面に遷移
        self.performSegue(withIdentifier: "userDetailSegue" , sender: self)
    }
    
    //UserViewControllerのsearchedUserに値をセット
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetailSegue" {
           let nextVC = segue.destination as! UserViewController
            nextVC.searchedUser = selectedUser
        }
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
