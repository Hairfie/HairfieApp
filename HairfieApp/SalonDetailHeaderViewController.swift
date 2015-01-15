//
//  SalonDetailHeaderViewController.swift
//  HairfieApp
//
//  Created by Antoine Hérault on 28/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


@objc class SalonDetailHeaderViewController : UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var picturesScrollView: UIScrollView!
    @IBOutlet weak var picturesPageControl: UIPageControl!
    @IBOutlet weak var hairdresserPictureView: UIRoundImageView!
    @IBOutlet weak var hairdresserPictureBorderView: UIView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var numReviewsLabel: UILabel!
    
    var business: Business!
    
    override func viewWillAppear(animated: Bool) {
        
        hairdresserPictureView.contentMode = UIViewContentMode.Center
        
        // configure hairdresser's picture border
        hairdresserPictureBorderView.layer.cornerRadius = hairdresserPictureBorderView.frame.size.height / 2
        hairdresserPictureBorderView.clipsToBounds = true
        hairdresserPictureBorderView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        // configure rating views
        ratingView.notSelectedImage = UIImage(named: "not_selected_star");
        ratingView.halfSelectedImage = UIImage(named: "half_selected_star");
        ratingView.fullSelectedImage = UIImage(named: "selected_star.png");
        ratingView.rating = 0;
        ratingView.editable = false;
        ratingView.maxRating = 5;
        
        refresh();
    }
    
    func refresh() {
        var downloader = SDWebImageDownloader.sharedDownloader()
        var superFrame = self.view.frame;
        
        nameLabel.text = business.name;
        if (Int(business.numReviews) > 0) {
            ratingView.rating = Float(business.ratingBetween(0, and: 5))
        } else {
            ratingView.rating = 0
        }
        
        if (Int(business.numReviews) < 2) {
            numReviewsLabel.text = NSString(
                format: NSLocalizedString("%@ review", tableName: "Salon_Detail", comment: ""),
                business.numReviews
            );
        } else {
            numReviewsLabel.text = NSString(
                format: NSLocalizedString("%@ reviews", tableName: "Salon_Detail", comment: ""),
                business.numReviews
            );
        }

        // remove all existing pictures
        picturesScrollView.subviews.map({ $0.removeFromSuperview() });

        if (business.kind == KIND_ATHOME && business.owner != nil) {
            hairdresserPictureBorderView.hidden = false;
            picturesPageControl.hidden = true;

            picturesScrollView.contentSize = CGSize(width: superFrame.width, height: superFrame.height);

            var frame = hairdresserPictureView.frame;
            var background = UIImageView(frame: getFrameForPictureAtIndex(0));
            background.contentMode = UIViewContentMode.ScaleAspectFill;
            if((business.owner.picture) != nil) {
                var pictureUrl = business.owner.picture.urlWithWidth(frame.width * 2, height: frame.height * 2);
                downloadImage(pictureUrl!, callback:{ (image, error) -> Void in
                    if (nil != image) {
                        self.hairdresserPictureView.image = image;
                    }
                })
                // background image, smaller for better blur effect
                downloadImage(business.owner.picture.urlWithWidth(50, height: 50)!, callback:{ (image, error) -> Void in
                    if (nil != image) {
                        background.image = image!.applyLightEffect();
                    }
                })
            }

            picturesScrollView.addSubview(background);
        } else {
            hairdresserPictureBorderView.hidden = true;

            picturesScrollView.contentSize = CGSize(width: CGFloat(business.pictures.count) * picturesScrollView.frame.width, height: picturesScrollView.frame.height)
            
            picturesPageControl.hidden = false;
            picturesPageControl.numberOfPages = business.pictures.count;
            picturesPageControl.currentPage = 0;
            var index: Int
            for index = 0; index < business.pictures.count; ++index {
                var frame = getFrameForPictureAtIndex(index);
                var picture: Picture = business.pictures[index] as Picture
                var pictureView = UIImageView(frame: frame)
                pictureView.contentMode = UIViewContentMode.ScaleAspectFill;
                var pictureUrl = picture.urlWithWidth(frame.width, height: frame.height)
                downloadImage(pictureUrl!, callback: { (image, error) -> Void in
                  
                    if (nil != image) {
                        pictureView.image = image
                    }
                })
                picturesScrollView.addSubview(pictureView);
            }
        }
    }

    func downloadImage(url: NSURL, callback: (UIImage?, error: NSError?) -> Void) {
        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(
            url,
            options: nil,
            progress: nil,
            completed: { (image, data, error, finished) -> Void in
                if (nil != image) {
                    callback(image, error:error);
                } else {
                    callback(nil, error:error);
                }
            }
        )
    }

    func getFrameForPictureAtIndex(index: Int) -> CGRect {
        return CGRectMake(
            self.view.frame.size.width * CGFloat(index),
            0,
            self.view.frame.width,
            self.view.frame.height
        )
    }

    func goToCurrentPicturePage(animated: Bool) {
        var page = picturesPageControl.currentPage
        var bounds = picturesScrollView.bounds
        bounds.origin.x = CGRectGetWidth(bounds) * CGFloat(page)
        bounds.origin.y = 0
        picturesScrollView.scrollRectToVisible(bounds, animated: animated)
    }

    @IBAction func picturePageChanged(AnyObject) {
        goToCurrentPicturePage(true);
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        if (scrollView == self.picturesScrollView) {
            var pageWidth = self.view.frame.size.width;
            var pageNumber = floor((picturesScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            picturesPageControl.currentPage = Int(pageNumber);
        }
    }
}