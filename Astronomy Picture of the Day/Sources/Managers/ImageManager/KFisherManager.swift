//
//  KFisherManager.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 09.02.2024.
//

import UIKit
import Kingfisher

enum DownloadImgManager {
    static func setImagePDF(with url: URL?,
                            imageView: UIImageView,
                            placeholder: UIImage? = UIImage(named: "pic_product_no name")) {
        let processor = PDFProcessor()
        imageView.image = placeholder

        guard let url = url else {
            return
        }

        let imageResource = KF.ImageResource(downloadURL: url)
        
        imageView.kf.setImage(
            with: .network(imageResource),
            placeholder: placeholder,
            options: [.processor(processor)],
            progressBlock: nil
        )
    }
    
    static func setImage(with url: URL?,
                         imageView: UIImageView,
                         placeholder: UIImage? = UIImage(named: "load")) {
        
        imageView.image = placeholder
        guard let url = url else {
            return
        }
        
        let imageResource = KF.ImageResource(downloadURL: url)
        imageView.kf.setImage(
            with: .network(imageResource),
            placeholder: placeholder,
            options: [.cacheOriginalImage],
            progressBlock: nil
        )
    }
    
    static func setImageWithTrim(with url: URL?,
                                 imageView: UIImageView,
                                 placeholder: UIImage? = UIImage(named: "pic_product_no name")) {
        
        imageView.image = placeholder
        guard let url = url else {
            return
        }
    
        let size = imageView.intrinsicContentSize
        let width = Int(size.width * UIScreen.main.scale)
        let height = Int(size.height * UIScreen.main.scale)
        
        let trimStr = "https://image.prodly.ru/unsafe/trim/fit-in/\(width)x\(height)/\(url.absoluteString)"
        guard let trimURL = URL(string: trimStr) else {
            return
        }

        let imageResource = KF.ImageResource(downloadURL: trimURL)
        imageView.kf.setImage(
            with: .network(imageResource),
            placeholder: placeholder,
            options: [],
            progressBlock: nil
        )
    }
}

// swiftlint:disable all
struct PDFProcessor: ImageProcessor {
    
    var identifier: String = "ru.l-tech.ent.prodly"
    
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            let pdfData = data as CFData
            guard let provider:CGDataProvider = CGDataProvider(data: pdfData) else {return nil}
            guard let pdfDoc:CGPDFDocument = CGPDFDocument(provider) else {return nil}
            guard let pdfPage:CGPDFPage = pdfDoc.page(at: 1) else {return nil}
            var pageRect:CGRect = pdfPage.getBoxRect(.mediaBox)
            pageRect.size = CGSize(width:pageRect.size.width, height:pageRect.size.height)
            UIGraphicsBeginImageContextWithOptions(pageRect.size, false, UIScreen.main.scale)
            guard let context:CGContext = UIGraphicsGetCurrentContext()  else {return nil}
            context.saveGState()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1, y: -1)
            context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect:  pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(pdfPage)
            context.restoreGState()
            let pdfImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return pdfImage
        }
    }
}
