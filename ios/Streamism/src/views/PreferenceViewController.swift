//
//  PreferenceViewController.swift
//  Streamism
//
//  Created by Brian Ault on 9/8/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

protocol PreferenceDelegate {
    func preferenceChanged(_ preference:StreamCategoryPreference)
}

class PreferenceViewController: UIViewController {

    var delegate:PreferenceDelegate?
    var preference:StreamCategoryPreference = StreamCategoryPreference.all()
    
    @IBOutlet weak var buttonGaming: UIButton!
    @IBOutlet weak var buttonEntertainment: UIButton!
    @IBOutlet weak var buttonPeople: UIButton!
    @IBOutlet weak var buttonNews: UIButton!
    @IBOutlet weak var buttonSports: UIButton!
    @IBOutlet weak var buttonMisc: UIButton!
    
    let gamingColor         = UIColor(red: 234, green: 93, blue: 83, alpha: 1)
    let entertainmentColor  = UIColor(red: 14, green: 87, blue: 195, alpha: 1)
    let peopleColor         = UIColor(red: 40, green: 180, blue: 197, alpha: 1)
    let newsColor           = UIColor(red: 21, green: 128, blue: 101, alpha: 1)
    let sportsColor         = UIColor(red: 126, green: 87, blue: 143, alpha: 1)
    let miscColor           = UIColor(red: 208, green: 146, blue: 55, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        updateUIState()
        
        buttonGaming.alignContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUIState() {
        buttonGaming.isSelected = preference.hasType(.Gaming)
        buttonEntertainment.isSelected = preference.hasType(.Entertainment)
        buttonPeople.isSelected = preference.hasType(.People)
        buttonNews.isSelected = preference.hasType(.News)
        buttonSports.isSelected = preference.hasType(.Sports)
        buttonMisc.isSelected = preference.hasType(.Misc)
    }
    
    @IBAction func preferenceChanged(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender {
        case buttonGaming:
            if sender.isSelected {preference.addType(.Gaming)} else {preference.removeType(.Gaming)};
            break
        case buttonEntertainment:
            if sender.isSelected {preference.addType(.Entertainment)} else {preference.removeType(.Entertainment)};
            break
        case buttonPeople:
            if sender.isSelected {preference.addType(.People)} else {preference.removeType(.People)};
            break
        case buttonNews:
            if sender.isSelected {preference.addType(.News)} else {preference.removeType(.News)};
            break
        case buttonSports:
            if sender.isSelected {preference.addType(.Sports)} else {preference.removeType(.Sports)};
            break
        case buttonMisc:
            if sender.isSelected {preference.addType(.Misc)} else {preference.removeType(.Misc)};
            break
        default:
            break
        }
        
        if let delegate = self.delegate {
            delegate.preferenceChanged(preference)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension UIButton {
    func alignContent(spacing:CGFloat = 10) {
        if let titleLabel = titleLabel, let imageView = imageView {
            if let title = titleLabel.text, let image = imageView.image {
                let titleSize = NSString(string: title).size(withAttributes: [NSAttributedStringKey.font : titleLabel.font])
                
//                let buttonImageSize = image.size
                
                let topImageOffset = (frame.size.height - (titleSize.height + image.size.height + spacing)) / 2
                let leftImageOffset = (frame.size.width - image.size.width) / 2
                imageEdgeInsets = UIEdgeInsetsMake(topImageOffset,
                                                   leftImageOffset,
                                                   0,0)
                
                let titleTopOffset = topImageOffset + spacing + image.size.height
                let leftTitleOffset = (frame.size.width - titleSize.width) / 2 - image.size.width
                
                titleEdgeInsets = UIEdgeInsetsMake(titleTopOffset,
                                                   leftTitleOffset,
                                                   0,0)
            }
        }
    }
}
