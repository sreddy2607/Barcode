//
//  BarcodeScanView.swift
//  SampleBarcodeScanner
//
//  Created by Chinna Addepally on 11/20/18.
//  Copyright © 2018 Chinna Addepally. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeScanViewDelegate: class {
    func didFinishScanningBarcode(code: String, type: String)
    func enterCodeManually()
}

class BarcodeScanView: UIView {

    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    lazy var captureSession: AVCaptureSession = AVCaptureSession()
    var metadata = [AVMetadataObject.ObjectType]()
    
    var focusView: FocusView!
    
    weak var delegate: BarcodeScanViewDelegate?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //Turn On Or Off Flash
    var torchMode: TorchMode = .off {
        didSet {
            guard let captureDevice = captureDevice, captureDevice.hasFlash else { return }
            guard captureDevice.isTorchModeSupported(torchMode.captureTorchMode) else { return }
            
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.torchMode = torchMode.captureTorchMode
                captureDevice.unlockForConfiguration()
            } catch {}
        }
    }
    
    func addFocusView() {
        focusView = FocusView.init(frame: CGRect.zero, focusText: "UPC bar code")
        focusView.translatesAutoresizingMaskIntoConstraints = false
        focusView.backgroundColor = UIColor.clear
        addSubview(focusView)
        
        let viewsDict: [String: Any] = ["FocusView": focusView]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[FocusView]|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[FocusView]|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        bringSubviewToFront(focusView)
    }
    
    //Add output to capture session
    func setupSessionOutput() {
        let output = AVCaptureMetadataOutput()
        captureSession.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = supportedCodeTypes
        videoPreviewLayer?.session = captureSession
    }
    
    //Add video preview layer to view
    func configureVideoPreviewLayer() {
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        
        guard let videoPreviewLayer = videoPreviewLayer else {
            return
        }
        
        layer.masksToBounds = true
        videoPreviewLayer.frame = layer.bounds
        layer.addSublayer(videoPreviewLayer)
    }
    
    
    //Create Device and add to session
    func setUpCamera() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        self.captureDevice = captureDevice
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            setupSessionOutput()
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        configureVideoPreviewLayer()
        addFocusView()
    }
    
    //Start session Runnning
    func startCapturing() {
        guard !isSimulatorRunning else {
            return
        }
        captureSession.startRunning()
    }
    
    //Stop Session Running
    func stopCapturing() {
        guard !isSimulatorRunning else {
            return
        }
        captureSession.stopRunning()
    }

    //Update video preview layer
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer?.frame = bounds
    }
}

extension BarcodeScanView: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard !metadataObjects.isEmpty else { return }
        
        guard
            let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            var code = metadataObj.stringValue,
            supportedCodeTypes.contains(metadataObj.type)
            else { return }
        
        var rawType = metadataObj.type.rawValue
        
        if metadataObj.type == AVMetadataObject.ObjectType.ean13 && code.hasPrefix("0") {
            code = String(code.dropFirst())
            rawType = AVMetadataObject.ObjectType.upca.rawValue
        }
        
        self.delegate?.didFinishScanningBarcode(code: code, type: rawType)
        
        stopCapturing()
    }
}
