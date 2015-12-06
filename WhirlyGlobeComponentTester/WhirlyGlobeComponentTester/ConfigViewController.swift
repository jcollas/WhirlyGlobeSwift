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

enum MaplyTestCategory : String, CustomStringConvertible {
    
    case BaseLayers = "Base Layers"
    case OverlayLayers = "Overlay Layers"
    case Objects = "Maply Objects"
    case Animation = "Animation"
    case Gestures = "Gestures"
    case Internal = "Internals"
    
    var description: String {
        return self.rawValue
    }
}

enum MaplyTestOption: String, CustomStringConvertible {
    
    // Base image layers
    case Blank = "Blank"
    case GeographyClass = "Geography Class - Local"
    case BlueMarble = "NASA Blue Marble - Local"
    case StamenWatercolor = "Stamen Watercolor - Remote"
    case OSM = "OpenStreetMap (Mapquest) - Remote"
    case MapBoxSat = "MapBox Satellite - Remote"
    case MapBoxTerrain = "MapBox Terrain - Remote"
    case MapBoxRegular = "MapBox Regular - Remote"
    case QuadTest = "Quad Test Layer"
    case QuadTestAnimate = "Quad Test Layer - Animated"
    case QuadVectorTest = "Quad Vector Test Layer"
    
    // Overlay image layers
    case USGSOrtho = "USGS Ortho (WMS) - Remote"
    case OWM = "OpenWeatherMap - Remote"
    case ForecastIO = "Forecast.IO Snapshot - Remote"
    case MapboxStreets = "MapBox Streets Vectors - Remote"
    case MapzenVectors = "Mapzen Vectors - Remote"
    
    // Objects we can display
    case Label2D = "Labels - 2D"
    case Label3D = "Labels - 3D"
    case Marker2D = "Markers - 2D"
    case Marker3D = "Markers - 3D"
    case Sticker = "Stickers"
    case ShapeCylinder = "Shapes: Cylinders"
    case ShapeSphere = "Shapes: Spheres"
    case ShapeGreatCircle = "Shapes: Great Circles"
    case Country = "Countries"
    case LoftedPoly = "Lofted Polygons"
    case MegaMarkers = "Mega Markers"
    case LatLon = "Lon/Lat lines"
    case Roads = "SF Roads"

    // Animation
    case AnimateSphere = "Animated Sphere"
    
    // Gestures
    case NorthUp = "Keep North Up"
    case Pinch = "Pinch Gesture"
    case Rotate = "Rotate Gesture"
    
    // Internals
    case Culling = "Culling Optimization"
    case Perf  = "Performance Output"
    case WaitLoad = "Image waitLoad"
    
    var description: String {
        return self.rawValue
    }
}

class ConfigViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    class Section {
        // Section name (as displayed to user)
        var section: MaplyTestCategory
        
        var name: String {
            return section.description
        }
        
        // Entries (name,boolean) within the section
        var rows: [Row]
        
        // If set, user can only select one of the options
        var singleSelect: Bool
        
