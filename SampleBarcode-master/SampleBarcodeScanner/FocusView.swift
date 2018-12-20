//
//  FocusView.swift
//  SampleBarcodeScanner
//
//  Created by Chinna Addepally on 11/22/18.
//  Copyright © 2018 Chinna Addepally. All rights reserved.
//

import UIKit

class FocusView: UIView {
    
    var connerView: UIImageView!
    var focusTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, focusText: String) {
        self.init(frame: frame)
        
        createConnerView()
        createFocusText(text: focusText)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createConnerView() {
        connerView = UIImageView.init(frame: CGRect.zero)
        connerView.translatesAutoresizingMaskIntoConstraints = false
        connerView.contentMode = .scaleAspectFit
        connerView.clipsToBounds = true
        connerView.image = UIImage.init(imageLiteralResourceName: "conner")
        addSubview(connerView)
    }
    
    func createFocusText(text: String) {
        focusTextLabel = UILabel.init(frame: CGRect.zero)
        focusTextLabel.translatesAutoresizingMaskIntoConstraints = false
        focusTextLabel.numberOfLines = 0
        focusTextLabel.textAlignment = .center
        focusTextLabel.textColor = UIColor.white
        focusTextLabel.preferredMaxLayoutWidth = 200
        focusTextLabel.text = text
        connerView.addSubview(focusTextLabel)
    }
    
    func createConstraints() {
        self.addConstraint(NSLayoutConstraint.init(item: connerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint.init(item: connerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        connerView.addConstraint(NSLayoutConstraint.init(item: focusTextLabel, attribute: .centerX, relatedBy: .equal, toItem: connerView, attribute: .centerX, multiplier: 1, constant: 0))
        
        connerView.addConstraint(NSLayoutConstraint.init(item: focusTextLabel, attribute: .centerY, relatedBy: .equal, toItem: connerView, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
