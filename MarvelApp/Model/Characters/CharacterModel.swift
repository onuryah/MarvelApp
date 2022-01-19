//
//  CharactersModel.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 18.01.2022.
//

import Foundation

struct JsonResults : Codable{
    let data : CharacterDatas
}
struct CharacterDatas : Codable {
    let count : Int
    let results : [Character]
}

struct Character : Codable {
    let id : Int
    let name : String
    let description : String
    let comics: Comics
    let thumbnail : Thumbnail
    let urls : [URLElement]
}

struct Thumbnail: Codable {
    let path, thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let items: [ComicsItem]
}

struct ComicsItem: Codable {
    let resourceURI, name: String
}


struct URLElement: Codable {
    let url: String
}


