//
//  SplashScreenVC.swift
//  ARNavigation
//
//  Created by SAIL on 31/01/24.
//

import UIKit

class SplashScreenVC: UIViewController { //}, Controller {
//    var type: ControllerType = .nav


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func nextVC(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
