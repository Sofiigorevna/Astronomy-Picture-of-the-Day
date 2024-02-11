//
//  ViewController.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 05.02.2024.
//

import UIKit
import Kingfisher

protocol DetailViewProtocol: AnyObject {
    func configuration(model: PictureData?)
}

class DetailViewController: UIViewController, DetailViewProtocol {
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
    private lazy var scrollView: UIScrollView = {
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
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.scrollIndicatorInsets = view.safeAreaInsets
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    }
    
    // MARK: - Setup
    private func setupHierarhy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(image)
        scrollView.addSubview(contentViewForStack)
        contentViewForStack.addSubview(stack)
    }
    
    private func setupLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.height.equalTo(contentView.snp.width).multipliedBy(0.7)
        }
        
        image.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(view)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        contentViewForStack.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(scrollView)
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
            DownloadImgManager.setImage(
                with: URL(string: data),
                imageView: image)
        }
    }
    
    private func prepareNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.tintColor = .systemBackground
        
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
    }
    
    //MARK: — Status Bar Appearance
    
    private var shouldHideStatusBar: Bool {
        let frame = contentViewForStack.convert(contentViewForStack.bounds, to: nil)
        return frame.minY < view.safeAreaInsets.top
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var previousStatusBarHidden = false
        
        if  previousStatusBarHidden != shouldHideStatusBar {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            previousStatusBarHidden = shouldHideStatusBar
        }
    }
}

