//
//  SearchViewController.swift
//  Heady
//
//  Created by Dhiraj on 06/04/19.
//  Copyright © 2019 Dhiraj. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
     override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    var movie = [MovieList]()

    var phtol:Bool = false
    var pltoh:Bool = false
    var rhtol:Bool = false
    var rltoh:Bool = false

    @IBAction func ratinghtol(_ sender: Any) {
        rhtol = true
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController{
            vc.rhtol = rhtol
            vc.movie = self.movie

             self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func ratingltoh(_ sender: Any) {
        rltoh = true
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController{
            vc.rltoh = rltoh
            vc.movie = self.movie
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func popularityhtol(_ sender: Any) {
        phtol = true
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController{
            vc.phtol = phtol
            vc.movie = self.movie

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func populariryltoh(_ sender: Any) {
        pltoh = true
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController{
            vc.pltoh = pltoh
            vc.movie = self.movie

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
