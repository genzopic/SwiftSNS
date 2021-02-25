//
//  SendDBModel.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/24.
//

import Foundation
//import UIKit
import Firebase
//import FirebaseStorage

class SendDBModel {
    
    var userID = String()
    var userName = String()
    var comment = String()
    var userImageString = String()
    var contentImageData = Data()
    var db = Firestore.firestore()
    // 送信機能を集約する
    init(){
        
        
    }
    //
    init(userID: String,userName: String, comment: String, userImageString: String, contentImageData: Data) {
        self.userID = userID
        self.userName = userName
        self.comment = comment
        self.userImageString = userImageString
        self.contentImageData = contentImageData
    }
    // 匿名ログインした時のユーザイメージをfirestorageに保存し、urlをアプリ内に保存しておく
    func sendProfileImageData(data: Data) {
        guard let image = UIImage(data:data) else { return }
        guard let profileImage = image.jpegData(compressionQuality: 0.1) else { return }
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        imageRef.putData(profileImage, metadata: .none) { (metadata, error) in
            if let err = error {
                print("profileImage putData err: ",err.localizedDescription)
                return
            }
            print("profileImage putData success")
            imageRef.downloadURL { (url, error) in
                if let err = error {
                    print("profileImage downLoadURL err: ",err.localizedDescription)
                    return
                }
                print("Url: \(url!.absoluteString)")
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
            }
        }
    }
    //
    func sendData(roomNumber: String) {
        // 送信の処理を行う
        let imageRef = Storage.storage().reference().child("Images").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        imageRef.putData(self.contentImageData, metadata: .none) { (metadata, error) in
            if let err = error {
                print("contentImage putData err: ",err.localizedDescription)
                return
            }
            print("contentImage putData success")
            imageRef.downloadURL { (url, error) in
                if let err = error {
                    print("contentImage downLoadURL err: ",err.localizedDescription)
                    return
                }
                print("Url: \(url!.absoluteString)")
                self.db.collection(roomNumber).document().setData(["userID" : self.userID,
                                                                   "userName": self.userName,
                                                                   "comment" :self.comment,
                                                                   "userImageString": self.userImageString,
                                                                   "contentImage": url?.absoluteString as Any,
                                                                   "postDate": Date().timeIntervalSince1970]) { (error) in
                    if let err = error {
                        print("setData err: ",err.localizedDescription)
                    }
                }
                
            }
            
        }

        
    }
    
}
