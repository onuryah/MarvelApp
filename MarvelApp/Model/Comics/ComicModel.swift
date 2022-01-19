//
//  ComicModel.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 19.01.2022.
//

import Foundation

struct ComicModel: Codable{
    let data: DataClass
}

struct DataClass: Codable {
    let results: [Result]
}
struct Result: Codable{
    let title : String
    let dates : [DateElement]
}
struct DateElement: Codable {
    let type, date: String
}


