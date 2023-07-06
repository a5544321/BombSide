//
//  FiveImgScoreView.swift
//  BombSide
//
//  Created by Andy on 2017/4/19.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import UIKit

protocol FiveImgScoreDelegate :NSObjectProtocol{
    func FiveImgScoreDidScored(sender: FiveImgScoreView, point: Int)
}

@IBDesignable
class FiveImgScoreView: UIView {
    
    #if TARGET_INTERFACE_BUILDER
    @IBOutlet open weak var delegate: FiveImgScoreDelegate?
    #else
    open weak var delegate: FiveImgScoreDelegate?
    #endif
    
    var point = 3
    var btnArray = [UIButton]()
    var imgViewTitle :UIImageView?
    
    var labelTitle :UILabel?
    var labelLow :UILabel?
    var labelHigh :UILabel?
    
    var intScoreSpace :Int = 8
    
    
    
    @IBInspectable var strTitle :String = "" {
        didSet{
            //imgViewTitle?.isHidden = true
            labelTitle?.isHidden   = false
            labelTitle?.text = strTitle
        }
    }
    
    @IBInspectable var strLow :String = "" {
        didSet{
            labelLow?.text = strLow
        }
    }
    
    @IBInspectable var strHigh :String = "" {
        didSet{
           labelHigh?.text = strHigh
        }
    }
    
    @IBInspectable var imageScore :UIImage?{
        didSet{
            for button :UIButton in btnArray {
                button.setImage(imageScore, for: .normal)
            }
        }
    }
    
    @IBInspectable var imageTitle :UIImage?{
        didSet{
            labelTitle?.isHidden = true
            
            if (imgViewTitle == nil) {
                imgViewTitle = UIImageView(frame: (labelTitle?.frame)!)
                imgViewTitle?.contentMode = .scaleAspectFit
                addSubview(imgViewTitle!)
            }
            imgViewTitle?.image = imageTitle
            imgViewTitle?.isHidden = false
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initAllInOne()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initAllInOne()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        initAllInOne()
    }
    
    init(frame: CGRect, image: UIImage, title: String, lowDescrip: String, highDescrip: String){
        super.init(frame: frame)
        initAllInOne()
    }
    
    //MARK: Self Init
    
    func initAllInOne() {
        initButtonArray()
        initTitleLabel()
    }
    
    
    func initButtonArray() {
        let btnWidth = CGFloat((self.bounds.width * 0.7 - CGFloat(6 * intScoreSpace)) * 0.2)
        
        for x in 0...4{                                // 起點                  //加按鍵寬                   //加空隙
            let button = UIButton(frame: CGRect(x: (bounds.width * 0.3) + btnWidth * CGFloat(x) + CGFloat((x+1) * intScoreSpace), y: CGFloat(0), width: btnWidth, height: self.bounds.height * 0.8))
            button.addTarget(self, action:#selector(FiveImgScoreView.scoreBtnPressed(clickedBtn:)) , for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFit
            button.adjustsImageWhenHighlighted = false
            button.tag = x + 1
            btnArray.append(button)
            button.alpha = (button.tag <= point) ? 1.0 : 0.3
            addSubview(button)
        }
        
        // Low label
        labelLow = UILabel(frame: CGRect(x: bounds.width * 0.3 + 8, y: bounds.height * 0.8 - 3, width: bounds.width * 0.3, height: bounds.height * 0.2))
        addSubview(labelLow!)
        // High label
        labelHigh = UILabel(frame: CGRect(x: bounds.width * 0.7 - 4, y: bounds.height * 0.8 - 3, width: bounds.width * 0.3, height: bounds.height * 0.2))
        labelHigh?.textAlignment = .right
        addSubview(labelHigh!)
        
        labelLow?.font  = UIFont(name: "HanziPenTC-W5", size: 12)
        labelHigh?.font = UIFont(name: "HanziPenTC-W5", size: 12)
    }
    
    func initTitleLabel() {
        self.labelTitle = UILabel(frame: CGRect(x:bounds.width * 0.025,y: bounds.height * 0.07, width:bounds.width * 0.25, height: bounds.height * 0.85))
        labelTitle?.textAlignment = .center
        labelTitle?.adjustsFontSizeToFitWidth = true
        labelTitle?.font = UIFont(name: "HanziPenTC-W5", size: 20)
        addSubview(labelTitle!)
       
    }
    
    //MARK: Button Click
    
    @objc func scoreBtnPressed(clickedBtn :UIButton) {
        print(clickedBtn.tag)
        var delay :Float = 0
        for button :UIButton in btnArray {
            if button.tag <= clickedBtn.tag
            {
                if button.alpha < 1
                {
                    UIView.animate(withDuration: 0.1,
                                   delay: TimeInterval(delay),
                                   options: .curveLinear,
                                   animations: {
                                    button.alpha = 1.0
                                    button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    },
                                   completion: { (finish) in
                                    UIView.animate(withDuration: 0.05, animations: { 
                                        button.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    })
                    })
                    
                    delay += 0.1
                    
                }
                
                
            }
            else
            {
                button.alpha = 0.3
            }
//            button.alpha = (button.tag <= clickedBtn.tag) ? 1.0 : 0.3
        }
        
        point = clickedBtn.tag
        self.delegate?.FiveImgScoreDidScored(sender: self, point: clickedBtn.tag)
    }
    
    
    
    // MARK: Self Method
    
    func setScoreImage(image :UIImage) {
        imageScore = image
    }
    
    func setTitleImage(image :UIImage) {
        imageTitle = image
    }
    
    func setTitleString(title :String) {
        strTitle = title
    }
    
    func setTitleFontSize(size :CGFloat) {
        labelTitle?.font = UIFont(name: (labelTitle?.font.fontName)!, size: size)
    }
    
    func setLowHighString(low :String, high :String) {
        labelLow?.text = low
        labelHigh?.text = high
    }
    
    
    
    

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        
//    }
    

}
