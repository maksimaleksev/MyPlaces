//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Maxim Alekseev on 04.02.2020.
//  Copyright © 2020 Maxim Alekseev. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
}
