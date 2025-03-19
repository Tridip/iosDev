//
//  CollectionViewCell.swift
//  Flickr
//
//  Created by Tridip Sarkar on 19/03/25.
//

import UIKit
//CollectionViewCell - is used to display the downloaded image
class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFill
        activityIndicatorView.startAnimating()
    }

}
