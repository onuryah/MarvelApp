//
//  Cyrypto.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 20.01.2022.
//

import Foundation
import CryptoKit

class Crypto{
    func MD5(data : String)->String{
        let hashValue = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hashValue.map{
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
