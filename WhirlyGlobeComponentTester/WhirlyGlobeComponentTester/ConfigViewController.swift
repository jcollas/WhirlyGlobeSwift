//
//  ConfigViewController.swift
//  WhirlyGlobeComponentTester
//
//  Created by Juan J. Collas on 8/31/2014.
//  Copyright (c) 2014 mousebird consulting. All rights reserved.
//

import UIKit

enum ConfigOptions : Int {
    case All, Terrain, Flat
}

enum MaplyTestCategory : Int, CustomStringConvertible {
    case BaseLayers, OverlayLayers, Objects, Animation, Gestures, Internals
    
    var description: String {
        switch self {
        case BaseLayers:
            return "Base Layers"
        case OverlayLayers:
            return "Overlay Layers"
        case Objects:
            return "Maply Objects"
        case Animation:
            return "Animation"
        case Gestures:
            return "Gestures"
        case Internals:
            return "Internals"
        }
    }
}

class ConfigViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    class ConfigSection {
        // Section name (as dispalyed to user)
        var sectionName: String
        
        // Entries (name,boolean) within the section
        var rows: [String: Bool]
        
        // If set, user can only select one of the options
        var singleSelect: Bool
        
        init(sectionName: String, rows: [String: Bool], singleSelect: Bool = false) {
            self.sectionName = sectionName
            self.rows = rows
            self.singleSelect = singleSelect
        }
    }
    
    // Dictionary reflecting the current values from the table
    var values: [ConfigSection] = []
    
    // What we'll display in terms of user options
    var configOptions: ConfigOptions = .All
    
    override init(nibName nibNameOrNil: String!, bundle: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: bundle)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func valueForSection(section : String, row: String) -> Bool {
        
        for cs in values {
            if (cs.sectionName == section) {
                let csRow = cs.rows[row]
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
        var newValues: [ConfigSection] = []
        
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
                    ]))
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
                        kMaplyTestRoads: false ]))
            newValues.append(
                    ConfigSection(sectionName: kMaplyTestCategoryAnimation, rows: [ kMaplyTestAnimateSphere: false ]))
            
        case .Terrain:
            true
            
        case .Flat:
            newValues.append(
                ConfigSection(sectionName: kMaplyTestCategoryOverlayLayers, rows: [ kMaplyTestUSGSOrtho: false,
                    kMaplyTestOWM: false,
                    kMaplyTestForecastIO: false,
                    kMaplyTestMapboxStreets: false,
    //              kMaplyMapzenVectors: false
                    ]))
            newValues.append(
                    ConfigSection(sectionName: kMaplyTestCategoryObjects, rows: [ kMaplyTestLabel2D: false,
                        kMaplyTestLabel3D: false,
                        kMaplyTestMarker2D: false,
                        kMaplyTestMarker3D: false,
                        kMaplyTestSticker: false,
                        kMaplyTestCountry: false,
                        kMaplyTestMegaMarkers: false,
                        kMaplyTestLatLon: false,
                        kMaplyTestRoads: false ]))
        }
        
        newValues.append(
            ConfigSection(sectionName: kMaplyTestCategoryGestures, rows: [ kMaplyTestNorthUp: false,
                kMaplyTestPinch: true,
                kMaplyTestRotate: true ]) )
        
        newValues.append(
            ConfigSection(sectionName: kMaplyTestCategoryInternal, rows: [ kMaplyTestCulling: false,
                kMaplyTestPerf: false,
                kMaplyTestWaitLoad: false ]) )
        
        values = newValues;
    }
    
    //    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //        return YES;
    //    }
    
    // MARK: UITableView delegate and data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return values.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section >= values.count) {
            return nil
        }
        
        let cs = values[section];
        return cs.sectionName
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section >= values.count) {
            return 0
        }
        
        let cs = values[section];
        return cs.rows.count
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section >= values.count) {
            return
        }
        
        let cs = values[indexPath.section]
        if (indexPath.row >= cs.rows.count) {
            return
        }
        
        var arr = cs.rows.keys.sort { $0 < $1 }
        let key = arr[indexPath.row]
        let selected : Bool = cs.rows[key]!
        cell.backgroundColor = selected ? UIColor(red:0.75, green:0.75, blue:1.0, alpha:1.0) : UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cs = values[indexPath.section]
        
        var arr = cs.rows.keys.sort { $0 < $1 }
        let cell = UITableViewCell(style:.Default, reuseIdentifier:nil)
        let key = arr[indexPath.row]
        cell.textLabel!.text = key
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section >= values.count) {
            return
        }
        
        let cs = values[indexPath.section]
        if (indexPath.row >= cs.rows.count) {
            return
        }
        
        var arr = cs.rows.keys.sort { $0 < $1 }
        let key = arr[indexPath.row]
        
        let selectState : Bool = cs.rows[key]!
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