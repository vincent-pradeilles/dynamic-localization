//
//  ViewController.swift
//  DynamicLocalization
//
//  Created by Vincent on 10/08/2017.
//  Copyright © 2017 Vincent. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var frenchLocalizationButton: UIButton!
    @IBOutlet weak var englishLocalizationButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocalizedStrings()
        NotificationCenter.default.addObserver(self, selector: #selector(setLocalizedStrings), name: LocalizationWasModifiedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func frenchLocalizationButtonPressed(_ sender: Any) {
        Bundle.setLanguage("fr")
    }
    
    @IBAction func englishLocalizationButtonPressed(_ sender: Any) {
        Bundle.setLanguage("en")
    }
    
    @objc private func setLocalizedStrings() {
        helloLabel.text = NSLocalizedString("Hello!", comment: "")
        frenchLocalizationButton.setTitle(NSLocalizedString("Go to French localization", comment: ""), for: .normal)
        englishLocalizationButton.setTitle(NSLocalizedString("Go to English localization", comment: ""), for: .normal)
    }
}

