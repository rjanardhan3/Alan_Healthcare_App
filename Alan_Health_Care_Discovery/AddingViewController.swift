//
//  AddingViewController.swift
//  Alan_Health_Care_Discovery
//
//  Created by Raj Janardhan on 6/30/20.
//  Copyright © 2020 Raj Janardhan. All rights reserved.
//

import UIKit
import AlanSDK

class AddingViewController: UIViewController {
    var button: AlanButton!
    func isitanInt(value: String) -> Bool{
        if(value == ""){
            return true
        }
        let myInt1 = Int(value) ?? nil
        if(myInt1 != nil){
            return true
        }
        
        return false
    }
    @IBOutlet weak var RBCtf: UITextField!
    @IBOutlet weak var heartratetf: UITextField!
    @IBOutlet weak var idtf: UITextField!
    //@IBOutlet weak var WBCtf: UITextField!
    //@IBOutlet weak var BPtf: UITextField!
    @IBOutlet weak var BPtf: UITextField!
    @IBOutlet weak var WBCtf: UITextField!
    @IBOutlet weak var nametf: UITextField!
    var xto = false
    var alert:UIAlertController = UIAlertController(title: "Missing Name", message: "You cannot create a contact without a name", preferredStyle: .alert);
    
    var tempoo: NSDictionary = [:];
    
    var alert2:UIAlertController = UIAlertController(title: "Missing ID", message: "You cannot create a contact without an ID", preferredStyle: .alert);
    
    var alert3:UIAlertController = UIAlertController(title: "Missing Components", message: "You are missing some nonessential information. Would you like to add the data?", preferredStyle: .alert);
    
    var alert4: UIAlertController = UIAlertController(title: "Same Name and ID", message: "You already have a contact with the same name and ID", preferredStyle: .alert);
    var alert5: UIAlertController = UIAlertController(title: "Invalid Data", message: "Your heart rate, blood white blood cell count, and red blood cell count must be numbers", preferredStyle: .alert)
    
    var dat: [String: [String]] = [:];
    
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
            //print("je;;")
            //print(str)
            print(str["screen"] as! NSString)
            //print("chicken")
            
            
            
