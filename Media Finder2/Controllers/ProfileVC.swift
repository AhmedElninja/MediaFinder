//
//  ProfileVC.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 28/04/2023.
//

import SQLite

class ProfileVC: UIViewController {
    //MARK: - Outlets.
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK: - LifeCycle  Methods.
     override func viewDidLoad() {
        super.viewDidLoad()
         showData()
        } 
        
    //MARK: - Actions.
    @IBAction func LogOutBtnTapped(_ sender: UIButton) {
        let def = UserDefaults.standard
        def.setValue(false, forKey: UserDefultKeys.isUserloggedIn)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.goToSignInVC()
        }
    }
}

//MARK: - Private Methods.
extension ProfileVC {
    private func showData() {
        guard let userEmail = UserDefaults.standard.string(forKey: UserDefultKeys.emailToken) else {
            print("User email not found in UserDefaults.")
            return
        }

        if let user = DataBaseManger.shared.getUser(email: userEmail) {
            self.emailLabel.text = user.email
            self.nameLabel.text = user.name
            self.phoneLabel.text = user.phone
            self.addressLabel.text = user.address
            self.genderLabel.text = user.gender.rawValue
            self.userImageView.image = user.image.getImage()
        } else {
            print("User not found in the database.")
        }
    }
}
