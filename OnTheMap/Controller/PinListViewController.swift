//
//  PinListViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class PinListViewController: MapAndPinViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleStudentLocationsRespone()
        print("Pin List View")
    }
    
    func handleStudentLocationsRespone() {
        OnTheMapAPIClient.getStudentLocations { (success, results, error) in
            if success {
                if let studentLocationArray = results {
                    self.studentLocationResults = studentLocationArray
                    print("success")
                    print(self.studentLocationResults.count)
                    self.tableView.reloadData()
                }
            } else {
                print("Fail")
                print(error)
            }
        }
    }
}

extension PinListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: constants.cellIdentifier)
        let student = studentLocationResults[indexPath.row]
        cell.textLabel?.text = student.firstName + " " + student.lastName
        
        print(studentLocationResults[indexPath.row].firstName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocationResults.count
        
    }
}

extension PinListViewController {
    enum constants {
        static let cellIdentifier = "studentCell"
    }
}
