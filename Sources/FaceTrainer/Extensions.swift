//
//  Extensions.swift
//  FaceTrainerPackageDescription
//
//  Created by Arman Galstyan on 12/17/17.
//

import Foundation
import AppKit
import LASwift


internal extension NSImage {
    func resizedForRecognition() -> NSImage? {
        let targetSize = NSSize(width: TrainFaceImageWidthConstant, height: TrainFaceImageWidthConstant)
        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        
        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: frame)
        })
        
        return image
    }
    
    func rotated(byDegrees rotationDegree: CGFloat) -> NSImage {
        let degrees = (rotationDegree * CGFloat.pi / 180)
        var imageBounds = NSZeroRect ; imageBounds.size = self.size
        let pathBounds = NSBezierPath(rect: imageBounds)
        var transform = NSAffineTransform()
        transform.rotate(byDegrees: degrees)
        pathBounds.transform(using: transform as AffineTransform)
        let rotatedBounds:NSRect = NSMakeRect(NSZeroPoint.x, NSZeroPoint.y , self.size.width, self.size.height )
        let rotatedImage = NSImage(size: rotatedBounds.size)
        
        imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth(imageBounds) / 2)
        imageBounds.origin.y  = NSMidY(rotatedBounds) - (NSHeight(imageBounds) / 2)
        
        transform = NSAffineTransform()
        transform.translateX(by: +(NSWidth(rotatedBounds) / 2 ), yBy: +(NSHeight(rotatedBounds) / 2))
        transform.rotate(byDegrees: degrees)
        transform.translateX(by: -(NSWidth(rotatedBounds) / 2 ), yBy: -(NSHeight(rotatedBounds) / 2))
        rotatedImage.lockFocus()
        transform.concat()
        self.draw(in: imageBounds, from: NSZeroRect, operation: NSCompositingOperation.copy, fraction: 1.0)
        rotatedImage.unlockFocus()

        return rotatedImage
    }
    
    func grayScaleImage() -> NSImage {
        let image = self
        let imageRect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        var rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let imageReference = image.cgImage(forProposedRect: &rect  , context: nil, hints: nil)
        
        
        context!.draw(imageReference!, in: imageRect)
        let newImage = NSImage.init(cgImage: (context!.makeImage())!, size: self.size)
        return newImage
    }
}

internal extension Date {
    var millisecondsSince1970:CLong {
        return CLong((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
}

internal extension Array where Element == Double {
    func normalized() -> [Double] {
        let sumOfArray = sqrt(sum(self.map({ pow($0,2)})))
        return self.map({ $0 / sumOfArray })
    }
}

