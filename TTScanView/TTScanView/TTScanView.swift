//
//  TTScanView.swift
//  TTScanView
//
// Copyright (c) 2015 Tatsuya Tanaka
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE

import Foundation
import AVFoundation
import UIKit

@objc(TTScanDelegate) public protocol ScanDelegate {
    func detectedCode(code: String)
}

@objc(TTScanView) public class ScanView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var imageView = UIImageView()
    var frameView = UIView()
    var cameraView = UIView()
    
    var readingTypes = Array<String>()
    
    
    private(set) public var cameraEnabled = true
    public var delegate: ScanDelegate?
    
    public enum CameraType: Int {
        case QRcode = 0x01
        case Barcode = 0x02
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public init() {
        super.init(frame: CGRectMake(0, 0, 300, 300))
        self.setup()
    }
    
    private func setup() {
        self.imageView.layer.magnificationFilter = kCAFilterNearest
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.setupCamera()
    }
    
    func setupCamera() {
        frameView.layer.borderColor = UIColor.greenColor().CGColor
        frameView.layer.borderWidth = 3
        self.addSubview(frameView)
        
        session = AVCaptureSession()
        device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            self.input = try AVCaptureDeviceInput(device: self.device)
            self.session!.addInput(self.input)
        }
        catch {
            NSLog("Error - Initialization of AVCaptureDeviceInput");
            cameraEnabled = false
        }
        
        output = AVCaptureMetadataOutput()
        output!.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session!.addOutput(output)
        output!.metadataObjectTypes = output!.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        cameraView.layer.addSublayer(previewLayer!)
        cameraView.backgroundColor = UIColor.blackColor()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        previewLayer!.frame = self.bounds
        imageView.frame = self.bounds
        cameraView.frame = self.bounds
    }
    
    @objc public func start(mode: Int) {
        self.start(CameraType(rawValue: mode)!)
    }
    
    public func start(mode: CameraType) {
        if !cameraEnabled {
            return
        }
        readingTypes.removeAll()
        
        if (mode.rawValue & CameraType.Barcode.rawValue != 0) {
            readingTypes.append(AVMetadataObjectTypeEAN13Code)
        }
        if (mode.rawValue & CameraType.QRcode.rawValue != 0) {
            readingTypes.append(AVMetadataObjectTypeQRCode)
        }
        session!.startRunning()
    }
    
    public func stop() {
        session!.stopRunning()
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var highlightViewRect = CGRectZero
        var codeObject: AVMetadataMachineReadableCodeObject
        var detectionString: String?
        
        for metadata in metadataObjects {
            for type in readingTypes {
                if metadata.type == type {
                    codeObject = previewLayer!.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                    highlightViewRect = codeObject.bounds
                    detectionString = metadata.stringValue
                    break
                }
            }
            
            if detectionString != nil {
                if let delegate = delegate {
                    frameView.frame = highlightViewRect
                    self.stop()
                    delegate.detectedCode(detectionString!)
                    break
                }
            }
        }
    }
    
    // MARK: - shows
    
    public func showQRcode(str: String) {
        let ciFilter = CIFilter(name: "CIQRCodeGenerator")!
        ciFilter.setDefaults()
        
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        ciFilter.setValue(data, forKey: "inputMessage")
        ciFilter.setValue("L", forKey: "inputCorrectionLevel")
        
        let ciContext = CIContext(options: nil)
        let cgimg = ciContext.createCGImage(ciFilter.outputImage!, fromRect:ciFilter.outputImage!.extent)
        let image = UIImage(CGImage: cgimg, scale: 1.0, orientation: UIImageOrientation.Up)
        self.imageView.image = image
        self.cameraView.removeFromSuperview()
        self.addSubview(self.imageView)
        self.layoutIfNeeded()
        self.stop();
    }
    
    @objc public func showCamera(mode: Int) {
        self.showCamera(CameraType(rawValue: mode)!)
    }
    
    public func showCamera(mode: CameraType) {
        self.imageView.removeFromSuperview()
        self.addSubview(self.cameraView)
        self.layoutIfNeeded()
        self.start(mode)
    }
    
    
}