//
//  UserViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/10.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds


class UserViewController: UIViewController {
    //バナー広告インスタンス
    var bannerView: GADBannerView!
    
    //ログインしているユーザー
    let currentUser = Auth.auth().currentUser

    //検索されたユーザー情報(dictionary型)
    var searchedUser = [String: Any]()
    
    //ログインユーザーが検索したユーザーをフォローしているかのフラグ
    var following: Bool = false

    @IBOutlet weak var userNameField: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    //フォローボタン
    //ログインユーザーのfollowコレクションに検索しているユーザーのuidを保存
    @IBAction func follow(_ sender: Any) {
        if following {
            //既にフォローしている場合、followコレクションからuidを削除して、ボタンをフォローするに変更する
            
            //followコレクションからデータ削除
            Firestore.firestore().collection("users").document(currentUser!.uid).collection("follow").document(searchedUser["uid"] as! String).delete() {
                err in
                if let err = err {
                    print("フォロー解除中にエラーが発生しました:\(err)")
                } else {
                    print("フォローの解除に成功しました")
                }
            }
            
            //followerコレクションからデータ削除
            Firestore.firestore().collection("users").document(searchedUser["uid"] as! String).collection("follower").document(currentUser!.uid).delete() {
                err in
                if let err = err {
                    print("フォロワー解除中にエラーが発生しました:\(err)")
                } else {
                    print("フォロワー解除に成功しました")
                }
            }
            
            
            following = false
            followButton.setTitle("フォローする", for: .normal)
        } else {
            //フォローしていない場合followコレクションにuidを保存して、ボタンをフォロー中に変更する
            
            //followコレクションにデータ投入
            Firestore.firestore().collection("users").document(currentUser!.uid).collection("follow").document(searchedUser["uid"] as! String).setData(["permitted": false, "name": searchedUser["name"], "email": searchedUser["email"]])
            
            //followerコレクションにデータ投入
            Firestore.firestore().collection("users").document(searchedUser["uid"] as! String).collection("follower").document(currentUser!.uid).setData(["permitted": false, "name": currentUser!.displayName, "email": currentUser!.email])
            
            following = true
            followButton.setTitle("フォロー中", for: .normal)
        }
    }
    
    //カレンダーを確認するボタン
    @IBAction func toScheduleSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "scheduleSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //そのままだとAny型をString型に入れることになりエラーが出るため as! Stringが必要
        //ユーザー名を代入
        userNameField.text = searchedUser["name"] as! String
        
        //ログインユーザーが検索ユーザーをフォローしているかを確認
        Firestore.firestore().collection("users").document(currentUser!.uid).collection("follow").document(searchedUser["uid"] as! String).getDocument{(document, error) in
            if let document = document, document.exists {
                print("検索したユーザーはフォロー中です:\(document.data())")
                self.following = true
                self.followButton.setTitle("フォロー中", for: .normal)
            } else {
                print("検索したユーザーはフォローしていません")
                self.following = false
                self.followButton.setTitle("フォローする", for: .normal)
            }
        }
    
          bannerView = GADBannerView(adSize: kGADAdSizeBanner)
          bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
          bannerView.rootViewController = self
          bannerView.load(GADRequest())
          
          addBannerViewToView(bannerView)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
