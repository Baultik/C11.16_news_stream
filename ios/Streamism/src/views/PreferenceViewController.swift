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
    
    @IBOutlet weak var buttonGaming: PreferenceToggle!
    @IBOutlet weak var buttonEntertainment: PreferenceToggle!
    @IBOutlet weak var buttonPeople: PreferenceToggle!
    @IBOutlet weak var buttonNews: PreferenceToggle!
    @IBOutlet weak var buttonSports: PreferenceToggle!
    @IBOutlet weak var buttonMisc: PreferenceToggle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        updateUIState()
        
        ///buttonGaming.alignContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUIState() {
        buttonGaming.isOn = preference.hasType(.Gaming)
        buttonEntertainment.isOn = preference.hasType(.Entertainment)
        buttonPeople.isOn = preference.hasType(.People)
        buttonNews.isOn = preference.hasType(.News)
        buttonSports.isOn = preference.hasType(.Sports)
        buttonMisc.isOn = preference.hasType(.Misc)
    }
    
    @IBAction func preferenceChanged(_ sender: PreferenceToggle) {
        sender.isOn = !sender.isOn
        switch sender {
        case buttonGaming:
            if sender.isOn {preference.addType(.Gaming)} else {preference.removeType(.Gaming)};
            break
        case buttonEntertainment:
            if sender.isOn {preference.addType(.Entertainment)} else {preference.removeType(.Entertainment)};
            break
        case buttonPeople:
            if sender.isOn {preference.addType(.People)} else {preference.removeType(.People)};
            break
        case buttonNews:
            if sender.isOn {preference.addType(.News)} else {preference.removeType(.News)};
            break
        case buttonSports:
            if sender.isOn {preference.addType(.Sports)} else {preference.removeType(.Sports)};
            break
        case buttonMisc:
            if sender.isOn {preference.addType(.Misc)} else {preference.removeType(.Misc)};
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
