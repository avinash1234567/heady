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
, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    var phtol:Bool = false
    var pltoh:Bool = false
    var rhtol:Bool = false
    var rltoh:Bool = false
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchText.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.gray
        let collectionflow = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(collectionflow, animated: true)
        collectionflow.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        // Do any additional setup after loading the view, typically from a nib.
        callMovieListApi(search: "all")
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let search = textField.text!
        if(search.count>0){
            callMovieListApi(search: search)
            textField.text = nil
            
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(phtol || rhtol || rltoh || pltoh){
            callMovieListApi(search: "all")
              }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (movie.count > 0){
            return movie.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.movieName.text = self.movie[indexPath.row].title
        
         
        let url = movie[indexPath.row].poster_path
        if(url != nil){
            cell.moviePoster.downloaded(from: url!)

        }
        //cell.moviePoster.image = self.movie[indexPath.row].poster_path
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow ))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size , height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController{
            vc.movieDetail = movie[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func filter(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController{
            vc.movie = movie
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    var movie = [MovieList]()
    func callMovieListApi(search : String)  {
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request("\(MOVIE_LIST)query=\(search)&api_key=\(API_KEY)", method: .get , parameters: nil)
            .responseJSON { closureResponse in
                if String(describing: closureResponse.result) == "SUCCESS"
                {
                    SVProgressHUD.dismiss()
                    
                    let JSON = closureResponse.result.value as? NSDictionary
                    if let moviedata = JSON?["results"] as? NSArray
                    {
                        self.movie.removeAll()

                        for d in moviedata{
                            if let movieDict = d as? [String:Any]{
                                let movie_data = MovieList(rawData: movieDict)
                                self.movie.append(movie_data)
                            }
                            
                        }
                        
                        
                        self.collectionView.reloadData()
                    }
                    if(self.phtol ){
                        
                        var filter = self.movie.sorted { (c1, c2) -> Bool in
                            return c1.popularity > c2.popularity
                        }
                        
                        self.movie.removeAll()
                        
                        self.movie = filter
                        filter.removeAll()
                        self.collectionView.reloadData()
                        
                    }
                    if(self.pltoh ){
                        
                       var filter = self.movie.sorted(by: { $0.popularity < $1.popularity })

                        self.movie.removeAll()
                        
                        self.movie = filter
                        filter.removeAll()
                        
                        OperationQueue.main.addOperation( {
                            self.collectionView.reloadData()
                        })
                    }
                    if(self.rhtol){
                        var filter = self.movie.sorted { (c1, c2) -> Bool in
                            return c1.vote_average > c2.vote_average
                        }
                        self.movie.removeAll()
                        
                        self.movie = filter
                        filter.removeAll()
                        
                        OperationQueue.main.addOperation( {
                            self.collectionView.reloadData()
                        })        }
                    if(self.rltoh){
                        var filter = self.movie.sorted { (c1, c2) -> Bool in
                            return c1.vote_average < c2.vote_average
                        }
                        self.movie.removeAll()
                        self.movie = filter
                        filter.removeAll()
                        
                        OperationQueue.main.addOperation( {
                            self.collectionView.reloadData()
                        })
                        
                    }
                }
                else {
                    
                    SVProgressHUD.showError(withStatus: "Failed!")
                }
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
