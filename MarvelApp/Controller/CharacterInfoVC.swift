//
//  CharacterInfoVC.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 18.01.2022.
//

import UIKit
import SDWebImage
import CryptoKit

class CharacterInfoVC: UIViewController {
    @IBOutlet weak var selectedCharNameLabelField: UILabel!
    @IBOutlet weak var selectedCharImageView: UIImageView!
    @IBOutlet weak var selectedCharComicsTableView: UITableView!
    @IBOutlet weak var selectedCharDescriptionLabelField: UILabel!
    var selectedChar : Character?
    var fetchedComics = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synchronizeChosenChar()
        setDelegates()
        fetchData()
        backButtonAdded()
    }
    fileprivate func backButtonAdded() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
    }
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    

}

extension CharacterInfoVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let comicsCount = self.fetchedComics.count
        if comicsCount <= 10 {
            return comicsCount
        }else {
            let extra = comicsCount - 10
            for _ in 1...extra{
                self.fetchedComics.removeLast()
            }
            return self.fetchedComics.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectedCharComicsTableView.dequeueReusableCell(withIdentifier: "comicsCell", for: indexPath) as! ComicsCell
        let comicName = self.fetchedComics[indexPath.row].title
        cell.comicNameLabelField.text = comicName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.fetchedComics[indexPath.row].dates[0].date)
    }
    
    fileprivate func setDelegates(){
        selectedCharComicsTableView.delegate = self
        selectedCharComicsTableView.dataSource = self
    }
    fileprivate func synchronizeChosenChar(){
        self.selectedChar = Singleton.chosenCharacter
        selectedCharDescriptionLabelField.text = self.selectedChar?.description
        if selectedChar?.description == ""{
            selectedCharDescriptionLabelField.text = "The Description of your selected character is not found."
        }
        if let char = self.selectedChar {
            let charImageExtension = char.thumbnail.thumbnailExtension
            let charImagePath = char.thumbnail.path
            let charImageStr = charImagePath+"."+charImageExtension
            let charImageUrl = URL(string: charImageStr)
            
            selectedCharDescriptionLabelField.lineBreakMode = .byWordWrapping
            selectedCharDescriptionLabelField.numberOfLines = 0
            
            navigationItem.title = self.selectedChar?.name
        
        selectedCharImageView.sd_setImage(with: charImageUrl)
        }
    }
    
    fileprivate func MD5(data : String)->String{
        let hashValue = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hashValue.map{
            String(format: "%02hhx", $0)
        }
        .joined()
    }
    
    private func fetchData(){
        let ts = Keys().time
        let hash = "&hash="+MD5(data: "\(ts)\(Keys().privateKey)\(Keys().publicKey)")
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
                  if self.fetchedComics.count == 0 {
                        self.fetchedComics = characters.data.results
                      var number = -1
                      for result in self.fetchedComics {
                          let dates = result.dates
                          
                          number = number + 1
                          
                          let specificDate = dates[0].date
                          
                          let formatter = DateFormatter()
                          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                          if let someDateTime = formatter.date(from: "\(specificDate)"){
                              let desiredDateStr = "2006-01-01T00:00:00-0000"
                              if let desiredDate = formatter.date(from: desiredDateStr){
                                  if someDateTime < desiredDate{
                                      self.fetchedComics.remove(at: number)
                                      number = number - 1
                                  }
                              }
                                  
                          }
                          
                      }
                      number = 0
                      
                      
                      DispatchQueue.main.async {
                          self.selectedCharComicsTableView.reloadData()
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
