//
//  showFollowUserViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/11.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ShowFollowUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //バナー広告インスタンス
    var bannerView: GADBannerView!
    
    //ログインユーザー
    let currentUser = Auth.auth().currentUser
    
    @IBAction func openSlideView(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    
    //フォローユーザー
    var searchedUsers = [Dictionary<String, Any>]() {
        //Firestoreから非同期でレスポンスが返ってくるため、searchedUsersが変更されたときにここでreload
        didSet{
            followUserTable.reloadData()
        }
    }
    
    //テーブル
    @IBOutlet weak var followUserTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Firestore.firestore().collection("users").document(currentUser!.uid).collection("follow").getDocuments() {(QuerySnapshot, err) in
            if let err = err {
                print("ログインユーザーのフォローデータ取得時にエラーが発生しました:\(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    var data = document.data()
                    data.updateValue(document.documentID, forKey: "uid")
                    self.searchedUsers.append(data)
                    print("ログインユーザーのフォローデータ取得に成功しました:\(document.data())")
                }
            }
        }
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        addBannerViewToView(bannerView)
        
        print(currentUser!.email)
    }
    
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
    
    //セルを押下した際に起きるイベント処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //prepareにユーザーデータを引き継ぐためにselectedUserに格納
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowUserId") as! FollowUserCalendarViewController
        //selectedUser = self.searchedUsers[indexPath.row]
        
        nextVC.selectedUser = self.searchedUsers[indexPath.row]
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        //ボタンを押すとユーザー画面に遷移
        //self.performSegue(withIdentifier: "followUserScheduleSegue" , sender: self)
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
