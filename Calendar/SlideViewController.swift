//
//  SlideViewController.swift
//  Calendar
//
//  Created by 笹谷亮太 on 2020/08/20.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideViewController: SlideMenuController {
    override func awakeFromNib() {
         if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTab") {
               self.mainViewController = controller
           }
         if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Left") {
               self.leftViewController = controller
           }
           super.awakeFromNib()
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
