//
//  DemoCell.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import UIKit
import Kingfisher

class DemoCell: UICollectionViewCell {
    
    static let cellId = "DemoCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageLink: String!{
        didSet{
            setImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setImage()
        
    }
    
    func setImage(){
        
        guard let imageURL = URL(string: imageLink) else {
            print("Link is not URL")
            return
        }
        
        imageView!.kf.setImage(with: imageURL, placeholder: UIImage(named: "holder"))
        
    }
    
}
