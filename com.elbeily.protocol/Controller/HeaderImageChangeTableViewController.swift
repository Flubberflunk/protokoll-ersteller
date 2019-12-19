//
//  HeaderImageChangeTableViewController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 19.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class HeaderImageChangeTableViewController: MenuController {
    
    var imagePicker = UIImagePickerController()
    var proto : Protocol?
    var selectedImgData : Data?
    var selImg : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Export Header ändern"
        tableView.register(UINib(nibName: "HeaderImageTableViewCell", bundle: nil), forCellReuseIdentifier: "headerImageCell")
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if 0 == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stdCell", for: indexPath)
            cell.textLabel?.text = "Wählen Sie ein Bild aus Ihrer Bibiliothek, dieses Bild ersetzt das Standardbild in dem PDF Export Header.\n\nFür ein besonders gutes Ergebnise ist eine Bildgröße von 1024 x 200 px empfohlen."
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerImageCell", for: indexPath) as! HeaderImageTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.selectedImg.image = getHeaderImageForProto(proto: proto!)
            cell.imageButton.setTitle(localization.selectImageFromGallery, for: .normal)
            
            return cell
        }
        
    }
    
    
    
}


extension HeaderImageChangeTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        selImg = image
        if let img = image {
            let success = saveImage(image: img)

        }
        
        self.dismiss(animated: true, completion: { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("custom-header.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
