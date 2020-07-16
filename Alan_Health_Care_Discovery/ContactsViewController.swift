//
//  ContactsViewController.swift
//  Alan_Health_Care_Discovery
//
//  Created by Raj Janardhan on 7/2/20.
//  Copyright © 2020 Raj Janardhan. All rights reserved.
//

import UIKit
import AlanSDK
class ContactsViewController: UIViewController{
    var button: AlanButton!
     var names = ["Chad Johnson", "Thomas Edwards", "Stephen Johnson", "Larry Ingles", "Samantha Stewart", "Edward Miller", "Reggie Parker"];
    var issa = ""
    var curr_patient = ""
    var checko = false
    var curr_data = [String](repeating: "", count: 6)
    @IBOutlet weak var tv: UITableView!
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
            //print(str["command"])
            
            if(str["command"] is String && str["command"]! as! String == "fix"){
                self.performSegue(withIdentifier: "addingpatients", sender: nil)
            }
            else if(str["screen"] as! String == "thisthang" || str["screen"] as! String == "movingtocontacts"){
                //print("hi raj how are you")
                let t = str["command"] as! NSDictionary
                let tt = t["value"] as! String
                issa = tt
                self.performSegue(withIdentifier: "addingpatients", sender: nil)
            }
            else if(str["screen"] as! String == "movingtodata" || str["screen"] as! String == "hoverrover"){
                var thistemp = str["command"] as! NSDictionary
                issa = thistemp["value"] as! String
                self.performSegue(withIdentifier: "searchis", sender: nil)
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
            else if(str["screen"] as! String == "movecontacts"){
                button.playText("You already are at the contacts page")
            }
            else if(str["screen"] as! String == "search_screen"){
                print(2)
                self.performSegue(withIdentifier: "gotosearch", sender: nil)
            }
            else if(str["screen"] as! String == "home"){
                button.playText("Going home.")
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleEvent(_:)),
        name:NSNotification.Name(rawValue: "kAlanSDKEventNotification"), object:nil)
        button.setVisualState(["screen": "contacts"])
        
        button.activate()
        
        tv.delegate = self
        tv.dataSource = self
        // Do any additional setup after loading the view.
        //cell.accessoryType = .detailDisclosureButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        button.deactivate()
        if(segue.identifier == "searchis"){
            let dc = segue.destination as! ProfileViewController
           // print(tempo)
            //dc.curr_patient = tempo
            dc.curr_patient = issa;
            print(issa)
            print(1234512435)
            if(checko){
                print("hi")
                dc.IDtf.text = dc.dat[issa]![0]
                dc.RBCtf.text = dc.dat[issa]![3]
                dc.WBCtf.text = dc.dat[issa]![2]
                dc.bptf.text = dc.dat[issa]![4]
                dc.HRtf.text = dc.dat[issa]![5]
                
                dc.namelabel = issa
                dc.IDlabel = curr_data[0]
                dc.WBClabel = curr_data[2]
                dc.RBClabel = curr_data[3]
                dc.BPlabel = curr_data[4]
                dc.HRlabel = curr_data[5]
            }
            
            
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

}

extension ContactsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
        issa = names[indexPath.row]
        if(issa ==  curr_patient){
            checko = true
        }
         self.performSegue(withIdentifier: "searchis", sender: nil)
    }
}

extension ContactsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //doSomethingWithItem(indexPath.row)
        print(indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .detailDisclosureButton
        cell.textLabel?.text = names[indexPath.row];
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "Patients"
    }
}
