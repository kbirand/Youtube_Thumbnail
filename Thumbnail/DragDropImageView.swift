
import Cocoa
import Quartz

var myNewImage : NSImage?

class DragDropImageView: NSImageView, NSDraggingSource {

    var mouseDownEvent: NSEvent?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        isEditable = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        isEditable = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }


    func draggingSession(_: NSDraggingSession,
                         sourceOperationMaskFor _: NSDraggingContext) -> NSDragOperation {
        return NSDragOperation.copy.union(.delete)
    }

    func draggingSession(_: NSDraggingSession, endedAt _: NSPoint,
                         operation: NSDragOperation) {
        if operation == .delete {
            image = nil
        }
    }

    override func mouseDown(with theEvent: NSEvent) {
        mouseDownEvent = theEvent
    }

    override func mouseDragged(with event: NSEvent) {

        let mouseDown = mouseDownEvent!.locationInWindow
        let dragPoint = event.locationInWindow
        let dragDistance = hypot(mouseDown.x - dragPoint.x, mouseDown.y - dragPoint.y)

        if dragDistance < 3 {
            return
        }

        guard let image = self.image else {
            return
        }

        let size = NSSize(width: log10(image.size.width) * 30, height: log10(image.size.height) * 30)

        if let draggingImage = image.resizeMaintainingAspectRatio(withSize: size) {

            let draggingItem = NSDraggingItem(pasteboardWriter: image)

            let draggingFrameOrigin = convert(mouseDown, from: nil)

            let draggingFrame = NSRect(origin: draggingFrameOrigin, size: draggingImage.size)
                .offsetBy(dx: -draggingImage.size.width / 2, dy: -draggingImage.size.height / 2)
            draggingItem.draggingFrame = draggingFrame

            draggingItem.imageComponentsProvider = {
                let component = NSDraggingImageComponent(key: NSDraggingItem.ImageComponentKey.icon)
                
                component.contents = image
                
                component.frame = NSRect(origin: NSPoint(), size: draggingFrame.size)
                return [component]
            }

            beginDraggingSession(with: [draggingItem], event: mouseDownEvent!, source: self)
        }
    }
}

extension NSImage {

    var height: CGFloat {
        return size.height
    }

    var width: CGFloat {
        return size.width
    }

    var PNGRepresentation: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }

        return nil
    }

    func resize(withSize targetSize: NSSize) -> NSImage? {
        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: frame)
        })

        return image
    }

    func resizeMaintainingAspectRatio(withSize targetSize: NSSize) -> NSImage? {
        let newSize: NSSize
        let widthRatio  = targetSize.width / self.width
        let heightRatio = targetSize.height / self.height

        if widthRatio > heightRatio {
            newSize = NSSize(width: floor(self.width * widthRatio),
                             height: floor(self.height * widthRatio))
        } else {
            newSize = NSSize(width: floor(self.width * heightRatio),
                             height: floor(self.height * heightRatio))
        }
        return self.resize(withSize: newSize)
    }


    func crop(toSize targetSize: NSSize) -> NSImage? {
        guard let resizedImage = self.resizeMaintainingAspectRatio(withSize: targetSize) else {
            return nil
        }
        let x     = floor((resizedImage.width - targetSize.width) / 2)
        let y     = floor((resizedImage.height - targetSize.height) / 2)
        let frame = NSRect(x: x, y: y, width: targetSize.width, height: targetSize.height)

        guard let representation = resizedImage.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        let image = NSImage(size: targetSize,
                            flipped: false,
                            drawingHandler: { (destinationRect: NSRect) -> Bool in
            return representation.draw(in: destinationRect)
        })

        return image
    }


    func savePngTo(url: URL) throws {
        if let png = self.PNGRepresentation {
            try png.write(to: url, options: .atomicWrite)
        } else {
            throw NSImageExtensionError.unwrappingPNGRepresentationFailed
        }
    }
    
    func imagePNGRepresentation() -> NSData? {
          if let imageTiffData = self.tiffRepresentation, let imageRep = NSBitmapImageRep(data: imageTiffData) {
              // let imageProps = [NSImageCompressionFactor: 0.9] // Tiff/Jpeg
              // let imageProps = [NSImageInterlaced: NSNumber(value: true)] // PNG
            imageRep.converting(to: NSColorSpace.sRGB, renderingIntent: NSColorRenderingIntent.perceptual)
            let imageData = imageRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [.compressionFactor:0.7]) as NSData?
              return imageData
          }
          return nil
      }
    
    enum NSImageExtensionError: Error {
        case unwrappingPNGRepresentationFailed
    }
}
