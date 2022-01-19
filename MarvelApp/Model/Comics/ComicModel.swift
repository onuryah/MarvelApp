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


//https://gateway.marvel.com:443/v1/public/characters/1009144/comics?&ts=1642605884.377012&apikey=075dc2d2b76b928ea9d6f86de07c121f&hash=4fcc17d2afc2c26741bcbda46522093a
//https://gateway.marvel.com:443/v1/public/characters/1011334/comics?format=comic&formatType=comic&modifiedSince=2005-01-01&orderBy=-onsaleDate&apikey=075dc2d2b76b928ea9d6f86de07c121f

//https://gateway.marvel.com:443/v1/public/characters?&ts=1642606209.955076&apikey=075dc2d2b76b928ea9d6f86de07c121f&hash=1f3a81b988df3b513e09f214e6f32499


