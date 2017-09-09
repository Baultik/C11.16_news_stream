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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func preferenceChanged(_ sender: UISwitch) {
        var preference = StreamCategoryPreference()
        switch sender.tag {
            case 1: if sender.isOn {preference.addType(type: .Gaming)}; break
            case 2: if sender.isOn {preference.addType(type: .Entertainment)}; break
            case 3: if sender.isOn {preference.addType(type: .People)}; break
            case 4: if sender.isOn {preference.addType(type: .News)}; break
            case 5: if sender.isOn {preference.addType(type: .Sports)}; break
            case 6: if sender.isOn {preference.addType(type: .Misc)}; break
            default: break
        }
        
        if let delegate = self.delegate {
            delegate.preferenceChanged(preference)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
