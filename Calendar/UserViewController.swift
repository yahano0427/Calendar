//
//  UserViewController.swift
//  
//
//  Created by 笹谷亮太 on 2020/08/06.
//

import UIKit
import FirebaseFirestore

class UserViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = "ボタンを押すとFirestoreにデータが保存されるよ"
    }
    
    private func addAdaLovelace() {
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    @IBAction func tapButton(_ sender: Any) {
        addAdaLovelace()
        label.text = "データが保存されたよ"
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
