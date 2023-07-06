//
//  HisMapViewController.swift
//  BombSide
//
//  Created by Andy on 2017/6/5.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import UIKit
import MapKit

class HisMapViewController: UIViewController {
    
    @IBOutlet weak var mMapView: MKMapView!

    override func viewDidLoad(){
        super.viewDidLoad()
        mMapView.showsUserLocation = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
