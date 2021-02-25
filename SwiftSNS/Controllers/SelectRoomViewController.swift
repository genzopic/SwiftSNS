//
//  SelectRoomViewController.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/24.
//

import UIKit
//
import ViewAnimator

class SelectRoomViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    //
    var roomArray = ["今日の1枚","爆笑報告場(草)","景色が好き！","夜景写真軍団","今日のごはん"]
    var imageArray = ["0","1","2","3","4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SelectRoomViewController viewDidLoad")

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SelectRoomViewController viewWillAppear")

        self.navigationController?.isNavigationBarHidden = true
        tableView.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SelectRoomViewController viewDidAppear")

        tableView.isHidden = false
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        UIView.animate(views: tableView.visibleCells, animations: animation, completion:nil)
    }
    


}


// MARK: - ,UITableViewDelegate,UITableViewDataSource
extension SelectRoomViewController: UITableViewDelegate,UITableViewDataSource {
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomArray.count
    }
    // セルの構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //Roomの画像を反映
        let roomImageView = cell.contentView.viewWithTag(1) as! UIImageView
        roomImageView.image = UIImage(named: imageArray[indexPath.row])
        //room名
        let roomLabel = cell.contentView.viewWithTag(2) as! UILabel
        roomLabel.text = roomArray[indexPath.row]
        return cell
    }
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    // セルをタッチしたら
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移
        let timeLineVC = self.storyboard?.instantiateViewController(identifier: "timeLineVC") as! TimeLineViewController
        timeLineVC.roomNumber = indexPath.row
        self.navigationController?.pushViewController(timeLineVC, animated: true)
    }

}
