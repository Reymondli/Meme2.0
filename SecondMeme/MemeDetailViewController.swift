//
//  MemeDetailViewController.swift
//  SecondMeme
//
//  Created by ziming li on 2017-06-20.
//  Copyright © 2017 ziming li. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeSelected: Meme!
    
    // MARK: Outlets
    

    @IBOutlet weak var imageDetailView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load Memed Image
        self.imageDetailView!.image = memeSelected.memedImage
        imageDetailView.contentMode = .scaleAspectFit
        
        // For collection view
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // For collection view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