        init(section: MaplyTestCategory, rows: [Row], singleSelect: Bool = false) {
            self.section = section
            self.rows = rows
            self.singleSelect = singleSelect
        }
    }
    
    struct Row {
        var option: MaplyTestOption
        var selected = false
        
        var name: String {
            return option.description
        }
        
        init(option: MaplyTestOption, selected: Bool = false) {
            self.option = option
            self.selected = selected
        }
        
        mutating func toggle() {
            selected = !selected
        }
    }
    
    // Dictionary reflecting the current values from the table
    var values: [Section] = []
    
    // What we'll display in terms of user options
    var configOptions: ConfigOptions = .All
    
    override init(nibName nibNameOrNil: String!, bundle: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: bundle)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func valueForSection(category: MaplyTestCategory, option: MaplyTestOption) -> Bool {
        
        for cs in values {
            if (cs.name == category.description) {
                for row in cs.rows {
                    if row.option == option {
                        return row.selected
                    }
                }
            }
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view from its nib.
        var newValues: [Section] = []
        
        newValues.append(
            Section(section: .BaseLayers,
                rows: [
                    Row(option: .Blank),
                    Row(option: .GeographyClass, selected: true),
                    Row(option: .BlueMarble),
                    Row(option: .StamenWatercolor),
                    Row(option: .OSM),
                    Row(option: .MapBoxSat),
                    Row(option: .MapBoxTerrain),
                    Row(option: .MapBoxRegular),
                    Row(option: .QuadTest),
                    Row(option: .QuadVectorTest),
                    Row(option: .QuadTestAnimate)
                ],
                singleSelect:true) )
        
        // We won't let the user do some things in terrain mode (overlay, basically)
        //  or 2D flatmap mode (shapes, basically)
        switch (configOptions) {
        case .All:
            newValues.append(
                Section(section: .OverlayLayers,
                    rows: [
                        Row(option: .USGSOrtho),
                        Row(option: .OWM),
                        Row(option: .ForecastIO),
                        Row(option: .MapboxStreets)
//                  kMaplyMapzenVectors: false
                    ]))
            newValues.append(
                Section(section: .Objects,
                    rows: [
                        Row(option: .Label2D),
                        Row(option: .Label3D),
                        Row(option: .Marker2D),
                        Row(option: .Marker3D),
                        Row(option: .Sticker),
                        Row(option: .ShapeCylinder),
                        Row(option: .ShapeSphere),
                        Row(option: .ShapeGreatCircle),
                        Row(option: .Country),
                        Row(option: .LoftedPoly),
                        Row(option: .MegaMarkers),
                        Row(option: .LatLon),
                        Row(option: .Roads)
                    ]))
            newValues.append(
                Section(section: .Animation, rows: [ Row(option:. AnimateSphere) ]))
            
        case .Terrain:
            true
            
        case .Flat:
            newValues.append(
                Section(section: .OverlayLayers,
                    rows: [
                        Row(option: .USGSOrtho),
                        Row(option: .OWM),
                        Row(option: .ForecastIO),
                        Row(option: .MapboxStreets)
//                  kMaplyMapzenVectors: false
                    ]))
            newValues.append(
                Section(section: .Objects,
                    rows: [
                        Row(option: .Label2D),
                        Row(option: .Label3D),
                        Row(option: .Marker2D),
                        Row(option: .Marker3D),
                        Row(option: .Sticker),
                        Row(option: .Country),
                        Row(option: .MegaMarkers),
                        Row(option: .LatLon),
                        Row(option: .Roads)
                    ]))
        }
        
        newValues.append(
            Section(section: .Gestures,
                rows: [
                    Row(option: .NorthUp),
                    Row(option: .Pinch, selected: true),
                    Row(option: .Rotate, selected: true)
                ]) )
        
        newValues.append(
            Section(section: .Internal,
                rows: [
                    Row(option: .Culling),
                    Row(option: .Perf),
                    Row(option: .WaitLoad)
                ]) )
        
        values = newValues
    }
    
    // MARK: UITableView delegate and data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return values.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section >= values.count) {
            return nil
        }
        
        let cs = values[section]
        return cs.name
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section >= values.count) {
            return 0
        }
        
        let cs = values[section]
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
        
        let row = cs.rows[indexPath.row]
        cell.backgroundColor = row.selected ? UIColor(red:0.75, green:0.75, blue:1.0, alpha:1.0) : UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cs = values[indexPath.section]
        
        let cell = UITableViewCell(style:.Default, reuseIdentifier:nil)
        let row = cs.rows[indexPath.row]
        cell.textLabel!.text = row.name
        
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

        // Be careful with assignment and structs.
        if cs.singleSelect {
            // Turn everything else off and this one on
            if cs.rows[indexPath.row].selected == false {
                for i in 0..<cs.rows.count {
                    cs.rows[i].selected = false
                }
                cs.rows[indexPath.row].selected = true
            }
            tableView.reloadSections(NSIndexSet(index:indexPath.section), withRowAnimation: .Fade)
        } else {
            cs.rows[indexPath.row].toggle()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
}