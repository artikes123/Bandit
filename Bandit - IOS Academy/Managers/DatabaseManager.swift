//
//  DatabaseManager.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import Foundation
import FirebaseDatabase
import Firebase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    public let database = Database.database(url: "https://bandit-74781-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    private init() {
        
    }
    
    //MARK: - USER Operations
    
    public func insertUsers(with email: String, username: String, instrument: String, completion: @escaping (Bool) -> Void) {
        
        //Create users root node if there is no user
        database.child("users").observeSingleEvent(of: .value) { [weak self] (snapShot) in
            
            //Snapshot değeri dolu geldiği zaman(yani user daha önceden DB'ye eklendiği zaman) else'e girmiyor.
            // !!!!!!! usersDictionary dediğimiz şey: DB'deki users dalının altındaki değerleri getiriyoruz.
            guard var usersDictionary = snapShot.value as? [String: Any] else {
                
                self?.database.child("users").setValue([username.lowercased() : ["email": email, "instrument:": instrument]], withCompletionBlock: { (error, _) in
                    guard error == nil else {
                        print("Databaase manager insert user error")
                        completion(false)
                        return
                    }
                    completion(true)
                    
                })
                return
            }
            usersDictionary[username] = ["email" : email, "instrument": instrument]
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { (error, _) in
                if error != nil {
                    completion(false)
                }
                else {
                    completion(true)
                }
            })
            
        }     
    }
 
    
    public func getUsername(with email: String, completion: @escaping (String?) -> Void) {
        // username'i post atmaya çalışan user'ın emaili ile bulmaya çalışacağız.
        
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String: [String: Any]]  /* Dictionary olduuğu için string any olarak cast ettik ki for loop içerisinde kulalnabilelim */ else {
                print("can not get email")
                completion(nil)
                return
            }
            
            for(username, value) in users {
                if value["email"] as? String == email {
                    print("Database username \(username)")
                    completion(username)
                    break
                }
            }
        }
    }
    
    //MARK: - Search
    public func getSearchedUsername(with username: String, completion: @escaping ([String]?) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            
            guard let user = snapshot.value as? [String: [String:Any]] else {
                print("cant get searched username")
                completion([])
                return
            }
            
            var userArrayList = [String]()
            
            for (usernameDB, _) in user {
                
                if usernameDB.contains(username){
                    userArrayList.append(usernameDB)
                    
                }
                
            }
            completion(userArrayList)
        }
    }
    //MARK: - Getting Posts
    
    public func getGenrePosts(for genre: MusicCategories, completion: @escaping ([String: [String:Any]]) -> Void) {
        let path = "posts/\(genre.title)"
        database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            guard let posts = snapshot.value as? [String: [String:Any]] else {
                print("Cant get postnames for getPostFileNames")
                return
            }
                print(posts)
                completion(posts)
            }
        
        }

    public func getPosts(for user: User, completion: @escaping ([PostModel]) -> Void) {
        
        let path = "users/\(user.userName.lowercased())/posts"
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            
            guard let posts = snapshot.value as? [[String : String]] else {
                
                print("getting post error")
                completion([])
                return
                
            }
            
            let models: [PostModel] = posts.compactMap({
                var model = PostModel(postURL: URL(fileURLWithPath: ""), user: user)
                model.fileName = $0["FileName"] ?? ""
                model.caption = $0["Caption"] ?? ""
                model.postGenre = $0["Post Genre"] ?? ""
                
                return model
            })
            completion(models)
        }
    }
    
    //MARK: - Inserting Posts
    
    /**
    Inserting posts under the user's posts
     */
    public func insertPostsToDBUsers(with fileName: String, caption: String, genre: String, completion: @escaping (Bool) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self](snapshot) in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            
            let newEntry = ["FileName": fileName, "Caption": caption, "Post Genre": genre]
            //User'In altında posts varsa, filename'i daha önceden belirlenmiş olan dosyayı appendle
            if var posts = value["posts"] as? [[String:Any]] {
                
                posts.append(newEntry)
                value["posts"] = posts
                self?.database.child("users").child(username).setValue(value) { (error, _) in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
            else {
                value["posts"] = [newEntry]
                self?.database.child("users").child(username).setValue(value) { (error, _) in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
            
        }
        
    }
    
    /**
        Inserting posts to DB
     */
    
    public func insertPostToDBwithModel(with model: PostModel, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let value = ["username": username, "likedByCurrentUser" : model.likedByCurrentUser, "bandits": model.banditFileNames, "genre": model.postGenre, "caption": model.caption] as [String : Any]
        let pathAllPosts = "posts/All_Posts/\(model.fileName)"
        let pathGenrePosts = "posts/\(model.postGenre)/\(model.fileName)"
        
        database.child(pathAllPosts).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard var postDictionary = snapshot.value as? [[String: Any]] else {
                self?.database.child(pathAllPosts).setValue(value) { (error, _) in
                    guard error == nil else {
                        print("error is \(error)")
                        completion(false)
                        return
                    }
                    self?.database.child(pathGenrePosts).setValue(value) { (error, _) in
                        guard error == nil else {
                            completion(false)
                            print("error is \(error)")
                            return
                        }
                        completion(true)
                    }
                }
                return
            }
            postDictionary.append(value)
            self?.database.child(pathAllPosts).setValue(postDictionary,withCompletionBlock: { (error, _) in
                guard error == nil else {
                    print("error is \(error)")
                    completion(false)
                    return
                }
                self?.database.child(pathGenrePosts).setValue(value)
                completion(true)
            })
            
        }
        
    }

    
    //MARK: - Notifications
    public func getNotifications(completion: @escaping ([NotificationStruct]) -> Void) {
        completion(NotificationStruct.mockData())
    }
    
    public func follow(username:String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    public func markNotificationAsHidden(notificationID: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    
    //MARK: - Follow System
    
    public func getFollowerFollowing(for user: User,
                                     type:UserListViewController.ListType,
                                     completion: @escaping ([String]) -> Void) {
        let path = "users/\(user.userName.lowercased())/\(type.rawValue)"
        print("fetching path \(path)")
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let userNameCollection = snapshot.value as? [String] else {
                completion([])
                return
            }
            completion(userNameCollection)
        }
    }
    
    public func getFollowingUsers(completion: @escaping ([String]) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            return
        }
        print(username)
        let path = "users/\(username)/following"
        
        database.child(path).observeSingleEvent(of: .value) {(snapshot) in
            guard let followingUsers = snapshot.value as? [String] else {
                print("GETTFOLLOWİNGUSERS DB ERROR")
                return completion([])
            }
            print(followingUsers)
            completion(followingUsers)
            
        }
    }
    
    public func isValidRelationShip(for user: User, type: UserListViewController.ListType, completion: @escaping (Bool) -> Void) {
        let path = "users/\(user.userName.lowercased())/\(type.rawValue)"
        
        guard let currentUserUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            return
        }
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let userNameCollection = snapshot.value as? [String] else {
                completion(false)
                return
            }
            completion(userNameCollection.contains(currentUserUsername))
        }
        
    }
    
    public func updateRelationShip(for user: User, follow:Bool, completion: @escaping (Bool) -> Void) {
        
        guard let currentUserUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            return
        }
        
        if follow {
            let path = "users/\(currentUserUsername)/following"
            
            //insert in current users following
            database.child(path).observeSingleEvent(of: .value) { (snapshot) in
                let userToInsert = user.userName
                if var current = snapshot.value as? [String] {
                    if !current.contains(userToInsert) {
                        current.append(userToInsert)
                        self.database.child(path).setValue(current) { (error, _) in
                            completion(error == nil)
                        }
                    }
                }
                else {
                    self.database.child(path).setValue([userToInsert]) { (error, _) in
                        completion(error == nil)
                    }
                }
            }
            
            //insert in target user follower
            
            let path2 = "users/\(user.userName.lowercased())/followers"
            
            //insert in current users following
            database.child(path2).observeSingleEvent(of: .value) { (snapshot) in
                let userToInsert = currentUserUsername
                if var current = snapshot.value as? [String] {
                    current.append(userToInsert)
                    self.database.child(path2).setValue(current) { (error, _) in
                        completion(error == nil)
                    }
                }
                else {
                    self.database.child(path2).setValue([userToInsert]) { (error, _) in
                        completion(error == nil)
                    }
                }
            }
        }
        
        else {
            
            //remove in current users following
            
            //remove in target user follower
            
        }
        
    }
    
}
