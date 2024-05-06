//
//  TermsandConditionsViewController.swift
//  AR Main Navigation
//
//  Created by ELISHA RAJ on 02/04/24.
//

import UIKit

class TermsandConditionsViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    var titlStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text = self.titlStr
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }

}
