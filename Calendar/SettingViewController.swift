//
//  SettingViewController.swift
//  
//
//  Created by 笹谷亮太 on 2020/08/06.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseUI

class SettingViewController: UIViewController, UITextFieldDelegate {
    //ログインユーザー
    let currentUser = Auth.auth().currentUser
    
    //フォローまたはフォロワーのユーザーデータを格納する
    var searchedUsers = [Dictionary<String, Any>]()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()! }}
    
    @IBAction func followButton(_ sender: Any) {
        //フォローしているユーザーデータを取得してShowFollow UserControllerに画面遷移する
        Firestore.firestore().collection("users").document(currentUser!.uid).collection("follow").getDocuments() {(QuerySnapshot, err) in
            if let err = err {
                print("ログインユーザーのフォローデータ取得時にエラーが発生しました")
            } else {
                for document in QuerySnapshot!.documents {
                    self.searchedUsers.append(document.data())
                    print("ログインユーザーのフォローデータ取得に成功しました:\(document.data())")
                }
            }
            
            //フォロー一覧画面に遷移
            //Firestoreの処理内に記述することがポイント、そうしないと非同期処理で先にperformSegueが呼ばれるために、データ渡すことができない
            self.performSegue(withIdentifier: "showFollowSegue", sender: self)
        }
    }
    
    @IBAction func tap(_ sender: Any) {
        self.performSegue(withIdentifier: "test", sender: self)
    }
    
    @IBAction func followerButton(_ sender: Any) {
        //フォロワーのユーザーデータを取得してShowFolloUserControllerに画面遷移
        Firestore.firestore().collection("users").document(currentUser!.uid).collection("follower").getDocuments() {(QuerySnapshot, err) in
            if let err = err {
                print("ログインユーザーのフォロワーデータ取得時にエラーが発生しました")
            } else {
                for document in QuerySnapshot!.documents {
                    self.searchedUsers.append(document.data())
                    print("ログインユーザーのフォロワーデータ取得に成功しました:\(document.data())")
                }
            }
            
            //フォロワー一覧画面に遷移
            //Firestoreの処理内に記述することがポイント、そうしないと非同期処理で先にperformSegueが呼ばれるために、データ渡すことができない
            self.performSegue(withIdentifier: "showFollowSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFollowSegue" {
            let nextVC = segue.destination as! ShowFollowUserViewController
            nextVC.searchedUsers = self.searchedUsers
        }
    }
    
    @IBAction func changeProfile(_ sender: Any) {
        print(nameTextField.text!)
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("users").addDocument(data: [
            "name": nameTextField.text!,
            
        ]) { err in
            if let err = err {
                print("エラーが発生しました \(err)")
            } else {
                print("ドキュメントに追加しました ID:\(ref!.documentID)")
            }
        }
        
        //Firebase Authのユーザー情報を更新
        //なぜか変更が反映されないから一旦放置
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nameTextField.text!
        changeRequest?.commitChanges()
        
        //ここの段階では名前が変更されていない
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            print("変更後のユーザー名: \(user?.displayName)")
        }

        //1.UIAlertControllerクラスのインスタンスを作成
        //タイトル、メッセージ、アラートの表示スタイルを指定
        let alert: UIAlertController = UIAlertController(title: "保存が完了しました", message:  "ここにはメッセージの内容が表示されます", preferredStyle: .alert)
        
        //2.actionの設定
        //action初期化時にタイトル、スタイル、押された時に実行するハンドラを指定する
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            print("おk")
        })
        
        //3.UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        
        //4.Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    //ログアウトボタンを押す時の動作
    @IBAction func logout(_ sender: Any) {
        do {
            //そのまま記述すると'Call can throw, but it is not marked with 'try' and the error is not handled'と怒られるのでエラーハンドリング
            try authUI.signOut()
        } catch {
            print(error)
        }

        //上のauthUI.signOut()でログアウトが完了しているためnilが返る
        Auth.auth().addStateDidChangeListener{(auth, user) in
            print("現在ログインしているユーザーのメールアドレス:\(user?.email)")
        }
        
        //ログアウトによる画面遷移
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    //ユーザー検索画面に移動
    @IBAction func searchView(_ sender: Any) {
        self.performSegue(withIdentifier: "searchViewSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        title = "プロフィール画面的な"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ここでユーザー情報を取得
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let email = user.email
                let name = user.displayName
                print("ログイン完了しました。displayName:\(name) email:\(email)")
                //user.emailでメールアドレス、user.uidでidを取得
                //user.multiFactor.enroll(with: "testMultiFactorAssertion", displayName: "testDisplayName")
                //var multiFactorString = "MultiFactor: "
                //for info in user.multiFactor.enrolledFactors {
                    //multiFactorString += info.displayName ?? "[DisplayName]"
                    //multiFactorString += " "
            }
        }
    }
}
/*
import UIKit
import FirebaseFirestore

class UserModel {
    var name: String = String()
    var mail: String = String()
}

extension UserModel {
    static func setParameter(request: UserModel) -> [String: Any] {
        var parameter: [String: Any] = [:]
        parameter["name"] = request.name
        parameter["mail"] = request.mail
        return parameter
    }
}

extension UserModel {
    static func create(request: UserModel,success:@escaping () -> Void) {
        let param = setParameter(request: request)
        let dataStore = Firestore.firestore().collection("users").addDocument(data: param)
        dataStore.setData(param) { (error) in
            if error != nil {
                print(error)
            }
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
