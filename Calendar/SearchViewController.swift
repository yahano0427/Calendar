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
    //入力フォーム
    @IBOutlet weak var searchTextField: UITextField!
    
    //ログインユーザーのuid
    let uid = Auth.auth().currentUser?.uid

    //検索
    @IBAction func search(_ sender: Any) {
        print(searchTextField.text!)
        Firestore.firestore().collection("users").whereField("email", isEqualTo: searchTextField.text!).getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("ユーザーが見つかりませんでした。:\(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
            
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
