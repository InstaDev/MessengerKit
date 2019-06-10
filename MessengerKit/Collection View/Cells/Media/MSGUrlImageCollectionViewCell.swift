//
//  MSGUrlImageCollectionViewCell.swift
//  MessengerKit
//
//  Created by Andrey Anisimov on 10/06/2019.
//

import UIKit

class MSGUrlImageCollectionViewCell: MSGMessageCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    override public var message: MSGMessage? {
        didSet {
            guard let message = message,
                case let MSGMessageBody.url(url) = message.body else { return }
            if let intUrl = URL(string: url) {
                imageView.load.request(with: intUrl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
    }
    
}
