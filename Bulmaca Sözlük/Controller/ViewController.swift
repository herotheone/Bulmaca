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
import Firebase
import SVProgressHUD
import GoogleMobileAds
import GRDB.Swift


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, GADRewardBasedVideoAdDelegate {
   
  
    var bannerView : GADBannerView!
    var rewardBasedAd : GADRewardBasedVideoAd!
    
    @IBOutlet weak var aramaSonuclariTableView: UITableView!
    
    
    @IBOutlet weak var aramaTextField: SearchTextField!
    
    
    var sozlukDizisi = [BuyukSozluk]()
    var searchTextFieldDizisi = [BuyukSozluk]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var textFieldDizisi : [String] = [ ]
    var altSonuc : [String] = [ ]
    var herhangiBirDizi : [ String ] = [ ]
    var grdbDizisi : [ String ] = [ ]
    var deger : Float = 0.0
    var birInt : Int = 0
   
    var dbPath : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var dbResourcePath : String = ""
        
        
        var config = Configuration()
        config.readonly = true
        
        let fileManager = FileManager.default
        do{
            dbPath = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("db2.sqlite")
                .path
            
            if !fileManager.fileExists(atPath: dbPath) {
                dbResourcePath = Bundle.main.path(forResource: "db2", ofType: "sqlite")!
                try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
                print("Dosya yoktu kopyalandı")
            }
        }catch{
            print("An error has occured")
        }
        
        
        
        do {
            
            let dbQueue = try DatabaseQueue(path: dbPath)
            
            try dbQueue.inDatabase { db in
                
                //Select all data from the table named tablename residing in SQLite
                let rows = try Row.fetchCursor(db, "SELECT * FROM ZIMPORT")
                
                while let row = try rows.next() {
                    
                    let someString : String = row["gAnahtarKelime"]
                    let someString2 : String = row["gMana1"]
                    let someString3 : String = row["gMana2"]
                    let someString4 : String = row["gMana3"]
                    print("Anahtar Kelime : \(someString)")
                    print("Mana 1 : \(someString2)")
                    print("Mana 2 : \(someString3)")
                    print("Mana 3 : \(someString4)")
                    
                    grdbDizisi.append(someString)
                    
                }
                
                
                
                
            }
            
            
        } catch {
            
            print(error.localizedDescription)
            
        }
    
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-8553309387589335/1793811402"
        bannerView.rootViewController = self
        
        let riquest = GADRequest()
        riquest.testDevices = [ kGADSimulatorID , "c0dd8e340f66bd0b8d8477bd15a9467b2bffd622"]
        bannerView.load(riquest)
//
//        rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
//        rewardBasedAd.delegate = self
//        rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-8553309387589335/3169638105")
        
        
        //Google deneme id : ca-app-pub-3940256099942544/1712485313
//        aramaTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
//
//
        
        aramaSonuclariTableView.backgroundColor = UIColor.clear

        
         aramaTextField.theme.font = UIFont(name: "KohinoorBangla-Regular", size: 22)!
         aramaTextField.highlightAttributes = [NSAttributedStringKey.backgroundColor: UIColor.yellow, NSAttributedStringKey.font:UIFont(name: "KohinoorBangla-Regular", size: 22)!]
        aramaTextField.filterStrings(grdbDizisi)
        
        aramaTextField.comparisonOptions = NSString.CompareOptions.anchored
        
        
        
        aramaTextField.theme.cellHeight = 30
        
    
        
        aramaTextField.itemSelectionHandler = {item, itemPosition in
            
            self.aramaTextField.text = item[itemPosition].title


            self.grdbSonuclariniListele(gelenAnahtarKelime: item[itemPosition].title)
            self.view.endEditing(true)

        }

    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = aramaSonuclariTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        
        let numaralandirma = indexPath.row + 1
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        cell.selectionStyle = .none
        
        let isIndexValid = altSonuc.indices.contains(1)
        
        if isIndexValid == false
        {
            cell.textLabel?.text = "\(altSonuc[indexPath.row])"
        }else{
            cell.textLabel?.text = "\(numaralandirma). \(altSonuc[indexPath.row])"
        }
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return altSonuc.count
    }
    
    func loadItems(with request:NSFetchRequest<BuyukSozluk> = BuyukSozluk.fetchRequest())
    {
        do {
        sozlukDizisi = try context.fetch(request)
        
           
            altSonuc = [ ]
            
            altSonuc.append(sozlukDizisi[0].mana1!)
            
            if sozlukDizisi[0].mana2 != nil
            {
              altSonuc.append(sozlukDizisi[0].mana2!)
            }
            if sozlukDizisi[0].mana3 != nil
            {
                altSonuc.append(sozlukDizisi[0].mana3!)
            }
            if sozlukDizisi[0].mana4 != nil
            {
                altSonuc.append(sozlukDizisi[0].mana4!)
            }
            if sozlukDizisi[0].mana5 != nil
            {
                altSonuc.append(sozlukDizisi[0].mana5!)
            }
            if sozlukDizisi[0].mana6 != nil
            {
                altSonuc.append(sozlukDizisi[0].mana6!)
            }
            if sozlukDizisi[0].mana7 != nil
            {
                altSonuc.append(sozlukDizisi[0].mana7!)
            }
            if sozlukDizisi[0].mana8 != nil
            {
                altSonuc.append(sozlukDizisi[0].mana8!)
            }
            if sozlukDizisi[0].mana9 != nil
            {
                altSonuc.append(sozlukDizisi[0].mana2!)
            }
            if sozlukDizisi[0].mana10 != nil
            {
                altSonuc.append(sozlukDizisi[0].mana10!)
            }
            
           
            
            altSonuc = altSonuc.sorted(by: <)
            
            
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
        
        request.predicate = NSPredicate(format: "anahtarKelime LIKE[c] %@", anahtarKelimem)
        
        loadItems(with: request)
    }

   func searchTextFieldFonksiyonu()
   {
    // MARK: - SearchTextField'lardaki çıkacak değerleri sıralıyoruz.
    
    let requestim :NSFetchRequest<BuyukSozluk> = BuyukSozluk.fetchRequest()
    
    do {
        searchTextFieldDizisi = try context.fetch(requestim)
    }catch
    {
        print("SearchTextField verileri yüklenirken bir hata oluştu : \(error)")
    }
    
    for number in 0..<searchTextFieldDizisi.count {
        let xbc = searchTextFieldDizisi[number]
        textFieldDizisi.append("\(xbc.anahtarKelime!)")
    }
    
    aramaTextField.filterStrings(textFieldDizisi)
    
 }
    
    
   
    
    
  func silmeYap()
  {
    // Initialize Fetch Request
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BuyukSozluk")
    
    // Configure Fetch Request
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest) as! [NSManagedObject]
        
        for item in items {
            context.delete(item)
        }
        
        // Save Changes
        try context.save()
            print("Başarıyla silindi.")
        
    } catch {
        // Error Handling
        // ...
    }
    }
  
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if aramaTextField.text?.count == 0
        {
           
            for number in 0..<11 {
                
                let indexPath = IndexPath(row: number, section: 0)
                let cell = aramaSonuclariTableView.cellForRow(at: indexPath)
                
                cell?.textLabel?.text = ""
            }
            
            
        }
    }
    
    func grdbSonuclariniListele (gelenAnahtarKelime : String) {
        
        
        
        do {
            let dbQueue = try DatabaseQueue(path: dbPath)
            
            try dbQueue.inDatabase { db in
                
                //Select all data from the table named tablename residing in SQLite
                let rows2 = try Row.fetchCursor(db, "SELECT * FROM ZIMPORT WHERE gAnahtarKelime = '\(gelenAnahtarKelime)'")
                
                while let row2 = try rows2.next() {
                    
                    
                    let someString1 : String = row2["gMana1"]
                    let someString2 : String = row2["gMana2"]
                    let someString3 : String = row2["gMana3"]
                    let someString4 : String = row2["gMana4"]
                    let someString5 : String = row2["gMana5"]
                    let someString6 : String = row2["gMana6"]
                    let someString7 : String = row2["gMana7"]
                    let someString8 : String = row2["gMana8"]
                    let someString9 : String = row2["gMana9"]
                    let someString10 : String = row2["gMana10"]
                    
                    
                    
                    
                    altSonuc = [ ]
                    altSonuc.append(someString1)
                    
                    if someString2 != "NULL"{
                        altSonuc.append(someString2)}
                    
                    if someString3 != "NULL" {
                        altSonuc.append(someString3)}
                    if someString4 != "NULL" {
                        altSonuc.append(someString4)}
                    if someString5 != "NULL" {
                        altSonuc.append(someString5) }
                    if someString6 != "NULL" {
                        altSonuc.append(someString6) }
                    if someString7 != "NULL" {
                        altSonuc.append(someString7) }
                    if someString8 != "NULL" {
                        altSonuc.append(someString8) }
                    if someString9 != "NULL" {
                        altSonuc.append(someString9) }
                    if someString10 != "NULL"{
                        altSonuc.append(someString10)
                    }
                    
                    
                    
                    
                    
                    
                    aramaSonuclariTableView.reloadData()
                    
                }
             
            }
            
            
        } catch {
            
            print(error.localizedDescription)
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
       
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load: \(error.localizedDescription)")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    
}

