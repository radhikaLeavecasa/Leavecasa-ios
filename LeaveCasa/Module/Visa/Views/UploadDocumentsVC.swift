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
    var visaDetails: VisaDetailModel?
    var selectedRow = Int()
    var pdfFiles: [URL?] = []
    var imageFiles: [UIImage?] = []
    var paxCount = 1
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<(visaDetails?.documents?.count ?? 0) {
            pdfFiles.append(nil)
            imageFiles.append(nil)
        }
        lblPassengerCount.text = "Pax \(paxCount)/\(param["Passenger"] as? String ?? "")"
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionNext(_ sender: UIButton) {
        paxCount += 1
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
        if visaDetails?.documents?[indexPath.row].type == "pdf" {
            if let pdfFileURL = pdfFiles[indexPath.row] {
                displayPDFPage(url: pdfFileURL, imgVw: cell.imgVwDocument)
            }
        } else {
            cell.imgVwDocument.image = imageFiles[indexPath.row]
        }
        cell.lblUpload.text = cell.imgVwDocument.image == nil ? "Upload" : "Re-Upload"
        return cell
    }
    @objc func addDocument(_ sender: UIButton) {
        selectedRow = sender.tag
        if visaDetails?.documents?[sender.tag].type == "pdf" {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            present(documentPicker, animated: true, completion: nil)
        } else {
            ImagePickerManager().pickImage(self){ image in
                self.imageFiles[self.selectedRow] = image
            }
            tblVwDocuments.reloadData()
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
                let fileSizeInBytes = Double(fileSize)
                let fileSizeInMB = fileSizeInBytes / (1024 * 1024) // Convert bytes to MB
                
                // Check if the file size is less than or equal to 5 MB
                if fileSizeInMB <= 5 {
                    pdfFiles[selectedRow] = selectedFileURL
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
