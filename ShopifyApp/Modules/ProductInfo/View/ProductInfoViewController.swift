//
//  ProductInfoViewController.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 13/06/2024.
//

import UIKit

class ProductInfoViewController: UIViewController {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentPageIndex = 0 {
        didSet{
            pageControl.currentPage = currentPageIndex
        }
    }
    private let viewModel:ProductInfoViewModel = ProductInfoViewModel(networkService: NetworkService.shared)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.getProduct(productID: 9365476245804)
        viewModel.bindToViewController = {
            [weak self] productInfo in
            self?.collectionView.reloadData()
            self?.pageControl.numberOfPages =  productInfo.images.count
        }
       
        // Do any additional setup after loading the view.
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
extension ProductInfoViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productInfo.images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productInfoCell", for: indexPath) as! ProductInfoCollectionViewCell
        cell.setup(viewModel.productInfo.images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPageIndex = Int(scrollView.contentOffset.x / width)
    }
}
