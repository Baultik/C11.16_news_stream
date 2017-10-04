//
//  ViewController.swift
//  Streamism
//
//  Created by Brian Ault on 8/9/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,PreferenceDelegate {
    private var prefViewController:PreferenceViewController?
    private var streamGridViewController:StreamGridController?
    private var prefConstraintConstant:CGFloat = 0
    @IBOutlet weak var prefConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "prefEmbed") {
            prefViewController = segue.destination as? PreferenceViewController
            prefViewController?.delegate = self;
            
            prefConstraintConstant = prefConstraint.constant
            
        } else if (segue.identifier == "streamGridEmbed") {
            streamGridViewController = segue.destination as? StreamGridController
        }
    }
    
    func preferenceChanged(_ preference:StreamCategoryPreference) {
        streamGridViewController?.preferenceUpdate(preference)
    }
    @IBAction func togglePreferenceView(_ sender: Any) {
        prefConstraint.constant = prefConstraint.constant == 0 ? prefConstraintConstant : 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

