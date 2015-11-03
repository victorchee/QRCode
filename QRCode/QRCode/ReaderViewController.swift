//
//  ReaderViewController.swift
//  QRCode
//
//  Created by qihaijun on 11/3/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit
import AVFoundation

class ReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let deviceInput = try AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode] // 必须放在addOutput之后，否则报错
            }
        } catch _ {
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopScan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scan(sender: UIButton) {
        if sender.selected {
            stopScan()
        } else {
            startScan()
        }
        sender.selected = !sender.selected
    }

    private func startScan() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        if !captureSession.running {
            captureSession.startRunning()
        }
    }
    
    private func stopScan() {
        let previewLayer = view.layer.sublayers?.first
        if previewLayer is AVCaptureVideoPreviewLayer {
            previewLayer?.removeFromSuperlayer()
        }
        
        if captureSession.running {
            captureSession.stopRunning()
        }
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if let metadataObject = metadataObjects.first,
            let readResult = metadataObject.stringValue {
                let alert = UIAlertController(title: nil, message: readResult, preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
                    
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
        }
        stopScan()
    }
}

