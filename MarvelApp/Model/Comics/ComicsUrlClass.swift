//
//  ComicsUrl.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 19.01.2022.
//

import Foundation

struct ComicsUrlClass {
    let baseUrl = "https://gateway.marvel.com:443/v1/public/characters/"
    let apiKey = "&apikey="+Keys().publicKey
    let type = "/comics?"
    let parameters = "format=comic&formatType=comic&modifiedSince=2005-01-01&orderBy=-onsaleDate&apikey="
}
