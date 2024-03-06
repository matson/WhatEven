//
//  FirebaseAPI.swift
//  WhatEven
//
//  Created by Tracy Adams on 3/4/24.
//

import Foundation
import Firebase
import SystemConfiguration

class FirebaseAPI {
    
    let db = Firestore.firestore()
    
    //MARK: get and save methods
    
    //get comments
    func getComments(forPostId postId: String, completion: @escaping ([Comment]) -> Void) {
        
        if !isConnectedToNetwork() {
            // Show network alert here
            alertNet()
            return
        }
        
        
        let commentsCollection = db.collection(Constants.FStore.collectionNameComment)
        
        commentsCollection.whereField("postId", isEqualTo: postId).order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching comments")
                return
            }
            
            var tempComments = [Comment]()
            let dispatchGroup = DispatchGroup()
            
            for document in documents {
                let data = document.data()
                
                dispatchGroup.enter()
                
                let user = data["createdBy"] as? String ?? ""
                let text = data["commentText"] as? String ?? ""
                let postID = data["postId"] as? String ?? ""
                let timestamp = data["timestamp"] as? TimeInterval
                
                // Convert the timestamp to a Date object
                let date = Date(timeIntervalSince1970: timestamp ?? 0)
                
                // Fetch user details for the createdBy UID
                self.getUsers(uid: user) { result in
                    switch result {
                    case .success(let userDetails):
                        let comment = Comment(user: userDetails, postID: postID, text: text, timestamp: date)
                        tempComments.append(comment)
                    case .failure(let error):
                        print("Error retrieving user details: \(error.localizedDescription)")
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                // Sort the comments array in descending order based on the timestamp field
                tempComments.sort { comment1, comment2 in
                    return comment1.timestamp.compare(comment2.timestamp) == .orderedDescending
                }
                completion(tempComments)
            }
        }
    }
    
    //get posts
    func getPosts(completion: @escaping ([Bloop]) -> Void) {
        
        if !isConnectedToNetwork() {
            // Show network alert here
            alertNet()
            return
        }
        
        let postsCollection = db.collection(Constants.FStore.collectionNamePost)
        
        postsCollection.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching something")
                return
            }
            
            var bloops = [Bloop]()
            
            let dispatchGroup = DispatchGroup()
            
            for document in documents {
                let data = document.data()
                let postID = document.documentID
                
                dispatchGroup.enter()
                
                let imageData = data["image"] as? Data ?? Data()
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let createdBy = data["createdBy"] as? String ?? ""
                
                let image = UIImage(data: imageData)
                
                // Fetch user details for the createdBy UID
                self.getUsers(uid: createdBy) { result in
                    switch result {
                    case .success(let userDetails):
                        let bloop = Bloop(images: image!, description: description, name: name, comments: [], createdBy: userDetails, postID: postID)
                        bloops.append(bloop)
                    case .failure(let error):
                        print("Error retrieving user details: \(error.localizedDescription)")
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(bloops)
            }
        }
        
    }
    
    //register user
    func createUser(withEmail email: String, password: String, username: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                guard let uid = authResult?.user.uid else {
                    completion(NSError(domain: "com.yourapp.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get user ID"]))
                    return
                }
                
                let db = Firestore.firestore()
                let userDetailsCollection = db.collection("userDetails")
                
                let documentRef = userDetailsCollection.document(uid)
                documentRef.setData([
                    "uid": uid,
                    "userEmail": email,
                    "username": username
                ]) { error in
                    completion(error)
                }
            }
        }
    }
    
    //post Comment
    func postCommentToFirestore(commentText: String, uid: String, receivedPostId: String, timestamp: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let finalCommentText = commentText
        
        db.collection(Constants.FStore.collectionNameComment).addDocument(data: [
            Constants.FStore.commentTextField: finalCommentText,
            Constants.FStore.createdByField: uid,
            Constants.FStore.postIDField: receivedPostId,
            Constants.FStore.commentTimestampField: timestamp
        ]) { (error) in
            if let e = error {
                completion(.failure(e))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    //post Post
    func postItemToFirestore(name: String, description: String, image: UIImage, uid: String, completion: @escaping (Error?) -> Void) {
        // Convert the UIImage to Data
        guard let imageData = image.pngData() else {
            // Handle the error if conversion fails
            completion(NSError(domain: "Image Conversion Error", code: 0, userInfo: nil))
            return
        }
        
        let documentRef = db.collection(Constants.FStore.collectionNamePost).addDocument(data: [
            Constants.FStore.createdByField: uid,
            Constants.FStore.postImageField: imageData,
            Constants.FStore.postNameField: name,
            Constants.FStore.postDescriptionField: description
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data")
                completion(e)
            } else {
                print("Successfully saved data")
                completion(nil)
            }
        }
    }
    
    
    //get userDetails:
    func getUsers(uid: String, completion: @escaping (Result<UserDetails, Error>) -> Void) {
        
        let collectionName = Constants.FStore.collectionNameUserDetails
        let userDetailsQuery = db.collection(collectionName).whereField("uid", isEqualTo: uid)
        
        let dispatchGroup = DispatchGroup() // Create a dispatch group
        
        dispatchGroup.enter() // Enter the dispatch group
        
        var userDetails: UserDetails? // Declare a variable to store the user details
        
        userDetailsQuery.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let documents = snapshot?.documents else {
                    completion(.failure(NSError(domain: "No documents found.", code: 0, userInfo: nil)))
                    return
                }
                
                for document in documents {
                    let data = document.data()
                    
                    let userEmail = data["userEmail"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    
                    userDetails = UserDetails(username: username, userEmail: userEmail, uid: uid)
                }
            }
            
            dispatchGroup.leave() // Leave the dispatch group
        }
        
        dispatchGroup.notify(queue: .main) {
            if let user = userDetails {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "Failed to retrieve user details.", code: 0, userInfo: nil)))
            }
        }
    }
    
    //alert
    func alertNet(){
        let alert = UIAlertController(title: "No Network Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: Network Connection Code
    
    // Check network connection
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
}
