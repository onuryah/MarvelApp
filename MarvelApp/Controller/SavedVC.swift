//
//  SavedVC.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 20.01.2022.
//

import UIKit
import CoreData

class SavedVC: UIViewController {
    @IBOutlet weak var savedCharactersTableView: UITableView!
    var charNameArray = [String]()
    var charIdArray = [Int]()
    var imageArray = [Data]()
    var idArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonAdded()
        setDelegates()
        getData()
        print("kontrol : \(imageArray)")
    }
    


}

extension SavedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.charNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = charNameArray[indexPath.row]
        return cell
    }
    
    fileprivate func backButtonAdded() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Characters", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
    }
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setDelegates(){
        savedCharactersTableView.delegate = self
        savedCharactersTableView.dataSource = self
    }
    
    func getData(){
        charNameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
           let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    if let name = result.value(forKey: "characterName") as? String{
                        self.charNameArray.append(name)
                    }
                    
                    if let id = result.value(forKey: "characterId") as? UUID{
                        self.idArray.append(id)
                    }
                    self.savedCharactersTableView.reloadData()
                }
            }

        } catch {
            print("Error")
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                charNameArray.remove(at:  indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.savedCharactersTableView.reloadData()
                                
                                do {
                                    try context.save()
                                    
                                } catch {
                                    print("error")
                                    break
                                }
                            }
                        }
                    }
                }
                
                
            } catch {
                
            }
            
        }
    }
    
    
    
}
