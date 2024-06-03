//
//  ProductDetailsViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 01/06/2024.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    @IBOutlet weak var addToCartBtn: UIButton!
    
    @IBOutlet weak var detailsScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsScrollView.layer.cornerRadius=40
        detailsScrollView.clipsToBounds=true
        detailsScrollView.layer.shadowColor = UIColor.black.cgColor
        detailsScrollView.layer.shadowOffset = CGSize(width: 0, height: 2)
        detailsScrollView.layer.shadowRadius = 4
        detailsScrollView.layer.shadowOpacity = 0.5
        detailsScrollView.layer.shadowColor = UIColor.black.cgColor
        detailsScrollView.layer.masksToBounds = false
        addToCartBtn.layer.cornerRadius=40
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
