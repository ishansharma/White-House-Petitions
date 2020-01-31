//
//  ViewController.swift
//  P7 White House Petitions
//
//  Created by Ishan Sharma on 1/27/20.
//  Copyright © 2020 Ishan Sharma. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var filterString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from We The People White House API", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        let fc = UIAlertController(title: "Filter Petitions", message: "", preferredStyle: .alert)
        fc.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Enter keyword"
            textField.text = self.filterString
        });
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {alert -> Void in
            let filterTextField = fc.textFields![0] as UITextField
            self.filterString = filterTextField.text!.lowercased()
            self.filterResults()
            self.tableView.reloadData()
        });
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        fc.addAction(saveAction)
        fc.addAction(cancelAction)
        present(fc, animated: true)
    }
    
    func filterResults() {
        // if filterString is not blank, we need to filter petitions
        if filterString != "" {
            for petition in petitions {
                if petition.title.lowercased().range(of: filterString) != nil || petition.body.lowercased().range(of: filterString) != nil {
                    filteredPetitions.append(petition)
                }
            }
            petitions = filteredPetitions
        }
    }
}

