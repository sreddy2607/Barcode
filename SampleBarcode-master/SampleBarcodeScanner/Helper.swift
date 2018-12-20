//
//  Helper.swift
//  SampleBarcodeScanner
//
//  Created by Chinna Addepally on 11/19/18.
//  Copyright © 2018 Chinna Addepally. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                  AVMetadataObject.ObjectType.code39,
                                  AVMetadataObject.ObjectType.code39Mod43,
                                  AVMetadataObject.ObjectType.code93,
                                  AVMetadataObject.ObjectType.code128,
                                  AVMetadataObject.ObjectType.ean8,
                                  AVMetadataObject.ObjectType.ean13,
                                  AVMetadataObject.ObjectType.aztec,
                                  AVMetadataObject.ObjectType.pdf417,
                                  AVMetadataObject.ObjectType.itf14,
                                  AVMetadataObject.ObjectType.dataMatrix,
                                  AVMetadataObject.ObjectType.interleaved2of5,
                                  AVMetadataObject.ObjectType.qr]

extension AVMetadataObject.ObjectType {
    public static let upca: AVMetadataObject.ObjectType = .init(rawValue: "org.gs1.UPC-A")
}

/// Checks if the app is running in Simulator.
var isSimulatorRunning: Bool = {
    #if swift(>=4.1)
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
    #else
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    return true
    #else
    return false
    #endif
    #endif
}()


enum TorchMode {
    case on
    case off
    
    /// Torch mode image.
    var image: UIImage {
        switch self {
        case .on:
            return UIImage.init(imageLiteralResourceName: "flashonicon")
        case .off:
            return UIImage.init(imageLiteralResourceName: "flashofficon")
        }
    }
    
    /// Returns `AVCaptureTorchMode` value.
    var captureTorchMode: AVCaptureDevice.TorchMode {
        switch self {
        case .on:
            return .on
        case .off:
            return .off
        }
    }
}
