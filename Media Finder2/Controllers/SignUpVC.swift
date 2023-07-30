//
//  SignUpVC.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 24/04/2023.
//

import SDWebImage
import SQLite


class SignUpVC: UIViewController {
    
    // MARK: - Outlets.
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passworedTextField: UITextField!
    @IBOutlet weak var confirmPassworedTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    // MARK: - Proprepties.
    private var gender: Gender = .Female
    private var imagePicker = UIImagePickerController()
    private var isUserImageChanged: Bool = false

    // MARK: - LifeCycle Method.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign Up Screen"
        DataBaseManger.shared.createTable()
        imagePicker.delegate = self
        getImageFromURL()
        
       
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 
    // MARK: - Actions.
    @IBAction func genderSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            gender = .Female
        } else {
            gender = .male
        }
    }
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        if IsDateEnterd() {
            if isDataValid() {
                goToSignInVC()
            }
        }
    } 
    @IBAction func addressBtnTapped(_ sender: UIButton) {
        goToMapVC()
    }
    
    @IBAction func userImageBtnTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    

}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate.
extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImageView.image = pickedImage
            isUserImageChanged = true
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Methods.
extension SignUpVC {
    private func getImageFromURL() {
        userImageView.sd_setImage(with: URL(string: "https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png"), placeholderImage: UIImage(named: "user"))
    }
    private func goToSignInVC(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let signInVC: SignInVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC ) as! SignInVC
      
        let user = User(
            name: nameTextField.text ?? "",
            phone: phoneTextField.text ?? "",
            email: emailTextField.text ?? "",
            passwored: passworedTextField.text ?? "",
            address: addressTextField.text ?? "",
            gender: gender,
            image: CodableImage.init(withImage: userImageView.image!)
            )
            
        DataBaseManger.shared.insertUser(user, emailToken: emailTextField.text!)
        
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    private func goToMapVC(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let mapVC: MapVC = mainStoryboard.instantiateViewController(withIdentifier: Views.mapVC ) as! MapVC
        mapVC.delegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
     
    private func IsDateEnterd() -> Bool {
        guard isUserImageChanged != false else {
            showAlert(message: "Please choose image!")
            return false
        }
        guard nameTextField.text != "" else {
            showAlert(message: "Please enter name!")
            return false 
        }
        guard emailTextField.text != "" else {
            showAlert(message: "Please enter email!")

            return false
        }
        guard phoneTextField.text != "" else {
            showAlert(message: "Please enter phone!")

            return false
        }
        guard passworedTextField.text != "" else {
            showAlert(message: "Please enter passwored!")
            
            return false
        }
        guard confirmPassworedTextField.text != "" else {
            showAlert(message: "Please enter confirm passwored!")
            if confirmPassworedTextField.text != passworedTextField.text {
                showAlert(message: "Passwored dosen't match")
            } else {
                return true
            }

            return false
        }
        guard addressTextField.text != "" else {
            showAlert(message: "Please enter address!")

            return false
        }
        return true
    }
    private func isDataValid() -> Bool {
        guard Validator.shared().isValidEmail(email: emailTextField.text!) else {
            showAlert(message: "Please enter Valid email. Example: mail@Example.com")
            return false
        }
        guard Validator.shared().isValidPhone(number: phoneTextField.text!) else {
            showAlert(message: "Please enter Valid Phone Number. Example: 01000000000")
            return false
        }
        guard Validator.shared().isValidPassword(password: passworedTextField.text!) else {
            showAlert(message: "Please enter Valid Passwored. Must contain At least: one Capital letter, one small letter, one Number and one spesific character, it must be at least 8 character Example: Aa@12345")
            return false
        }
        return true
    }
    
}
extension SignUpVC: addressDelegation {
    func sendAddress(address: String) {
        addressTextField.text = address
    }
}


