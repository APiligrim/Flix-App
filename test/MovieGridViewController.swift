//
//  MovieGridViewController.swift
//  test
//
//  Created by webuygoods.com on 2/27/19.
//  Copyright © 2019 AnaPiligrim. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UITableViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
   
    var movies = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self as? UICollectionViewDelegate
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4
        layout.minimumLineSpacing = 4
        
        //the width will change depending on what phone the user is running your app on
        //multiply by 2 bc. you want spaces in 2 places
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2 ) / 3
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        
        
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                self.collectionView.reloadData()
                
                print(self.movies)
               //
                
            }
        }
        task.resume()    }
    
    //count how many items movies.count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
       
        //movies have items!
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
