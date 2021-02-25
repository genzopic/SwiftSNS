//
//  TimeLineViewController.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/25.
//

import UIKit

class TimeLineViewController: UIViewController {
    
    var roomNumber = Int()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    // +ボタンをタップで、カメラを起動する
    @IBAction func openCamera(_ sender: Any) {
        
        // アラート表示（カメラORアルバムの選択）
        showAlert()
        
        
        
    }
    
    
    
    // MARK: func
    // アラート表示
    func showAlert(){
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.doCamera()
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.doAlbum()
        }
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    //
    func doCamera(){
        let sourceType:UIImagePickerController.SourceType = .camera
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    //
    func doAlbum(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
        
    
}



// MARK: - UINavigationControllerDelegate,UIImagePickerControllerDelegate
extension TimeLineViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] as? UIImage != nil{
            let selectedImage = info[.originalImage] as! UIImage
            // 値を渡しながら画面遷移
            let editVC = self.storyboard?.instantiateViewController(identifier: "editVC") as! EditViewController
            editVC.roomNumber = roomNumber
            editVC.passImage = selectedImage
            self.navigationController?.pushViewController(editVC, animated: true)
            // 閉じる
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }

    
}
