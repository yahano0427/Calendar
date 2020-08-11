//
//  NoUserViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/11.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit

class NoUserViewController: UIViewController {
    @IBAction func returnSearchButton(_ sender: Any) {
        self.performSegue(withIdentifier: "returnSearchSegue", sender: self)
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
