//
//  ShoppingItem.swift
//  HW4-ShoppingList
//
//  Created by 张福翔 on 2020/11/9.
//

import UIKit
import os.log

class ShoppingItem: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a item", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        self.init(name: name, photo: photo, rating: rating)
    }
    
    // MARK: archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("shopping_items")
    
    // MARK: properties
    var name: String
    var photo: UIImage?
    var rating: Int = 0
    
    // MARK: types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    init(name: String, photo: UIImage?, rating: Int) {
        assert(!(name.isEmpty || rating < 0 || rating > 5))
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
