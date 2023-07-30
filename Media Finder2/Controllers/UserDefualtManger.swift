//
//  UserDefualtManger.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 13/05/2023.
//

import Foundation

class UserDefualtManger {

    //Mark: - singltone.
    static let shared = UserDefualtManger()

    private let def = UserDefaults.standard

    func convertUserIntoData(_ user: User)  {
        let encoder = JSONEncoder()
        if let encodeUser = try? encoder.encode(user) {
            let def = UserDefaults.standard
            def.setValue(encodeUser, forKey: UserDefultKeys.user)

        }
    }
    func convertFromDataIntoUser() -> User? {
        if let userData = UserDefaults.standard.object(forKey: UserDefultKeys.user) as? Data {
            let decoder = JSONDecoder()
            if let decodedUser = try? decoder.decode(User.self, from: userData) {
                return decodedUser
            }
        }
        return nil
    }
}
