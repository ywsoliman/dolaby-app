//
//  ProductInfoViewController.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 13/06/2024.
//

import UIKit

class ProductInfoViewController: UIViewController {
    
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productBrand: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sizesSegment: UISegmentedControl!
        
    @IBOutlet weak var bodyViewContainer: UIView!
    
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var quantityStatus: UILabel!
    @IBOutlet weak var colorSegment: UISegmentedControl!
    
    @IBOutlet weak var quantityControlBtn: UIStepper!
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
        quantityControlBtn.minimumValue = 1
       // viewModel.getProduct(productID: 9365476245804)
      //  viewModel.getProduct(productID: 9365476278572)
       // viewModel.getProduct(productID: 9365475983660)
        viewModel.getProduct(productID: 9365474771244)
        viewModel.bindToViewController = {
            [weak self] productInfo in
//            self?.collectionView.reloadData()
//            self?.pageControl.numberOfPages = productInfo.images.count
           self?.updateViewWithProductInfo(productInfo)
        }
        sizesSegment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        colorSegment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)

    //   applyCornerRadius()
        // Do any additional setup after loading the view.
    }
    private func applyCornerRadius() {
           let path = UIBezierPath(roundedRect: bodyViewContainer.bounds,
                                   byRoundingCorners: [.topLeft, .topRight],
                                   cornerRadii: CGSize(width: 20, height: 20))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           bodyViewContainer.layer.mask = mask
       }
    private func updateViewWithProductInfo(_ productInfo: Product) {
            productName.text = productInfo.title
            productBrand.text = productInfo.vendor
            priceLabel.text = "$\(productInfo.variants.first?.price ?? "0.00")"
            sizesSegment.removeAllSegments()
            colorSegment.removeAllSegments()
            let sizes = productInfo.getSizeOptions()
            let colors = productInfo.getColorOptions()
            for (index, size) in sizes.enumerated() {
                sizesSegment.insertSegment(withTitle: size, at: index, animated: false)
            }
            if !sizes.isEmpty {
                sizesSegment.selectedSegmentIndex = 0
            }
            for (index, color) in colors.enumerated() {
                colorSegment.insertSegment(withTitle: color, at: index, animated: false)
            }
            if !colors.isEmpty {
                colorSegment.selectedSegmentIndex = 0
            }
            updateQuantityLabel()
            descriptionLabel.text = productInfo.bodyHTML
            collectionView.reloadData()
            pageControl.numberOfPages = productInfo.images.count
        }
    @IBAction func addToCartPressed(_ sender: Any) {
       let variantId = viewModel.productInfo.getVariantID(option1: sizesSegment.titleForSegment(at: sizesSegment.selectedSegmentIndex) ?? "", option2: colorSegment.titleForSegment(at: colorSegment.selectedSegmentIndex) ?? "")
    }
    
    @IBAction func quantityControlPressed(_ sender: UIStepper) {
        productQuantity.text = "\(Int(sender.value))"
        updateQuantityLabel()
    }
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        updateQuantityLabel()
     }
    func updateQuantityLabel(){
        let quantityInVentory = viewModel.productInfo.getVariantQuantity(option1: sizesSegment.titleForSegment(at: sizesSegment.selectedSegmentIndex) ?? "", option2: colorSegment.titleForSegment(at: colorSegment.selectedSegmentIndex) ?? "")
        if Int(quantityControlBtn.value) > quantityInVentory {
            quantityStatus.text = "No Enough Items"
        }else{
            quantityStatus.text = ""
        }
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
extension ProductInfoViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
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
