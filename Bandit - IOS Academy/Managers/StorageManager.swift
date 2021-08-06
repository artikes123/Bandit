//
//  StorageManager.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

final class StorageManager {
    
    private var downloadURL: URL?
    
    public static let shared = StorageManager()
    
    private let storageBucket = Storage.storage().reference()
    
    private init() {
        
    }
    
    //MARK: - UploadURL
    
    public func uploadVideoURL(from url: URL, fileName: String, genre: String, completion: @escaping (Bool) -> Void) {
        
        //Signin ya da sign up olurken kullanıcının girdiği email'in dictionary olarak kayıtlı olduğu user'ı geçktikten sonra, gelen veriyi userdefaults'a "username" olarak kaydettiğimiz stringi buraya çekiyoruz.
        
        guard let username = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            print("username failed")
            return
        }
        
        //Uploading to videos
        
        let storageUploadDirectory = ["All_Videos/\(fileName)", "Videos/\(username)/\(fileName)", "ALL_Music_Genre_Videos//\(genre)/\(fileName)", "VideosByGenre/\(genre)/\(username)/\(fileName)"]
        
        for directory in storageUploadDirectory {
            
            storageBucket.child(directory).putFile(from: url, metadata: nil) { (_, error) in
                if error != nil {
                    print("uploading to directory error is \(error)")
                }
            }
            
        }
        completion(true)
    }
    
    //MARK: - DownloadURLs
    
    /**
     Download Vİdeos with fileName From all videos. For HOMEVC
     */
    
    func getVideosWithFileName(with postNames: String, users: String?, completion: @escaping (Result<PostModel, Error>?) -> Void){
        self.storageBucket.child("All_Videos/\(postNames)").downloadURL { (url, error) in
            if let error = error {
                print("Get Download URL error is \(error)")
                completion(.failure(error))
            }
            else if let url = url {
                completion(.success(PostModel(postURL: url, identifier: "", user: User(userName: users ?? "", profilePictureURL: nil, identifier: ""))))
            }
        }
    }
    
    /**
     DownloadURL from ALLVideos
     */
    func getDownloadURL(with postModel: PostModel, completion: @escaping (Result<URL, Error>?) -> Void){
        
        self.storageBucket.child("All_Videos/\(postModel.postURL)").downloadURL { (url, error) in
            if let error = error {
                print("Get Download URL error is \(error)")
                completion(.failure(error))
            }
            else if let url = url {
                print("url is \(url)")
                completion(.success(url))
            }
        }
    }
    
    /**
     DownloadURL For music Genre
     */
    
    func getDownloadURLForMusicGenreVC(with genre: MusicCategories, completion: @escaping (Result<URL, Error>) -> Void) {
        
        storageBucket.child("VideoByGenre/\(genre)").downloadURL { (url, error) in
            if error == nil {
                if let url = url {
                    completion(.success(url))
                }
                else {
                    print("Can't unwrap url for music genre vc")
                }
            }
            else {
                print("Downloading urlfor music genre error is \(error)")
            }
        }
        
    }
    
    //MARK: - Getting Follow Info
    
    func getFollowingUsersInfo(completion: @escaping ([String], [UIImage?]) -> Void) {
        // Getting info for the user which is saved in UserDefaults
        DatabaseManager.shared.getFollowingUsers() { [weak self] (followingUsers) in
            
            for followingUser in followingUsers {
                
                //Image
                var image : UIImage?
                self?.storageBucket.child("profile_pictures/\(followingUser)/profile_picture.png").getData(maxSize: .max, completion: { (data, error) in
                    guard let data = data else {
                        return print("getting profile picture error \(error)")
                    }
                    image = UIImage(data: data)
                })
                
                //Following Users Videos
                self?.storageBucket.child("Videos/\(followingUser)").listAll { (listResult, error) in
                    if error == nil {
                        
                        listResult.items.compactMap({ usersPostNames in
                            
                            completion([usersPostNames.name], [image])
                            
                        })
                    }
                    else {
                        print("storagebucket list all error")
                    }
                    
                }
            }
        }
    }
    
    
    //MARK: - Profile Picture OPS
    
    public func uploadProfilePicture(with image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        let path = "profile_pictures/\(username)/profile_picture.png"
        // UIimage olan profile picture'I database'e pngData olarak koyuyoruz.
        storageBucket.child(path).putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                completion(.failure(error))
            }
            else {
                // PNG olarak yüklediğimiz datayı url olarak çekiyoruz.
                self.storageBucket.child(path).downloadURL { (url, error) in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    completion(.success(url))
                }
            }
        }
    }
    
    public func downloadProfilePicture(for username: String, completion: @escaping (URL?) -> Void) {
        let path = "profile_pictures/\(username)/profile_picture.png"
        
        storageBucket.child(path).downloadURL { (url, error) in
            if error == nil {
                guard let url = url else {
                    return
                }
                completion(url)
            }
            else {
                completion(nil)
                print("uncomplete url \(error)")
            }
        }
    }
    
    
    //MARK: - Generate Video Name
    
    public func generateVideoName() -> String {
        
        //videoların isimleri aynı zamanda post ID olarak iş görecek
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimeStamp = Int(Date().timeIntervalSince1970)
        
        return "\(unixTimeStamp)" + "_" + uuidString + "_" + "\(number)" + "_"
        
    }
}
