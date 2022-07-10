//
//  BeerDetaulsViewController.swift
//  WikiBeerUIKIT
//
//  Created by Joaquin on 9/7/22.
//

import UIKit

class BeerDetailsViewController: UIViewController {

    private let titleAttributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
        NSAttributedString.Key.foregroundColor : UIColor.white
    ]

    private let subtitleAttributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
        NSAttributedString.Key.foregroundColor : UIColor.lightGray
    ]

    private let detailsAttributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
        NSAttributedString.Key.foregroundColor : UIColor.lightGray
    ]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = AppColor.background
        view.translatesAutoresizingMaskIntoConstraints = false

        let ribbonIcon = UIImageView(image: UIImage(named: "ribbon"))
        ribbonIcon.tintColor = AppColor.yellow
        ribbonIcon.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(ribbonIcon)

        NSLayoutConstraint.activate([
            ribbonIcon.topAnchor.constraint(equalTo: view.topAnchor),
            ribbonIcon.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12)
        ])

        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    init(beerDetails: BeerDetails) {
        super.init(nibName: nil, bundle: nil)

        NetworkManager().load(beerDetails.imageURL) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }

        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: beerDetails.title, attributes: titleAttributes))
        text.append(NSAttributedString(string: "\n" + beerDetails.subtitle, attributes: subtitleAttributes))
        text.append(NSAttributedString(string: "\n\n" + beerDetails.details, attributes: detailsAttributes))

        label.attributedText = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(imageView)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
            imageView.heightAnchor.constraint(equalTo: label.heightAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),

            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 24),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24)
        ])
        
        let preferredScrollViewHeightAnchor = scrollView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        preferredScrollViewHeightAnchor.priority = .defaultLow
        preferredScrollViewHeightAnchor.isActive = true

        let tapGestureRegocnizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRegocnizer)
    }

    @objc func handleTap() {
        dismiss(animated: true)
    }
}
