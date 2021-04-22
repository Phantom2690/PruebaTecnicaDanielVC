//
//  ProductTableCell.swift
//  PruebaTecnicaBuscadorProductos
//
//  Created by Daniel Vazquez on 21/4/21.
//

import UIKit

class ProductTableCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceUnderLineLabel: UILabel!
    @IBOutlet weak var priceFinalLabel: UILabel!
    @IBOutlet weak var colorsView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productNameLabel.text = ""
        priceFinalLabel.text = ""
        priceUnderLineLabel.text = ""
        productImageView.image = nil
    }
    
    func configure(productData: Product) {
        productNameLabel.text = productData.productDisplayName
        if let promoPrice = productData.promoPrice {
            priceUnderLineLabel.text = String(promoPrice)
        }
        if let priceFinal = productData.listPrice {
            priceFinalLabel.text = String(priceFinal)
            
            let text = priceFinalLabel.text
            let textRange = NSRange(location: 0, length: (text?.count)!)
            let attributedText = NSMutableAttributedString(string: text!)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value:  NSUnderlineStyle.single.rawValue, range: textRange)
            priceFinalLabel.attributedText = attributedText
        }
        if let urlImage = productData.smImage {
            let url = URL(string: urlImage)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.productImageView.image = UIImage(data: data!)
            }
        }
        
        if let variantcolor = productData.variantsColor, variantcolor.count > 0 {
            var xCircle: CGFloat = 10
            for circleColor in variantcolor {
                
                if let colorHex = circleColor.colorHex {
                    let colorShow = hexStringToUIColor(hex: colorHex)
                    showCircle(xCircle: xCircle, color: colorShow)
                    xCircle = xCircle + 25
                }
            }
        }
    }
    
    func showCircle(xCircle: CGFloat, color: UIColor){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: xCircle, y: 10), radius: CGFloat(10), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
            
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
            
        colorsView.layer.addSublayer(shapeLayer)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
