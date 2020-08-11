//
//  UserViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/10.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    //""と初期化すると型宣言をする必要がなくなる(自動でString型になる)
    var userName = ""

    @IBOutlet weak var userNameField: UILabel!
    
    @IBAction func returnSearchButton(_ sender: Any) {
        self.performSegue(withIdentifier: "returnSearchSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userNameField.text = userName
    }
    
    @IBAction func toScheduleSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "scheduleSegue", sender: self)
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
