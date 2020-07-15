//
//  SearchViewController.swift
//  Alan_Health_Care_Discovery
//
//  Created by Raj Janardhan on 6/30/20.
//  Copyright © 2020 Raj Janardhan. All rights reserved.
//

import UIKit
import AlanSDK

class SearchViewController: UIViewController {
    var names = ["Chad Johnson", "Thomas Edwards", "Stephen Johnson", "Larry Ingles", "Samantha Stewart", "Edward Miller", "Reggie Parker"];
    var curr_data = [String](repeating: "", count: 6);
    @IBOutlet weak var nametf: UITextField!
    var alert: UIAlertController = UIAlertController(title: "Input Name", message: "Please input a name to search", preferredStyle: .alert)
    var tempo = "";
     var dat: [String: [String]] = [:];
    var thisthingy = false
    var button: AlanButton!
    
    var alert2: UIAlertController = UIAlertController(title: "Invalid Name", message: "That name is not a part of the patient list", preferredStyle: .alert)
    override func viewDidLoad() {
        super.viewDidLoad()
        nametf.text = "";
        alert.addAction(UIAlertAction(title:"cancel", style: .default, handler: nil));
        alert2.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil));
        
        let config = AlanConfig(key: "d1dff9e61d903c7ca3bd654b10e6806c2e956eca572e1d8b807a3e2338fdd0dc/stage")
        
        self.button = AlanButton(config: config)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.button)
        let b = NSLayoutConstraint(item: self.button, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -40)
        let r = NSLayoutConstraint(item: self.button, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -20)
        let w = NSLayoutConstraint(item: self.button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        let h = NSLayoutConstraint(item: self.button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        self.view.addConstraints([b, r, w, h])
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleEvent(_:)),
        name:NSNotification.Name(rawValue: "kAlanSDKEventNotification"), object:nil)
        button.setVisualState(["screen": "search_screen"])
        
        button.activate()
        dat["Chad Johnson"] = ["CJ", "Chad Johnson", "3700", "2700", "70/20", "60"];
        dat["Thomas Edwards"] = ["TE", "Thomas Edwards", "3733", "2300", "79/30", "80"];
        dat["Stephen Johnson"] = ["SJ", "Stephen Johnson", "3920", "2400", "20/100"];
        dat["Larry Ingles"] = ["LI", "Larry Ingles", "2830", "4200", "78/60", "95"];
        dat["Samantha Stewart"] = ["SS", "Samantha Stewart", "4333", "7200", "91/45", "72"];
        dat["Edward Miller"] = ["EM", "Edward Miller", "3923", "2333", "87/60", "42"];
        dat["Reggie Parker"] = ["RP", "Reggie Parker", "2333", "4241", "90/23", "82"]
        // Do any additional setup after loading the view.
    }
    
    @objc func handleEvent(_ notification: Notification) {
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
            print(1)
            //print(str["command"])
            print(2)
            if(str["command"] is String &&  str["command"]! as! String == "fix"){
                self.performSegue(withIdentifier: "addingpatients", sender: nil)
            }
            else if(str["command"] is String && str["command"]! as! String == "searchpatient"){
                button.deactivate()
                
                if(nametf.text! == ""){
                    button.playText("There is no name to add")
                }
                else{
                    var supo = false
                    for tem in names{
                        if(tem == nametf.text!){
                            let pvc = ProfileViewController()
                            tempo = nametf.text!;
                            pvc.curr_patient = tempo;
                            //print(nametf.text!)
                            thisthingy = true
                            button.playText("Going to patient")
                            supo = true
                        
                            self.performSegue(withIdentifier: "searchis", sender: nil)
                        }
                    }
                    if(!supo){
                        button.playText("Patient Not Found")
                    }
                }
                button.activate()
            }
            else if(str["screen"] as! String == "thisthang"){
                let ttt = str["command"] as! NSDictionary
                var tttt = ttt["value"] as! String
                for ddd in names{
                    if(ddd == tttt){
                        tempo = tttt
                        thisthingy = true
                        self.performSegue(withIdentifier: "searchis", sender: nil)
                    }
                }
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
            else if(str["screen"] as! String == "movecontacts" || str["screen"] as! String == "allpatients"){
                self.performSegue(withIdentifier: "goingcontacts", sender: nil)
            }
            else if(str["screen"] as! String == "searchingscreen"){
                var temp = str["command"] as! NSDictionary
                nametf.text = temp["value"] as! String
                
                /*
                print(str["screen"])
                print(213)
                print(str["command"])
 */
            }
            else if(str["screen"] as! String == "home"){
                button.playText("Going to the home screen")
                self.performSegue(withIdentifier: "gohome", sender: nil)
            }
        }
        
    }
    
    @IBAction func search(_ sender: Any) {
        if(nametf.text == ""){
            self.present(alert, animated: true);
        }
        
        var t = false;
        var xx = 0
        for i in names{
            
            if(i == nametf.text){
                t = true;
                let pvc = ProfileViewController()
                tempo = nametf.text!;
                pvc.curr_patient = tempo;
                //print(nametf.text!)
                thisthingy = true
               // pvc.updatestuff()
                //pvc.updatestuff(person: tempo)
                self.performSegue(withIdentifier: "searchis", sender: nil)
                //print(pvc.curr_patient)
                //present(pvc, animated: true, completion: nil)
                //self.present(pvc, animated: true);
                //self.shouldPerformSegue(withIdentifier: "searchis", sender: nil)
                //presentingViewController(pvc, animated: true, )
                //switch view controllers and pass info
            }
        }
        if(!t){
            self.present(alert2, animated: true);
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        button.deactivate()
        if(segue.identifier == "searchis"){
            let dc = segue.destination as! ProfileViewController
            print(tempo)
            dc.curr_patient = tempo
            if(tempo == names[names.count-1] && curr_data[0] != ""){
                dc.namelabel = tempo
                dc.IDlabel = curr_data[0]
                dc.WBClabel = curr_data[2]
                dc.RBClabel = curr_data[3]
                dc.BPlabel = curr_data[4]
                dc.HRlabel = curr_data[5]
            }
        }
        
        
    }

}
