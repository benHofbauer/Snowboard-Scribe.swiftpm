//
//  Trail.swift
//  Snowboard Scribe
//
//  Created by Ben Hofbauer on 2/23/25.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
final class Trail {
    
    public var date: Date
    public var rating: Rating
    public var enjoyment: Double
    public var name: String
    public var powder: Bool
    public var trees: Bool
    public var moguls: Bool
    
    init(date: Date, rating: Rating, enjoyment: Double, name: String, powder:Bool = false, trees:Bool = false, moguls:Bool = false) {
        self.date = date
        self.rating = rating
        self.enjoyment = enjoyment
        self.name = name
        self.powder = powder
        self.trees = trees
        self.moguls = moguls
    }
}
