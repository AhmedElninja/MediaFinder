//
//  Constans.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 01/05/2023.
//

import Foundation

// MARK: - Propreties
struct Storyboards {
    static let main: String = "Main"
}

// MARK: - Views
struct Views {
    static let signInVC: String = "SignInVC"
    static let signUpVC: String = "SignUpVC"
    static let profileVC: String = "ProfileVC"
    static let mapVC: String = "MapVC"
    static let mediaVC: String = "MediaVC"


}
 
// MARK: - SQLiteTableKeys
struct SQLiteTableKeys {
    static let isTableCreatedKey: String = "isTableCreated"
}

//Mark: - UserDefultKeys
struct UserDefultKeys {
    static let isUserloggedIn: String = "isUserloggedIn"
    static let user: String = "User"
    static let emailToken: String = "emailToken"
}

//Mark: - API
struct APIMangers {
    static let baseURL = "https://itunes.apple.com/search"
}


