//
//  TrainFaceBitArray.swift
//  FaceTrainerPackageDescription
//
//  Created by Arman Galstyan on 12/17/17.
//

import Foundation
import LASwift
import AppKit

extension String: Error {
    
}

internal struct TrainFaceBitArray {
    var bitArray: Vector
    init(image: NSImage) {
        let rgbaImage = RGBAImage(image: image)
        let rgbaImageBitArray = Array(rgbaImage!.pixels)
        bitArray = rgbaImageBitArray.map({ (Double($0.B) + Double($0.R) + Double($0.G)) / Double(3)})
    }
    
    init(data: Data) throws {
        guard let faceImage = NSImage(data: data) else {
            //TODO
            throw "some error need to be implemented"
        }
        self.init(image: faceImage)
    }
}