            if(str["command"] is String == false){
                tempoo = str["command"] as! NSDictionary
            }
            if(str["command"] is String && str["command"]! as! String == "fix"){
                //self.performSegue(withIdentifier: "addingpatients", sender: nil)
                if(nametf.text == ""){
                    //self.present(alert, animated: true)
                    button.playText("You must have a name to create a patient")
                           
                }
                else if(idtf.text == ""){
                    button.playText("You must have an ID to create a patient")
                    
                }
                else if(dat[nametf.text ?? ""]?[0] == idtf.text){
                    button.playText("You already have a contact with that name and ID")
                }
                else if((!isitanInt(value: WBCtf.text!) || !isitanInt(value: RBCtf.text!)) || (!isitanInt(value: heartratetf.text!))){
                    button.playText("Your blood pressure, White blood cell count, and red blood cell count must be numbers");
                }
                else{
                    xto = true
                    button.playText("Patient Successfully Added")
                    self.performSegue(withIdentifier: "searchis", sender: nil)
                }
            }
            else if(str["screen"]! as! String == "Heart_Rate"){
                let thistemp = tempoo["number"] as! NSNumber
                heartratetf.text = thistemp.stringValue
            }
            else if(str["screen"] as! String == "WBC"){
                let thistemp = tempoo["number"] as! NSNumber
                WBCtf.text = thistemp.stringValue
            }
            else if(str["screen"] as! String == "RBC"){
                let thistemp = tempoo["number"] as! NSNumber
                RBCtf.text = thistemp.stringValue
            }
            else if(str["screen"] as! String == "BP"){
                //let thistemp = tempoo["number"] as! NSString
             //   BPtf.text = thistemp as String
                
            }
            else if(str["screen"] as! String == "name"){
               // let thistemp = tempoo["number"] as! NSString
                print(tempoo)
                nametf.text = tempoo["value"] as! String
            }
            else if(str["screen"] as! String == "movecontacts" || str["screen"] as! String == "allpatients"){
                self.performSegue(withIdentifier: "remembercontact", sender: nil)
            }
            else if(str["screen"] as! String == "home"){
                self.performSegue(withIdentifier: "gohome", sender: nil)
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleEvent(_:)), name:NSNotification.Name(rawValue: "kAlanSDKEventNotification"), object:nil)
        button.setVisualState(["screen": "adding_screen"])
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        alert2.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        
        button.activate()
        
        dat["Chad Johnson"] = ["CJ", "Chad Johnson", "3700", "2700", "70/20", "60"];
        dat["Thomas Edwards"] = ["TE", "Thomas Edwards", "3733", "2300", "79/30", "80"];
        dat["Stephen Johnson"] = ["SJ", "Stephen Johnson", "3920", "2400", "20/100"];
        dat["Larry Ingles"] = ["LI", "Larry Ingles", "2830", "4200", "78/60", "95"];
        dat["Samantha Stewart"] = ["SS", "Samantha Stewart", "4333", "7200", "91/45", "72"];
        dat["Edward Miller"] = ["EM", "Edward Miller", "3923", "2333", "87/60", "42"];
        dat["Reggie Parker"] = ["RP", "Reggie Parker", "2333", "4241", "90/23", "82"]
        
        alert3.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert5.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        alert4.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                //Move to next VC and transfer data
            let searchvc = SearchViewController();
            searchvc.names.append(self.nametf.text!);
            }))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func creater(_ sender: Any) {
        print(isitanInt(value: "27"))
        print(isitanInt(value: "asdf"))
        if(nametf.text == ""){
            self.present(alert, animated: true)
            
        }
        else if(idtf.text == ""){
            self.present(alert2, animated: true);
        }
        /*
        else if((BPtf.text! == "" || WBCtf.text! == "") || (RBCtf.text! == "" || heartratetf.text! == "")){
            self.present(alert3, animated: true);
        }
       
 */
        else if((!isitanInt(value: WBCtf.text!) || !isitanInt(value: RBCtf.text!)) || (!isitanInt(value: heartratetf.text!))){
            print(isitanInt(value: WBCtf.text!))
            print(isitanInt(value: RBCtf.text!))
            print(isitanInt(value: heartratetf.text!))
            self.present(alert5, animated: true)
        }
        else{
            //transition to next VC
            let searchvc = SearchViewController()
            
            searchvc.names.append(nametf.text!);
            /*
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let sb = storyboard.instantiateViewController(identifier: "Profile View Controller") as! ProfileViewController
            sb.dat[nametf.text!] = [idtf.text!, nametf.text!, WBCtf.text!, RBCtf.text!, BPtf.text!, heartratetf.text!]
            present(sb, animated: true, completion: nil);
            let sb2 = storyboard.instantiateViewController(identifier: "Search View Controller") as! SearchViewController
            sb2.names.append(nametf.text!)
            present(sb2, animated: true, completion: nil);
            */
            xto = true
            self.performSegue(withIdentifier: "searchis", sender: nil)
            //performSegue(withIdentifier: "searchis", sender: nil)
            print(43)
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
            //print(tempo)
            dc.dat[nametf.text!] = [idtf.text!, nametf.text!, WBCtf.text!, RBCtf.text!, BPtf.text!, heartratetf.text!]
            let tt = nametf.text!
            dc.curr_patient = nametf.text!
            //print(dc.name.text!);
            //dc.name = UILabel()
           // dc.name.text = "hi"
            dc.namelabel = nametf.text!
            print(tt)
            //dc.ID.text! = idtf.text!
            dc.IDlabel = idtf.text!
            if(BPtf.text! == ""){
                dc.BPlabel = "Not Available"
                //dc.BP.text! = "Not Available"
            }
            else{
                dc.BPlabel = BPtf.text!
                //dc.BP.text! = BPtf.text!
            }
            if(heartratetf.text! == ""){
                dc.HRlabel = "Not Available"
               // dc.HR.text! = "Not Available"
            }
            else{
                dc.HRlabel = heartratetf.text!
                //dc.HR.text! = heartratetf!.text!
            }
            if(WBCtf.text! == ""){
                dc.WBClabel = "Not Available"
                //dc.WBC.text! = "Not Available"
            }
            else{
                dc.WBClabel = WBCtf.text!
                //dc.WBC.text! = WBCtf.text!
            }
            if(RBCtf.text! == ""){
                dc.RBClabel = "Not Available"
                //dc.RBC.text! = "Not Available"
            }
            else{
                dc.RBClabel = RBCtf.text!
                //dc.RBC.text! = RBCtf.text!
            }
            
        }
        
        
    }

}
