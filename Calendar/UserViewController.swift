//
//  UserViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/10.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import Firebase


class UserViewController: UIViewController {
    
    //ログインしているユーザー
    let currentUser = Auth.auth().currentUser

    //検索されたユーザー情報(dictionary型)
    var searchedUser = [String: Any]()
    
    //ログインユーザーが検索したユーザーをフォローしているかのフラグ
    var following: Bool = false

    @IBOutlet weak var userNameField: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    //検索に戻るボタン
    @IBAction func returnSearchButton(_ sender: Any) {
        self.performSegue(withIdentifier: "returnSearchSegue", sender: self)
    }
    
    //フォローボタン
    //ログインユーザーのfollowコレクションに検索しているユーザーのuidを保存
    @IBAction func follow(_ sender: Any) {
        if following {
            //既にフォローしている場合、followコレクションからuidを削除して、ボタンをフォローするに変更する
            Firestore.firestore().collection("users").document(currentUser!.uid).collection("follow").document(searchedUser["uid"] as! String).delete() {
                err in
                if let err = err {
                    print("フォロー解除中にエラーが発生しました:\(err)")
                } else {
                    print("フォローの解除に成功しました")
                }
            }
            
            following = false
            followButton.setTitle("フォローする", for: .normal)
        } else {
            //フォローしていない場合followコレクションにuidを保存して、ボタンをフォロー中に変更する
            Firestore.firestore().collection("users").document(currentUser!.uid).collection("follow").document(searchedUser["uid"] as! String).setData(["permitted": false, "name": searchedUser["name"], "email": searchedUser["email"]])
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
        Firestore.firestore().collection("users").document(currentUser!.uid).collection("follow").whereField("uid", isEqualTo: searchedUser["uid"]).getDocuments() {
            (QuerySnapshot, err) in
            if QuerySnapshot!.isEmpty {
                self.following = false
                self.followButton.setTitle("フォローする", for: .normal)
            } else {
                self.following = true
                self.followButton.setTitle("フォロー中", for: .normal)
            }
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
