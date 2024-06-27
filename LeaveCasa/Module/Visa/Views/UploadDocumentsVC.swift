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

class UploadDocumentsVC: UIViewController, UIDocumentPickerDelegate {
    //MARK: - @IBOutlets
    @IBOutlet weak var tblVwDocuments: UITableView!
    @IBOutlet weak var lblPassengerCount: UILabel!
    //MARK: - Variables
    var param = [String: Any]()
    var paramData = [String: Data]()
    var visaDetails: VisaDetailModel?
    var selectedRow = Int()
    var pdfFiles: [(String, URL?)] = []
    var imageFiles: [(String,UIImage?)] = []
    var paxCount = 1
    var amount = Double()
    var termsText = String()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<(visaDetails?.documents?.count ?? 0) {
            pdfFiles.append(("", nil))
            imageFiles.append(("", nil))
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
                    vc.paramData = paramData
                    vc.amount = amount
                    vc.termsText = termsText
                    self.pushView(vc: vc)
                }
            } else {
                if let vc = ViewControllerHelper.getViewController(ofType: .UploadDocumentsVC, StoryboardName: .Visa) as? UploadDocumentsVC {
                    vc.paxCount = paxCount + 1
                    vc.paramData = paramData
                    vc.param = param
                    vc.amount = amount
                    vc.termsText = termsText
                    vc.visaDetails = visaDetails
                    self.pushView(vc: vc)
                }
            }
        }
    }
    func addDoc(j: (String, URL?), iStr: String, paramStr: String, k: (String, UIImage?)) {
        if j.0 == iStr {
            fetchData(from: j.1!) { fetchedData in
                // Assign fetchedData to your Data? variable
                self.paramData["\(paramStr)[\(self.paxCount-1)]"] = fetchedData
                // Now you can use 'data' which contains the fetched data, or it may be nil if there was an error
            }
        } else if k.0 == iStr {
            self.paramData["\(paramStr)[\(self.paxCount-1)]"] = k.1?.pngData()
        }
    }
    func fetchData(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            completion(data)
        }.resume()
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
            }
        } else {
            cell.imgVwDocument.image = imageFiles[indexPath.row].1
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
            ImagePickerManager().pickImage(self){ image in
                self.imageFiles[self.selectedRow].1 = image
                self.imageFiles[self.selectedRow].0 = self.visaDetails?.documents?[sender.tag].name ?? ""
                self.tblVwDocuments.reloadData()
            }
        }
    }
    
    // MARK: - UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: selectedFileURL.path)
            if let fileSize = fileAttributes[.size] as? Int64 {
                let fileSizeMB = Double(fileSize) / (1024 * 1024)
                
                // Check if the file size is less than or equal to 5 MB
                if fileSizeMB <= 5 {
                    pdfFiles[selectedRow].1 = selectedFileURL
                    self.pdfFiles[self.selectedRow].0 = self.visaDetails?.documents?[self.selectedRow].name ?? ""
                } else {
                    LoaderClass.shared.showSnackBar(message: "PDF size should be less than or equal to 5 MB")
                }
            } else {
                print("File size attribute not found")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        // Use the selected file URL here
        print("Selected file URL: \(selectedFileURL)")
        tblVwDocuments.reloadData()
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
}
