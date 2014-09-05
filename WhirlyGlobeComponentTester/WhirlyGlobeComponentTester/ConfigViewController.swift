//
//  ConfigViewController.swift
//  WhirlyGlobeComponentTester
//
//  Created by Juan J. Collas on 8/31/2014.
//  Copyright (c) 2014 mousebird consulting. All rights reserved.
//

import UIKit

enum ConfigOptions : Int {
    case All
    case Terrain
    case Flat
}

class ConfigSection {
    // Section name (as dispalyed to user)
    var sectionName : String
    
    // Entries (name,boolean) within the section
    var rows : Dictionary<String, Bool>
    
    // If set, user can only select one of the options
    var singleSelect : Bool
    
    init(sectionName: String, rows: Dictionary<String, Bool>, singleSelect: Bool) {
        self.sectionName = sectionName
        self.rows = rows
        self.singleSelect = singleSelect
    }
}

class ConfigViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Dictionary reflecting the current values from the table
    var values : Array<ConfigSection> = []
    
    // What we'll display in terms of user options
    var configOptions : ConfigOptions = .All
    
    override init(nibName nibNameOrNil: String!, bundle: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: bundle)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func valueForSection(section : String, row: String) -> Bool {
        
        for cs in values {
            if (cs.sectionName == section) {
                var csRow = cs.rows[row]
                if (csRow != nil) {
                    return csRow!
                }
            }
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view from its nib.
        var newValues : Array<ConfigSection> = []
        
        newValues.append(
            ConfigSection(sectionName: kMaplyTestCategoryBaseLayers,
                rows:
                [ kMaplyTestBlank: false,
                    kMaplyTestGeographyClass: true,
                    kMaplyTestBlueMarble: false,
                    kMaplyTestStamenWatercolor: false,
                    kMaplyTestOSM: false,
                    kMaplyTestMapBoxSat: false,
                    kMaplyTestMapBoxTerrain: false,
                    kMaplyTestMapBoxRegular: false,
                    kMaplyTestQuadTest: false,
                    kMaplyTestQuadVectorTest: false,
                    kMaplyTestQuadTestAnimate: false ],
                singleSelect:true) )
        
        // We won't let the user do some things in terrain mode (overlay, basically)
        //  or 2D flatmap mode (shapes, basically)
        switch (configOptions) {
        case .All:
            newValues.append(
                ConfigSection(sectionName: kMaplyTestCategoryOverlayLayers, rows: [ kMaplyTestUSGSOrtho: false,
                    kMaplyTestOWM: false,
                    kMaplyTestForecastIO: false,
                    kMaplyTestMapboxStreets: false,
                    //                  kMaplyMapzenVectors: false
                    ], singleSelect: false))
            newValues.append(
                    ConfigSection(sectionName: kMaplyTestCategoryObjects, rows: [ kMaplyTestLabel2D: false,
                        kMaplyTestLabel3D: false,
                        kMaplyTestMarker2D: false,
                        kMaplyTestMarker3D: false,
                        kMaplyTestSticker: false,
                        kMaplyTestShapeCylinder: false,
                        kMaplyTestShapeSphere: false,
                        kMaplyTestShapeGreatCircle: false,
                        kMaplyTestCountry: false,
                        kMaplyTestLoftedPoly: false,
                        kMaplyTestMegaMarkers: false,
                        kMaplyTestLatLon: false,
                        kMaplyTestRoads: false ],
                        singleSelect:false))
            newValues.append(
                    ConfigSection(sectionName: kMaplyTestCategoryAnimation, rows: [ kMaplyTestAnimateSphere: false ], singleSelect: false))
            
        case .Terrain:
            true
            
        case .Flat:
            newValues.append(
                ConfigSection(sectionName: kMaplyTestCategoryOverlayLayers, rows: [ kMaplyTestUSGSOrtho: false,
                    kMaplyTestOWM: false,
                    kMaplyTestForecastIO: false,
                    kMaplyTestMapboxStreets: false,
    //              kMaplyMapzenVectors: false
                    ], singleSelect: false))
            newValues.append(
                    ConfigSection(sectionName: kMaplyTestCategoryObjects, rows: [ kMaplyTestLabel2D: false,
                        kMaplyTestLabel3D: false,
                        kMaplyTestMarker2D: false,
                        kMaplyTestMarker3D: false,
                        kMaplyTestSticker: false,
                        kMaplyTestCountry: false,
                        kMaplyTestMegaMarkers: false,
                        kMaplyTestLatLon: false,
                        kMaplyTestRoads: false ], singleSelect: false))
        }
        
        newValues.append(
            ConfigSection(sectionName: kMaplyTestCategoryGestures, rows: [ kMaplyTestNorthUp: false,
                kMaplyTestPinch: true,
                kMaplyTestRotate: true ], singleSelect: false) )
        
        newValues.append(
            ConfigSection(sectionName: kMaplyTestCategoryInternal, rows: [ kMaplyTestCulling: false,
                kMaplyTestPerf: false,
                kMaplyTestWaitLoad: false ], singleSelect: false) )
        
        values = newValues;
    }
    
    //    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //        return YES;
    //    }
    
    // MARK: UITableView delegate and data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return values.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String! {
        
        if (section >= values.count) {
            return ""
        }
        
        var cs = values[section];
        return cs.sectionName
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section >= values.count) {
            return 0
        }
        
        var cs = values[section];
        return cs.rows.count
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section >= values.count) {
            return
        }
        
        var cs = values[indexPath.section]
        if (indexPath.row >= cs.rows.count) {
            return
        }
        
        var arr = sorted(cs.rows.keys)
        var key = arr[indexPath.row]
        var selected : Bool = cs.rows[key]!
        cell.backgroundColor = selected ? UIColor(red:0.75, green:0.75, blue:1.0, alpha:1.0) : UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cs = values[indexPath.section]
        
        var arr = sorted(cs.rows.keys)
        var cell = UITableViewCell(style:.Default, reuseIdentifier:nil)
        var key = arr[indexPath.row]
        cell.textLabel!.text = key
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section >= values.count) {
            return;
        }
        
        var cs = values[indexPath.section]
        if (indexPath.row >= cs.rows.count) {
            return;
        }
        
        var arr = sorted(cs.rows.keys)
        var key = arr[indexPath.row]
        
        var selectState : Bool = cs.rows[key]!
        if (cs.singleSelect) {
            // Turn everything else off and this one on
            if (!selectState) {
                for theKey in arr {
                    cs.rows[theKey] = false
                }
                cs.rows[key] = true
            }
            tableView.reloadSections(NSIndexSet(index:indexPath.section), withRowAnimation:.Fade)
        } else {
            cs.rows[key] = !selectState
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Fade)
        }
    }
    
}