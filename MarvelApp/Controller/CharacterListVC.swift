//
//  ViewController.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 18.01.2022.
//

import UIKit
import CryptoKit
import SDWebImage
import CoreData

class CharacterListVC: UIViewController {
    @IBOutlet weak var characterTableView: UITableView!
    var fetchedCharacters = [Character]()
    var offSetNumber = 0
    var indexObserver = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        fetchDatas()
        favoritesButtonAdded()


    }


}
extension CharacterListVC : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = characterTableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterCell
        cell.characterNameLabelField.text = self.fetchedCharacters[indexPath.row].name
        let thm = self.fetchedCharacters[indexPath.row].thumbnail.path
        let ex = self.fetchedCharacters[indexPath.row].thumbnail.thumbnailExtension
        let thmex = thm+"."+ex
        cell.characterImageView.sd_setImage(with: URL(string: thmex))
        self.indexObserver = indexPath.row
        
        if self.indexObserver == self.fetchedCharacters.count - 5 {
            offSetNumber = offSetNumber + 1
            fetchDatas()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = fetchedCharacters[indexPath.row]
        Singleton.chosenCharacter = selectedCharacter
        performSegue(withIdentifier: "details", sender: nil)
    }
    
    fileprivate func setDelegates() {
        characterTableView.delegate = self
        characterTableView.dataSource = self
    }
    
    fileprivate func MD5(data : String)->String{
        let hashValue = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hashValue.map{
            String(format: "%02hhx", $0)
        }
        .joined()
    }
    
    fileprivate func fetchDatas(){
        let ts = Keys().time
        let hash = "&hash="+MD5(data: "\(ts)\(Keys().privateKey)\(Keys().publicKey)")
        let totalUrl = CharactersUrlClass().baseUrl+"limit=30&offset="+"\(30 * offSetNumber)"+"&ts="+ts+CharactersUrlClass().apiKey+hash
        guard let url = URL(string: totalUrl)else{return}
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if data != nil {
                guard let data = data else {return}
              do{
                  let characters = try JSONDecoder().decode(JsonResults.self, from: data)
                  let desiredCharacters = characters.data.results
                  if self.fetchedCharacters.count == 0 {
                        self.fetchedCharacters = desiredCharacters
                        DispatchQueue.main.async {
                            self.characterTableView.reloadData()
                        }
                        
                  } else{
                      DispatchQueue.main.async {
                          desiredCharacters.forEach { char in
                              self.fetchedCharacters.append(char)
                              self.characterTableView.reloadData()
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
    
    fileprivate func favoritesButtonAdded() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites >", style: UIBarButtonItem.Style.plain, target: self, action: #selector(favoritesButtonClicked))
    }
    @objc func favoritesButtonClicked(){
        performSegue(withIdentifier: "toSaveVC", sender: nil)
        
        
        
        
    }
    
    

    
    

    
    
    
    
    
}

