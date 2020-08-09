//
//  UserViewController.swift
//  
//
//  Created by 笹谷亮太 on 2020/08/06.
//

import UIKit
import FirebaseFirestore

class UserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
