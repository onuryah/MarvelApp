//
//  FetchComics.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 20.01.2022.
//

import Foundation
import UIKit

class FetchComics {
    var jsonArray = [Result]()
    func fetchData(tableView: UITableView, selectedChar: Character?, completion : @escaping([Result]?) -> ()){
        let ts = Keys().time
        let hash = "&hash="+Crypto().MD5(data: "\(ts)\(Keys().privateKey)\(Keys().publicKey)")
        guard let charId = selectedChar?.id else {return}
        let totalUrl = ComicsUrlClass().baseUrl+"\(charId)"+ComicsUrlClass().type+"&ts="+ts+ComicsUrlClass().apiKey+hash
        
        guard let url = URL(string: totalUrl)else{return}
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if data != nil {
                guard let data = data else {return}
              do{
                  let characters = try JSONDecoder().decode(ComicModel.self, from: data)
                  if self.jsonArray.count == 0 {
                        self.jsonArray = characters.data.results
                      var number = -1
                      for result in self.jsonArray{
                          let dates = result.dates
                          
                          number = number + 1
                          
                          let specificDate = dates[0].date
                          
                          let formatter = DateFormatter()
                          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                          if let someDateTime = formatter.date(from: "\(specificDate)"){
                              let desiredDateStr = "2006-01-01T00:00:00-0000"
                              if let desiredDate = formatter.date(from: desiredDateStr){
                                  if someDateTime < desiredDate{
                                      self.jsonArray.remove(at: number)
                                      number = number - 1
                                  }
                              }
                                  
                          }
                          
                          
                      }
                      completion(self.jsonArray)
                      number = 0
                      
                      
                      DispatchQueue.main.async {
                          tableView.reloadData()
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
