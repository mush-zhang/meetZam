//
//  MovieAndList.swift
//  MySampleApp
//
//  Created by Ling Zhang on 3/22/17.
//
//


import Foundation
import AWSDynamoDB
import AWSMobileHubHelper

let AWSDynamoDBTableName = "movie_table"//"meetzam-mobilehub-1569925313-Movie"
class SingleMovie : AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    //var movie_id: Int?
    
    var title = String()
    var directors = Set<String>()
    var genres = Set<String>()
    var longDescription: String?
    var poster_path: String?
    var releaseYear: String?
    var shortDescriptiontle: String?
    var tmdb_id: String?
    var topCast = Set<String>()
    //var TMDB_popularity: String?
    var trailer_key: String?
    

    var image: UIImage?
    var pop: String?
    
    class func dynamoDBTableName() -> String {
        return AWSDynamoDBTableName
    }
    
    class func hashKeyAttribute() -> String {
        return "title"
    }
    
/*
    func getMovieForDisplay(key: String, movie_data: SingleMovie?, movieTitle: UILabel!, movieTitleDetailed: UITextView!, imageView: UIImageView!, moviePopInfo: UILabel!){
        print("     enter func getmovieForDisplay")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let mapper = AWSDynamoDBObjectMapper.default()
        mapper.load(SingleMovie.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            }
            else if let movie_data = task.result as? SingleMovie {
                //print("     Getting fields")
                movieTitle.text = movie_data.Title
                //print(movieTitle.text)
                movieTitleDetailed.text = movie_data.overview
                //print(movieTitleDetailed.text)
                //imgName = URL("https://image.tmdb.org/t/p/w500/" + movie_data.poster_path)
                let path = "https://image.tmdb.org/t/p/w500/" + movie_data.poster_path!
                let imageURL = URL(string: path)
                let imageData = try! Data(contentsOf: imageURL!)
                imageView.image = UIImage(data: imageData)
                
                moviePopInfo.text = "Popularity: " + movie_data.TMDB_popularity!
                
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
    }
 */
    func refreshList(movie_list: MovieList, view: FrameViewController, user_profile: UserProfileToDB)  {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        // queryExpression.exclusiveStartKey = self.lastEvaluatedKey
        //queryExpression.limit = 5
        
        dynamoDBObjectMapper.scan(SingleMovie.self, expression: queryExpression).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            var c = 0
            
            if let paginatedOutput = task.result {
                for item in paginatedOutput.items as! [SingleMovie] {

                    let path = "https://image.tmdb.org/t/p/w500/" + (item.poster_path)!
                    let imageURL = URL(string: path)
                    let imageData = try! Data(contentsOf: imageURL!)
                    item.image = UIImage(data: imageData)
                    //item.pop = "Popularity: " + item.TMDB_popularity!
                    movie_list.tableRows.append(item)
                    
                    if c == 0 {
                        print("LALALA")
                        if (user_profile.currentLikedMovie.contains(item.title)) {
                            print("scan:FOUND THE MOVIE IN LIKED LIST")
                            view.like = true
                        }
                        else {
                            print("scan:NOT LIKED")
                        }
 
                        view.movieTitle.text = item.title
                        view.movieDetailedInfo.text = item.longDescription
                        let path = "https://image.tmdb.org/t/p/w500/" + (item.poster_path)!
                        let imageURL = URL(string: path)
                        let imageData = try! Data(contentsOf: imageURL!)
                        view.imageView.image = UIImage(data: imageData)
                        
                        view.movie_info = item;
                    }
                    
                    print(movie_list.tableRows.count)
                    print(movie_list.tableRows[c].title ?? "mushroom_title")
                    print(movie_list.tableRows[c].topCast.description )
                    if c > 0 {
                        print(movie_list.tableRows[c - 1].title ?? "mushroom_prev_title")
                    }
                    c = c + 1
                    
                }
                
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //self.tableView.reloadData()
            if let error = task.error as? NSError {
                print("Error: \(error)")
            }
            print("number of all movies \(c)")
            
            return nil
        })
        
    }
    
}

class MovieList {
    var tableRows:Array = [SingleMovie]()
    
    
}

