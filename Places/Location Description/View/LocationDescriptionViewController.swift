//
//  LocationDescriptionViewController.swift
//  Places
//
//  Created by Shivani Dosajh on 24/02/18.
//

import UIKit

class LocationDescriptionViewController: UIViewController {
    var viewModel :LocationDescriptionViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            
        }
    }
    //MARK: Outlets
    @IBOutlet fileprivate weak var locationNameLabel: UILabel! {
        didSet {
            locationNameLabel.text = viewModel?.placeObject.name
        }
    }
    
    @IBOutlet fileprivate weak var locationImageView: UIImageView! {
        didSet {
            if let urlString = viewModel?.placeObject.imageUrl {
                DispatchQueue.global().async {
                    [weak self] in
                    self?.loadImageFromURL(imageURL: urlString ){ [weak self] (image) in
                        DispatchQueue.main.async {
                            self?.locationImageView.image = image
                            
                        }
                    }
                }
            }
        }
        
    }
    
    @IBOutlet weak var weatherView: UIView! {
        didSet {
            weatherView.dropShadow()
        }
    }
    
    @IBOutlet weak var locationDescriptionLabel: UILabel! {
        didSet {
            locationDescriptionLabel.text = viewModel?.placeObject.description
        }
    }
    
    
    @IBOutlet weak var weatherDescription: UILabel! {
        didSet {
            weatherDescription.text = viewModel?.weatherData?.weatherDescription?.description
            
        }
    }
    
    @IBOutlet weak var tempratureValueLabel: UILabel! {
        didSet {
            tempratureValueLabel.text = String( describing : viewModel?.weatherData?.temprature)
        }
    }
    
    @IBOutlet weak var humidityValueLabel: UILabel! {
        didSet {
            humidityValueLabel.text = "\(String(describing: viewModel?.weatherData?.humidity!))"
        }
    }
    
    @IBOutlet weak var pressureValueLabel: UILabel! {
        didSet {
            pressureValueLabel.text =
            "\(String(describing: viewModel?.weatherData?.pressure))"
            
        }
    }
    
    @IBOutlet weak var showOnMapButton: UIButton!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.model = LocationDescriptionModelImplementation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapShowOnMap(_ sender: UIButton) {
        let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.mapViewControllerNibName) as! MapViewController
        mapViewController.placeObject = viewModel?.placeObject
        show(mapViewController, sender: self)
    }
    
    
    func loadImageFromURL(imageURL: String ,completionHandler : @escaping(UIImage?)->Void) {
        if let url = URL(string: imageURL) {
            do {
                let data = try Data.init(contentsOf: url)
                let image = UIImage(data: data)
                completionHandler(image)
            } catch {
                completionHandler(nil)
            }
        } else {
            completionHandler(nil)
        }
    }
}

extension LocationDescriptionViewController : LocationDescriptionViewDelegate , Loadable {
    
    func refreshViews() {
        pressureValueLabel.text = "\(viewModel?.weatherData?.pressure ?? 0)"
        humidityValueLabel.text = "\(viewModel?.weatherData?.humidity ?? 0 )"
        tempratureValueLabel.text = "\(viewModel?.weatherData?.temprature ?? 0 )"
        weatherDescription.text = viewModel?.weatherData?.weatherDescription?.first?.description
    
        view.setNeedsDisplay()
        view.setNeedsLayout()
      
        if let icon = viewModel?.weatherData?.weatherDescription?.first?.icon {
            
        loadImageFromURL(imageURL: "https://openweathermap.org/img/w/\(icon).png") {
            [weak self] (image) in
            DispatchQueue.main.async {
                self?.weatherIconImageView.image = image
            }
        }
        }
    }
    
    func showLoader() {
        showLoadingView()
    }
    func hideLoader() {
        hideLoadingView()
    }
}

