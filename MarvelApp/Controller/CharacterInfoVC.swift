//
//  CharacterInfoVC.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 18.01.2022.
//

import UIKit
import SDWebImage
import CoreData

class CharacterInfoVC: UIViewController {
    @IBOutlet weak var selectedCharImageView: UIImageView!
    @IBOutlet weak var selectedCharComicsTableView: UITableView!
    @IBOutlet weak var selectedCharDescriptionLabelField: UILabel!
    private var selectedChar : Character?
    private var fetchedComics = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synchronizeChosenChar()
        setDelegates()
        fetchData()
        backButtonAdded()
        addButtonAdded()
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
    
    fileprivate func addButtonAdded(){
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }
    
    @objc func addButtonClicked() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: context)
        
        //Attributes
        if let charName = self.selectedChar?.name{
            newPainting.setValue(charName, forKey: "charName")
        }
        
        do {
            try context.save()
        } catch {}
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func fetchData(){
        FetchComics().fetchData(tableView: selectedCharComicsTableView, selectedChar: selectedChar) { results in
            if results != nil {
                self.fetchedComics = results!
            }
        }
    }
}
