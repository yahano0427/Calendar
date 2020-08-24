//
//  SearchViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/10.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class SearchViewController: UIViewController {
    //バナー広告インスタンス
    var bannerView: GADBannerView!
    
    //ログインユーザー
    var currentUser = Auth.auth().currentUser
    
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
                    if(document.documentID == self.currentUser!.uid) {
                        print("ログインユーザーが検索されました")
                        //returnで明示的に返り値を指定しないとnouser画面に遷移したあとユーザー画面に遷移してしまう
                        return self.performSegue(withIdentifier: "nouser", sender: self)
                    }
                    
                    //検索したユーザーデータをsearchedUserに入れる
                    self.searchedUser = document.data()
                    self.searchedUser.updateValue(document.documentID, forKey: "uid")
                    
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
