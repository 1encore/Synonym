//
//  SingleWordViewController.swift
//  Synonim
//
//  Created by Yerbolat Beisenbek on 30.10.17.
//  Copyright © 2017 Yerbolat Beisenbek. All rights reserved.
//

import UIKit

class SingleWordViewController: UIViewController {


    @IBOutlet weak var synonymLabel: UILabel!
    
    var word : String!
    var index : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synonymLabel.text = word
    }

    
    @IBAction func asMain(_ sender: UIButton) {
        let synDefault = UserDefaults.standard
        synDefault.set(word, forKey: "syn")
        synDefault.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
