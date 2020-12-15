import UIKit

struct ResponseData: Decodable {
    private enum CodingKeys : String, CodingKey {
        case search = "Search"
    }
    let search: [Movie]
}

struct Movie : Decodable {
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case imdbID = "imdbID"
        case type = "Type"
    }
    var title: String = "Unknown"
    var year: String = "Unknown"
    var poster: String = "Unknown"
    var imdbID: String = "Unknown"
    var type: String = "Unknown"
}

struct MovieDetails : Decodable {
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case imdbID = "imdbID"
        case type = "Type"
        case production = "Production"
    }
    var title: String = "Unknown"
    var year: String = "Unknown"
    var rated: String = "Unknown"
    var released: String = "Unknown"
    var runtime: String = "Unknown"
    var genre: String = "Unknown"
    var director: String = "Unknown"
    var writer: String = "Unknown"
    var actors: String = "Unknown"
    var plot: String = "Unknown"
    var language: String = "Unknown"
    var country: String = "Unknown"
    var awards: String = "Unknown"
    var poster: String = "Unknown"
    var imdbRating: String = "Unknown"
    var imdbVotes: String = "Unknown"
    var imdbID: String = "Unknown"
    var type: String = "Unknown"
    var production: String = "Unknown"
    
    init(movie: Movie) {
        title = movie.title
        year = movie.year
        type = movie.type
        imdbID = movie.imdbID
        poster = movie.poster
    }
}

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    static var movies = loadMovies(fileName: "MoviesList")!
    static var moviesDetails = loadMoviesDetails(dirName: "MoviesDetails")!

     var filteredMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchBar.delegate = self

        filteredMovies = ViewController.movies
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    static func loadMovies(fileName: String) -> [Movie]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "txt") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.search
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    static func loadMoviesDetails(dirName: String) -> [MovieDetails]? {
        do {
            var result = [MovieDetails]()
            let url = Bundle.main.url(forResource: dirName, withExtension: nil)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url!, includingPropertiesForKeys: nil, options: [])
            let txtFiles = directoryContents.filter{ $0.pathExtension == "txt" }
            
            let decoder = JSONDecoder()
            for file in txtFiles {
                let data = try Data(contentsOf: file)
                let jsonData = try decoder.decode(MovieDetails.self, from: data)
                result.append(jsonData)
            }
            return result
        } catch {
           print("error:\(error)")
        }
        return nil
    }
    
    static func addMovie(movie: Movie) {
        ViewController.movies.append(movie)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = filteredMovies[indexPath.row]
        cell.titleLabel?.text = movie.title
        cell.yearLabel?.text = movie.year
        cell.typeLabel?.text = movie.type
        cell.posterImageView?.image = UIImage(named: movie.poster)
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            ViewController.movies.remove(at: indexPath.row)
            self.filteredMovies.remove(at: indexPath.row)
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = self.tableView.indexPath(for: cell)!
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            if segue.identifier == "movieDetails" {
                let detailsViewController = segue.destination as! DetailsViewController
                
                let filteredMovie = filteredMovies[indexPath.row]
                for movieDetails in ViewController.moviesDetails {
                    if (movieDetails.imdbID == filteredMovie.imdbID) {
                        detailsViewController.movieDetails = movieDetails
                    }
                }
                
                if (detailsViewController.movieDetails == nil) {
                    let movie = filteredMovies[indexPath.row]
                    detailsViewController.movieDetails = MovieDetails.init(movie: movie)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = []
        
        if searchText == "" {
            filteredMovies = ViewController.movies
        } else {
            for movie in ViewController.movies {
                if (movie.title.lowercased().contains(searchText.lowercased())) {
                    filteredMovies.append(movie)
                }
            }
        }
        
        self.tableView.reloadData()

        if filteredMovies.count == 0 {
            setEmptyDataPlaceholder("No items found")
        } else {
            removeEmptyDataPlaceholder()
        }
    }
    
    func setEmptyDataPlaceholder(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        label.text = message
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "TrebuchetMS", size: 15)
        label.sizeToFit()
        
        self.tableView.isScrollEnabled = false
        self.tableView.backgroundView = label
        self.tableView.separatorStyle = .none
    }
    
    func removeEmptyDataPlaceholder() {
        self.tableView.isScrollEnabled = true
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
    }

    
}

