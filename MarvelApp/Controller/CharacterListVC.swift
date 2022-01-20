//
//  ViewController.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 18.01.2022.
//

import UIKit
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
        favoritesButtonAdded()
        FetchCharacters().fetchCharacters(offSetNumber: offSetNumber, tableView: characterTableView, array: fetchedCharacters) { characters in
            if characters != nil {
                self.fetchedCharacters = characters!
            }
        }
    }
}

extension CharacterListVC : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = characterTableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterCell
        itemsInCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    fileprivate func itemsInCell(cell: CharacterCell, indexPath: IndexPath){
        cell.characterNameLabelField.text = self.fetchedCharacters[indexPath.row].name
        let thm = self.fetchedCharacters[indexPath.row].thumbnail.path
        let ex = self.fetchedCharacters[indexPath.row].thumbnail.thumbnailExtension
        let thmex = thm+"."+ex
        cell.characterImageView.sd_setImage(with: URL(string: thmex))
        self.indexObserver = indexPath.row
        
        if self.indexObserver == self.fetchedCharacters.count - 5 {
            offSetNumber = offSetNumber + 1
            FetchCharacters().fetchCharacters(offSetNumber: offSetNumber, tableView: characterTableView, array: fetchedCharacters) { characters in
                if characters != nil {
                    self.fetchedCharacters = characters!
                }
            }
        }
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
    
    fileprivate func favoritesButtonAdded() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites >", style: UIBarButtonItem.Style.plain, target: self, action: #selector(favoritesButtonClicked))
    }
    @objc func favoritesButtonClicked(){
        performSegue(withIdentifier: "toSaveVC", sender: nil)
    }
}

