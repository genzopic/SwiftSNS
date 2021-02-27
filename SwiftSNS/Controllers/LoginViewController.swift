//
//  LoginViewController.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/24.
//

import UIKit
//
import Firebase

class LoginViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var urlString = String()
    var sendDBModel = SendDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // カメラ、写真のアクセス許可確認
        let checkModel = CheckModel()
        checkModel.showCheckPermission()
        
    }
    
    @IBAction func tappedLogin(_ sender: Any) {
        if textField.text?.isEmpty == true {
            return
        }
        
        // 匿名ログイン
        Auth.auth().signInAnonymously { (result, error) in
            if let err = error  {
                print("signin err: ", err.localizedDescription)
                return
            }
            let user = result?.user
            print("user: ",user.debugDescription)

            // 次の画面へ遷移
            let selectVC = self.storyboard?.instantiateViewController(identifier: "SelectVC") as! SelectRoomViewController
            
            // ユーザー名を保存
            UserDefaults.standard.setValue(self.textField.text, forKey: "userName")
            
            // 画像をクラウドストレージに送信
            guard let data = self.profileImageView.image?.jpegData(compressionQuality: 0.1) else { return }
            self.sendDBModel.sendProfileImageData(data: data)
            
            self.navigationController?.pushViewController(selectVC, animated: true)
            
        }
        
        // 
        
        
    }
    // imageViewをタップ
    @IBAction func tappedImageView(_ sender: Any) {
        print("tappedImageView")
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        showAlert()
        
    }
    
    
    // MARK: - func
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] as? UIImage != nil{
            let selectedImage = info[.originalImage] as! UIImage
            profileImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
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
    //アラート
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
    // タッチでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }

}
