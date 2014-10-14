//
//  PopUpViewController.swift
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 07/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@objc class PopUpViewController : UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    //@IBOutlet weak var logoImg: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.titleLabel.minimumScaleFactor = 0.9
        self.nextButton.layer.cornerRadius = 5
        self.nextButton.layer.masksToBounds = true

    }
    
    func showInView(aView: UIView!, withTitle titleString: String!, withMessage message: String!, withButton buttonString: String!, animated: Bool)
    {
        aView.addSubview(self.view)
        //logoImg!.image = image
        titleLabel!.text = titleString
        messageLabel!.text = message
        nextButton.setTitle(buttonString, forState: .Normal)

        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    @IBAction func closePopup(sender: AnyObject) {
        self.removeAnimate()
    }
}