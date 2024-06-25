//
//  OnboardingViewController.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel:OnboardingViewModel = OnboardingViewModel()
    var currentPageIndex = 0 {
        didSet{
            pageControl.currentPage = currentPageIndex
            if currentPageIndex == viewModel.slides.count-1{
                nextButton.setTitle("Start", for: .normal)
            }else{
                nextButton.setTitle("Next", for: .normal)
            }
            nextButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadSlides()
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = viewModel.slides.count

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {

        if currentPageIndex < viewModel.slides.count-1 {
            currentPageIndex += 1
            let indexPath = IndexPath(item: currentPageIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        }else{
            UserDefaults.standard.set(true, forKey: "onboardingShown")
            let controller = storyboard?.instantiateViewController(identifier: "loginNav") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true)
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
extension OnboardingViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.slides.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.setup(viewModel.slides[indexPath.row])
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
