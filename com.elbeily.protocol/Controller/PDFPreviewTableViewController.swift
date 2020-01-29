//
//  PDFPreviewTableViewController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 17.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit
import PDFGenerator
import RealmSwift
import Foundation

class PDFPreviewTableViewController: MenuController {
    
    
    var currentProtocol : Protocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        createSpinnerViewAndShow()
        self.title = localization.pdfGenerating
        generatePDF()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    public enum PDFPage {
        case whitePage(CGSize) // = A white view
        case view(UIView)
        case image(UIImage)
        case imagePath(String)
        case binary(Data)
        case imageRef(CGImage)
    }
    
    func generatePDF() {
        
        let proto = currentProtocol!
        
        let contentSizeWidth = 1024.0
        let width = contentSizeWidth
        //        SVProgressHUD.show()
        let v1 = UIScrollView(frame: CGRect(x: 0.0,y: 0, width: width, height: 100.0))
        var y = 0.0
        let headerHeight = 250.0
        let labelH1Height = 21.0
        let labelH2Height = 17.0
        let h1FontSize : CGFloat = 20.0
        let h2FontSize : CGFloat = 17.0
        let h1Font = UIFont(name:"Arial", size: h1FontSize)
        let h2Font = UIFont(name:"Arial", size: h2FontSize)
        let margin = 20.0
        let dividerHeight = 2.0
        let x = 10.0
        let fontColor = UIColor.flatBlack()
        
        //get header image
        let image = getHeaderImageForProto()
        //header image
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: y, width: width, height: headerHeight)
        v1.addSubview(imageView)
        
        //divider
        y += headerHeight + margin
        let divider1 = UIView()
        divider1.frame =  CGRect(x: 10.0, y: y, width: (width - 20.0), height: dividerHeight)
        divider1.backgroundColor = .lightGray
        v1.addSubview(divider1)
        
        //object
        y += margin
        let object = UILabel()
        object.font = h1Font
        var title = "Objekt: "
        var atLeastOne = 0
        atLeastOne += (globalSettings?.showCostObject ?? true) ? 1 : 0
        
        title += ((atLeastOne > 1) ? " / " : "") + ((globalSettings?.showCostObject ?? true)  ? proto.costLocation?.name ?? localization.NA : "")
        atLeastOne += (globalSettings?.showProjektTitle ?? true) ? 1 : 0
        
        title += ((atLeastOne > 1) ? " / " : "") + ((globalSettings?.showProjektTitle ?? true)  ? proto.project?.name ?? localization.NA : "")
        
        atLeastOne += (globalSettings?.showTopicName ?? true) ? 1 : 0
        
        title += ((atLeastOne > 1) ? " / " : "") + ((globalSettings?.showTopicName ?? true)  ? proto.topic?.name ?? localization.NA : "")
        object.text = title
        
        
        
        object.frame = CGRect(x:x, y:y, width: width-x, height: labelH1Height)
        object.textColor = fontColor
        v1.addSubview(object)
        
        //proto Nr
        let protoNr = UILabel()
        y += labelH1Height
        protoNr.font = h1Font
        protoNr.text = String(format: "%@: %@", localization.labelProtoNr, proto.number)
        protoNr.frame = CGRect(x:x, y:y, width: width-x, height: labelH1Height)
        protoNr.textColor = fontColor
        v1.addSubview(protoNr)
        
        //Writers
        let writers = UILabel()
        writers.font = h1Font
        var signs = "Zeichen:"
        for writer in proto.writers {
            if(writer.mail == proto.writers.last?.mail) {
                signs += String(format: "%@",writer.sign)
            }else {
                signs += String(format: "%@/",writer.sign)
                
            }
        }
        writers.text = signs
        writers.textAlignment = .right
        writers.frame = CGRect(x:width/2, y:y, width: width/2 - x, height: labelH1Height)
        writers.textColor = fontColor
        v1.addSubview(writers)
        
        //proto date
        y += margin
        let protoDate = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "dd.MM.yy"
        let stringDate = dateFormatter.string(from: proto.date)
        protoDate.font = h1Font
        protoDate.text = String(format: "%@ %@","Besprechung vom ", stringDate)
        protoDate.frame = CGRect(x:x, y:y, width: width-x, height: labelH1Height)
        protoDate.textColor = fontColor
        v1.addSubview(protoDate)
        
        //divider
        y += margin + margin
        let divider2 = UIView()
        divider2.frame =  CGRect(x: x, y: y, width: width-x, height: dividerHeight)
        divider2.backgroundColor = .lightGray
        v1.addSubview(divider2)
        let startVerticalDividery = y
        y += margin
        let partiH = y
        
        //participantsHeader
        let participantHeader = UILabel()
        participantHeader.font = h1Font
        participantHeader.frame =  CGRect(x: x, y: y, width: width-x, height: labelH1Height)
        participantHeader.text = "Teilnehmer:"
        participantHeader.textColor = fontColor
        v1.addSubview(participantHeader)
        
