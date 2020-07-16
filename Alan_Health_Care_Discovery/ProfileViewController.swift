//
//  ProfileViewController.swift
//  Alan_Health_Care_Discovery
//
//  Created by Raj Janardhan on 6/30/20.
//  Copyright © 2020 Raj Janardhan. All rights reserved.
//

import UIKit
import AlanSDK

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

class ProfileViewController: UIViewController {
    var button: AlanButton!
    var currpatient: String!
    
    
    
    var bpbool = false
    var RBCbool = false
    var WBCbool = false
    var HRbool = false
    var IDbool = false
    var cc = 0
    
    @objc func fire(){
        if(cc > 5){
            return
        }
        else if(bpbool){
            cc += 1
            BP.isHighlighted = false
            bpbool = false
            HR.isHighlighted = true
            HR.highlightedTextColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
            HRbool = true
        }
        else if(RBCbool){
            cc += 1
            IDbool = true
            ID.isHighlighted = true
            ID.highlightedTextColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
            RBC.isHighlighted = false
            RBCbool = false
        }
        else if(WBCbool){
            cc += 1
            RBC.isHighlighted = true
            RBC.highlightedTextColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
            RBCbool = true
            WBC.isHighlighted = false
            WBCbool = false
        }
        else if(HRbool){
            cc += 1
            WBC.isHighlighted = true
            WBC.highlightedTextColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
            HRbool = false
            HR.isHighlighted = false
            WBCbool = true
        }
        else if(IDbool){
            cc += 1
            IDbool = false
            ID.isHighlighted = false
        }
        /*
        switch tf{
            case("bp"):
                BP.isHighlighted = false
                break
            case("RBC"):
                RBC.isHighlighted = false
                break
            case("WBC"):
                WBC.isHighlighted = false
                break
            case("HR"):
                HR.isHighlighted = false
                break
            case("ID"):
                ID.isHighlighted = false
                break
            default:
                break
        }*/
    }
    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        button.deactivate()
        if(segue.identifier == "tohome"){
            let dc = segue.destination as! ViewController
            //dc.curr_patient = name.text!
            
            if(checko){
                print(72)
                dc.curr_patient = name.text!
                dc.curr_data[0] = IDtf.text!
                dc.curr_data[1] = name.text!
                dc.curr_data[2] = WBCtf.text!
                dc.curr_data[3] = RBCtf.text!
                dc.curr_data[4] = bptf.text!
                dc.curr_data[5] = HRtf.text!
            }
        }
        
        
        
    }
    
    @objc func handleEvent(_ notification: Notification) {
       guard let userInfo = notification.userInfo,
       let jsonString = userInfo["jsonString"] as? String,
       let data = jsonString.data(using: .utf8),
       let obj = try? JSONSerialization.jsonObject(with: data, options: []),
       let json = obj as? [String: Any]
       else { return }
       print(21)
       print(json)
       //print(json["data"])
        if(json["data"] != nil){
            //print(json["data"].unsafelyUnwrapped)
            var str = json["data"].unsafelyUnwrapped as! NSDictionary
            //print(str["command"])
            if(str["command"] is String && str["command"]! as! String == "fix"){
                self.performSegue(withIdentifier: "addingpatients", sender: nil)
            }
            if(str["screen"] as! String == "thisthang"){
                let teeso = str["command"] as! NSDictionary
                currpatient = teeso["value"] as? String
                name.text = currpatient
                RBC.text = "RBC: " + (dat[currpatient]?[3])!
                WBC.text = "WBC: " + (dat[currpatient]?[2])!
                ID.text = "ID: " + (dat[currpatient]?[0])!
                BP.text = "BP: " + dat[currpatient]![4]
                HR.text = "HR: " + dat[currpatient]![5]
            }
            else if(str["screen"] as! String == "Heart_Rate"){
                //print(str["command"])
                var temp = str["command"] as! NSDictionary
                var temp2 = temp["value"] as! String
                if(!x){
                    HR.text = "HR: " + temp2
                    dat[name.text!]![5] = temp2
                }
                else{
                    HRtf.text = temp2
                }
                
            }
            else if(str["screen"] as! String == "WBC"){
                var temp = str["command"] as! NSDictionary
                var temp2 = temp["value"] as! String
                if(!x){
                    WBC.text = "WBC: " + temp2
                    dat[name.text!]![2] = temp2
                }
                else{
                    WBCtf.text = temp2
                }
                
            }
            else if(str["screen"] as! String == "healthyRBC" || str["screen"] as! String == "healthyBP"){
                button.callProjectApi("setcurrpatient", withData: ["value": name.text!]){(_, _) in
                
                }
            }
            else if(str["screen"] as! String == "setName" || str["screen"] as! String == "healthyHR"){
               // button.setVisualState(["curr": name.text!])
                //button.setVisualState(["screen": name.text!])
                button.callProjectApi("setcurrpatient", withData: ["value": name.text!]){(_, _) in
 
                }
            }
            else if(str["screen"] as! String == "RBC"){
                var temp = str["command"] as! NSDictionary
                var temp2 = temp["value"] as! String
                if(!x){
                    RBC.text = "RBC: " + temp2
                    dat[name.text!]![3] = temp2
                }
                else{
                    RBCtf.text = temp2
                }
            }
            else if(str["screen"] as! String == "BP"){
                //print(str["command"])
                let tem = str["command"] as! String
                if(!x){
                    BP.text = "BP: " + tem
                }
                else{
                    bptf.text = tem
                }
                //print(str["screen"])
                //var temp = str["command"] as! NSDictionary
                //var temp2 = temp["value"] as! String
                //BP.text = "BP: " + temp2
                //dat[name.text!]![4] = temp2
                
            }
            else if(str["screen"] as! String == "ID"){
                var temp = str["command"] as! NSDictionary
                var temp2 = temp["value"] as! String
                if(!x){
                    ID.text = "ID: " + temp2
                    dat[name.text!]![0] = temp2
                }
                else{
                    IDtf.text = temp2
                }
                
            }
            else if(str["screen"] as! String == "home"){
                self.performSegue(withIdentifier: "gohome", sender: nil)
            }
            else if(str["screen"] as! String == "movecontacts" || str["screen"] as! String == "allpatients"){
                self.performSegue(withIdentifier: "movingcontacts", sender: nil)
            }
            else if(str["screen"] as! String == "searchscreen"){
                print(3)
                self.performSegue(withIdentifier: "thesearchis", sender: nil)
            }
            else if(str["screen"] as! String == "hoverover"){
                if(!x){
                    let tem = str["command"] as! NSDictionary
                    print(235)
                    print(str["command"])
                    print(235)
                    
                    if(tem["value"] as! String != name.text! || !IDtf.isHidden){
                        var tem2 = tem["value"] as! String
                        IDtf.isHidden = true
                        WBCtf.isHidden = true
                        RBCtf.isHidden = true
                        bptf.isHidden = true
                        HRtf.isHidden = true
                        ID.text = "ID: " + dat[tem2]![0]
                        WBC.text = "WBC: " + dat[tem2]![2]
                        RBC.text = "RBC: " + dat[tem2]![3]
                        BP.text = "BP: " + dat[tem2]![4]
                        HR.text = "HR: " + dat[tem2]![5]
                    }
                    
                    
                    BP.isHighlighted = true
                    BP.highlightedTextColor = #colorLiteral(red: 0.9334612489, green: 1, blue: 0, alpha: 1)
                    bpbool = true
                    var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
                    //timer.fire()
                    //sleep(1)
                    var str = dat[name.text!]![4]
                    //button.playText("The patient's blood pressure is " + str)
                    
                    //BP.isHighlighted = false
                    /*
                    HR.isHighlighted = true
                    HR.highlightedTextColor = #colorLiteral(red: 0.9467340112, green: 1, blue: 0, alpha: 1)
 */
                    //sleep(1)
                    str = dat[name.text!]![5]
                    //button.playText("The patient's heart rate is " + str)
                    //HR.isHighlighted = false
                    //WBC.isHighlighted = true
                    //WBC.highlightedTextColor = #colorLiteral(red: 0.8686456084, green: 1, blue: 0, alpha: 1)
                    //sleep(1)
                    str = dat[name.text!]![2]
                   // button.playText("The patient's white blood cell count is " + str)
                    //WBC.isHighlighted = false
                    //RBC.isHighlighted = true
                    //RBC.highlightedTextColor = #colorLiteral(red: 0.8024414778, green: 1, blue: 0, alpha: 1)
                    //sleep(1)
                    str = dat[name.text!]![3]
                   // button.playText("The patient's red blood cell count is " + str)
                    //RBC.isHighlighted = false
                    //ID.isHighlighted = true
                   // ID.highlightedTextColor = #colorLiteral(red: 1, green: 0.9659166932, blue: 0.1538560092, alpha: 1)
                    //sleep(1)
                    str = dat[name.text!]![0]
                  //  button.playText("The patient's ID is " + str)
                    
                   // HR.isHighlighted = true
                    //HR.highlightedTextColor = #colorLiteral(red: 0.9355748892, green: 0.8926454186, blue: 0.3701760769, alpha: 1)
                    //sleep(1)
                   // HR.isHighlighted = false
                    
                }
                //button.setVisualState(["screen": "profile_screen"])
                
            }
            else if(str["screen"] as! String == "updateData"){
                dat["Chad Johnson"] = ["CJ", "Chad Johnson", "3700", "2700", "70/20", "60"];
                dat["Thomas Edwards"] = ["TE", "Thomas Edwards", "3733", "2300", "79/30", "80"];
                dat["Stephen Johnson"] = ["SJ", "Stephen Johnson", "3920", "2400", "20/100", "40"];
                dat["Larry Ingles"] = ["LI", "Larry Ingles", "2830", "4200", "78/60", "95"];
                dat["Samantha Stewart"] = ["SS", "Samantha Stewart", "4333", "7200", "91/45", "72"];
                dat["Edward Miller"] = ["EM", "Edward Miller", "3923", "2333", "87/60", "42"];
                dat["Reggie Parker"] = ["RP", "Reggie Parker", "2333", "4241", "90/23", "82"]
                if(!x){
                    print(currpatient as Any)
                    IDtf.isHidden = false
                    IDtf.text = dat[name.text!]![0];
                    RBCtf.isHidden = false
                    RBCtf.text = dat[name.text!]![3];
                    WBCtf.isHidden = false
                    WBCtf.text = dat[name.text!]![2]
                    HRtf.isHidden = false
                    HRtf.text = dat[name.text!]![5]
                    bptf.isHidden = false
                    bptf.text = dat[name.text!]![4]
                    x = true
                    
                    ID.text? = "ID: "
                    RBC.text? = "RBC: "
                    WBC.text? = "WBC: "
                    HR.text? = "HR: "
                    BP.text? = "BP: "
                    
                    
                    butt.setTitle("Confirm Updates", for: .normal)
                }
                else{
                    if(IDtf.text == ""){
                        button.playText("You need an ID to update the data")
                    }
                    else{
                        button.playText("Patient information updated")
                        ID.text = "ID: " + IDtf.text!
                        IDtf.isHidden = true
                        if(RBCtf.text == ""){
                            RBC.text = "RBC: Not Available"
                        }
                        else{
                            RBC.text = "RBC: " + RBCtf.text!
                        }
                        RBCtf.isHidden = true
                        RBC.isHidden = false
                        if(WBCtf.text == ""){
                            WBC.text = "WBC: Not Available"
                        }
                        else{
                            WBC.text = "WBC: " + WBCtf.text!
                        }
                        WBCtf.isHidden = true
                        WBC.isHidden = false
                        if(bptf.text == ""){
                            BP.text = "BP: Not Available"
                        }
                        else{
                            BP.text = "BP: " + bptf.text!
                        }
                        bptf.isHidden = true
                        BP.isHidden = false
                        if(HRtf.text == ""){
                            HR.text = "HR: Not Available"
                        }
                        else{
                            HR.text = "HR: " + HRtf.text!
                        }
                        HRtf.isHidden = true
                        HR.isHidden = false
                    }
                }
            }
        }
        
    }
    
    
    var checko = false
    @IBOutlet weak var ID: UILabel!
    var IDlabel: String = ""
    //ID.text! = ""
    @IBOutlet weak var RBC: UILabel!
    var RBClabel: String = ""
    //RBC.text! = ""
    @IBOutlet weak var HR: UILabel!
    var HRlabel: String = ""
    //HR.text! = ""
    @IBOutlet weak var WBC: UILabel!
    var WBClabel: String = ""
    //WBC.text! = ""
    @IBOutlet weak var BP: UILabel!
    var BPlabel: String = ""
    //BP.text! = ""
    @IBOutlet weak var name: UILabel!
    var namelabel: String = ""
    //name.text! = ""
    var curr_patient = String();
    /*
     
     {id: 'CJ', title: 'Chad Johnson', WBC: 3700, RBC: 2700, BP: "70/20", HeartRate: 60},
     {id: 'TE', title: 'Thomas Edwards', WBC: 3733, RBC: 2300, BP: "79/30", HeartRate: 80},
     {id: 'SJ', title: 'Stephen Johnson', WBC: 3920, RBC: 2400, BP: "20/100", HeartRate: 40},
     {id: 'LI', title: 'Larry Ingles', WBC: 2830, RBC: 4200, BP: "78/60", HeartRate: 95},
     {id: 'SS', title: 'Samantha Stewart', WBC: 4333, RBC: 7200, BP: "91/45", HeartRate: 72},
     {id: 'EM', title: 'Edward Miller', WBC: 3923, RBC: 2333, BP: '87/60', HeartRate: 42},
     {id: 'RP', title: 'Reggie Parker', WBC: 2333, RBC: 4241, BP: '90/23', HeartRate: 82}
     */
    var dat: [String: [String]] = [:];
   
    @IBOutlet weak var IDtf: UITextField!
    @IBOutlet weak var RBCtf: UITextField!
    @IBOutlet weak var WBCtf: UITextField!
    @IBOutlet weak var HRtf: UITextField!
    @IBOutlet weak var bptf: UITextField!
    var x = false;
    
    
    func updatestuff(person: String){
        //do{
            curr_patient = person;
            name.text = curr_patient;
            
            BP.text! = "BP:" + dat[curr_patient]![4];
            ID.text! = "ID: " + dat[curr_patient]![0];
            HR.text! = "HR: " + dat[curr_patient]![5];
            WBC.text! = "WBC: " + dat[curr_patient]![2];
            RBC.text! = "RBC: " + dat[curr_patient]![3];
        
    }
    
    
    var alert: UIAlertController = UIAlertController(title: "Missing ID", message: "You cannot update the contact without setting an ID", preferredStyle: .alert)
    
    var alert2: UIAlertController = UIAlertController(title: "Missing Data", message: "You are missing some information. Would you still like to proceed?", preferredStyle: .alert);
    var alert3: UIAlertController = UIAlertController(title: "Invalid Format", message: "You must set the heart rate, WBC, and RBC to numbers.", preferredStyle: .alert);
    
    var tempor = false;
    @IBOutlet weak var butt: UIButton!
    @IBAction func updatedata(_ sender: Any) {
        dat["Chad Johnson"] = ["CJ", "Chad Johnson", "3700", "2700", "70/20", "60"];
        dat["Thomas Edwards"] = ["TE", "Thomas Edwards", "3733", "2300", "79/30", "80"];
        dat["Stephen Johnson"] = ["SJ", "Stephen Johnson", "3920", "2400", "20/100", "40"];
        dat["Larry Ingles"] = ["LI", "Larry Ingles", "2830", "4200", "78/60", "95"];
        dat["Samantha Stewart"] = ["SS", "Samantha Stewart", "4333", "7200", "91/45", "72"];
        dat["Edward Miller"] = ["EM", "Edward Miller", "3923", "2333", "87/60", "42"];
        dat["Reggie Parker"] = ["RP", "Reggie Parker", "2333", "4241", "90/23", "82"]
        if(!x){
            print(2353)
            print(name.text!)
            print(dat["Reggie Parker"])
            //print(dat["Reggie Parker"]![0])
            print(23532)
            IDtf.isHidden = false
            IDtf.text = dat[name.text!]![0];
            RBCtf.isHidden = false
            RBCtf.text = dat[name.text!]![3];
            WBCtf.isHidden = false
            WBCtf.text = dat[name.text!]![2]
            HRtf.isHidden = false
            HRtf.text = dat[name.text!]![5]
            bptf.isHidden = false
            bptf.text = dat[name.text!]![4]
            x = true
            
            ID.text? = "ID: "
            RBC.text? = "RBC: "
            WBC.text? = "WBC: "
            HR.text? = "HR: "
            BP.text? = "BP: "
            
            
            butt.setTitle("Confirm Updates", for: .normal)
        }
        else{
            
            if(IDtf.text == ""){
                self.present(alert, animated: true);
            }
            else if((isitanInt(value: HRtf.text!) && isitanInt(value: WBCtf.text!)) && isitanInt(value: RBCtf.text!)){
              //  self.present(alert3, animated: true);
                self.present(alert3, animated: true)
            }
            
            else if((bptf.text == "" || HRtf.text == "") || (WBCtf.text == "" || RBCtf.text == "")){
                self.present(alert2, animated: true)
                if(tempor == true){
                    if(IDtf.text == ""){
                        IDtf.text! = "Not Available"
                    }
                    ID.text = "ID: " + IDtf.text!
                    
                    if(RBCtf.text == ""){
                        RBCtf.text! = "Not Available"
                    }
                    RBC.text = "RBC: " + RBCtf.text!
                    
                    if(WBCtf.text == ""){
                        WBCtf.text! = "Not Available";
                    }
                    WBC.text = "WBC: " + WBCtf.text!
                    
                    if(HRtf.text == ""){
                        HRtf.text = "Not Available"
                    }
                    HR.text = "Heart Rate: " + HRtf.text!
                    
                    if(bptf.text == ""){
                        bptf.text! = "Not Available";
                    }
                    BP.text = "BP: " + bptf.text!
                    let addingvc = AddingViewController()
                    //addingvc.dat["hi"] = [IDtf.text, name, WBCtf.text, RBCtf.text, bptf.text, HRtf.text];
                    addingvc.dat[name.text!] = [IDtf.text!, name.text!, WBCtf.text!, RBCtf.text!, bptf.text!, HRtf.text!];
                    bptf.text! = "";
                    IDtf.isHidden = true
                    RBCtf.isHidden = true
                    WBCtf.isHidden = true
                    HRtf.isHidden = true
                    bptf.isHidden = true
                    IDtf.text! = ""
                    HRtf.text = "";
                    RBCtf.text! = "";
                    WBCtf.text! = "";
                    x = false;
                    //proceed to view contrller
                }
            }
            else{
                butt.setTitle("Update Data", for: .normal)
                ID.text = "ID: " + IDtf.text!
                RBC.text = "RBC: " + RBCtf.text!
                WBC.text = "WBC: " + WBCtf.text!
                HR.text = "Heart Rate: " + HRtf.text!
                BP.text = "BP: " + bptf.text!
                
                let addingvc = AddingViewController()
                addingvc.dat[name.text!] = [IDtf.text!, name.text!, WBCtf.text!, RBCtf.text!, bptf.text!, HRtf.text!];
                
                IDtf.isHidden = true
                RBCtf.isHidden = true
                WBCtf.isHidden = true
                HRtf.isHidden = true
                bptf.isHidden = true
                
                x = false;
                //ID.text = "ID: " + IDtf.text
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
                        
        let config = AlanConfig(key: "d1dff9e61d903c7ca3bd654b10e6806c2e956eca572e1d8b807a3e2338fdd0dc/stage")
        BP.isHighlighted = true
        BP.highlightedTextColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
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
        
        button.setVisualState(["screen": "profile_screen"])
        
        button.activate()
        print(RBClabel)
        print("view loaded")
        name.text = namelabel
        ID.text = IDlabel
        RBC.text = RBClabel
        BP.text = BPlabel
        HR.text = HRlabel
        WBC.text = WBClabel
        if(namelabel != ""){
            checko = true
        }
        let DL = SearchViewController()
        if(DL.thisthingy == true){
            print(232323)
            curr_patient = DL.tempo;
            DL.thisthingy = false
        }
        let SL = AddingViewController()
        if(SL.xto){
            curr_patient = SL.nametf.text!
            SL.xto = false
        }
        //curr_patient = DL.tempo;
        
        dat["Chad Johnson"] = ["CJ", "Chad Johnson", "3700", "2700", "70/20", "60"];
        dat["Thomas Edwards"] = ["TE", "Thomas Edwards", "3733", "2300", "79/30", "80"];
        dat["Stephen Johnson"] = ["SJ", "Stephen Johnson", "3920", "2400", "20/100", "40"];
        dat["Larry Ingles"] = ["LI", "Larry Ingles", "2830", "4200", "78/60", "95"];
        dat["Samantha Stewart"] = ["SS", "Samantha Stewart", "4333", "7200", "91/45", "72"];
        dat["Edward Miller"] = ["EM", "Edward Miller", "3923", "2333", "87/60", "42"];
        dat["Reggie Parker"] = ["RP", "Reggie Parker", "2333", "4241", "90/23", "82"]
        
        IDtf.isHidden = true
        RBCtf.isHidden = true
        WBCtf.isHidden = true
        HRtf.isHidden = true
        bptf.isHidden = true
        
        alert3.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil));
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil));
        alert2.addAction(UIAlertAction(title: "No", style: .default, handler: nil));
        alert2.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.tempor = true;
            if(self.IDtf.text == ""){
                self.IDtf.text! = "Not Available"
            }
            self.ID.text = "ID: " + self.IDtf.text!
            
            if(self.RBCtf.text == ""){
                self.RBCtf.text! = "Not Available"
            }
            self.RBC.text = "RBC: " + self.RBCtf.text!
            
            if(self.WBCtf.text == ""){
                self.WBCtf.text! = "Not Available";
            }
            self.WBC.text = "WBC: " + self.WBCtf.text!
            
            if(self.HRtf.text == ""){
                self.HRtf.text = "Not Available"
            }
            self.HR.text = "Heart Rate: " + self.HRtf.text!
            
            if(self.bptf.text == ""){
                self.bptf.text! = "Not Available";
            }
            self.BP.text = "BP: " + self.bptf.text!
            let addingvc = AddingViewController()
            //addingvc.dat["hi"] = [IDtf.text, name, WBCtf.text, RBCtf.text, bptf.text, HRtf.text];
            addingvc.dat[self.name.text!] = [self.IDtf.text!, self.name.text!, self.WBCtf.text!, self.RBCtf.text!, self.bptf.text!, self.HRtf.text!];
            self.bptf.text! = "";
            self.IDtf.isHidden = true
            self.RBCtf.isHidden = true
            self.WBCtf.isHidden = true
            self.HRtf.isHidden = true
            self.bptf.isHidden = true
            self.IDtf.text! = ""
            self.HRtf.text = "";
            self.RBCtf.text! = "";
            self.WBCtf.text! = "";
            self.x = false;
        }))
        print(curr_patient)
        
        if("Reggie Parker" == curr_patient){
            print(23)
        }
        print(dat["Reggie Parker"]![0])
        var str2 = "Reggie Parker"
        
        str2 = curr_patient
        print(str2)
        var someArray = [String](repeating: "", count: 6)
        if(name.text == ""){
            name.text = curr_patient;
            
        }
        else{
            dat[curr_patient] = []
            curr_patient = name.text!
            //dat[curr_patient]![1] = curr_patient
            someArray[1] = name.text!
        }
        
        if(BP.text! == ""){
            BP.text! = "BP:" + dat[str2]![4];
        }
        else{
            
            if(BP.text! == "Not Available"){
                //dat[curr_patient]![4] = ""
                
                someArray[4] = ""
            }
            else{
                //dat[curr_patient]![4] = BP.text!
                someArray[4] = BP.text!
            }
            let temp = BP.text!
            BP.text! = "BP: " + temp
        }
        if(ID.text! == ""){
             ID.text! = "ID: " + dat[str2]![0];
        }
        else{
            
            //dat[curr_patient]![0] = ID.text!
            someArray[0] = ID.text!
            let temp = ID.text!
            ID.text! = "ID: " + temp
        }
        if(HR.text! == ""){
            HR.text! = "HR: " + dat[str2]![5];
        }
        else{
            
            if(HR.text! == "Not Available"){
                //dat[curr_patient]![5] = ""
                someArray[5] = "";
            }
            else{
                //dat[curr_patient]![5] = HR.text!
                someArray[5] = HR.text!
            }
            let temp = HR.text!
            HR.text! = "HR: " + temp
        }
        if(WBC.text! == ""){
            WBC.text! = "WBC: " + dat[str2]![2];
        }
        else{
            
            if(WBC.text! == "Not Available"){
                //dat[curr_patient]![2] = ""
                someArray[2] = ""
            }
            else{
                //dat[curr_patient]![2] = WBC.text!
                someArray[2] = HR.text!
            }
            let temp = WBC.text!
            WBC.text! = "WBC: " + temp;
        }
        if(RBC.text! == ""){
            RBC.text! = "RBC: " + dat[str2]![3];
        }
        else{
            
            if(RBC.text! == "Not Available"){
                //dat[curr_patient]![2] = ""
                someArray[2] = ""
            }
            else{
                //dat[curr_patient]![2] = RBC.text!
                someArray[2] = RBC.text!
            }
            let temp = RBC.text!
            RBC.text! = "RBC: " + temp;
        }
        print("asdfasdlkfasdfj")
        dat[name.text!] = someArray
        for i in dat[name.text!]!{
            print(i)
            
        }
        
       // button.setVisualState(["curr": name.text!])
        
        currpatient = name.text!
        button.callProjectApi("setClientData", withData: ["value": name.text!]){ (_, _) in
            
        }
        /*
        if(name.text! == "Reggie Parker"){
            currpatient = "Reggie Parker"
        }
        else if(name.text! == "Samantha Stewart"){
            currpatient = "Samantha Stewart"
        }
        else if(name.text! == "Chad Johnson"){
            currpatient = "Chad Johnson"
        }
        else if(name.text! == "Thomas Edwards"){
            currpatient = "Thomas Edwards"
        }
        else if(name.text! == "Edward Miller"){
            currpatient = "Edward Miller"
        }
 */
        
        
        
        //ID.text! = "ID: " + dat[str2]![0];
       // HR.text! = "HR: " + dat[str2]![5];
        //WBC.text! = "WBC: " + dat[str2]![2];
        //RBC.text! = "RBC: " + dat[str2]![3];
 
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
