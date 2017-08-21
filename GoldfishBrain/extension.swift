//
//  extension.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/27.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }

            DispatchQueue.main.async { () -> Void in

                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }

}

extension UIImage {

    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return UIImagePNGRepresentation(self) }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }

    func fixOrientation() -> UIImage? {
        if self.imageOrientation == .up {
            return self
        }

        var transform = CGAffineTransform.identity

        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat(M_PI_2))
        default:
            print("1 is normal")
        }

        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            print("2 is normal")
        }

        guard let cgImage = self.cgImage else { return nil }

        guard let ctx = CGContext.init(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                                       space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }

        ctx.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: self.size))
        }

        guard let cgImg = ctx.makeImage() else { return nil }
        let img = UIImage(cgImage: cgImg)
        return img
    }

    func cornerImage(size: CGSize) -> UIImage? {
        let images = self
        print("images = \(images)")
        UIGraphicsBeginImageContext(size)
        guard let gc = UIGraphicsGetCurrentContext() else {  return nil }
        let radius = size.width / 2
        gc.concatenate(gc.ctm)
        gc.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: 1.5 *  3.14, endAngle:  1.5 * -3.14, clockwise: true)
        gc.closePath()
        gc.clip()
        gc.draw(self.cgImage!, in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

extension UITextField {

    func addTextTopBorder() {

        let border = CALayer()
        let width = CGFloat(1.0)

        border.borderColor = UIColor.gray.cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: 0, width: Int(self.frame.size.width), height: 1)

        self.layer.addSublayer(border)

    }
}

extension UIView {

    func addTopBorder() {

        let border = CALayer()
        let width = CGFloat(1.0)

        border.borderColor = UIColor.gray.cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: 0, width: Int(self.frame.size.width), height: 1)

        self.layer.addSublayer(border)

    }

    func dropShadow() {

        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 2

//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
//        
//        self.layer.rasterizationScale = UIScreen.main.scale

    }

}
