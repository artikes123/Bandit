//
//  Extension.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 9.06.2021.
//

import Foundation
import UIKit

extension UIView {
    
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
        
    }
    var bottom: CGFloat {
        return top + height
    }
}

extension DateFormatter {
    static let defaultFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String {
    static func date(with date: Date) -> String {
        return DateFormatter.defaultFormatter.string(from: date)
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
    
    //Saving Image to FileManager
    func saveImage(image: UIImage, to directoryName: String) {
        let imageData = image.pngData()
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        let path = documentDirectory.appendingPathComponent(directoryName)
        do { try imageData?.write(to: path) }
        catch { print("Error saving image to FileManager")}
        
        
    }
    //Getting Image From FileManager
    func getSavedImage(from directoryName: String) -> UIImage? {
        
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return UIImage(contentsOfFile: URL(fileURLWithPath: directory.absoluteString).appendingPathComponent(directoryName).path)
        }
        return nil
    }
}

extension UIView {
    
    func clickAnimate() {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform.identity
            }
            
        }
        
    }
}

extension UIViewController {
    
    public func showAlert(viewControllerToPresent : UIViewController, with error: Error) {
        let alert = UIAlertController(title: "Whoops", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(viewControllerToPresent, animated: true, completion: nil)
    }

    
}
