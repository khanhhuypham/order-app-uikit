//
//  ViewExtension.swift
//
//  Created by kelvin on 11/11/18.
//

import UIKit
import Foundation

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {

            layer.cornerRadius = newValue
//            layer.masksToBounds = self.clipsToBounds
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    



    
}

extension UIView {
    func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
           self.layer.maskedCorners = corners
           self.layer.cornerRadius = radius
           self.layer.borderWidth = borderWidth
           self.layer.borderColor = borderColor.cgColor

    }
    
    

    func addBorder(toEdges edges: UIRectEdge, color: UIColor, thickness: CGFloat) {
        // Remove existing custom border layers (optional)
        layer.sublayers?.removeAll(where: { $0.name == "CustomBorder" })

        func addBorderLayer(frame: CGRect) {
            let border = CALayer()
            border.name = "CustomBorder"
            border.backgroundColor = color.cgColor
            border.frame = frame
            layer.addSublayer(border)
        }

        if edges.contains(.top) || edges == .all {
            addBorderLayer(frame: CGRect(x: 0, y: 0, width: bounds.width, height: thickness))
        }
        
 
        if edges.contains(.bottom) || edges == .all {
            addBorderLayer(frame: CGRect(x: 0, y: bounds.height - thickness, width: bounds.width, height: thickness))
        }
        
        if edges.contains(.left) || edges == .all {
            addBorderLayer(frame: CGRect(x: 0, y: 0, width: thickness, height: bounds.height))
        }
        
        if edges.contains(.right) || edges == .all {
            addBorderLayer(frame: CGRect(x: bounds.width - thickness, y: 0, width: thickness, height: bounds.height))
        }
    }


    
    func addBorder(color: UIColor = ColorUtils.orange_brand_900(), margins: CGFloat = 1, borderLineSize: CGFloat = 1) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .height,
                                                multiplier: 1, constant: borderLineSize))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1, constant: margins))
    }
}
/**
 * Extends UIView with shortcut methods
 *
 * @author Alexander Volkov
 * @version 1.0
 */
extension UIView {
    
    /// Adds bottom border to the view with given side margins
    ///
    /// - Parameters:
    ///   - color: the border color
    ///   - margins: the left and right margin
    ///   - borderLineSize: the size of the border
    func addBottomBorder(color: UIColor = ColorUtils.blueButton(), margins: CGFloat = 1, borderLineSize: CGFloat = 1) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .height,
                                                multiplier: 1, constant: borderLineSize))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1, constant: margins))
    }
}




extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String?, with color: UIColor) {

        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
}
enum RoundType {
    case top
    case bottom
    case left
    case right
    case northeast
    case southwest
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
    case both
    case none
}

extension UIView {

    func round(with type: RoundType, radius: CGFloat = 3.0) {
        var corners: CACornerMask
        switch type {
            case .northeast:
                corners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
            case .southwest:
                corners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
            case .top:
                corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .bottom:
                corners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .left:
                corners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            case .right:
                corners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            case .bottomLeft:
                corners = .layerMinXMaxYCorner
            case .bottomRight:
                corners = .layerMaxXMaxYCorner
            case .topRight:
                corners = .layerMaxXMinYCorner
            case .topLeft:
                corners = .layerMinXMinYCorner
            case .both:
                corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .none:
                corners = []
            }
        DispatchQueue.main.async {
           self.layer.maskedCorners = corners
           self.layer.cornerRadius = radius
           self.layer.masksToBounds = true
       }
    }

}


extension UIView {

    @discardableResult
    func setGradietColor(colorOne: UIColor, colorTwo: UIColor)  {

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0,0.1]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)

        layer.insertSublayer(gradientLayer, at: 0)
      
   }
}


extension UIView{
    
    enum RoundCornersAt{
        case topRight
        case topLeft
        case bottomRight
        case bottomLeft
    }
    
        //multiple corners using CACornerMask
    func roundCorners(corners:[RoundCornersAt], radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [
            corners.contains(.topRight) ? .layerMaxXMinYCorner:.init(),
            corners.contains(.topLeft) ? .layerMinXMinYCorner:.init(),
            corners.contains(.bottomRight) ? .layerMaxXMaxYCorner:.init(),
            corners.contains(.bottomLeft) ? .layerMinXMaxYCorner:.init(),
        ]
    }
    
}
extension UIView {
    /// Remove allSubView in view
    func removeAllSubViews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }

}


extension UIView {
    func setupCornerRadius(_ cornerRadius: CGFloat = 0, maskedCorners: CACornerMask? = nil) {
        layer.cornerRadius = cornerRadius
        if let corners = maskedCorners {
            layer.maskedCorners = corners
        }
    }
    
    func animateClick(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform.identity
            } completion: { _ in completion() }
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 7
        layer.backgroundColor = ColorUtils.orange_brand_900().cgColor
    }
}

//MARK: add horizontl line
extension UIView {
    
