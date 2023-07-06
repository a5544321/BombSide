//
//  AddDetailConditionViewController.swift
//  BombSide
//
//  Created by Andy on 2017/4/14.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import UIKit

class AddDetailConditionViewController: UIViewController,HSBColorPickerDelegate, FiveImgScoreDelegate {
    
    var colorPicker: HSBColorPicker?
    var place: Place?
    var strLocation: String = ""
    var strAddress: String = ""
    
    
    @IBOutlet weak var labelLocation: UILabel!
    
    @IBOutlet weak var scoreClean: FiveImgScoreView!
    @IBOutlet weak var scoreToiletSmell: FiveImgScoreView!
    @IBOutlet weak var scoreComfortable: FiveImgScoreView!
    @IBOutlet weak var scoreBombSmell: FiveImgScoreView!
    @IBOutlet weak var scoreWater: FiveImgScoreView!
    @IBOutlet weak var scoreAmount: FiveImgScoreView!

    @IBOutlet weak var shitView: ShitView!
    
    @IBOutlet weak var buttonfinishPickColor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreClean.setLowHighString(low: "髒", high: "乾淨")
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddDetailConditionViewController.showColorPicker(gesture:)))
        shitView.addGestureRecognizer(tap)
        
        labelLocation.text = place?.name
        
        colorPicker = HSBColorPicker(frame: CGRect(x: -self.view.frame.width * 0.65, y: 20, width: self.view.frame.width * 0.65, height: self.view.frame.height))
        self.view.addSubview(colorPicker!);
        colorPicker?.isUserInteractionEnabled = true
        colorPicker?.isHidden = true
        colorPicker?.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func showColorPicker(gesture: UITapGestureRecognizer) {
        if !(self.colorPicker?.isHidden)! {
            return
        }
        
        self.colorPicker?.isHidden = false
        UIView.animate(withDuration: 0.5,
                       animations: { 
                        self.colorPicker?.frame = CGRect(x: 0, y: 20, width: ScreenSize.width * 0.65, height: ScreenSize.height)
        })
        { (finish: Bool) in
            self.buttonfinishPickColor.isHidden = false
        }
    }
    
    
    @IBAction func finishPickBtnPressed(_ sender: UIButton) {
        sender.isHidden = true
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.colorPicker?.frame = CGRect(x: -ScreenSize.width * 0.65, y: 20, width: ScreenSize.width * 0.65, height: ScreenSize.height)
        })
        { (finish: Bool) in
            self.colorPicker?.isHidden = true
        }
        
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        var placeID: Int = 0
        
        if place?.id == nil
        {
            // New place
            // check has same name place
            if let pID = SqlManager.shareInstance().getPlaceIdbyName(name: (place?.name)!)
            {
                // 其實是舊地點
        
                SqlManager.shareInstance().updatePlaceScore(pId: pID, clean: scoreClean.point, smell: scoreToiletSmell.point, comfort: scoreComfortable.point)
                placeID = pID
                
            }
            else
            {
                // new place
                place?.clean = scoreClean.point
                place?.smell = scoreToiletSmell.point
                place?.comfortable = scoreComfortable.point
                
                print(place?.description())
                placeID = (SqlManager.shareInstance().insertPlace(place: place!))
            }
        }
        else
        {
            // old place
            SqlManager.shareInstance().updatePlaceScore(pId: (place?.id)!, clean: scoreClean.point, smell: scoreToiletSmell.point, comfort: scoreComfortable.point)
            placeID = (place?.id)!
        }
        
        print("Place ID \(placeID)")
        // insert new record
        SqlManager.shareInstance().insertRecord(placeId: placeID,
                                                 time: Date().timeIntervalSinceReferenceDate,
                                                 water: scoreWater.point,
                                                 smell: scoreBombSmell.point,
                                                 amount: scoreAmount.point,
                                                 red: shitView.mColor.redInt,
                                                 green: shitView.mColor.greenInt,
                                                 blue: shitView.mColor.blueInt,
                                                 completeBlock:{
                                                    (succees) in
                                                    
                                                    if succees {
                                                        let alert = UIAlertController(title: "Success", message: "", preferredStyle:.alert)
                                                        
                                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {ss in
                                                            self.navigationController?.popToRootViewController(animated: true)
                                                        }))
                                                        
//                                                        self.present(alert, animated: true, completion: { c in
//                                                            print("completeeeeee")
//                                                        })
                                                        self.present(alert, animated: true, completion: {
                                                            
                                                        })
                                                    }
                                                    else{
                                                        let alert = UIAlertController(title: "Fail", message: "", preferredStyle:.alert)
                                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
            
        })
        
        
    }
    
    //------------------------------------
    // MARK: - ColorPicker Delegate
    //------------------------------------
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        
    }

    func HSBColorPickerChangedColor(sender: HSBColorPicker, color: UIColor) {
//        self.view.backgroundColor = color
        shitView.setColor(color: color)
    }
    
    
    //------------------------------------
    // MARK: - FiveScore Delegate
    //------------------------------------
    func FiveImgScoreDidScored(sender: FiveImgScoreView, point: Int) {
        
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
