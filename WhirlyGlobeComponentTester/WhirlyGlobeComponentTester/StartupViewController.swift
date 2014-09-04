//
//  StartupViewController.swift
//  SwiftTest
//
//  Created by Juan J. Collas on 8/27/2014.
//  Copyright (c) 2014 Moreira Consulting, Inc. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.backgroundColor = UIColor.grayColor()
        self.tableView!.separatorColor = UIColor.whiteColor()
        self.tableView!.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.view.addSubview(tableView!)
        self.view.autoresizesSubviews = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView!.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nums : MapType = .NumTypes
        
        return nums.toRaw()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String! {
        return nil
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style:.Default, reuseIdentifier:nil)
        var mapType = MapType.fromRaw(indexPath.row)!
        
        switch mapType {
        case .Globe:
            cell.textLabel!.text = "Globe (3D)"
            
        case .GlobeWithElevation:
            cell.textLabel!.text = "Globe w/ Elevation (3D)"
            
        case .Map2D:
            cell.textLabel!.text = "Map (2D)"
            
        case .Map3D:
            cell.textLabel!.text = "Map (3D)"
            
        default:
            cell.textLabel!.text = "Unknown"
        }
        
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.grayColor()
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var viewC = TestViewController(mapType: MapType.fromRaw(indexPath.row)!)
        self.navigationController!.pushViewController(viewC, animated: true)
    }
}

