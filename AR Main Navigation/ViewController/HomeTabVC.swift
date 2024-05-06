//
//  HomeTabVC.swift
//  ARNavigation
//
//  Created by SAIL on 31/01/24.
//

import UIKit

class HomeTabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }



}
