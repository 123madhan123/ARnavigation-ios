//
//  SignUpVC.swift
//  ARNavigation
//
//  Created by SAIL on 31/01/24.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var mobilenumbertf: UITextField!
    @IBOutlet weak var confPwdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confPwdTF.addBottomBorder()
        self.passwordTF.addBottomBorder()
        self.emailTF.addBottomBorder()
        self.usernameTF.addBottomBorder()
        self.mobilenumbertf.addBottomBorder()
        }

    
    override func viewWillAppear(_ animated: Bool) {
    
    }

    @IBAction func submit(_ sender: Any) {
        let url = "\(ServiceAPI.baseUrl)/arnavigation/signup.php"
        if let userName = usernameTF.text, let pass = passwordTF.text,let rePass = confPwdTF.text, let mobile = mobilenumbertf.text, let mailId = emailTF.text {
            
            let userinfo : [String : String] = ["Username":userName,"mailid":mailId,"MobileNumber":mobile, "Password": pass,"repassword":rePass]
            APIHandler.shared.postAPIValues(type: SignUpModel.self, apiUrl: url, method: "POST", formData: userinfo) { result in
                switch result {
                case .success(let response):
                    print("------",response)
                    DispatchQueue.main.sync {
                        self.navigateToLoginPage()
                    }
                case .failure(let err):
                    print("--------",err)
                }
            }
            
            
        }
    }
    
    private func navigateToLoginPage() {
        if let viewControllers = self.navigationController?.viewControllers {
            for controllers in viewControllers {
                if controllers is LoginVC {
                    self.navigationController?.popToViewController(controllers, animated: true)
                }
            }
        }
    }
    
}
