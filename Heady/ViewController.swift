//
//  ViewController.swift
//  Heady
//
//  Created by Dhiraj on 05/04/19./Users/dhiraj/Desktop/iOS Projects/talkRecruit/talkRecruit/Info.plist
//  Copyright © 2019 Dhiraj. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD



class ViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource
            , UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.gray
        let collectionflow = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(collectionflow, animated: true)
        collectionflow.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        // Do any additional setup after loading the view, typically from a nib.
      callMovieListApi()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.movieName.text = self.movie[indexPath.row].title
        
        
        cell.moviePoster.layer.cornerRadius=cell.moviePoster.frame.size.width/2
        if let logo = movie[indexPath.row].poster_path{
//            cell.moviePoster.sd_setImage(with: URL(string: logo)) { (img, err, cache, url) in
//                if err != nil{
//                    print(err!.localizedDescription)
//                    //imgPhoto.image = #imageLiteral(resourceName: "driver-1")
//
//                }
//            }
        }
        let url = movie[indexPath.row].poster_path
         //cell.moviePoster.sd_setImage(with: URL(string: url as! String)
        //cell.moviePoster.image = self.movie[indexPath.row].poster_path
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController{
             vc.movieDetail = movie[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    var movie = [MovieList]()
    func callMovieListApi()  {
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(MOVIE_LIST, method: .get , parameters: nil)
            .responseJSON { closureResponse in
                if String(describing: closureResponse.result) == "SUCCESS"
                {
                    SVProgressHUD.dismiss()

                    let JSON = closureResponse.result.value as? NSDictionary
                    if let moviedata = JSON?["results"] as? NSArray
                    {
                        
                        for d in moviedata{
                            if let movieDict = d as? [String:Any]{
                                let movie_data = MovieList(rawData: movieDict)
                                self.movie.append(movie_data)
                            }
                            
                        }
                        
                        self.collectionView.reloadData()
                    }
                }
                else {
                    
                    SVProgressHUD.showError(withStatus: "Failed!")
                }
        }
    }
}

