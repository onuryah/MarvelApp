//
//  UrlClass.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 18.01.2022.
//

import Foundation

struct CharactersUrlClass {
    let baseUrl = "https://gateway.marvel.com:443/v1/public/characters?"
    let chosenParameters = "limit=30&offset="
    let apiKey = "&apikey="+Keys().publicKey
    let hash = "&hash="
}