    func changeColorOfInnerText(color:UIColor,backGroundView:UIColor) {
        
        if self.subviews.count > 0{
            
            self.subviews.forEach{(view) in
                
                view.backgroundColor = backGroundView
                
                if let label = view as? UILabel {
                    label.textColor = color
                    
                    switch label.tag{
                        case 0:
                            label.font = UIFont.systemFont(ofSize: 16, weight: .light)
                        case 1:
                            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                        case 2:
                            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                        default:
                            label.font = UIFont.systemFont(ofSize: 16, weight: .light)
                    }
                }
                self.changeColorOfInnerText(color: color,backGroundView: backGroundView)
            }
            
        }
    }
    
    
    
    
    func createDottedLine(width: CGFloat, color: UIColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color.cgColor
        caShapeLayer.lineWidth = width
        
        caShapeLayer.lineDashPattern = [7,3] // 7 is the length of dash, 3 is length of the gap.
        let cgPath = CGMutablePath()

        let cgPoint = [CGPoint(x: 0, y: self.bounds.midY), CGPoint(x: self.bounds.width, y: self.bounds.midY)]

        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)

      }
}


extension UIView {
    func displayTooltip(_ message: String, completion: (() -> Void)? = nil) {
        let tooltipBottomPadding: CGFloat = 12
        let tooltipCornerRadius: CGFloat = 6
        let tooltipAlpha: CGFloat = 0.95
        let pointerBaseWidth: CGFloat = 14
        let pointerHeight: CGFloat = 8
        let padding = CGPoint(x: 18, y: 12)
        
        let tooltip = UIView()
        
        let tooltipLabel = UILabel()
        tooltipLabel.numberOfLines = 0
        tooltipLabel.text = "    \(message)    "
        tooltipLabel.font = UIFont.systemFont(ofSize: 12)
        tooltipLabel.contentMode = .center
        tooltipLabel.textColor = .white
        tooltipLabel.layer.backgroundColor = UIColor(red: 44 / 255, green: 44 / 255, blue: 44 / 255, alpha: 1).cgColor
        tooltipLabel.layer.cornerRadius = tooltipCornerRadius
        
        tooltip.addSubview(tooltipLabel)
        tooltipLabel.translatesAutoresizingMaskIntoConstraints = false
        tooltipLabel.bottomAnchor.constraint(equalTo: tooltip.bottomAnchor, constant: -pointerHeight).isActive = true
        tooltipLabel.topAnchor.constraint(equalTo: tooltip.topAnchor).isActive = true
        tooltipLabel.leadingAnchor.constraint(equalTo: tooltip.leadingAnchor).isActive = true
        tooltipLabel.trailingAnchor.constraint(equalTo: tooltip.trailingAnchor).isActive = true
        
        let labelHeight = message.height(withWidth: .greatestFiniteMagnitude, font: UIFont.systemFont(ofSize: 12)) + padding.y
        let labelWidth = message.width(withHeight: .zero, font: UIFont.systemFont(ofSize: 12)) + padding.x
        
        let pointerTip = CGPoint(x: labelWidth / 2, y: labelHeight + pointerHeight)
        let pointerBaseLeft = CGPoint(x: labelWidth / 2 - pointerBaseWidth / 2, y: labelHeight)
        let pointerBaseRight = CGPoint(x: labelWidth / 2 + pointerBaseWidth / 2, y: labelHeight)
        
        let pointerPath = UIBezierPath()
        pointerPath.move(to: pointerBaseLeft)
        pointerPath.addLine(to: pointerTip)
        pointerPath.addLine(to: pointerBaseRight)
        pointerPath.close()
        
        let pointer = CAShapeLayer()
        pointer.path = pointerPath.cgPath
        pointer.fillColor = UIColor(red: 44 / 255, green: 44 / 255, blue: 44 / 255, alpha: 1).cgColor
        
        tooltip.layer.addSublayer(pointer)
        (superview ?? self).addSubview(tooltip)
        tooltip.translatesAutoresizingMaskIntoConstraints = false
        tooltip.bottomAnchor.constraint(equalTo: topAnchor, constant: -tooltipBottomPadding + pointerHeight).isActive = true
        tooltip.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tooltip.heightAnchor.constraint(equalToConstant: labelHeight + pointerHeight).isActive = true
        tooltip.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        
        tooltip.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            tooltip.alpha = tooltipAlpha
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                tooltip.alpha = 0
            }, completion: { _ in
                tooltip.removeFromSuperview()
                completion?()
            })
        })
    }
}

extension UIView {
    func setDisabledLayer(_ isDisabled: Bool, color: UIColor = UIColor.black.withAlphaComponent(0.2)) {
        let layerName = "disabledLayer"

        if isDisabled {
            // Avoid adding twice
            if layer.sublayers?.first(where: { $0.name == layerName }) == nil {
                let overlayLayer = CALayer()
                overlayLayer.name = layerName
                overlayLayer.frame = bounds
                overlayLayer.backgroundColor = color.cgColor
                overlayLayer.cornerRadius = layer.cornerRadius
                overlayLayer.masksToBounds = true
                layer.addSublayer(overlayLayer)
            }
        } else {
            // Remove the disabled layer
            layer.sublayers?.removeAll(where: { $0.name == layerName })
        }
    }

    // Optional — call this in layoutSubviews if your view resizes
    func updateDisabledLayerFrame() {
        if let overlay = layer.sublayers?.first(where: { $0.name == "disabledLayer" }) {
            overlay.frame = bounds
        }
    }
}
