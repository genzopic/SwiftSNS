//
//  CheckModel.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/24.
//

//import Foundation
import Photos

class CheckModel {

    func showCheckPermission()  {
        // ユーザーに許可を促す
        // 最初に起動した時に、許可の選択画面が表示される。２回目からは、最初に選択されたものが格納されていて、許可を促す画面は出ない
        PHPhotoLibrary.requestAuthorization { (status) in

            switch(status){
            case .authorized:
                print("許可されています")
            case .denied:
                print("拒否")
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .limited:
                print("limited")
            default:
                break
            }
        }
    }
}
