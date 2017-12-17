//
//  FaceDetector.swift
//  FaceTrainerPackageDescription
//
//  Created by Arman Galstyan on 12/17/17.
//

import Foundation
import AppKit

public final class FVFaceDetector {
    
    func detectFace(inImageWithData data: Data) throws -> NSImage? {
        guard let image = NSImage(data: data) else {
            throw "error: invalid data"
        }
        
        let detectedFaceImage = try self.detectFace(inImage: image)
        return detectedFaceImage
    }
    
    func detectFace(inImage image: NSImage) throws -> NSImage? {
        let imageForFaceDetection = image
        var rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let imageReference = imageForFaceDetection.cgImage(forProposedRect: &rect, context: nil, hints: nil)
        let personciImage = CIImage(cgImage: imageReference!)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        
        let faces = faceDetector?.features(in: personciImage)
        
        guard let detectedFaces = faces, !detectedFaces.isEmpty else {
            return nil
        }
        
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        if detectedFaces.count > 1 {
            throw "more then one face"
        }
        
        let face = detectedFaces.first as! CIFaceFeature
        
        guard face.hasLeftEyePosition && face.hasRightEyePosition else {
            return nil
        }
        
        let rotationAngle = CGFloat(getRotationAngle(firstPoint: face.leftEyePosition, secondPoint: face.rightEyePosition))
        let faceViewRect = face.bounds.applying(transform)
        let cuttenFaceImage = cutFace(image: imageForFaceDetection, rect: computeScaleFaceRect(fromRect: faceViewRect, rotationAngle: Double(rotationAngle)))
        let rotatedFaceImage = cuttenFaceImage.rotated(byDegrees: rotationAngle)
        
        let processedImage = rotatedFaceImage.resizedForRecognition()
        return processedImage
        
    }
    
}
