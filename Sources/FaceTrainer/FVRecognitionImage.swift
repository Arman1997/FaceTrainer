//
//  FVRecognitionImage.swift
//  FaceTrainerPackageDescription
//
//  Created by Arman Galstyan on 12/17/17.
//

import Foundation
import AppKit

internal class FVRecognitionImage {
    private var bitArray: TrainFaceBitArray!
    var image: NSImage
    init(image: NSImage) throws {
        let faceDetector = FVFaceDetector()
        guard let detectedFaceImage = try faceDetector.detectFace(inImage: image) else {
            throw FVError.noFaceDetected
        }
        self.bitArray = TrainFaceBitArray(image: detectedFaceImage.grayScaleImage())
        self.image = detectedFaceImage.grayScaleImage()
    }
    
    convenience init(data: Data) throws {
        guard let image = NSImage(data: data) else {
            throw "error: invalid parameter"
        }
        try self.init(image: image)
    }
    
    internal func getBitArray() -> TrainFaceBitArray {
        return self.bitArray
    }
}
