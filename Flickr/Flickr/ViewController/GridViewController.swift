//
//  GridViewController.swift
//  Flickr
//
//  Created by Tridip Sarkar on 18/03/25.
//

import UIKit
//GridViewController - This is a controller of GridView
class GridViewController: UIViewController {
    
    private let viewModel = FlickrViewModel()
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var lineSpacing:Double = 2  // vertical spacing between the grid cell
    var interitemSpacing:Double = 2 // horizontal spacing 
    var itemPerRow:Double = 3.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.onPhotosUpdated = { [weak self] status in
            if(status){
                self?.collectionView.reloadData()
                self?.activityIndicatorView.stopAnimating()
            }
        }
        self.activityIndicatorView.startAnimating()
        viewModel.loadPhotos()
        
        
        // Do any additional setup after loading the view.
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = flowLayout
        
        self.collectionView.register(UINib(
            nibName:"CollectionViewCell",
            bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell"
        )
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            // Adjust layout or UI updates here
            if UIDevice.current.orientation.isLandscape {
                print("Landscape mode")
                self.collectionView.reloadData()
            } else if UIDevice.current.orientation.isPortrait {
                print("Portrait mode")
                self.collectionView.reloadData()
            }
        }, completion: nil)
    }
    
    /*
    checkAndLoadMoreData - This is called on dragging the collection view bottom to up direction
    for loading next page.
    */
    func checkAndLoadMoreData(_ scrollView: UIScrollView) {
        let endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height)
        if endScrolling >= scrollView.contentSize.height {
            print("checkAndLoadMoreData: Load More")
            self.viewModel.loadPhotos(isLoadMore: true)
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

extension GridViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkAndLoadMoreData(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!decelerate){
            self.checkAndLoadMoreData(scrollView)
        }
    }
   
}

extension GridViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getPhotoCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell,let photo = viewModel.getPhoto(at: indexPath.row) else
        {
            fatalError("CollectionViewCell not created")
        }
        
        cell.backgroundColor = .lightGray
        viewModel.loadImage(url:photo.imageUrl) { image in
            if let image {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    cell.activityIndicatorView.stopAnimating()
                }
            }
        }
        
        return cell
    }
    
}

extension GridViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - interitemSpacing*2)/itemPerRow - interitemSpacing
        let height = width
        return CGSize(width:width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInset = UIEdgeInsets(top:0, left:interitemSpacing,bottom:0, right: interitemSpacing)
        return edgeInset
    }
    
    
}