        y += labelH1Height + margin
        //participants
        for partici in proto.participants {
            let participants = UILabel()
            participants.font = h2Font
            participants.frame =  CGRect(x: x, y: y, width: width-x, height: labelH1Height)
            participants.text = String(format: "%@ %@ \t %@",partici.salutation,partici.lastName, partici.company?.name ?? "")
            participants.textColor = fontColor
            v1.addSubview(participants)
            y += labelH1Height
        }
        let pastParthi = y
        
        
        //recieverHeader
        var recieverY = partiH
        let recieverHeader = UILabel()
        recieverHeader.font = h1Font
        recieverHeader.textAlignment = .right
        recieverHeader.frame =  CGRect(x: width/2, y: recieverY, width: width/2 - x, height: labelH1Height)
        recieverHeader.text = "Verteiler: (Versand per E-Mail)"
        recieverHeader.textColor = fontColor
        v1.addSubview(recieverHeader)
        recieverY += labelH1Height + margin
        
        //recieverList
        for distributor in proto.distributors {
            let distributors = UILabel()
            distributors.font = h2Font
            distributors.textAlignment = .right
            distributors.frame =  CGRect(x: width/2, y: recieverY, width: width/2 - x, height: labelH1Height)
            distributors.text = String(format: "%@",distributor.mail)
            distributors.textColor = fontColor
            v1.addSubview(distributors)
            recieverY += labelH1Height
        }
        
        y = pastParthi > recieverY ? pastParthi : recieverY
        
        
        //vertical divider
        let vDividerW = dividerHeight
        let vDiv = UIView()
        vDiv.frame =  CGRect(x: ((width/2)-(vDividerW/2)), y: startVerticalDividery, width: vDividerW, height: (y - startVerticalDividery))
        vDiv.backgroundColor = .lightGray
        v1.addSubview(vDiv)
        
        let vDiv1H = y
        
        //divider
        let divider3 = UIView()
        divider3.frame =  CGRect(x: x, y: y, width: width-x, height: dividerHeight)
        divider3.backgroundColor = .lightGray
        v1.addSubview(divider3)
        y += margin
        
        let w1 = width*0.1
        let w3 = width*0.3
        let w2 = width - w1 - w3
        
        
        
        //header1
        let h1 = UILabel()
        h1.text = "TOP"
        h1.font = h1Font
        h1.textColor = fontColor
        h1.frame =  CGRect(x: x, y: y, width: w1, height: labelH1Height)
        v1.addSubview(h1)
        
        //header3
        let h3 = UILabel()
        h3.text = "Zu erledigen durch:"
        h3.font = h1Font
        h3.textAlignment = .center
        h3.numberOfLines = 0
        h3.textColor = fontColor
        h3.frame =  CGRect(x: w1+w2, y: y, width: w3, height: labelH1Height*2)
        v1.addSubview(h3)
        y += labelH1Height*2
        
        //divider
        let divider4 = UIView()
        divider4.frame =  CGRect(x: x, y: y, width: width-x, height: dividerHeight)
        divider4.backgroundColor = .lightGray
        v1.addSubview(divider4)
        y += margin
        
        let sortedEntries = sortEntry(proto.entries)
        
