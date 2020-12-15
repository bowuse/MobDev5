import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var typeTextBox: UITextField!
    @IBOutlet weak var yearTextBox: UITextField!
    
    @IBAction func addMovie(_ sender: UIButton) {
        var newMovie = Movie()
        newMovie.title = titleTextBox.text!
        newMovie.year = yearTextBox.text!
        newMovie.type = typeTextBox.text!
        ViewController.addMovie(movie: newMovie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearTextBox.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if textField == yearTextBox {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }

}
