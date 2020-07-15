//
//  ViewController.swift
//  Alan_Health_Care_Discovery
//
//  Created by Raj Janardhan on 6/30/20.
//  Copyright © 2020 Raj Janardhan. All rights reserved.
//

import UIKit
import AlanSDK
import NotificationCenter

class ViewController: UIViewController {
    fileprivate var button: AlanButton!
    var curr_patient = ""
    //fileprivate var text: AlanText!
    var names = ["Chad Johnson", "Thomas Edwards", "Stephen Johnson", "Larry Ingles", "Samantha Stewart", "Edward Miller", "Reggie Parker"];
    
    var alancurr = ""
    
    var curr_data = [String](repeating: "", count: 6)
    @IBOutlet weak var findpatients: UIButton!
    @IBOutlet weak var addpatient: UIButton!
    @IBOutlet weak var viewpatients: UIButton!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.button.playText("Hello")
        button.deactivate()
        if(segue.identifier == "totable"){
            //let dc = segue.destination as! ProfileViewController
           // print(tempo)
            //dc.curr_patient = tempo
            //dc.curr_patient = issa;
            print(curr_patient)
            let dc = segue.destination as! ContactsViewController
            button.setVisualState(["screen": "contacts"])
            if(curr_patient != ""){
                dc.names.append(curr_patient)
                
                curr_patient = ""
                dc.curr_data = curr_data
            }
        }
        if(segue.identifier == "tosearch"){
            let dc = segue.destination as! SearchViewController
            if(curr_patient != ""){
                dc.names.append(curr_patient)
                dc.curr_data = curr_data
            }
            print(1)
            button.setVisualState(["screen": "search_screen"])
        }
        if(segue.identifier == "gotoprofile"){
            let dc = segue.destination as! ProfileViewController
            dc.curr_patient = alancurr
        }
        
        
    }
    @objc func handleEvent(_ notification: Notification) {
       // button.deactivate()
       guard let userInfo = notification.userInfo,
       let jsonString = userInfo["jsonString"] as? String,
       let data = jsonString.data(using: .utf8),
       let obj = try? JSONSerialization.jsonObject(with: data, options: []),
       let json = obj as? [String: Any]
       else { return }
       print(21)
       //print(json)
       //print(json["data"])
        if(json["data"] != nil){
            //print(json["data"].unsafelyUnwrapped)
            var str = json["data"].unsafelyUnwrapped as! NSDictionary
           //print(str["command"])
            if(str["command"]! != nil){
                //print(str["command"])
               // print(str["screen"])
                //do{
                if(str["command"] is NSDictionary){
                    
                }
                else{
                    if(str["command"]! as! String == "fix"){
                        self.performSegue(withIdentifier: "addingpatients", sender: nil)
                    }
                }

                                
    
            }
            else if(str["screen"] as! String == "Heart_Rate"){
                print(str["command"])
            }
            if(str["screen"] as! String == "thisthang"){
                //print(str["command"])
                var thistime = str["command"] as! NSDictionary
                var thistime2 = thistime["value"] as! NSString
                for checkname in names{
                    print(37)
                    if(checkname == thistime2 as String){
                        alancurr = thistime2 as String
                        self.performSegue(withIdentifier: "gotoprofile", sender: nil)
                    }
                }
            }
            else if(str["screen"] as! String == "movingtodata"){
                var thistime = str["command"] as! NSDictionary
                alancurr = thistime["value"] as! String
                self.performSegue(withIdentifier: "gotoprofile", sender: nil)
            }
            if(str["screen"] as! String == "movecontacts" || str["screen"] as! String == "allpatients"){
                self.performSegue(withIdentifier: "totable", sender: nil)
            }
            else if(str["screen"] as! String == "BP" || str["screen"] as! String == "ID"){
                button.playText("Please set a current patient")
            }
            else if(str["screen"] as! String == "WBC" || str["screen"] as! String == "RBC"){
                button.playText("Please set a current patient")
            }
            else if(str["screen"] as! String == "Heart_Rate"){
                button.playText("Please set a current patient")
            }
            else if(str["screen"] as! String == "search_screen"){
                self.performSegue(withIdentifier: "isasearch", sender: nil)
            }
            else if(str["screen"] as! String == ""){
                button.playText("You are already at the home page")
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let config = AlanConfig(key: "d1dff9e61d903c7ca3bd654b10e6806c2e956eca572e1d8b807a3e2338fdd0dc/stage")
        
        self.button = AlanButton(config: config)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.button)
        let b = NSLayoutConstraint(item: self.button, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -40)
        let r = NSLayoutConstraint(item: self.button, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -20)
        let w = NSLayoutConstraint(item: self.button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        let h = NSLayoutConstraint(item: self.button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        self.view.addConstraints([b, r, w, h])
        button.activate()
        button.setVisualState(["screen": "your_data"])
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleEvent(_:)),
        name:NSNotification.Name(rawValue: "kAlanSDKEventNotification"), object:nil)
        //self.button.playText("Hello")
        //self.button = AlanButton(config: config)
        //self.button.translatesAutoresizingMaskIntoConstraints = false
        //self.view.addSubview(self.button)
        //self.view.bringSubviewToFront(self.button)
        //let b = NSLayoutConstraint(item: self.button, attribute: .bottom, relatedBy: .equal,
        //toItem: self.view, attribute: .bottom, multiplier: 1, constant: -40)
        //toItem: self.view, attribute: .right, multiplier: 1, constant: -20)
       // toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        //let h = NSLayoutConstraint(item: self.button, attribute: .height, relatedBy: .equal,
        //toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        //self.view.addConstraints([b, r, w, h])
        

        findpatients.layer.cornerRadius = 10;
        addpatient.layer.cornerRadius = 10;
        viewpatients.layer.cornerRadius = 10;
        // Do any additional setup after loading the view.
    }

    fileprivate func setupAlan() {
        
        // Define project key
        //let config = AlanConfig(key: "d1dff9e61d903c7ca3bd654b10e6806c2e956eca572e1d8b807a3e2338fdd0dc/prod")
        /*
        //  Init Alan button
        self.button = AlanButton(config: config)
        
        // Init Alan text panel
        self.text = AlanText(frame: CGRect.zero)
        
        // Add button and text to the view
        self.view.addSubview(self.button)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.text)
        self.text.translatesAutoresizingMaskIntoConstraints = false
        
        // Aling button and text on the view
        let views = ["button" : self.button!, "text" : self.text!]
        let verticalButton = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0@299)-[button(64)]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
        let verticalText = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0@299)-[text(64)]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
        let horizontalButton = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0@299)-[button(64)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
        let horizontalText = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[text]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
        self.view.addConstraints(verticalButton + verticalText + horizontalButton + horizontalText)
 */
    }
}

