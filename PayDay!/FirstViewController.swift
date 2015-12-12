//
//  FirstViewController.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 9/18/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var varDec = VariableDec()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tbc = tabBarController as! VariableController
        varDec = tbc.varDec
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

