//
//  SettingsVC.swift
//  ARNavigation
//
//  Created by SAIL on 31/01/24.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func profile(_ sender: Any) {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func aboutUs(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        nextVC.titlStr = "ABOUT US"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func privacy(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        nextVC.titlStr = "Privacy Policy"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func terms(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsandConditionsViewController") as! TermsandConditionsViewController
        nextVC.titlStr = "Terms & Conditions"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
        
        
    }
    
    
}
