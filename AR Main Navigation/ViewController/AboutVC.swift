//
//  AboutVC.swift
//  ARNavigation
//
//  Created by SAIL on 31/01/24.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    
    var titlStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text = self.titlStr
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }



}
