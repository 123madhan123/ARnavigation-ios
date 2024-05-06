//
//  ProfileVC.swift
//  ARNavigation
//
//  Created by SAIL on 31/01/24.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var support: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var mobile_no: UILabel!
    
    @IBOutlet weak var nameLBl: UILabel!
    @IBOutlet weak var edit: UIImageView!
    
    @IBOutlet weak var useridLbl: UILabel!
    let apiHandler : APIHandler = APIHandler()
    var UserModel : UserDeatils?
    var apiUrl = String()
    var profileData: (mail: String, mobileno: String, dob: String)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email.addBottomBorder()
        self.dob.addBottomBorder()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.edit.addAction(for: .tap) {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        // Call fetchUserDetails when the view loads
        fetchUserDetails()
    }
    
    func fetchUserDetails() {
        // let url = "http://localhost/path/to/your/php/script.php"
        // Replace with the actual URL of your PHP script
        let url = "\(ServiceAPI.baseUrl)/arnavigation/viewprofile.php"
        let param = ["Username": Constant.userName]
        
        APIHandler.shared.postAPIValues(type: UserDeatils.self, apiUrl: url, method: "POST", formData: param) { result in
            switch result {
            case .success(let response):
                print("-----res", response)
                self.UserModel = response
                self.loadUserDetails()
            case .failure(let error):
                print("-----err", error)
                self.displayError(message: "Failed to fetch user details. Error: \(error)")
            }
        }
    }
    
    
    private func displayError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func loadUserDetails() {
        if let userData = UserModel {
            print("Fetched User Data:", userData) // Verify fetched data
            
            // Perform UI updates on the main thread
            DispatchQueue.main.async {
                self.email.text = userData.user.mailid
                self.nameLBl.text = userData.user.username
               
                self.dob.text = userData.user.dateOfJoin
                self.mobile_no.text = String(userData.user.mobileNumber)
            }
        }
    }
}
extension ProfileVC {
    func reloadUserDetails() {
        fetchUserDetails()
    }
}
