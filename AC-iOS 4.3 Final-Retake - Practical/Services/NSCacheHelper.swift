//
//  NSCacheHelper.swift
//  AC-iOS 4.3 Final-Retake - Practical
//
//  Created by C4Q on 6/4/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class NSCacheHelper {
    private init() {}
    static let manager = NSCacheHelper()
    private var myCache = NSCache<NSString, UIImage>()
    func addImage(with imageID: String, and image: UIImage) {
        myCache.setObject(image, forKey: imageID as NSString)
    }
    func getImage(with imageID: String) -> UIImage? {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
        }
        return myCache.object(forKey: imageID as NSString)
    }
}
