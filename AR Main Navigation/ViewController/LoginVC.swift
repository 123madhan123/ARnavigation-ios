import UIKit
import Alamofire

class LoginVC: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTF.addBottomBorder()
        self.password.addBottomBorder()
        
        // Call loginAPI asynchronously on the main thread
        DispatchQueue.main.async {
            self.loginAPI()
        }
    }
    
    func loginAPI() {
        guard let username = userNameTF.text, !username.isEmpty,
              let password = password.text, !password.isEmpty else {
            // Display an alert if username or password is empty
            showAlert(message: "Please enter both username and password.")
            return
        }

        let url = "\(ServiceAPI.baseUrl)arnavigation/login.php"
        let userinfo = ["Username": username, "Password": password]

        APIHandler.shared.postAPIValues(type: LoginModel.self, apiUrl: url, method: "POST", formData: userinfo) { result in
            switch result {
            case .success(let data):
                print(data)
                DispatchQueue.main.async {
                    if data.status {
                        // If login successful, set username and navigate to home page
                        Constant.userName = username
                        print(Constant.userName)
                        self.navigateToHomePage()
                    } else {
                        // If login fails, display an alert with the error message
                        self.showAlert(message: data.message)
                    }
                }
            case .failure(let error):
                print(error)
                // Display an alert for network or server errors
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to connect to the server. Please try again later.")
                }
            }
        }
    }

    private func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func signUp(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
       loginAPI()
    }
    
    private func navigateToHomePage() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabVC") as! HomeTabVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

class KeyboardDismissalHandler: NSObject, UITextFieldDelegate {
    static let shared = KeyboardDismissalHandler()

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
