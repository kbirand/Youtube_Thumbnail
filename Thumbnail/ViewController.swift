//
//  ViewController.swift
//  bbbbbb
//
//  Created by Koray Birand on 29.07.2020.
//  Copyright © 2020 Koray Birand. All rights reserved.
//

import Cocoa
import Quartz

var color : NSColor = NSColor.gray
var text : String = "FOTOĞRAF \nVİDEO " //\nTERİMLERİ \nSÖZLÜĞÜ "
var tAlign = "left"

class ViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet var scrollView: NSScrollView!
    
    @IBOutlet weak var myControls: NSStackView!
    @IBOutlet weak var temp: NSButton!
    @IBOutlet weak var imageView2: NSImageView!
    @IBOutlet var myText: NSTextView!
    var block = NSView()
    
    
    @IBAction func colorSelect(_ sender: NSColorWell) {
        color = sender.color
        generate()
    }
    
    @IBAction func leftAlign(_ sender: NSButton) {
        tAlign = "left"
        generate()
    }
    
    @IBAction func centerAlign(_ sender: NSButton) {
        tAlign = "center"
        generate()
    }
    
    @IBAction func rightAlign(_ sender: NSButton) {
        tAlign = "right"
        generate()
    }
    
    @IBAction func zI(_ sender: NSButton) {
        zoomIn()
    }
    
    @IBAction func zO(_ sender: NSButton) {
        zoomOut()
    }
    
    func textDidChange(_ notification: Notification) {
        
        guard let textView = notification.object as? NSTextView else { return }
        text = textView.string
        generate()
        
    }
    
    @IBAction func exportImage(_ sender: NSButton) {
        makePNGFromView()
    }
    
    @objc func zoomIn() {
        
        scrollView.magnification = scrollView.magnification - 0.1
        
    }
    
    @objc func zoomOut() {
        
        scrollView.magnification = scrollView.magnification + 0.1
        
    }
    
    @objc func makePNGFromView() {
        myControls.isHidden = true
        let rep = view.bitmapImageRepForCachingDisplay(in: view.bounds)!
        view.cacheDisplay(in: view.bounds, to: rep)
        
        if let data = rep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [.compressionFactor:0.7]) {
            rep.converting(to: NSColorSpace.sRGB, renderingIntent: NSColorRenderingIntent.perceptual)
            
            
            
            try! data.write(to: URL(fileURLWithPath: "/Users/koraybirand/Desktop/yt.jpg"))
        }
        myControls.isHidden = false
        
    }
    
    @objc func loadImage() {
        
        imageView2.image = myNewImage
        
    }
    
    @IBAction func flipImage(_ sender: NSButton) {
        imageView2.image = imageView2.image?.flipped(flipHorizontally: true, flipVertically: false)
    }
    
    
    func saveJpeg(image:NSImage) {
        
  
        
        
    }
    
    
    @objc func generate() {
        
        view.subviews.forEach({
            
            if ($0 is NSTextView) {
                $0.removeFromSuperview()
            }
            
            block.removeFromSuperview()
            
        })
        
        if tAlign == "left" {
            block = NSView(frame:  CGRect(x: 0, y: 0, width: 250, height: 1080))
            self.view.addSubview(block)
            block.wantsLayer = true
            block.layer?.backgroundColor = color.cgColor
            let subStrings = text.split(separator: "\n")
                   
                   var x = 0
                   for subString in subStrings {
                       let currentWord = String(subString)
                       generateLabel(with: currentWord, amount: x)
                       x = x + 1
                   }
        }
        
        
        if tAlign == "right" {
            block = NSView(frame:  CGRect(x: 1670, y: 0, width: 250, height: 1080))
            self.view.addSubview(block)
            block.wantsLayer = true
            block.layer?.backgroundColor = color.cgColor
            let subStrings = text.split(separator: "\n")
                   
                   var x = 0
                   for subString in subStrings {
                       let currentWord = String(subString)
                       generateLabel(with: currentWord, amount: x)
                       x = x + 1
                   }
        }
        
        if tAlign == "center" {
            generateLabel(with: text, amount: 0)
        }
        
        
       
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        generate()
        
    }
    
    
    
    @discardableResult func generateLabel(with text: String, amount: Int) -> NSTextView {
        
        var label = NSTextView()
        
        if tAlign == "left" {
            label = NSTextView(frame: CGRect(x: 45, y: 850 - (amount * 150), width: 1800, height: 170))
        }
        
        if tAlign == "center" {
            if amount == 0 {
                label = NSTextView(frame: CGRect(x: 0, y: 0 - (amount * 133), width: 1920, height: 340))
            } else {
                label = NSTextView(frame: CGRect(x: 0, y: 140 - (amount * 120), width: 1920, height: 170))
            }
        }
        
        if tAlign == "right" {
            label = NSTextView(frame: CGRect(x: 45, y: 850 - (amount * 150), width: 1800, height: 170))
        }
        
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: text,attributes: [.font: NSFont.init(name: "Helvetikb", size: 168)!])
        let subStrings = text.split(separator: "\n")
        let ranges = subStrings.map { (subString) -> Range<String.Index> in
            guard let range = text.range(of: subString) else {
                fatalError("Substring Hatalı")
            }
            return range
        }
        
        ranges.forEach { (range) in
            let nsRange = NSRange(range, in: text)
            attributedText.addAttribute(.backgroundColor, value: color, range: nsRange)
            attributedText.addAttribute(.foregroundColor, value: NSColor.white, range: nsRange)
            
            
            let style = NSMutableParagraphStyle()
            
            if tAlign == "left" {
                style.alignment = .left
                attributedText.addAttribute(.kern, value: -10, range: nsRange)
                attributedText.addAttribute(.baselineOffset, value: -4, range: nsRange)
            } else if tAlign == "right" {
                style.alignment = .right
                attributedText.addAttribute(.kern, value: -10, range: nsRange)
                attributedText.addAttribute(.baselineOffset, value: -4, range: nsRange)
            } else {
                style.alignment = .center
                style.paragraphSpacing  = -50
                attributedText.addAttribute(.kern, value: -10, range: nsRange)
                attributedText.addAttribute(.baselineOffset, value: -10, range: nsRange)
            }
            
            attributedText.addAttribute(.paragraphStyle, value: style, range: nsRange)
        }
        
        label.backgroundColor = NSColor.clear
        label.textStorage?.setAttributedString(attributedText)
        label.isEditable = false
        
        return label
    }
    
    override var representedObject: Any? {
        didSet {
            
        }
    }
    
    
}

extension NSImage {
    func flipped(flipHorizontally: Bool = false, flipVertically: Bool = false) -> NSImage {
        let flippedImage = NSImage(size: size)

        flippedImage.lockFocus()

        NSGraphicsContext.current?.imageInterpolation = .high

        let transform = NSAffineTransform()
        transform.translateX(by: flipHorizontally ? size.width : 0, yBy: flipVertically ? size.height : 0)
        transform.scaleX(by: flipHorizontally ? -1 : 1, yBy: flipVertically ? -1 : 1)
        transform.concat()

        draw(at: .zero, from: NSRect(origin: .zero, size: size), operation: .sourceOver, fraction: 1)

        flippedImage.unlockFocus()

        return flippedImage
    }
}
