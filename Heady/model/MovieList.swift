//
//  MovieList.swift
//  Heady
//
//  Created by Dhiraj on 05/04/19.
//  Copyright © 2019 Dhiraj. All rights reserved.
//

import Foundation

class MovieList : NSObject {
    var id : String!
    var vote_average : Double!
    var title : String!
    var popularity : Double!
    var poster_path : String!
    var original_title : String!
    var overview : String!
    var release_date : String!

    
    public override init() {
        super.init()
    }
    
    public init(rawData: [String: Any]){
        
        super.init()
        
        if let value = rawData["id"] as? String{
            id = value
        }
        if let value = rawData["vote_average"] as? Double{
            vote_average = value
        }
        if let value = rawData["title"] as? String{
            title = value
        }
        
        if let value = rawData["release_date"] as? String{
            release_date = value
        }
        if let value = rawData["popularity"] as? Double{
            popularity = value
        }
        if let value = rawData["poster_path"] as? String{
            poster_path = "http://image.tmdb.org/t/p/w185/\(value)"
        }
        if let value = rawData["original_title"] as? String{
            original_title = value
        }
        
        if let value = rawData["overview"] as? String{
            overview = value
        }
    }
    
}
