//
//  OnboardingViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 08/06/2024.
//

import Foundation
import UIKit
final class OnboardingViewModel{
    var slides:[OnboardingSlide] = []
    func loadSlides(){
        slides = [
            OnboardingSlide(title: "Discover Your Favorites", description:"Explore a vast selection of products tailored to your preferences", img:  UIImage(named: "fav_shopping")!),
            OnboardingSlide(title: "Easy and Secure Checkout", description:"Enjoy a seamless and safe shopping experience with our secure checkout", img:  UIImage(named: "checkout")!),
            OnboardingSlide(title: "Fast Delivery", description:"Get your orders delivered quickly and reliably right to your doorstep", img: UIImage(named: "delivery")!)
        
        ]
    }
}
