//
//  ViewController.swift
//  Synonim
//
//  Created by Yerbolat Beisenbek on 30.10.17.
//  Copyright © 2017 Yerbolat Beisenbek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewPlace: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchSynonyms(text: String){
        let text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!.lowercased()
        let url = "http://api.wordnik.com:80/v4/word.json/\(text)/relatedWords?useCanonical=false&relationshipTypes=synonym&limitPerRelationshipType=10&api_key=a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
        print(url)
        
        URLSession.shared.dataTask(with: URL(sting: url)!, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
    }
}

extension ViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        self.searchSynonyms(text: text)
    }
}
