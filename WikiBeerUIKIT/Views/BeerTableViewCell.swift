//
//  BeerTableViewCell.swift
//  WikiBeerUIKIT
//
//  Created by Joaquin on 9/7/22.
//

import UIKit

class BeerTableViewCell: UITableViewCell {
    static let reuseIdentifier = "BeerTableViewCell"

    private let titleAttributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold),
        NSAttributedString.Key.foregroundColor : UIColor.white
    ]

    private let subtitleAttributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
        NSAttributedString.Key.foregroundColor : UIColor.lightGray
    ]

    private var imageURL: String?
    private let indicator = UIActivityIndicatorView(frame: CGRect(x: 15, y: 45, width: 25, height: 25))

    private let thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(thumbnail)

        thumbnail.addSubview(indicator)

        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            thumbnail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
            thumbnail.widthAnchor.constraint(equalToConstant: 60),

            textLabel!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textLabel!.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: 24),
            textLabel!.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24),

            detailTextLabel!.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: 24),
            detailTextLabel!.topAnchor.constraint(equalTo: textLabel!.bottomAnchor, constant: 12),
            detailTextLabel!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        textLabel?.numberOfLines = 5
        textLabel?.textColor = .white
        textLabel?.translatesAutoresizingMaskIntoConstraints = false

        detailTextLabel?.textColor = AppColor.yellow
        detailTextLabel?.text = "MORE INFO"
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, subtitle: String, details: String, imageURL: String) {
        thumbnail.image = nil
        indicator.startAnimating()

        self.imageURL = imageURL
        NetworkManager().load(imageURL) { image in
            guard self.imageURL == imageURL else { return }

            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.thumbnail.image = image
            }
        }

        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: title, attributes: titleAttributes))
        text.append(NSAttributedString(string: "\n" + subtitle, attributes: subtitleAttributes))
        text.append(NSAttributedString(string: "\n\n" + details, attributes: subtitleAttributes))

        textLabel?.attributedText = text
    }
}