        var potentialH = 0.0
        for entry in sortedEntries {
            let nr = UILabel()
            nr.text = String(entry.number)
            nr.font = h1Font
            nr.frame =  CGRect(x: x, y: y, width: w1, height: labelH1Height)
            nr.textColor = fontColor
            v1.addSubview(nr)
            potentialH = y + labelH1Height
            
            var countLineBreaks = 0
            let ns = entry.content as NSString
            ns.enumerateLines { (str, _) in
                countLineBreaks += 1
            }
            let charactersPerLine = 70
            let lines = Double(entry.content.count / charactersPerLine) >= 1 ? Double(entry.content.count / charactersPerLine) : 1.0
            let contentH = (lines + Double(countLineBreaks)) * labelH2Height
            let content = UILabel()
            content.text = entry.content
            content.frame =  CGRect(x: w1+x, y: y, width: w2 - x, height: contentH)
            content.font = h2Font
            content.numberOfLines = 0
            content.textColor = fontColor
            v1.addSubview(content)
            
            potentialH = potentialH > (y + contentH) ? potentialH : y + contentH
            
            
            let status = UILabel()
            var text = ""
            var color : UIColor?
            switch entry.status {
            case Status.new:
                text = super.localization.new
                color = UIColor.flatRed()
                break
            case Status.working:
                text = super.localization.working
                color = UIColor.flatOrange()
                break
            case Status.done:
                text = super.localization.done
                color = UIColor.flatGreen()
                break
            default:
                break
                
            }
            
            var concernH = y
            status.text = text
            status.backgroundColor = color!
            status.font = h2Font
            status.textAlignment = .center
            status.frame =  CGRect(x: w1+w2, y: concernH, width: w3, height: labelH1Height)
            concernH += labelH1Height + margin
            status.textColor = fontColor
            v1.addSubview(status)
            
            //date label
            let dateLabel = UILabel()
            dateLabel.text = "Zu erledigen bis:"
            dateLabel.font = h1Font
            dateLabel.textAlignment = .center
            dateLabel.frame = CGRect(x: w1+w2, y: concernH, width: w3, height: labelH1Height)
            dateLabel.textColor = fontColor
            concernH +=  labelH1Height
            
            v1.addSubview(dateLabel)
            
            let date = UILabel()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat  = "dd.MM.yyyy"
            let stringDate = dateFormatter.string(from: entry.dateToExecute)
            date.text = stringDate
            date.font = h1Font
            date.textAlignment = .center
            date.frame = CGRect(x: w1+w2, y: concernH, width: w3, height: labelH1Height)
            date.textColor = fontColor
            concernH +=  labelH1Height + margin
            v1.addSubview(date)
            
            for concern in entry.concerncs{
                let concerns = UILabel()
                concerns.font = h1Font
                concerns.textAlignment = .center
                concerns.frame =  CGRect(x: w1+w2, y: concernH, width: w3, height: labelH2Height)
                concerns.text = String(format: "%@",concern.sign)
                concerns.textColor = fontColor
                v1.addSubview(concerns)
                concernH += labelH2Height
            }
            
            
            potentialH = potentialH > concernH ? potentialH : concernH
            
            y = potentialH
            
            //divider
            let divider = UIView()
            divider.frame =  CGRect(x: x, y: y, width: width-x, height: dividerHeight)
            divider.backgroundColor = .lightGray
            v1.addSubview(divider)
            y += margin
            
            
        }
        
        //vertical divider
        let vDiv1 = UIView()
        vDiv1.frame =  CGRect(x: w1, y: vDiv1H, width: vDividerW, height: (y - vDiv1H - margin))
        vDiv1.backgroundColor = .lightGray
        v1.addSubview(vDiv1)
        
        //vertical divider
        let vDiv3 = UIView()
        vDiv3.frame =  CGRect(x: w1+w2, y: vDiv1H, width: vDividerW, height: (y - vDiv1H - margin))
        vDiv3.backgroundColor = .lightGray
        v1.addSubview(vDiv3)
        
        
        
        if true == globalSettings!.showContact || true == globalSettings!.showCompanyName {
            y+=margin*2
            let divider = UIView()
            divider.frame =  CGRect(x: x, y: y, width: width-x, height: dividerHeight)
            divider.backgroundColor = .black
            v1.addSubview(divider)
            y += margin
            
        }
        
        
        var companyNameY = y
        if true == globalSettings?.showContact {
            
            var contactInfo = [String]()
            contactInfo.append(globalSettings!.contactAddressCountry)
            contactInfo.append(globalSettings!.contactAddressZipcode)
            contactInfo.append(globalSettings!.contactAddressState)
            contactInfo.append(globalSettings!.contactAddressTown)
            contactInfo.append(globalSettings!.contactAddressStreet)
            contactInfo.append("")
            contactInfo.append(globalSettings!.companyContactTele)
            contactInfo.append(globalSettings!.companyContactMail)
            
            
            
            for contact in contactInfo {
                let contactUI = UILabel()
                contactUI.font = h2Font
                contactUI.frame =  CGRect(x: x, y: y, width: width-x, height: labelH1Height)
                contactUI.text = contact
                contactUI.textColor = fontColor
                v1.addSubview(contactUI)
                companyNameY = y
                y += labelH1Height
            }
        }
        
        
        
        
        if true == globalSettings?.showCompanyName {
            let companyNameUI = UILabel()
            companyNameUI.font = h1Font
            companyNameUI.textAlignment = .right
            companyNameUI.frame = CGRect(x:w1+w2, y:companyNameY, width: w3 - x, height: labelH1Height)
            companyNameUI.text = globalSettings!.companyName
            companyNameUI.textColor = fontColor
            v1.addSubview(companyNameUI)
        }
        
        
        
        v1.backgroundColor = .white
        v1.contentSize = CGSize(width: contentSizeWidth, height: y + 40.0)
        
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending(String(format:"%@.pdf",proto.project?.name ?? "Protokoll")))
        
        // writes to Disk directly.
        do {
            try PDFGenerator.generate([v1], to: dst)
        } catch (let error) {
            print(error)
        }
        
        let dc = UIDocumentInteractionController(url: dst)
        dc.delegate = self
        dc.presentPreview(animated: true)
    }
    
    
}

extension PDFPreviewTableViewController : UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
