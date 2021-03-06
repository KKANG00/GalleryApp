//
//  ViewController.swift
//  GalleryApp
//
//  Created by KKANG on 2021/07/15.
//

import UIKit

var cachedImage: [URL:UIImage] = [:]

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellSpacing: CGFloat = 1
    let lineSpacing: CGFloat = 1
    var columns: CGFloat = 3
    
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
    
    @IBAction func moreColumn(_ sender: UIBarButtonItem) {
        columns += 1
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func UndoAll(_ sender: UIBarButtonItem) {
        columns = 3
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

class ImageItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func showImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func downloadImage(_ withUrl: URL) {
        
        if let safeImage = cachedImage[withUrl]{
            self.showImage(safeImage)
            return
        }
        
        // networking 비동기 처리
        // Using GlobalQueue
//        DispatchQueue.global(qos: .utility).async { [weak self] in
//            // [weak self] 약한 참조를 위한 guard문
//            guard let self = self else { return }
//
//            guard let data = try? Data(contentsOf: withUrl), let safeImage = UIImage(data: data) else { return }
//
//            cachedImage[withUrl] = safeImage
//            self.showImage(safeImage)
//        }
        
        // Using URLSession
        URLSession.shared.dataTask(with: withUrl) { data, reponse, error in
            if let error = error { print("Fail to load image", error.localizedDescription) }

            guard let safeData = data, let safeImage = UIImage(data: safeData) else { return }

            cachedImage[withUrl] = safeImage
            self.showImage(safeImage)
        }.resume()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageItemCell", for: indexPath) as! ImageItemCell
        
        cell.downloadImage(images[indexPath.row])
        
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
