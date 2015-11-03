//
//  GeneratorViewController.swift
//  QRCode
//
//  Created by qihaijun on 11/3/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit
import CoreImage

class GeneratorViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.text = textField.placeholder
        if let text = textField.text {
            imageView.image = generateQRCode(text)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    @IBAction func generate(sender: UIButton) {
        if let text = textField.text {
            let image = generateQRCode(text)
            imageView.image = image
        } else {
            imageView.image = nil
        }
    }
    
    private func generateQRCode(text: String) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        filter.setDefaults()
        
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }
        filter.setValue(data, forKey: "inputMessage")
        
        guard let outputImage = filter.outputImage else {
            return nil
        }
        let context = CIContext()
        let cgImage = context.createCGImage(outputImage, fromRect: outputImage.extent)
        
        let image = UIImage(CGImage: cgImage, scale: 1.0, orientation: UIImageOrientation.Up)
        
        let resizedImage = resizeImage(image, quality: .None, rate: 5.0)
        
        return resizedImage
    }

    private func resizeImage(image: UIImage, quality: CGInterpolationQuality, rate: CGFloat) -> UIImage {
        let size = CGSize(width: image.size.width * rate, height: image.size.height * rate)
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, quality)
        image.drawInRect(CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }

}

