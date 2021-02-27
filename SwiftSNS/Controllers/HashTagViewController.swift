//
//  HashTagViewController.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/27.
//

import UIKit
//
import SDWebImage

class HashTagViewController: UIViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    //
    var loadDBModel = LoadDBModel()
    
    var hashTag = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        loadDBModel.loadOKDelegate = self
        
        self.navigationItem.title = "#\(hashTag)"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 角丸にする
        topImageView.layer.cornerRadius = topImageView.frame.size.height / 2
        // ロードする
        loadDBModel.loadHashTag(hashTag: hashTag)
        
    }
    
    
    
}



// MARK: - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LoadOKDelegate
extension HashTagViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LoadOKDelegate {
    //
    func loadOK(check: Int) {
        if check == 1 {
            // データが入ってきたらリロードする
            collectionView.reloadData()
        }
    }
    // セクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countLabel.text = String(loadDBModel.dataSets.count)
        return loadDBModel.dataSets.count
    }
    // セルの構築
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let contentImageView = cell.contentView.viewWithTag(1) as! UIImageView
        contentImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].contentImage), completed: nil)
        topImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[loadDBModel.dataSets.count - 1].contentImage), completed: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 画面遷移
        let detailVC = self.storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        detailVC.userName = loadDBModel.dataSets[indexPath.row].userName
        detailVC.profileImageString = loadDBModel.dataSets[indexPath.row].profileImage
        detailVC.contentImageStrig = loadDBModel.dataSets[indexPath.row].contentImage
        detailVC.comment = loadDBModel.dataSets[indexPath.row].comment
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    // ３列になるように調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 値を変えて試してみる**************************
        let width = collectionView.bounds.width/3.0
        let height = width
        
        return CGSize(width: width, height: height)
    }
    // スペースを開けたい時に使う
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    // スペースを開けたい時に使う
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    // スペースを開けたい時に使う
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
