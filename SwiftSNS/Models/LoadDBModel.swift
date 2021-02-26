//
//  LoadDBModel.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/26.
//

//import Foundation
//
import Firebase

class LoadDBModel {
    
    var dataSets = [DataSet]()
    let db = Firestore.firestore()
    
    func loadContents(roomNumber: String) {
        
        db.collection(roomNumber).order(by: "postDate", descending: true).addSnapshotListener { (snapShot, error) in
            if let err = error {
                print("roomNumber \(roomNumber) addSnapshotListner err: ",err.localizedDescription)
                return
            }
            self.dataSets = []
            if let snapShotDoc = snapShot?.documents {
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let userID = data["userID"] as? String,
                       let userName = data["userName"] as? String,
                       let comment = data["comment"] as? String,
                       let profileImage = data["userImageString"] as? String,
                       let contentImage = data["contentImage"] as? String,
                       let postDate = data["postDate"] as? Double {
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, profileImage: profileImage, postDate: postDate, contentImage: contentImage)
                        self.dataSets.append(newDataSet)
                        
                    }
                }
                

            }
        }
        
    }
    
}
