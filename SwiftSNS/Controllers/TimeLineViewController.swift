//
//  TimeLineViewController.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/25.
//

import UIKit
//
import Firebase
import Photos
import ActiveLabel  // hashタグ
import SDWebImage

class TimeLineViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //
    var roomNumber = Int()
    var loadDBModel = LoadDBModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //
        loadDBModel.loadContents(roomNumber: String(roomNumber))
        
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
extension TimeLineViewController: UINavigationControllerDelegate,
                                  UIImagePickerControllerDelegate,
                                  UITableViewDelegate,
                                  UITableViewDataSource {
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDBModel.dataSets.count
    }
    // セルの構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //　アイコン
        let profileImageView = cell.contentView.viewWithTag(1) as! UIImageView
        profileImageView.sd_setImage(with: URL(string: self.loadDBModel.dataSets[indexPath.row].profileImage), completed: nil)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        // ユーザ名
        let userNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        userNameLabel.text = loadDBModel.dataSets[indexPath.row].userName
        // 投稿画像
        let contentImageView = cell.contentView.viewWithTag(3) as! UIImageView
        contentImageView.sd_setImage(with: URL(string: self.loadDBModel.dataSets[indexPath.row].contentImage), completed: nil)
        // ハッシュタグ
        let commentLabel = cell.contentView.viewWithTag(4) as! ActiveLabel
        commentLabel.enabledTypes = [.hashtag]
        commentLabel.text = loadDBModel.dataSets[indexPath.row].comment
        commentLabel.handleHashtagTap { (hashTag) in
            print("tapped hashTag: ",hashTag)
            // 画面遷移
            
        }
        
        return cell
    }
    // カメラorアルバムが選択されたら
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

