//
//  adjustmentsVC.swift
//  bbbbbb
//
//  Created by Koray Birand on 29.07.2020.
//  Copyright © 2020 Koray Birand. All rights reserved.
//

import Cocoa



class adjustmentsVC: NSViewController, NSTextViewDelegate {

    @IBOutlet weak var colowWell: NSColorWell!
    @IBOutlet var myText: NSTextView!
    @IBOutlet weak var loadedImage: DragDropImageView!
    
    @IBAction func selectedColor(_ sender: NSColorWell) {
        
        color = sender.color
        NotificationCenter.default.post(name: Notification.Name(rawValue: "generate"), object: nil)

    }
    
    @IBAction func zoomIn(_ sender: NSButton) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "zoomIn"), object: nil)
        
    }
    
    @IBAction func ZoomOut(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "zoomOut"), object: nil)
        
    }
    
    func textDidChange(_ notification: Notification) {
        
        guard let textView = notification.object as? NSTextView else { return }
        text = textView.string
        NotificationCenter.default.post(name: Notification.Name(rawValue: "generate"), object: nil)
        
    }
    
    @IBAction func loadImage(_ sender: NSButton) {
        
        myNewImage = loadedImage.image
        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadImage"), object: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func export(_ sender: NSButton) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "export"), object: nil)
        
    }
    
    @IBAction func left(_ sender: Any) {
        
        tAlign = "left"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "generate"), object: nil)
        
    }
    
    @IBAction func center(_ sender: Any) {
        
        tAlign = "center"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "generate"), object: nil)
        
    }
    
    @IBAction func right(_ sender: Any) {
        
        tAlign = "right"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "generate"), object: nil)
        
    }
    
}
