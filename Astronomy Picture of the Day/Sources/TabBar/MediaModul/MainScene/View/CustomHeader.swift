//
//  CustomHeader.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 06.02.2024.
//

import UIKit

typealias CompletionBlock = () -> Void

class CustomHeader: UICollectionReusableView {
    
    var onComletion: CompletionBlock?
    
    let globalQueue =  DispatchQueue.global(qos: .utility)
    var presenter: MainPresenterType?
    
    static let identifier = "CustomHeader"
    
    private let imageManager = ImageManager.shared
    
    // MARK: - Outlets
    
    private lazy var headerImageButton: UIButton = {
        let button = UIButton()
        button.imageView?.layer.masksToBounds = true
        button.imageView?.layer.cornerRadius = 5
        button.imageView?.contentMode = .scaleAspectFill
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(buttonTapped),for: .touchUpInside)
        return button
    }()
    
    lazy var pictureTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 3
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(headerImageButton)
        headerImageButton.addSubview(pictureTitle)
    }
    
    private func setupLayout() {
        headerImageButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pictureTitle.snp.makeConstraints { make in
            make.centerX.equalTo(headerImageButton)
            make.bottom.equalTo(headerImageButton).offset(-10)
            make.left.equalTo(headerImageButton).offset(8)
        }
    }
    
    func handleTapGuesture() {
        self.onComletion?()
    }
    
    // MARK: - Configuration
    
    func configuration(model: PictureData) {
        self.pictureTitle.text = model.title

        if let imageURL = URL(string: model.url){

            globalQueue.async {
                if let imageData = try? Data(contentsOf: imageURL){
                    DispatchQueue.main.async{
                        let image = UIImage(data: imageData )
                        self.headerImageButton.setImage(image, for: .normal)
                    }
                }
            }
        } else {
            let image = UIImage(named: "nz")
            self.headerImageButton.setImage(image, for: .normal)
            return
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc func buttonTapped() {
        handleTapGuesture()
    }
}
