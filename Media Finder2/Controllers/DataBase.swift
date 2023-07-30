//
//  DataBase.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 29/05/2023.
//

import SQLite

class DataBaseManger {
    
    // Singleton
    static let shared = DataBaseManger()
    
    // Properties
    var database: Connection!
    
    let usersTable: Table = Table("Users")
    let id = Expression<Int>("ID")
    let name = Expression<String>("Name")
    let email = Expression<String>("Email")
    let phone = Expression<String>("Phone")
    let passwored = Expression<String>("Passwored")
    let address = Expression<String>("Address")
    let gender = Expression<String>("Gender")
    let image = Expression<Data>("Image")
    
    let segmentTable: Table = Table("SegmentTable")
    let segmentIndex = Expression<Int>("SegmentIndex")
    let segmentData = Expression<Data>("SegmentData")
    let segmentMail = Expression<String>("SegmentMail")
}

// MARK: - DataBaseManger Methods
extension DataBaseManger {
    public func setUpConnection() {
        do {
            let doucmentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: true)
            let filePath = doucmentDirectory.appendingPathComponent("usersDatabase").appendingPathExtension("sqlite3")
            let database = try Connection(filePath.path)
            self.database = database
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func createTable() {
        let tableExistsQuery = usersTable.exists
        let tableSearchResultsQuery = segmentTable.exists
        
        let createTable = self.usersTable.create { table in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique: true)
            table.column(self.phone)
            table.column(self.passwored)
            table.column(self.address)
            table.column(self.gender)
            table.column(self.image)
        }
        let createSegmentTable = self.segmentTable.create { table in
            table.column(self.segmentIndex, primaryKey: true)
            table.column(self.segmentData)
            table.column(self.segmentMail)
        }
        
        do {
            try self.database.run(createTable)
            try self.database.run(createSegmentTable)
            print("Table Created")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func insertUser(_ user: User, emailToken: String) {
        if let imageData = user.image.imageData {
            let insertUser = self.usersTable.insert(
                self.name <- user.name,
                self.email <- user.email,
                self.phone <- user.phone,
                self.passwored <- user.passwored,
                self.address <- user.address,
                self.gender <- user.gender.rawValue,
                self.image <- imageData
            )
            
            do {
                try self.database.run(insertUser)
                UserDefaults.standard.set(emailToken, forKey: "emailToken")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func getUser(email: String) -> User? {
        let filteredUsers = self.usersTable.filter(self.email == email)
        
        do {
            let users = try self.database.prepare(filteredUsers)
            for user in users {
                let imageData = user[self.image]
                if let image = UIImage(data: imageData) {
                    return User(
                        name: user[self.name],
                        phone: user[self.phone],
                        email: user[self.email],
                        passwored: user[self.passwored],
                        address: user[self.address],
                        gender: Gender(rawValue: user[self.gender])!,
                        image: CodableImage(withImage: image)
                    )
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    public func saveSegmentData(segmentIndex: Int, data: Data, forUserEmail email: String) {
        guard let user = getUser(email: email) else {
            return
        }
        
        let segmentData = self.segmentTable.filter(self.email == user.email)
        
        do {
            if let _ = try self.database.pluck(segmentTable) {
                let update = segmentTable.update(self.segmentIndex <- segmentIndex,
                                                self.segmentData <- data)
                try self.database.run(update)
            } else {
                let insert = self.segmentTable.insert(self.segmentIndex <- segmentIndex,
                                                      self.segmentData <- data,
                                                      self.segmentMail <- user.email)
                try self.database.run(insert)
            }
            print("Segment Data saved for user: \(user.email)")
        } catch {
            print(error.localizedDescription)
        }
    }
    public func loadSegmentData(forUserEmail email: String) -> (segmentIndex: Int, data: Data)? {
        
        guard let user = getUser(email: email) else {
            print("User Not Found")
            return nil
        }
        
        do {
            if let row = try self.database.pluck(segmentTable) {
                let index = row[self.segmentIndex]
                let data = row[self.segmentData]
               
                return (segmentIndex: index, data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

                    
    
    

