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
        guard let comics = self.selectedChar?.comics.items else{return 0}
        return comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectedCharComicsTableView.dequeueReusableCell(withIdentifier: "comicsCell", for: indexPath) as! ComicsCell
        let comicName = self.selectedChar?.comics.items[indexPath.row].name
//        if let comicImageStr = self.selectedChar?.comics.collectionURI{
//            print(comicImageStr)
//        }
        cell.comicNameLabelField.text = comicName
        return cell
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
        print(totalUrl)
        
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
                      print("kontrol: \(self.fetchedComics)")
                  }
                    
                }catch{
                    print(error.localizedDescription)
                }
            }
            
        }
        .resume()
        
        
    }
    
}
