//
//  UploadDocumentsVC.swift
//  LeaveCasa
//
//  Created by acme on 26/06/24.
//

import UIKit
import UniformTypeIdentifiers
import IBAnimatable
import PDFKit
import Photos

class UploadDocumentsVC: UIViewController, UIDocumentPickerDelegate {
    //MARK: - @IBOutlets
    @IBOutlet weak var tblVwDocuments: UITableView!
    @IBOutlet weak var lblPassengerCount: UILabel!
    //MARK: - Variables
    var param = [String: Any]()
    var paramImg = [String: UIImage]()
    var paramUrls = [String: URL]()
    var visaDetails: VisaDetailModel?
    var selectedRow = Int()
    var pdfFiles: [(String, URL?,Int)] = []
    var imageFiles: [(String,UIImage?,Int)] = []
    var paxCount = 1
    var amount = Double()
    var termsText = String()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        LoaderClass.shared.stopAnimation()
        for _ in 0..<(visaDetails?.documents?.count ?? 0) {
            pdfFiles.append(("", nil, 0))
            imageFiles.append(("", nil, 0))
        }
        lblPassengerCount.text = "Pax \(paxCount)/\(param["pax"] as? String ?? "")"
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionNext(_ sender: UIButton) {
        if visaDetails?.documents?.count ?? 0 > pdfFiles.filter({$0.0 != ""}).count + imageFiles.filter({$0.0 != ""}).count {
            LoaderClass.shared.showSnackBar(message: "Please upload all the required documents of pax \(paxCount)")
        } else {
            for i in visaDetails?.documents ?? [] {
                for j in pdfFiles {
                    for k in imageFiles {
                        if ((i.name?.range(of: "medical certificate", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "medical_certificate", k: k)
                        } else if ((i.name?.range(of: "occupation designation", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "occupation_designation", k: k)
                        } else if ((i.name?.range(of: "employee bussiness", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "employee_bussiness", k: k)
                        } else if ((i.name?.range(of: "company bussiness", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "company_bussiness", k: k)
                        } else if ((i.name?.range(of: "address", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "address", k: k)
                        } else if ((i.name?.range(of: "contact number", options: .caseInsensitive)) != nil) {
//                            if j.0 == i.name {
//                                param["occupation_designation[\(paxCount-1)]"] = j.1
//                            } else if k.0 == i.name {
//                                param["occupation_designation[\(paxCount-1)]"] = k.1
//                            }
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "contact_number", k: k)
                        } else if ((i.name?.range(of: "passport", options: .caseInsensitive)) != nil) {
                            if ((i.desc?.range(of: "front", options: .caseInsensitive)) != nil) {
                                addDoc(j: j, iStr: i.name ?? "", paramStr: "passport_front", k: k)
                            } else if ((i.desc?.range(of: "back", options: .caseInsensitive)) != nil) {
                                addDoc(j: j, iStr: i.name ?? "", paramStr: "passport_back", k: k)
                            }
                        } else if ((i.name?.range(of: "Photograph", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "photograph", k: k)
                        } else if ((i.name?.range(of: "Hotel Booking", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "hotel_booking", k: k)
                        } else if ((i.name?.range(of: "return flight", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "return_flight", k: k)
                        } else if ((i.name?.range(of: "Cover Letter", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "cover_letter", k: k)
                        } else if ((i.name?.range(of: "GST certificate", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "GST_certificate", k: k)
                        } else if ((i.name?.range(of: "company bank statement", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "company_bank_statement", k: k)
                        } else if ((i.name?.range(of: "bussiness letter head", options: .caseInsensitive)) != nil) || ((i.name?.range(of: "business letter head", options: .caseInsensitive)) != nil){
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "bussiness_letter_head", k: k)
                        } else if ((i.name?.range(of: "Bank Statement", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "bank_statement", k: k)
                        } else if ((i.name?.range(of: "property valuation", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "property_valuation", k: k)
                        } else if ((i.name?.range(of: "Adhaar Card", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "aadhar_card", k: k)
                        } else if ((i.name?.range(of: "ITR", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "ITR", k: k)
                        } else if ((i.name?.range(of: "Occupation Proof/ NOC (3 Months salary)", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "occupation_designation", k: k)
                        } else if ((i.name?.range(of: "Occupation Proof/NOC", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "occupation_designation", k: k)
                        } else if ((i.name?.range(of: "FD/Property valuation report approved by CA", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "property_valuation", k: k)
                        } else if ((i.name?.range(of: "ID Card for employee", options: .caseInsensitive)) != nil) || ((i.name?.range(of: "ID Card", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "id_card", k: k)
                        } else if ((i.name?.range(of: "pan", options: .caseInsensitive)) != nil) {
                            addDoc(j: j, iStr: i.name ?? "", paramStr: "pan", k: k)
                        }
                    }
                }
            }
            
            if paxCount == Int(param["pax"] as? String ?? "") {
                if let vc = ViewControllerHelper.getViewController(ofType: .FillVisaDetailsVC, StoryboardName: .Visa) as? FillVisaDetailsVC {
                    vc.param = param
                    vc.termsText = termsText
                    vc.paramUrls = paramUrls
                    vc.paramImg = paramImg
                    vc.amount = amount
                    vc.termsText = termsText
                    self.pushView(vc: vc)
                }
            } else {
                if let vc = ViewControllerHelper.getViewController(ofType: .UploadDocumentsVC, StoryboardName: .Visa) as? UploadDocumentsVC {
                    LoaderClass.shared.loadAnimation()
                    vc.paxCount = paxCount + 1
                    vc.paramUrls = paramUrls
                    vc.paramImg = paramImg
                    vc.param = param
                    vc.amount = amount
                    vc.termsText = termsText
                    vc.visaDetails = visaDetails
                    self.pushView(vc: vc)
                }
            }
        }
    }
    func addDoc(j: (String, URL?,Int), iStr: String, paramStr: String, k: (String, UIImage?,Int)) {
        if j.0 == iStr {
            self.paramUrls["\(paramStr)[\(self.paxCount-1)]"] = j.1
        } else if k.0 == iStr {
            self.paramImg["\(paramStr)[\(self.paxCount-1)]"] = k.1
        }
    }
}

extension UploadDocumentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visaDetails?.documents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadDocumentsTVC", for: indexPath) as! UploadDocumentsTVC
        cell.btnUpload.tag = indexPath.row
        cell.lblDocumentName.text = "\(visaDetails?.documents?[indexPath.row].name ?? "") \(visaDetails?.documents?[indexPath.row].desc ?? "")"
        cell.lblDocType.text = "In \(visaDetails?.documents?[indexPath.row].type ?? "") format less than 5 MB"
        cell.lblDocCount.text = "Document \(indexPath.row+1)/\(visaDetails?.documents?.count ?? 0)"
        cell.btnUpload.addTarget(self, action: #selector(addDocument), for: .touchUpInside)
        if ((visaDetails?.documents?[indexPath.row].type?.range(of: "PDF", options: .caseInsensitive)) != nil) {
            if let pdfFileURL = pdfFiles[indexPath.row].1 {
                displayPDFPage(url: pdfFileURL, imgVw: cell.imgVwDocument)
                cell.lblPdfSize.text = pdfFiles[indexPath.row].2 != 0 ? "PDF size: \(pdfFiles[indexPath.row].2) MB" : ""
            } else {
                cell.lblPdfSize.text = ""
            }
        } else {
            cell.imgVwDocument.image = imageFiles[indexPath.row].1
            cell.lblPdfSize.text = imageFiles[indexPath.row].2 != 0 ? "Image size: \(imageFiles[indexPath.row].2) MB" : ""
        }
        cell.lblUpload.text = cell.imgVwDocument.image == nil ? "Upload" : "Re-Upload"
        return cell
    }
    @objc func addDocument(_ sender: UIButton) {
        selectedRow = sender.tag
        if ((visaDetails?.documents?[sender.tag].type?.range(of: "PDF", options: .caseInsensitive)) != nil) {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            present(documentPicker, animated: true, completion: nil)
        } else {
            ImagePickerManager().pickImage(self) { [weak self] image in
                guard let self = self else { return }
                
//                guard let pickedImage = image else {
//                    return // Handle case where image is nil
//                }
                
                // Get PHAsset from picked UIImage
                self.getPHAsset(from: image) { asset in
                    guard let asset = asset else {
                        print("Failed to retrieve PHAsset from picked image.")
                        return
                    }
                    
                    // Request image data and calculate size
                    self.getImageFileSize(asset: asset) { imageSizeBytes in
                        guard let imageSizeBytes = imageSizeBytes else {
                            print("Failed to get image size.")
                            return
                        }
                        
                        // Convert bytes to kilobytes (KB)
                        let imageSizeKB = Double(imageSizeBytes) / 1024.0
                        print("Actual size of image in KB: \(imageSizeKB)")
                        
                        // Update UI or handle image size as needed
                    }
                }
            }
        }
    }
    
    
    // MARK: - UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let size = getPDFSize(url: selectedFileURL) ?? 0
        // Check if the file size is less than or equal to 5 MB
        if size <= 5 {
            pdfFiles[selectedRow].1 = selectedFileURL
            self.pdfFiles[self.selectedRow].0 = self.visaDetails?.documents?[self.selectedRow].name ?? ""
            self.pdfFiles[self.selectedRow].2 = Int(size)
            tblVwDocuments.reloadData()
        } else {
            LoaderClass.shared.showSnackBar(message: "PDF size should be less than or equal to 5 MB")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
        dismiss(animated: true, completion: nil)
    }
    func displayPDFPage(url: URL, imgVw: AnimatableImageView) {
        if let pdfDocument = PDFDocument(url: url) {
            if let pdfPage = pdfDocument.page(at: 0) { // Displaying the first page (index 0)
                let pdfPageRect = pdfPage.bounds(for: .mediaBox)
                let renderer = UIGraphicsImageRenderer(size: pdfPageRect.size)
                
                let pdfImage = renderer.image { ctx in
                    UIColor.white.set()
                    ctx.fill(pdfPageRect)
                    ctx.cgContext.translateBy(x: 0.0, y: pdfPageRect.size.height)
                    ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                    pdfPage.draw(with: .mediaBox, to: ctx.cgContext)
                }
                imgVw.image = pdfImage
            }
        }
    }
    
    func getPDFSize(url: URL) -> Double? {
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: url.path)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    // Function to get PHAsset from UIImage
    func getPHAsset(from image: UIImage, completion: @escaping (PHAsset?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            completion(nil)
            return
        }
        
        let temporaryFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tempImage.jpg")
        
        do {
            try data.write(to: temporaryFileURL)
            
            let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [temporaryFileURL], options: nil)
            if let asset = fetchResult.firstObject {
                completion(asset)
            } else {
                completion(nil)
            }
        } catch {
            print("Error writing image data to file: \(error)")
            completion(nil)
        }
    }

    // Function to get image file size using PHAsset
    func getImageFileSize(asset: PHAsset, completion: @escaping (Int?) -> Void) {
        if #available(iOS 13.0, *) {
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: nil) { data, _, _, _ in
                guard let imageData = data else {
                    completion(nil)
                    return
                }
                let imageSize = imageData.count
                completion(imageSize)
            }
        } else {
            PHImageManager.default().requestImageData(for: asset, options: nil) { data, _, _, _ in
                guard let imageData = data else {
                    completion(nil)
                    return
                }
                let imageSize = imageData.count
                completion(imageSize)
            }
        }
    }
    
}
