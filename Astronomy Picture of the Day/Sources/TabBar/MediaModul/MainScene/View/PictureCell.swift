//
//  PictureCell.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 05.02.2024.
//

import UIKit
import SnapKit

class PictureCell: UICollectionViewCell {
    static let identifier = "PictureCell"
    private let imageManager = ImageManager.shared
    
    // MARK: - Outlets
    
    lazy var pictureTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 3
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error in Cell")
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        contentView.addSubview(imageView)
        imageView.addSubview(pictureTitle)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pictureTitle.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.bottom.equalTo(imageView).offset(-10)
            make.left.equalTo(imageView).offset(8)
        }
    }
    
    // MARK: - Configuration
   
    func configuration(model: PictureData) {
        self.pictureTitle.text = model.title
        
        imageManager.setImage(
            with: model.url,
            imageView: imageView,
            placeholder: UIImage(named: "nz")
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}





