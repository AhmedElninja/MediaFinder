//
//  SignInVC.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 25/04/2023.
//

import SQLite


class SignInVC: UIViewController {
    
    // MARK: - Outlets.
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passworedTextField: UITextField!
    
    // MARK: - Properties.
    var email: String = ""
    var passwored: String = ""
  
   

    
    // MARK: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions.
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        if isDataEntered() {
            logInData()
            if isDataCorrect() {
                goToMediaVC()
            }
        }  
    }
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        goToSignUpVC()
    }
}

// MARK: - Private Methods.
extension SignInVC {
    private func logInData() {
        guard let user = DataBaseManger.shared.getUser(email: emailTextField.text!) else {
            showAlert(message: "Email does not exist")
            return
        }
        
        email = user.email
        passwored = user.passwored
        
        if user.passwored == passworedTextField.text {
            UserDefaults.standard.set(user.email, forKey: UserDefultKeys.emailToken)
        } else {
            showAlert(message: "Wrong Passwored")
        }
    }
    
    private func goToMediaVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let mediaVC: MediaVC = mainStoryboard.instantiateViewController(withIdentifier: Views.mediaVC) as! MediaVC
        self.navigationController?.pushViewController(mediaVC, animated: true)
    }
    
    private func isDataCorrect() -> Bool {
        return email == emailTextField.text && passwored == passworedTextField.text
    }
    
    private func isDataEntered() -> Bool {
        guard emailTextField.text != "" else {
            showAlert(message: "Please enter email!")
            return false
        }
        
        guard passworedTextField.text != "" else {
            showAlert(message: "Please enter passwored!")
            return false
        }
        
        return true
    }
    private func goToSignUpVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let signUpVC: SignUpVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signUpVC) as! SignUpVC
        self.navigationController?.viewControllers = [signUpVC, self]
        self.navigationController?.popViewController(animated: true)
    }
}



