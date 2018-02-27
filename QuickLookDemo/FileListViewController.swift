//
//  FileListViewController.swift
//  QuickLookDemo
//
//  Created by Gabriel Theodoropoulos on 3/28/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import QuickLook


class FileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return fileURLs.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURLs[index] as QLPreviewItem
    }
    

    @IBOutlet weak var tblFileList: UITableView!
    
    let fileNames = ["AppCoda-PDF.pdf", "AppCoda-Pages.pages",
                     "AppCoda-Word.docx", "AppCoda-Keynote.key",
                     "AppCoda-Text.txt", "AppCoda-Image.jpeg",
                     "pptexamples.ppt"]
    
    var fileURLs = [URL]()
    
    let quickLookController = QLPreviewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        navigationItem.title = "Quick Look Demo"
        
        prepareFileURLs()
        quickLookController.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Custom Methods
    
    func configureTableView() {
        tblFileList.delegate = self
        tblFileList.dataSource = self
        tblFileList.register(UINib(nibName: "FileListCell", bundle: nil),
                             forCellReuseIdentifier: "idCellFile")
        tblFileList.reloadData()
    }

    func prepareFileURLs() {
        for file in fileNames {
            let fileParts = file.components(separatedBy: ".")
            if let fileURL = Bundle.main.url(forResource: fileParts[0], withExtension: fileParts[1]) {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    fileURLs.append(fileURL)
                }
            }
        }
    }
    
    func extractAndBreakFilenameInComponents(fileURL: URL) -> (fileName: String, fileExtension: String) {
        // Break the NSURL path into its components and create a new array with those components.
        let fileURLParts = fileURL.path.components(separatedBy: "/")
        
        // Get the file name from the last position of the array above.
        let fileName = fileURLParts.last
        
        // Break the file name into its components based on the period symbol (".").
        let filenameParts = fileName?.components(separatedBy: ".")
        
        // Return a tuple.
        return (filenameParts![0], filenameParts![1])
    }
    
    
    func getFileTypeFromFileExtension(fileExtension: String) -> String {
        var fileType = ""
        
        switch fileExtension {
        case "docx":
            fileType = "Microsoft Word document"
            
        case "pages":
            fileType = "Pages document"
            
        case "jpeg":
            fileType = "Image document"
            
        case "key":
            fileType = "Keynote document"
            
        case "pdf":
            fileType = "PDF document"
            
            
        default:
            fileType = "Text document"
            
        }
        
        return fileType
    }
    
    
    // MARK: UITableView Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileURLs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellFile",
                                                 for: indexPath as IndexPath)
        
        
        let currentFileParts = extractAndBreakFilenameInComponents(fileURL: fileURLs[indexPath.row])
        
        cell.textLabel?.text = currentFileParts.fileName
        cell.detailTextLabel?.text = getFileTypeFromFileExtension(fileExtension: currentFileParts.fileExtension)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if QLPreviewController.canPreview(fileURLs[indexPath.row] as QLPreviewItem) {
            quickLookController.currentPreviewItemIndex = indexPath.row
            navigationController?.pushViewController(quickLookController, animated: true)
        }
    }
    
    
}
