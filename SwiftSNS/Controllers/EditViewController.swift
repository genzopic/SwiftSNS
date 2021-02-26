//
//  EditViewController.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/25.
//

import UIKit
//
import Firebase

class EditViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    //
    var roomNumber = Int()
    var passImage = UIImage()
    //
    var userName = String()
    var userImageString = String()
    let screenSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボード
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func tappedSend(_ sender: Any) {
        if textField.text?.isEmpty == true {
            return
        }
        
        // 送信
        let passData = passImage.jpegData(compressionQuality: 0.01)
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid,
                                      userName: userName,
                                      comment: textField.text!,
                                      userImageString: userImageString,
                                      contentImageData: passData!)
        sendDBModel.sendData(roomNumber: String(roomNumber))
        //
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - func
    // キーボードが表示される時
    @objc func keyboardWillShow(_ notification:NSNotification){
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        textField.frame.origin.y = screenSize.height - keyboardHeight - textField.frame.height - 20
        sendButton.frame.origin.y = screenSize.height - keyboardHeight - sendButton.frame.height - 20
    }
    // キーボードが閉じられる時
    @objc func keyboardWillHide(_ notification:NSNotification){
        textField.frame.origin.y = screenSize.height - textField.frame.height - 20
        sendButton.frame.origin.y = screenSize.height - sendButton.frame.height - 20
        //空判定を
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    // タッチした時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    // キーボードが押された時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
