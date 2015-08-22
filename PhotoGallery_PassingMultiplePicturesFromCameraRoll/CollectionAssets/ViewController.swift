//
//  ViewController.swift
//  CollectionAssets
//
//  Created by Kristian Secor on 2/25/15.
//  Copyright (c) 2015 Kristian Secor. All rights reserved.
//

import UIKit

import UIKit
import AssetsLibrary

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var library: ALAssetsLibrary!
    
    var assets:[ALAsset] = []
    
    var selectedAssets:[ALAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedAssets.removeAll(keepCapacity: false)
        reloadAssets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "send" {
                
                (segue.destinationViewController as SendViewController ).sharedAssets = selectedAssets
            
        }
    }
    
    // MARK: - Navigation Bar
    
    func enableSendMode(enabled: Bool) {
        if enabled {
            let sendButtonItem = UIBarButtonItem(title: "Send",
                style: UIBarButtonItemStyle.Plain, target: self, action: "sendButtonAction:")
            self.navigationItem.rightBarButtonItem = sendButtonItem
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func sendButtonAction(sender: AnyObject) {
        self.performSegueWithIdentifier("send", sender: self)
    }
    
    // MARK: - ALAssetsLibrary
    
    func reloadAssets() {
        if library == nil {
            library = ALAssetsLibrary()
        }
        
        assets.removeAll(keepCapacity: true)
        library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock:
            { (group:ALAssetsGroup!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                if group != nil {
                    group.setAssetsFilter(ALAssetsFilter.allPhotos())
                    group.enumerateAssetsWithOptions(NSEnumerationOptions.Reverse,
                        usingBlock: { (asset:ALAsset!, index:Int,
                            stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                            if asset != nil {
                                self.assets.append(asset)
                            }
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView.reloadData()
                    })
                }
            }) { (error:NSError!) -> Void in
        }
    }
    
    // MARK: - UICollectionView
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return self.assets.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell",
                forIndexPath: indexPath) as PhotoViewCell
            let asset = assets[indexPath.row]
            cell.imageView.image = UIImage(CGImage: asset.thumbnail().takeUnretainedValue())
            cell.checked = contains(selectedAssets, asset)
            return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let width = collectionView.bounds.size.width
            let size = (width - 6) / 3.0
            return CGSizeMake(size, size)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 3.0
    }
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as PhotoViewCell
            let asset = assets[indexPath.row]
            if let foundIndex = find(selectedAssets, asset) {
                selectedAssets.removeAtIndex(foundIndex)
                cell.checked = false
            } else {
                selectedAssets.append(asset)
                cell.checked = true
            }
            collectionView.reloadItemsAtIndexPaths([indexPath])
            
            self.enableSendMode(selectedAssets.count > 0)
    }
}

