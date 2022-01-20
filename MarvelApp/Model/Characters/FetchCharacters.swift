//
//  FetchCharacters.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 20.01.2022.
//

import Foundation
import UIKit

class FetchCharacters{
    var jsonArray = [Character]()
    func fetchCharacters(offSetNumber : Int,tableView : UITableView,array: [Character], completion : @escaping([Character]?) -> ()){
        let ts = Keys().time
        let hash = "&hash="+Crypto().MD5(data: "\(ts)\(Keys().privateKey)\(Keys().publicKey)")
        let totalUrl = CharactersUrlClass().baseUrl+CharactersUrlClass().chosenParameters+"\(30 * offSetNumber)"+"&ts="+ts+CharactersUrlClass().apiKey+hash
        guard let url = URL(string: totalUrl)else{return}
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, request, error in
            if error != nil {
                return
            } else if data != nil {
                guard let data = data else {return}
              do{
                  let characters = try JSONDecoder().decode(JsonResults.self, from: data)
                  let desiredCharacters = characters.data.results
                  if array.count == 0 {
                      self.jsonArray = desiredCharacters
                      completion(self.jsonArray)
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                        
                  } else{
                      DispatchQueue.main.async {
                          desiredCharacters.forEach { char in
                              self.jsonArray.append(char)
                              tableView.reloadData()
                              completion(self.jsonArray)
                          }
                      }
                  }
                    
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
}
