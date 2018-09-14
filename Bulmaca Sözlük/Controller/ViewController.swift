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
    
    var deger : Float = 0.0
    var birInt : Int = 0
    
    @IBOutlet weak var butonS: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//
//        addBannerViewToView(bannerView)
//        bannerView.delegate = self
//        bannerView.adUnitID = "ca-app-pub-8553309387589335/1793811402"
//        bannerView.rootViewController = self
        
//        let riquest = GADRequest()
//        riquest.testDevices = [ kGADSimulatorID , "c0dd8e340f66bd0b8d8477bd15a9467b2bffd622"]
//        bannerView.load(riquest)
//
//        rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
//        rewardBasedAd.delegate = self
//        rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-8553309387589335/3169638105")
        
        
        //Google deneme id : ca-app-pub-3940256099942544/1712485313
        aramaTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        
        aramaSonuclariTableView.backgroundColor = UIColor.clear
        
        dataBaseKontroluYap()
        
        
        

        
        aramaTextField.theme.cellHeight = UITableViewAutomaticDimension
         aramaTextField.theme.font = UIFont(name: "KohinoorBangla-Regular", size: 22)!
         aramaTextField.highlightAttributes = [NSAttributedStringKey.backgroundColor: UIColor.yellow, NSAttributedStringKey.font:UIFont(name: "KohinoorBangla-Regular", size: 22)!]
        
        aramaTextField.itemSelectionHandler = {item, itemPosition in
            self.aramaTextField.text = item[itemPosition].title
            
            
            self.sonuclariListele(anahtarKelimem : item[itemPosition].title)
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
    
    
    func googleDatabaseiniCek()
    {
        let newItem = BuyukSozluk(context: self.context)
        
        for number in 1..<6654
        {
        let ref = Database.database().reference().child("BuyukSozluk/\(number)").observeSingleEvent(of: .value) { (snapshot) in
            if let phoneDB = snapshot.value as? NSDictionary{

                newItem.anahtarKelime = phoneDB["gAnahtarKelime"] as? String ?? ""
                newItem.mana1 = phoneDB["gMana1"] as? String ?? ""
                if phoneDB["gMana2"] as? String ?? "" == ""
                    {newItem.mana2 = nil}
                else{newItem.mana2 = phoneDB["gMana2"] as? String ?? ""}
                if phoneDB["gMana3"] as? String ?? "" == ""
                {newItem.mana3 = nil}
                else{newItem.mana3 = phoneDB["gMana3"] as? String ?? ""}
                if phoneDB["gMana4"] as? String ?? "" == ""
                {newItem.mana4 = nil}
                else{newItem.mana4 = phoneDB["gMana4"] as? String ?? ""}
                if phoneDB["gMana5"] as? String ?? "" == ""
                {newItem.mana5 = nil}
                else{newItem.mana5 = phoneDB["gMana5"] as? String ?? ""}
                if phoneDB["gMana6"] as? String ?? "" == ""
                {newItem.mana6 = nil}
                else{newItem.mana6 = phoneDB["gMana6"] as? String ?? ""}
                if phoneDB["gMana7"] as? String ?? "" == ""
                {newItem.mana7 = nil}
                else{newItem.mana7 = phoneDB["gMana7"] as? String ?? ""}
                if phoneDB["gMana8"] as? String ?? "" == ""
                {newItem.mana8 = nil}
                else{newItem.mana8 = phoneDB["gMana8"] as? String ?? ""}
                if phoneDB["gMana9"] as? String ?? "" == ""
                {newItem.mana9 = nil}
                else{newItem.mana9 = phoneDB["gMana9"] as? String ?? ""}
                if phoneDB["gMana10"] as? String ?? "" == ""
                {newItem.mana10 = nil}
                else{newItem.mana10 = phoneDB["gMana10"] as? String ?? ""}
                
                self.herhangiBirDizi.append(phoneDB["gAnahtarKelime"] as? String ?? "")
                self.aramaTextField.filterStrings(self.herhangiBirDizi)
                
                self.sozlukDizisi.append(newItem)
                
                
                    self.deger = Float(self.herhangiBirDizi.count) / Float(6653.0)
                    
                    if self.deger >= Float(1.0) {
                        
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showSuccess(withStatus: "Sözlük indirildi \n \n Sözlüğü çevrimdışı olarak da kullanabilirsiniz !")
                    }else{
                        SVProgressHUD.showProgress(self.deger, status: "Sözlük indiriliyor \n Lütfen bekleyin")
                        self.deger = self.deger + 1
                    }
                
                self.birFonksiyon(stringDegeri: phoneDB["gAnahtarKelime"] as? String ?? "")
                
              
                
                do{
                  try self.context.save()
                    print("Kaydedildi")
                 }
                catch
                 {
                    print("Error saving context")
                   }
            }
 
        }
            
            print(sozlukDizisi.count)
        }

        
        
    }
    func birFonksiyon(stringDegeri : String)  {
        butonS.setTitle(stringDegeri, for: .normal)
    }
    func dataBaseKontroluYap()  {
        // Telefonda kaç tane veri var onu kontrol ediyoruz
        let requestim :NSFetchRequest<BuyukSozluk> = BuyukSozluk.fetchRequest()
        
        do {
            searchTextFieldDizisi = try context.fetch(requestim)
        }catch
        {
            print("SearchTextField verileri yüklenirken bir hata oluştu : \(error)")
        }
        
        
        searchTextFieldFonksiyonu()
        
        
        Database.database().reference().child("BuyukSozluk").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists()
            {
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    if self.searchTextFieldDizisi.count == snapshots.count {
                        print("Google'dan gelen veriler ile telefondaki veriler birebir aynı update'e gerek yok")
                    }
                    else if self.searchTextFieldDizisi.count != snapshots.count {
                        self.silmeYap()
                        print("Google sözlüğü güncellenmiş ya da telefon ilk kullanımda update yapılacak.")
//                        SVProgressHUD.showProgress(0.0, status: "Sözlük indiriliyor : \n Lütfen bekleyin")
                        self.googleDatabaseiniCek()
                    }
                }
            }
            
            
        }
        
        
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
    
    @IBAction func reklamGoster(_ sender: Any) {
        if rewardBasedAd.isReady{
            rewardBasedAd.present(fromRootViewController: self)
        }
        
    }
    
}

