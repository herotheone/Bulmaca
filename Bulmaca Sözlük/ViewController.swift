//
//  ViewController.swift
//  Bulmaca Sözlük
//
//  Created by Emin Türk on 20.08.2018.
//  Copyright © 2018 Emin Türk. All rights reserved.
//

import UIKit
import SearchTextField
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var aramaSonuclariTableView: UITableView!
    
    @IBOutlet weak var aramaTextField: SearchTextField!
    
    var sozlukDizisi = [BuyukSozluk]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var textFieldDizisi : [String] = [ ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Delegeleri tanımlıyoruz
        aramaSonuclariTableView.delegate = self
        aramaSonuclariTableView.dataSource = self
        
        // MARK: - SearchTextField'lardaki çıkacak değerleri sıralıyoruz.
       
        for number in 0..<sozlukDizisi.count {
            let newItem = sozlukDizisi[number]
            textFieldDizisi.append("\(newItem.anahtarKelime!)")
        }
        
         aramaTextField.filterStrings(textFieldDizisi)
        
         aramaTextField.theme.cellHeight = 50
         aramaTextField.theme.font = UIFont(name: "KohinoorBangla-Regular", size: 22)!
         aramaTextField.highlightAttributes = [NSAttributedStringKey.backgroundColor: UIColor.yellow, NSAttributedStringKey.font:UIFont(name: "KohinoorBangla-Regular", size: 22)!]
        
        aramaTextField.itemSelectionHandler = {item, itemPosition in
            self.aramaTextField.text = item[itemPosition].title
            print("\(item[itemPosition].title)")
            
            self.sonuclariListele(anahtarKelimem : item[itemPosition].title)
            
        }

    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = aramaSonuclariTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        
        let item = sozlukDizisi[indexPath.row]
        
        cell.textLabel?.text = item.anahtarKelime
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sozlukDizisi.count
    }
    
    func loadItems(with request:NSFetchRequest<BuyukSozluk> = BuyukSozluk.fetchRequest())
    {
        do {
        sozlukDizisi = try context.fetch(request)
        }catch
        {
            print("Tablo yüklenirken bir hata oluştu : \(error)")
        }
    
        aramaSonuclariTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func sonuclariListele(anahtarKelimem : String)
    {
        let request : NSFetchRequest<BuyukSozluk> = BuyukSozluk.fetchRequest()
        
        request.predicate = NSPredicate(format: "anahtarKelime MATCHES[cd] %@", anahtarKelimem)
        
        loadItems(with: request)
    }

   
}

