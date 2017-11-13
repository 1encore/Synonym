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
    
    var words : [String] = []
    var secondSyn: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let synDefault = UserDefaults.standard
        if synDefault.value(forKey: "syn") != nil {
            secondSyn = synDefault.value(forKey: "syn") as! String
            self.searchSynonyms(text: secondSyn)
            searchBar.text = ""
            synDefault.removeObject(forKey: "syn")
        }
        
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
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            if(error != nil){
                print(error?.localizedDescription)
            }else{
                print(String(data: data!, encoding: String.Encoding.utf8))
                
                let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String: AnyObject]]
                
                if(json.count > 0){
                    let item = json[0]
                    
                    if let words = item["words"] as? [String] {
                        DispatchQueue.main.async {
                            self.displayWords(words: words)
                        }
                    }
                }
            }
        }.resume()
    }
    
    func displayWords(words: [String]) {
        self.words = words
        
        if(words.count > 0) {
            
            let singleWordVC = self.storyboard?.instantiateViewController(withIdentifier: "SingleWordVC") as! SingleWordViewController
            
            singleWordVC.word = words[0]
            singleWordVC.index = 0
            
            let pageVC = UIPageViewController()
            
            pageVC.setViewControllers([singleWordVC], direction: .forward, animated: true, completion: nil)
            pageVC.view.frame = self.viewPlace.frame
            
            self.addChildViewController(pageVC)
            self.view.addSubview(pageVC.view)
            pageVC.didMove(toParentViewController: self)
            
            pageVC.dataSource = self
            
        }
    }
    
}

extension ViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = (viewController as! SingleWordViewController).index - 1
        
        if(index < 0) {
            return nil
        }
        
        let singleWordVC = self.storyboard?.instantiateViewController(withIdentifier: "SingleWordVC") as! SingleWordViewController
        
        singleWordVC.word = words[index]
        singleWordVC.index = index
        
        return singleWordVC
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! SingleWordViewController).index + 1
        
        if(index >= words.count) {
            return nil
        }
        
        let singleWordVC = self.storyboard?.instantiateViewController(withIdentifier: "SingleWordVC") as! SingleWordViewController
        
        singleWordVC.word = words[index]
        singleWordVC.index = index
        
        return singleWordVC
    }
}

extension ViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        self.searchSynonyms(text: text)
        searchBar.text = ""
    }
}
