//
//  OnBoardingCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 09/06/2024.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var slideImage: UIImageView!
    
    
    @IBOutlet weak var slideTitleLabel: UILabel!
    
    
    @IBOutlet weak var slideDescriptionLabel: UILabel!
    
    static let identifier = "onboardingCell"
    
    func setup(_ slide:OnboardingSlide){
        slideImage.image = slide.img
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.description
    }
}
