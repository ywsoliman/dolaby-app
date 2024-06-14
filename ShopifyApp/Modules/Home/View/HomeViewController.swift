//
//  HomeViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 28/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    let indicator = UIActivityIndicatorView(style: .large)
    var homeViewModel: HomeViewModelProtocol?
    var discountImages: [String: String] = [:]
    
    @IBOutlet weak var discountScrollView: UIScrollView!
    @IBOutlet weak var discountPageControl: UIPageControl!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brandsCollectionView.delegate=self
        brandsCollectionView.dataSource=self
        brandsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        indicator.startAnimating()
        homeViewModel = HomeViewModel(service: NetworkService.shared, currencyService: CurrencyService.shared)
        homeViewModel?.fetchBrands()
        homeViewModel?.bindBrandsToViewController={[weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.brandsCollectionView.reloadData()
            }
        }
        view.addSubview(indicator)
        indicator.center = self.view.center
        indicator.startAnimating()
        
        setupDiscountSection()
        
    }
    
    func setupDiscountSection() {
        homeViewModel?.getDiscountCodes { [weak self] in
            self?.constructImageCouponDictionary()
            self?.setupDiscountPageControl()
            self?.setupDiscountScrollView()
            self?.loadDiscountImages()
        }
    }
    
    func constructImageCouponDictionary() {
        discountImages["discount-1"] = Discounts.discounts[0].title
        discountImages["discount-2"] = Discounts.discounts[1].title
        discountImages["discount-3"] = Discounts.discounts[2].title
    }
    
    func setupDiscountScrollView() {
        discountScrollView.delegate = self
        discountScrollView.isPagingEnabled = true
        discountScrollView.showsHorizontalScrollIndicator = false
        discountScrollView.contentSize = CGSize(
            width: view.bounds.width * CGFloat(discountImages.count),
            height: 225
        )
    }
    
    func setupDiscountPageControl() {
        discountPageControl.numberOfPages = discountImages.count
        discountPageControl.currentPage = 0
    }
    
    func loadDiscountImages() {
        
        for (index, imageAndCoupon) in discountImages.enumerated() {
            let imageView = UIImageView(image: UIImage(named: imageAndCoupon.key))
            imageView.contentMode = .scaleAspectFill
            imageView.frame = CGRect(
                x: CGFloat(index) * view.bounds.width,
                y: 0,
                width: view.bounds.width,
                height: discountScrollView.bounds.height
            )
            
            let tapGesture = CouponTapGestureRecognizer(target: self, action: #selector(handleDiscountImageTapped(_:)))
            tapGesture.couponCode = imageAndCoupon.value
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
            
            discountScrollView.addSubview(imageView)
        }
        
    }
    
    @objc func handleDiscountImageTapped(_ sender: CouponTapGestureRecognizer) {
        guard let coupon = sender.couponCode else { return }
        UIPasteboard.general.string = coupon
        couponCopiedAlert()
    }
    
    func couponCopiedAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "Copoun copied successfully!🎉 \(UIPasteboard.general.string ?? "N/A")",
            preferredStyle: .alert
        )
        
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true)
        }
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = discountScrollView.contentOffset.x / discountScrollView.frame.size.width
        discountPageControl.currentPage = Int(page)
    }
    
}

extension HomeViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        guard let brandProductsViewController = storyboard?.instantiateViewController(withIdentifier: "brandProductsScreen") as? BrandProductsViewController else {
            return
        }
        
        let brandProductsViewModel=BrandProductsViewModel(networkService: NetworkService.shared)
        brandProductsViewModel.brandId=homeViewModel?.getBrands()[indexPath.item].id ?? 475723497772
        brandProductsViewController.brandProductsViewModel=brandProductsViewModel
         navigationController?.pushViewController(brandProductsViewController, animated: true)
    }
}
extension HomeViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        homeViewModel?.getBrandsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCollectionViewCell
        cell.brandImage.layer.borderColor = UIColor.darkGray.cgColor
        cell.brandImage.layer.borderWidth=1
        cell.brandImage.layer.cornerRadius=20
        cell.brandName.text=homeViewModel?.getBrands()[indexPath.item].title
        let url=URL(string: homeViewModel?.getBrands()[indexPath.item].image?.src ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg")
        guard let imageUrl=url else{
            print("Error loading image: ",APIError.invalidURL)
            return cell
        }
        cell.brandImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loadingPlaceholder"))
        return cell
    }
    
}
extension HomeViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width=self.view.frame.width*0.425
        let height=width
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
}

class CouponTapGestureRecognizer: UITapGestureRecognizer {
    var couponCode: String?
}
