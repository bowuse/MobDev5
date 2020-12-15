import UIKit
import Foundation

class DetailsViewController: UIViewController {
    
    var movieDetails: MovieDetails!

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var awardsLabel: UILabel!
    
    @IBOutlet weak var plotLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImageView.image = UIImage(named: movieDetails.poster)
        
        titleLabel.text = movieDetails?.title
        yearLabel.text = movieDetails?.year
        genreLabel.text = movieDetails?.genre
        
        directorLabel.text = movieDetails?.director
        actorsLabel.text = movieDetails?.actors
        
        countryLabel.text = movieDetails?.country
        languageLabel.text = movieDetails?.language
        productionLabel.text = movieDetails?.production
        releasedLabel.text = movieDetails?.released
        runtimeLabel.text = movieDetails?.runtime
        
        ratingLabel.text = movieDetails?.imdbRating
        awardsLabel.text = movieDetails?.awards
        
        plotLabel.text = movieDetails?.plot
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
