//
//  ViewController.swift
//  AR2SISV
//
//  Created by Jan Fabel on 31.01.23.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func GoFunc(_ sender: Any) {
        openFileFromFinder()
    }
}



func openFileFromFinder() {
    let dialog = NSOpenPanel()
    dialog.title = "Choose a file"
    dialog.showsResizeIndicator = true
    dialog.showsHiddenFiles = false
    dialog.canChooseDirectories = true
    dialog.canCreateDirectories = false
    dialog.allowsMultipleSelection = false
    dialog.allowedFileTypes = ["plist", "xml"]
    
    if dialog.runModal() == NSApplication.ModalResponse.OK {
        let result = dialog.url // Pathname of the file
        
        if let fileUrl = result {
            // Do something with the file URL
            
         let data = try! Data(contentsOf: fileUrl)
         let decoder = PropertyListDecoder()
            do {
                let i = try decoder.decode(ar.self, from: data)
                
                guard let base64String = String(data: i.FairPlayKeyData, encoding: .utf8) else {
                    print("Failed to get base64 string.")
                    return }
                var b64str = base64String.dropLast(24)
                b64str = b64str.dropFirst(26)
                
                print(b64str)
                
                if let decodedData = Data(base64Encoded: String(b64str), options: .ignoreUnknownCharacters) {
                    // use the data here
                    if decodedData.count == 1140 {print("Filesize check OK!")}
                    selectPathToSaveFile(data: decodedData)
                } else {
                    print("Failed to decode the base64 string.")
                }
            } catch {
                print(error)
            }
        }
    } else {
        // User clicked on "Cancel"
    }
}

func selectPathToSaveFile(data:Data) {
    let saveDialog = NSSavePanel()
    saveDialog.title = "Save File"
    saveDialog.showsResizeIndicator = true
    saveDialog.canCreateDirectories = true
    saveDialog.nameFieldStringValue = "IC-Info.sisv"
    
    if saveDialog.runModal() == NSApplication.ModalResponse.OK {
        let fileUrl = saveDialog.url
        if let filePath = fileUrl?.path {
            // Do something with the file path, for example, write to it
            try? data.write(to: fileUrl!)
        }
    } else {
        // User clicked on "Cancel"
    }
}


struct ar: Codable {
    let FairPlayKeyData:Data
}
