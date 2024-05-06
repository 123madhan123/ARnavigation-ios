//
//  EditProfileVC.swift
//  ARNavigation
//
//  Created by SAIL on 31/01/24.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var doj: UILabel!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var userName: UITextField!
    var editProfileData: (email: String, phone: String, userName: String)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doj.addBottomBorder()
        self.email.addBottomBorder()
        self.phone.addBottomBorder()
        self.userName.addBottomBorder()
        

        
        
        _ = "\(ServiceAPI.baseUrl)arnavigation/editprofile.php"
        let _ : [String : String] = ["EmailId":"","mobileNo":"","DateOfJoin":""]
        
        if let profileData = editProfileData {
            userName.text = profileData.userName
            phone.text = profileData.phone
            email.text = profileData.email
            //            designationField.text = profileData.des
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }
    
    @IBAction func update(_ sender: Any) {
        if userName.text ?? "" != "" && phone.text ?? "" != "" && email.text ?? "" != ""
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
        
                 let url = ServiceAPI.editprofile
        
       
        var formData: [String: String] = [
            "Username": userName.text ?? "ammu",
            "mailid": email.text ?? "",
            "MobileNumber": phone.text ?? "",
            
        ]
        
        
        APIHandler().postAPIValues(type: EditProfileModel.self, apiUrl: url, method: "POST", formData: formData) { result in
    
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
