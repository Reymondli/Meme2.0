//
//  MemeTableViewController.swift
//  SecondMeme
//
//  Created by ziming li on 2017-06-16.
//  Copyright © 2017 ziming li. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableView?.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let memeDetail = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the memed image and meme label
        cell.imageView?.image = memeDetail.memedImage
        let labeltop = memeDetail.topText! as String
        let labelbottom = memeDetail.bottomText! as String
        cell.textLabel?.text = "TOP: \(labeltop) ➕ BOTTOM: \(labelbottom)"
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Grab the DetailVC from storyborad
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // Populate view controller with data form the selected item
        detailController.memeSelected = self.memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
        
}
