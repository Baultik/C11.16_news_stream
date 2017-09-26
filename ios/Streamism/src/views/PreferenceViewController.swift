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

class PreferenceViewController: UITableViewController {

    var delegate:PreferenceDelegate?
    var preference:StreamCategoryPreference = StreamCategoryPreference.all()
    
    @IBOutlet weak var switchGaming: UISwitch!
    @IBOutlet weak var switchEntertainment: UISwitch!
    @IBOutlet weak var switchPeople: UISwitch!
    @IBOutlet weak var switchNews: UISwitch!
    @IBOutlet weak var switchSports: UISwitch!
    @IBOutlet weak var switchMisc: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        updateSwitches()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateSwitches() {
        switchGaming.isOn = preference.hasType(.Gaming)
        switchEntertainment.isOn = preference.hasType(.Entertainment)
        switchPeople.isOn = preference.hasType(.People)
        switchNews.isOn = preference.hasType(.News)
        switchSports.isOn = preference.hasType(.Sports)
        switchMisc.isOn = preference.hasType(.Misc)
    }
    
    @IBAction func preferenceChanged(_ sender: UISwitch) {
        switch sender {
        case switchGaming:
            if sender.isOn {preference.addType(.Gaming)} else {preference.removeType(.Gaming)};
            break
        case switchEntertainment:
            if sender.isOn {preference.addType(.Entertainment)} else {preference.removeType(.Entertainment)};
            break
        case switchPeople:
            if sender.isOn {preference.addType(.People)} else {preference.removeType(.People)};
            break
        case switchNews:
            if sender.isOn {preference.addType(.News)} else {preference.removeType(.News)};
            break
        case switchSports:
            if sender.isOn {preference.addType(.Sports)} else {preference.removeType(.Sports)};
            break
        case switchMisc:
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
