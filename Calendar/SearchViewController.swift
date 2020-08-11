//
//  SearchViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/10.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    //検索したユーザーデータ
    var searchedUser = [String: Any]()
    
    //入力フォーム
    @IBOutlet weak var searchTextField: UITextField!
    
    //検索
    @IBAction func search(_ sender: Any) {
        Firestore.firestore().collection("users").whereField("email", isEqualTo: searchTextField.text!).getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("エラーが発生しました。:\(err)")
                
                //ユーザーが見つからなかった場合の画面に遷移
                self.performSegue(withIdentifier: "nouser", sender: self)
            } else {
                if QuerySnapshot!.isEmpty {
                    print("ユーザーが見つかりませんでした")
                    self.performSegue(withIdentifier: "nouser", sender: self)
                }
                for document in QuerySnapshot!.documents {
                    //検索したユーザーデータをsearchedUserに入れる
                    self.searchedUser = document.data()
                    
                    print("\(document.documentID) => \(document.data())")
                    
                    //検索結果のデータを渡してUserViewControllerに遷移
                    //ユーザーが見つかった場合のみユーザー画面に遷移
                    self.performSegue(withIdentifier: "user", sender: self)
                }
            }
        }
    }
    
    //prepareyはperformdSegueの前に実行される関数。遷移先にデータを渡したいときなどに使う
    //今回はユーザー名をUserViewControllerに渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "user" {
           let nextVC = segue.destination as! UserViewController
           nextVC.searchedUser = self.searchedUser
        }
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
