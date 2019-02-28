//
//  ViewController.swift
//  test
//
//  Created by webuygoods.com on 2/19/19.
//  Copyright © 2019 AnaPiligrim. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    //create an array
    
    //dictionary
    var movies = [[String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                self.tableView.reloadData()
                
                //sprint(dataDictionary)
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //when you have a lot of cells - you have a recycled cell - dequeque and you cast it
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        //acess the 1st, 2nd, 3rd movie
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        //acess the title of the movie by putting some key here - key "title" is found in the API
        //cast the title - tells you the type --- String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        //Swift optionals - inserts Question marks
        //cell.textLabel?.text = "row: \(indexPath.row)"
        
        //cell.titleLabel.text = title
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print("Loading up the details screen")
        
        //Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        //Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

