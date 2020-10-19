//
//  ViewController.swift
//  World Weather
//
//  Created by Sium on 8/9/17.
//  Copyright © 2017 Refat. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UISearchBarDelegate{

    var degree: Double!
    var condition: String!
    var imageURL: String!
    var city: String!
    var exists = true
    var checkExists: Bool!  //variable for checking exists variable
    var latValue: Double!
    var longValue: Double!
    var country: String!
    var prevlatValue: Double!
    var prevlongValue: Double!
    var prevcountry: String!
    var prevcity: String!
    var previmageURL: String!
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var cityNameOutlet: UILabel!
    
    @IBOutlet weak var conditionOutlet: UILabel!
    
    @IBOutlet weak var degreeOutlet: UILabel!
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    @IBOutlet weak var mapButtonOutlet: UIButton!
    
    @IBOutlet weak var prevSearched: UILabel!
    
    @IBOutlet weak var prevCityNameOutlet: UILabel!
    
    @IBOutlet weak var prevMapButtonOutlet: UIButton!

    
    @IBOutlet weak var prevConditionOutlet: UILabel!
    
    @IBOutlet weak var prevDegreeOutlet: UILabel!
    
    @IBOutlet weak var prevImageOutlet: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBarOutlet.delegate = self
        exists = true
        
        conditionOutlet.isHidden = true
        degreeOutlet.isHidden = true
        imageViewOutlet.isHidden = true
        mapButtonOutlet.isHidden = true
        
        //navigation color
        navigationController?.navigationBar.barTintColor = UIColor.brown
        checkExists = exists
        
        //hiding condition for 1st time ever app launching
        if self.prevConditionOutlet.text == "Condition" {
            prevSearched.isHidden = true
            prevCityNameOutlet.isHidden = true
            prevConditionOutlet.isHidden = true
            prevDegreeOutlet.isHidden = true
            prevImageOutlet.isHidden = true
            prevMapButtonOutlet.isHidden = true
        }
        else {
            prevSearched.isHidden = false
            prevCityNameOutlet.isHidden = false
            prevConditionOutlet.isHidden = false
            prevDegreeOutlet.isHidden = false
            prevImageOutlet.isHidden = false
            prevMapButtonOutlet.isHidden = false
        }
        
        //for map button
        mapButtonOutlet.layer.cornerRadius = 5
        mapButtonOutlet.layer.borderWidth = 3
        mapButtonOutlet.layer.borderColor = UIColor.white.cgColor
        //for prev map button
        prevMapButtonOutlet.layer.cornerRadius = 5
        prevMapButtonOutlet.layer.borderWidth = 3
        prevMapButtonOutlet.layer.borderColor = UIColor.white.cgColor
    }

    //following code on clicking search from keyboard
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        let urlRequest = URLRequest(url: URL(string: "http://api.apixu.com/v1/current.json?key=79b782d6fa984e2d90192815170908&q=\(searchBarOutlet.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    //retriving Condition, Image and Temp
                    if let current = json["current"] as? [String : AnyObject] {
                        if let temp = current["temp_c"] as? Double {
                            self.degree = temp
                        }
                        if let condition = current["condition"] as? [String : AnyObject]{
                            self.condition = condition["text"] as! String
                            let icon = condition["icon"] as! String
                            self.imageURL = "http:\(icon)"
                        }
                    }
                    //retriving city name
                    if let location = json["location"] as? [String : AnyObject]{
                        self.city = location["name"] as! String
                        if let lattitude = location["lat"] as? Double {
                            self.latValue = lattitude
                        }
                        if let longitude = location["lon"] as? Double {
                            self.longValue = longitude
                        }
                        self.country = location["country"] as! String

                    }
                   
                    if let _ = json["error"] {
                        self.exists = false
                    }
                    
                    // setting label texts
                    DispatchQueue.main.async {
                        if self.exists{
                            self.checkExists = self.exists
                            self.cityNameOutlet.text = self.city
                            self.conditionOutlet.text = self.condition
                            self.degreeOutlet.text = "\(self.degree.description)℃"
                            self.imageViewOutlet.downloadImage(from: self.imageURL)
                            
                            self.conditionOutlet.isHidden = false
                            self.degreeOutlet.isHidden = false
                            self.imageViewOutlet.isHidden = false
                            self.mapButtonOutlet.isHidden = false
                        } else {
                            self.checkExists = self.exists
                            
                            self.cityNameOutlet.text = "No match found."
                            self.conditionOutlet.isHidden = true
                            self.degreeOutlet.isHidden = true
                            self.imageViewOutlet.isHidden = true
                            self.mapButtonOutlet.isHidden = true
                            self.exists = true
                        }
                            
                    }
                    
                    
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
            }
        }
        //For instant Showing previous data
        if self.checkExists && self.cityNameOutlet.text != "Enter a City name" {

            UserDefaults.standard.set(self.cityNameOutlet.text, forKey: "city")
            UserDefaults.standard.set(self.conditionOutlet.text, forKey: "condition")
            UserDefaults.standard.set(self.degreeOutlet.text, forKey: "degree")
            UserDefaults.standard.set(self.imageURL, forKey: "image")
        
            if let cityName = UserDefaults.standard.object(forKey: "city") as? String {
                self.prevCityNameOutlet.text = cityName
            }
            if let condition1 = UserDefaults.standard.object(forKey: "condition") as? String {
                    self.prevConditionOutlet.text = condition1
                }
            if let degree1 = UserDefaults.standard.object(forKey: "degree") as? String {
                self.prevDegreeOutlet.text = degree1
            }
            if let image = UserDefaults.standard.object(forKey: "image") as? String {
                self.previmageURL = image
                self.prevImageOutlet.downloadImage(from: previmageURL)
            }
            
            //saving data to show map on clicking map button from prev section
            self.prevcity = city
            self.prevcountry = country
            self.prevlatValue = latValue
            self.prevlongValue = longValue
            UserDefaults.standard.set(self.prevcity, forKey: "prevcity")
            UserDefaults.standard.set(self.prevcountry, forKey: "prevcountry")
            UserDefaults.standard.set(self.prevlongValue, forKey: "long")
            UserDefaults.standard.set(self.prevlatValue, forKey: "lat")
            if let pCity = UserDefaults.standard.object(forKey: "prevcity") as? String {
                self.prevcity = pCity
            }
            if let pCountry = UserDefaults.standard.object(forKey: "prevcountry") as? String {
                self.prevcountry = pCountry
            }
            if let pLat = UserDefaults.standard.object(forKey: "lat") as? Double {
                self.prevlatValue = pLat
            }
            if let pLong = UserDefaults.standard.object(forKey: "long") as? Double {
                self.prevlongValue = pLong
            }

        }
        
        //conditions if false name is entered by user
        if cityNameOutlet.text != "No match found." && conditionOutlet.text != "Condition" {
            prevSearched.isHidden = false
            prevCityNameOutlet.isHidden = false
            prevConditionOutlet.isHidden = false
            prevDegreeOutlet.isHidden = false
            prevImageOutlet.isHidden = false
            prevMapButtonOutlet.isHidden = false
        }
        
        task.resume()
    }
    
    
    //hide key board in search bar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //saving data
    override func viewDidAppear(_ animated: Bool) {
        if self.checkExists {
            
            if let cityName = UserDefaults.standard.object(forKey: "city") as? String {
                
                self.prevCityNameOutlet.text = cityName
            }
            
            if let condition1 = UserDefaults.standard.object(forKey: "condition") as? String {
                
                self.prevConditionOutlet.text = condition1
            }
            
            if let degree1 = UserDefaults.standard.object(forKey: "degree") as? String {
                
                self.prevDegreeOutlet.text = degree1
            }
            if let image = UserDefaults.standard.object(forKey: "image") as? String {
                self.previmageURL = image
                self.prevImageOutlet.downloadImage(from: previmageURL)
            }
            if let pCity = UserDefaults.standard.object(forKey: "prevcity") as? String {
                self.prevcity = pCity
            }
            if let pCountry = UserDefaults.standard.object(forKey: "prevcountry") as? String {
                self.prevcountry = pCountry
            }
            if let pLat = UserDefaults.standard.object(forKey: "lat") as? Double {
                self.prevlatValue = pLat
            }
            if let pLong = UserDefaults.standard.object(forKey: "long") as? Double {
                self.prevlongValue = pLong
            }

            
        }
        
        if self.prevConditionOutlet.text == "Condition" {
            prevSearched.isHidden = true
            prevCityNameOutlet.isHidden = true
            prevConditionOutlet.isHidden = true
            prevDegreeOutlet.isHidden = true
            prevImageOutlet.isHidden = true
            prevMapButtonOutlet.isHidden = true
        }
        else {
            prevSearched.isHidden = false
            prevCityNameOutlet.isHidden = false
            prevConditionOutlet.isHidden = false
            prevDegreeOutlet.isHidden = false
            prevImageOutlet.isHidden = false
            prevMapButtonOutlet.isHidden = false
        }

        
    }
    
    
    
    @IBAction func mapButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "map", sender: nil)
    }
    
    @IBAction func map2ButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "map2", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier{
                case "map":
                    let mapController = segue.destination as! MapViewController
                    mapController.latiValue = latValue
                    mapController.longiValue = longValue
                    mapController.mapCountry = country
                    mapController.mapCity = city
                case "map2":
                    let map2Controller = segue.destination as! MapViewController
                    map2Controller.latiValue = prevlatValue
                    map2Controller.longiValue = prevlongValue
                    map2Controller.mapCountry = prevcountry
                    map2Controller.mapCity = prevcity
            default:
                break

            }
        }
    }
    
    
}


extension UIImageView {
    
    func downloadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        
        task.resume()
    }
    
}



