//
//  MSGUrlImageCollectionViewCell.swift
//  MessengerKit
//
//  Created by Andrey Anisimov on 10/06/2019.
//

import UIKit
import QuickLookThumbnailing

class MSGUrlImageCollectionViewCell: MSGMessageCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    override public var message: MSGMessage? {
        didSet {
            guard let message = message,
                  case let MSGMessageBody.url(url) = message.body else { return }
            if let intUrl = URL(string: url), intUrl.lastPathComponent.hasSuffix(".pdf") || intUrl.lastPathComponent.hasSuffix(".doc") || intUrl.lastPathComponent.hasSuffix(".docx") || intUrl.lastPathComponent.hasSuffix(".xls") || intUrl.lastPathComponent.hasSuffix(".xlsx") {
                fileNameLabel.text = intUrl.lastPathComponent
                if #available(iOS 13.0, *) {
                    let downloadTask = URLSession.shared.downloadTask(with: intUrl) {
                        urlOrNil, responseOrNil, errorOrNil in

                        guard let fileURL = urlOrNil else { return }

                        let documentsURL = try?
                        FileManager.default.url(for: .cachesDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
                        if let savedURL = documentsURL?.appendingPathComponent(intUrl.lastPathComponent) {
                            try? FileManager.default.moveItem(at: fileURL, to: savedURL)

                            let request = QLThumbnailGenerator.Request(fileAt: savedURL, size: CGSize(width: 400, height: 400), scale: 2, representationTypes: .thumbnail)
                            QLThumbnailGenerator.shared.generateBestRepresentation(for: request) { (thumbnail, error) in
                                DispatchQueue.main.async {
                                    if let thumb = thumbnail {
                                        let image = thumb.uiImage
                                        self.imageView.contentMode = .scaleAspectFill
                                        self.imageView.image = image
                                    }
                                }
                            }
                        }
                    }
                    downloadTask.resume()
                }
            } else if let intUrl = URL(string: url) {
                imageView.contentMode = .scaleAspectFill
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
