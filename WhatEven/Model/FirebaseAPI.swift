//
//  FirebaseAPI.swift
//  WhatEven
//
//  Created by Tracy Adams on 3/4/24.
//

import Foundation
import Firebase

class FirebaseAPI {
    let db = Firestore.firestore()
    
    //get comments 
    func getComments(forPostId postId: String, completion: @escaping ([Comment]) -> Void) {
            let commentsCollection = db.collection(Constants.FStore.collectionNameComment)
            
            commentsCollection.whereField("postId", isEqualTo: postId).addSnapshotListener { snapshot, error in
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
                    
                    let comment = Comment(user: user, postID: postID, text: text)
                    
                    tempComments.append(comment)
                    
                    dispatchGroup.leave()
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(tempComments)
                }
            }
        }
    
    //get posts
    func getPosts(completion: @escaping ([Bloop]) -> Void) {
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
                
                let bloop = Bloop(images: image!, description: description, name: name, comments: [], createdBy: createdBy, postID: postID)
                
                bloops.append(bloop)
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(bloops)
            }
        }
    }
}
