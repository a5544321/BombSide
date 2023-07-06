//
//  HistoryViewController.swift
//  BombSide
//
//  Created by Andy on 2017/4/25.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    var shits = [Record]()
    
    @IBOutlet weak var mTableView: UITableView!
    
    let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rb = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        rb.setImage(UIImage(named: "toilet"), for: .normal)
        rb.addTarget(self, action: #selector(HistoryViewController.showBombSelect(sender:)), for: .touchUpInside)
        
        let wCons = NSLayoutConstraint(item: rb, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let hCons = NSLayoutConstraint(item: rb, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        rb.addConstraints([wCons, hCons])
        let rightBtn = UIBarButtonItem(customView: rb)
//        self.navigationItem.rightBarButtonItem = rightBtn
        self.tabBarController?.navigationItem.rightBarButtonItem = rightBtn
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        shits = (SqlManager.shareInstance().getRecords(placeId: nil))
//        print(shits)
        mTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func showBombSelect(sender: UIButton) {
        let sheet = UIAlertController(title: "Sheeeeeep", message: "sssss", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "New Location", style: .default, handler: { (action) in
            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "mapVC")
            self.show(mapVC!, sender: nil)
        }))
        sheet.addAction(UIAlertAction(title: "History", style: .default, handler: { (action) in
            
        }))
        self.present(sheet, animated: true, completion: nil)
    }
    
    
    //--------------------------------------------------------------------------------
    // MARK: - TableView delegate
    //--------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "his_cell", for: indexPath) as! HistoryTableViewCell
        
        cell.mShitView.setColor(color: shits[indexPath.row].color)
        cell.labelName.text = shits[indexPath.row].place.name
        let dateFormatter = DateFormatter();
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        cell.labelAddress.text = dateFormatter.string(from: shits[indexPath.row].date)
        //print("date \(DateFormatter().string(from: shits[indexPath.row].date))")
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
