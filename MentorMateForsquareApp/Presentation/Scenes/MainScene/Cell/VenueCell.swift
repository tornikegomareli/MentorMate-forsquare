//
//  VanueCell.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 17.11.21.
//

import UIKit

class VenueCell: UITableViewCell {
    static let reuseIdentifier: String = "VenuesCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(model: Venue) {
        nameLabel.text = model.name
        cityLabel.text = model.location.city
        countryLabel.text = model.location.country
    }
}
