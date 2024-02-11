//
//  ImageManager.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 08.02.2024.
//

//import Foundation
//import SDWebImage
//
//final class ImageManager {
//    
//    // State
//    static let shared = ImageManager()
//    
//    private let group = DispatchGroup()
//    private let queue = DispatchQueue(
//        label: "com.ltech.polza.home.imageManager",
//        qos: DispatchQoS.userInitiated,
//        attributes: .concurrent
//    )
//    private var groupImagesResult = [UIImage?]()
//    
//    // Init
//    private init() { }
//    
//    // Interface
//    func setImage(
//        with url: String,
//        imageView: UIImageView,
//        contentMode: UIView.ContentMode? = nil,
//        placeholder: UIImage? = nil,
//        placeholderContentMode: UIView.ContentMode? = nil
//    ) {
//        imageView.image = placeholder
//        if let placeholderContentMode = placeholderContentMode {
//            imageView.contentMode = placeholderContentMode
//        }
//        
//        guard let url = URL(string: url) else {
//            return
//        }
//        imageView.sd_setImage(with: url,
//                              placeholderImage: placeholder) { [weak imageView] image, _, _, _ in
//            if image != nil, let contentMode = contentMode {
//                imageView?.contentMode = contentMode
//            }
//        }
//    }
//        
//    func setImage(with url: String,
//                  imageView: UIImageView,
//                  placeholder: UIImage? = nil,
//                  completionHandler: SDExternalCompletionBlock?) {
//        imageView.image = placeholder
//        guard let url = URL(string: url) else {
//            return
//        }
//        imageView.sd_setImage(with: url,
//                              placeholderImage: placeholder,
//                              completed: completionHandler)
//    }
//    
//    func getImage(
//        with url: String,
//        completion: @escaping (UIImage?) -> Void
//    ) {
//        guard let url = URL(string: url) else {
//            return
//        }
//        SDWebImageManager.shared.loadImage(
//            with: url,
//            progress: nil
//        ) { image, _, _, _, _, _ in
//            completion(image)
//        }
//    }
//    
//    func loadImages(with imagePaths: [String],
//                    completion: @escaping ([UIImage?]) -> Void) {
//        imagePaths.forEach { path in
//            group.enter()
//            queue.async(group: group,
//                        execute: { [weak self] in
//                self?.getImage(
//                    with: path,
//                    completion: { [weak self] image in
//                        //                        if let image = image {
//                        self?.groupImagesResult.append(image)
//                        //                        }
//                        self?.group.leave()
//                    }
//                )
//            })
//        }
//        group.notify(queue: .main) { [weak self] in
//            guard let strongSelf = self else { return }
//            completion(strongSelf.groupImagesResult)
//            strongSelf.groupImagesResult = []
//        }
//    }
//    
//}
//
