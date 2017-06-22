//
//  MemeCollectionViewController.swift
//  SecondMeme
//
//  Created by ziming li on 2017-06-16.
//  Copyright © 2017 ziming li. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimension2 = (view.frame.size.height - (2 * space)) / 6.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension2)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let memeDetail = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.memeImageView?.image = memeDetail.memedImage
        cell.memeImageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Grab the DetailVC from storyborad
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // Populate view controller with data form the selected item
        detailController.memeSelected = self.memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
    
}
