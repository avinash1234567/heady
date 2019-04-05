//
//  DetailViewController.swift
//  Heady
//
//  Created by Dhiraj on 05/04/19.
//  Copyright © 2019 Dhiraj. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overView: UILabel!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var poster: UIImageView!
    var movieDetail = MovieList()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        print(movieDetail.vote_average)
        self.movieTitle.text = movieDetail.original_title
        self.userRating.text = "Rating:-\(String(movieDetail.vote_average))"
        self.releaseDate.text = "Release Date:- \(movieDetail.release_date!)"
        self.overView.text = movieDetail.overview
        
        self.view.isHidden = false

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
