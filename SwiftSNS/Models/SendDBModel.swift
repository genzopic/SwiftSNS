//
//  SendDBModel.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/24.
//

import Foundation
//import UIKit
import FirebaseStorage

class SendDBModel {
    
    // 送信機能を集約する
    init(){
        
        
    }
        
    func sendProfileImageData(data: Data) {
        guard let image = UIImage(data:data) else { return }
        guard let profileImage = image.jpegData(compressionQuality: 0.1) else { return }
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        imageRef.putData(profileImage, metadata: .none) { (metadata, error) in
            if let err = error {
                print("profileImage putData err: ",err.localizedDescription)
                return
            }
            imageRef.downloadURL { (url, error) in
                if let err = error {
                    print("profileImage downLoadURL err: ",err.localizedDescription)
                    return
                }
                
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
            }
            
        }
    }
    
}
