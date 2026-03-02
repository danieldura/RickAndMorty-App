//
//  Item.swift
//  RickAndMorty-App
//
//  Created by Daniel Dura on 2/3/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
