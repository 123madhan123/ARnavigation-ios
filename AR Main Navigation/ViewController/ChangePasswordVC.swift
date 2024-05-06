//
//  ChangePasswordVC.swift
//  ARNavigation
//
//  Created by SAIL on 31/01/24.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var confrimPwd: UITextField!
    
    var editProfileData: (old: String, newpassword: String, confrim: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newPassword.addBottomBorder()
        self.confrimPwd.addBottomBorder()
        self.username.text = Constant.userName 

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }

    @IBAction func submit(_ sender: Any) {
        if username.text ?? "" != "" && newPassword.text ?? "" != "" && confrimPwd.text ?? "" != ""
        {
            
            geteditAPI()
        }else{
            
            let alertController = UIAlertController(title: "Alert", message: "Please fill all the field", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OK tapped")
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel tapped")
            }

            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
        }
      


    }
    func navigateToBack(){
        navigationController?.popViewController(animated: true)

    }
    
    func geteditAPI(){
        
                 let url = ServiceAPI.changepassword
        
       
        let formData: [String: String] = [
            "Username":"\(username.text ?? "")" ,
            "Password": newPassword.text ?? "",
            "ConfirmPassword": confrimPwd.text ?? "",
            
        ]
        
        
        APIHandler().postAPIValues(type: ChangePassword.self, apiUrl: url, method: "POST", formData: formData) { result in
    
            switch result {
            case .success(let data):
               
                DispatchQueue.main.async {
                    
    
                        let alertController = UIAlertController(title: "Alert", message: data.message, preferredStyle: .alert)

                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            print("OK tapped")

                            self.navigateToBack()
                        
                        }

                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                            print("Cancel tapped")
                        }

                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)

                    self.present(alertController, animated: true, completion: nil)
                   

                    
                }
                
                
            case .failure(let error):
                print(error)
                
            }
        }
                                   
        
    }
    
}
