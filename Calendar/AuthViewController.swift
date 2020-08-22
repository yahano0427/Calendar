//
//  AuthViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/08.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

//ユーザー認証ページ(最初に表示される画面)
//FirebaseUIによってUIを表示する
class AuthViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var AuthButton: UIButton!
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()! }}
    //var handle: AuthStateDidChangeListenerHandle!
    
    let providers: [FUIAuthProvider] = [
        //FUIFacebookAuth(),
        //FUITWitterAuth(),
        FUIEmailAuth()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //authUIのデリゲート
        self.authUI.delegate = self
        self.authUI.providers = providers
        
        //ログイン時にviewを描画していると怒られるので追加
        //definesPresentationContext = true
    }
    
    //ボタンをタップするとFirebaseUIを使ってサインイン
    @IBAction func buttonTapped(_ sender: Any) {
        //FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        //FirebaseUIのViewの表示
        self.present(authViewController, animated: true, completion: nil)
    }

    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        //同一emailを持つユーザーがFirestore内に既に存在しない場合、新規ユーザーと見なしてFirestoreに保存する
        Firestore.firestore().collection("users").whereField("email", isEqualTo: user?.email).getDocuments() { (QuerySnapshot, err) in
            if QuerySnapshot!.isEmpty {
                Firestore.firestore().collection("users").document(user?.uid as! String).setData([
                 "name": user?.displayName,
                 "email": user?.email
                ]) { err in
                    if let err = err {
                        print("Firestoreへの新規ユーザー保存時にエラーが発生しました \(err)")
                    } else {
                        print("Firestoreに新規ユーザーを保存しました。ID:\(user?.uid)")
                    }
                }
            }
        }

        //認証に成功するとnilが返るため、ここで次のページ遷移処理
        if error == nil {
            /*
            var frontViewController = self
            while((frontViewController.presentedViewController) != nil) {
                frontViewController = frontViewController.presentedViewController as! AuthViewController
            }
 */
            //frontViewController.performSegue(withIdentifier: "MainUISegue", sender: self)
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MainUI") as! SlideViewController
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
        }
    }
/*
     違うサイトのコピペ(参考に)
    var login_status = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    //認証画面から離れた時に呼ばれる(キャンセルボタン押下含む)
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        //認証に成功した場合
        if error == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let alert = UIAlertController(title: "ログインしました", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(titile: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            //キャンセルボタンを押された時は何も出さないようにしたい
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alert = UIAlertController(title: "認証失敗", message: "ログインに失敗しました", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
