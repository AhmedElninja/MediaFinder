//
//  UserModel.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 08/05/2023.
//


import UIKit

enum Gender: String, Codable {
    case male = "Male"
    case Female = "Female"
}

struct User: Codable {
    var name: String
    var phone: String
    var email: String
    var passwored: String
    var address: String
    var gender: Gender
    var image: CodableImage
}

struct CodableImage: Codable {
    let imageData: Data?
    
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else { return nil }
        let image = UIImage(data: imageData)
        return image
    }
    init(withImage image: UIImage) {
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
}

