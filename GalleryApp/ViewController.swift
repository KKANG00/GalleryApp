//
//  ViewController.swift
//  GalleryApp
//
//  Created by KKANG on 2021/07/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellSpacing: CGFloat = 1
    let lineSpacing: CGFloat = 1
    let columns: CGFloat = 3
    
    var images: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let plist = Bundle.main.url(forResource: "URLs", withExtension: "plist"), let contents = try? Data(contentsOf: plist),let properties = try? PropertyListSerialization.propertyList(from: contents, format: nil), let urls = properties as? [String]
              else { return }
        
        images = urls.compactMap{ URL(string: $0) }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

}

class ImageItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func showImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageItemCell", for: indexPath) as! ImageItemCell
        
        if let url = URL(string: "https://images.unsplash.com/photo-1579989939916-4fc37667022b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"),
           let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            cell.showImage(image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - cellSpacing * (columns-1))/columns
        return CGSize(width: width, height: width)
    }
    
    
    
}
