//
//  ViewController.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 05.02.2024.
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func configuration(model: PictureData?)
}

class DetailViewController: UIViewController, DetailViewProtocol {
    private let imageManager = ImageManager.shared
    let globalQueue =  DispatchQueue.global(qos: .utility)
    var presenter: DetailPresenterType?

    // MARK: - Outlets
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentViewForStack: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var scroolView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titlePicture: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines =  2
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var date: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines =  2
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var explanation: UILabel = {
        var label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines =  0
        label.textColor = .white
        
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titlePicture,
                                                   date,
                                                   explanation
                                                  ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.setCustomSpacing(1, after: titlePicture)
        stack.setCustomSpacing(10, after: date)
        stack.setCustomSpacing(10, after: explanation)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarhy()
        setupLayout()
        presenter?.configuration()
        prepareNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scroolView.scrollIndicatorInsets = view.safeAreaInsets
        scroolView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    }
    
    // MARK: - Setup
    private func setupHierarhy() {
        view.addSubview(scroolView)
        scroolView.addSubview(contentView)
        scroolView.addSubview(image)
        scroolView.addSubview(contentViewForStack)
        contentViewForStack.addSubview(stack)
    }
    
    private func setupLayout() {
        
        scroolView.snp.makeConstraints { make in
            make.right.left.top.bottom.equalTo(view)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scroolView)
            make.left.right.equalTo(view)
            make.height.equalTo(contentView.snp.width).multipliedBy(0.7)
        }
        
        image.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(view)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        contentViewForStack.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(scroolView)
        }
        
        stack.snp.makeConstraints { make in
            make.edges.equalTo(contentViewForStack).inset(14)
        }
    }
    
    // MARK: - Configuration

    func configuration(model: PictureData?) {
        self.titlePicture.text = model?.title
        self.explanation.text = model?.explanation
        self.date.text = model?.date
        
        if let data = model?.url {
            imageManager.setImage(
                with: data,
                imageView: image,
                placeholder: UIImage(named: "nz")
            )
        }
    }
    
    private func prepareNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()

        navigationController?.navigationBar.tintColor = .black

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
    }
}

