//
//  SavedCV.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 20.01.2022.
//

import UIKit
import CoreData

class SavedVC: UIViewController {
    @IBOutlet weak var savedCharTableView: UITableView!
    private var nameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        backButtonAdded()
        getData()
    }
}


extension SavedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    fileprivate func setDelegates(){
        savedCharTableView.delegate = self
        savedCharTableView.dataSource = self
    }
    
    fileprivate func backButtonAdded() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func getData(){
     nameArray.removeAll(keepingCapacity: false)
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
         fetchRequest.returnsObjectsAsFaults = false
         
         do {
            let results = try context.fetch(fetchRequest)
             if results.count > 0 {
                 
                 for result in results as! [NSManagedObject]{
                     
                     if let name = result.value(forKey: "charName") as? String{
                         self.nameArray.append(name)
                     }
                     self.savedCharTableView.reloadData()
                 }
             }
         } catch {}
     }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        
                                context.delete(result)
                                
                                do {
                                    try context.save()
                                    
                                } catch {
                                    break
                                }
                    }
                }
                self.nameArray.remove(at: indexPath.row)
                self.savedCharTableView.deleteRows(at: [indexPath], with: .automatic)
                self.savedCharTableView.reloadData()
            } catch {}
        }
    }
}
