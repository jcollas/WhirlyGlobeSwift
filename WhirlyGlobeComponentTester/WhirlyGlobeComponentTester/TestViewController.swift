//
//  TestViewController.swift
//  WhirlyGlobeComponentTester
//
//  Created by Juan J. Collas on 8/29/2014.
//  Copyright (c) 2014 mousebird consulting. All rights reserved.
//

import UIKit
import WhirlyGlobe

enum MapType: Int, Printable {
    case Globe, GlobeWithElevation, Map3D, Map2D, NumTypes
    
    var description: String {
        switch self {
        case Globe:
            return "Globe (3D)"
        case GlobeWithElevation:
            return "Globe w/ Elevation (3D)"
        case Map3D:
            return "Map (3D)"
        case Map2D:
            return "Map (2D)"
        default:
            return "Unknown"
        }
    }
}

struct LocationInfo {
    var name: String
    var lat: Float
    var lon: Float
}

let locations = [
    LocationInfo(name: "Kansas City", lat: 39.1, lon: -94.58),
    LocationInfo(name: "Washington, DC", lat: 38.895111, lon: -77.036667),
    LocationInfo(name: "Manila", lat: 14.583333, lon: 120.966667),
    LocationInfo(name: "Moscow", lat: 55.75, lon: 37.616667),
    LocationInfo(name: "London", lat: 51.507222, lon: -0.1275),
    LocationInfo(name: "Caracas", lat: 10.5, lon: -66.916667),
    LocationInfo(name: "Lagos", lat: 6.453056, lon: 3.395833),
    LocationInfo(name: "Sydney", lat: -33.859972, lon: 151.211111),
    LocationInfo(name: "Seattle", lat: 47.609722, lon: -122.333056),
    LocationInfo(name: "Tokyo", lat: 35.689506, lon: 139.6917),
    LocationInfo(name: "McMurdo Station", lat: -77.85, lon: 166.666667),
    LocationInfo(name: "Tehran", lat: 35.696111, lon: 51.423056),
    LocationInfo(name: "Santiago", lat: -33.45, lon: -70.666667),
    LocationInfo(name: "Pretoria", lat: -25.746111, lon: 28.188056),
    LocationInfo(name: "Perth", lat: -31.952222, lon: 115.858889),
    LocationInfo(name: "Beijing", lat: 39.913889, lon: 116.391667),
    LocationInfo(name: "New Delhi", lat: 28.613889, lon: 77.208889),
    LocationInfo(name: "San Francisco", lat: 37.7793, lon: -122.4192),
    LocationInfo(name: "Pittsburgh", lat: 40.441667, lon: -80),
    LocationInfo(name: "Freetown", lat: 8.484444, lon: -13.234444),
    LocationInfo(name: "Windhoek", lat: -22.57, lon: 17.083611),
    LocationInfo(name: "Buenos Aires", lat: -34.6, lon: -58.383333),
    LocationInfo(name: "Zhengzhou", lat: 34.766667, lon: 113.65),
    LocationInfo(name: "Bergen", lat: 60.389444, lon: 5.33),
    LocationInfo(name: "Glasgow", lat: 55.858, lon: -4.259),
    LocationInfo(name: "Bogota", lat: 4.598056, lon: -74.075833),
    LocationInfo(name: "Haifa", lat: 32.816667, lon: 34.983333),
    LocationInfo(name: "Puerto Williams", lat: -54.933333, lon: -67.616667),
    LocationInfo(name: "Panama City", lat: 8.983333, lon: -79.516667),
    LocationInfo(name: "Niihau", lat: 21.9, lon: -160.166667)
]

// High performance vs. low performance devices
enum PerformanceMode {
    case High, Low
}

class TestViewController: UIViewController, WhirlyGlobeViewControllerDelegate, MaplyViewControllerDelegate,UIPopoverControllerDelegate {

    /// This is the base class shared between the MaplyViewController and the WhirlyGlobeViewController
    var baseViewC: MaplyBaseViewController!
    
    /// If we're displaying a globe, this is set
    var globeViewC: WhirlyGlobeViewController?
    
    /// If we're displaying a map, this is set
    var mapViewC: MaplyViewController?
    
    var popControl: UIPopoverController?

    // The configuration view comes up when the user taps outside the globe
    private var configViewC: ConfigViewController!
    
    // Base layer
    private var baseLayerName: String!
    private var baseLayer: MaplyViewControllerLayer?
    
    // Overlay layers
    private var ovlLayers: [String: MaplyViewControllerLayer] = [:]
    
    // These represent a group of objects we've added to the globe.
    // This is how we track them for removal
    private var screenMarkersObj: MaplyComponentObject?
    private var markersObj: MaplyComponentObject?
    private var shapeCylObj: MaplyComponentObject?
    private var shapeSphereObj: MaplyComponentObject?
    private var greatCircleObj: MaplyComponentObject?
    private var screenLabelsObj: MaplyComponentObject?
    private var labelsObj: MaplyComponentObject?
    private var stickersObj: MaplyComponentObject?
    private var latLonObj: MaplyComponentObject?

    private var sfRoadsObjArray: [AnyObject]?
    private var vecObjects: [MaplyComponentObject]?
    
    private var megaMarkersObj: MaplyComponentObject?
    private var autoLabels: MaplyComponentObject?

    private var animSphere: MaplyActiveObject?

    private var loftPolyDict: [String: MaplyComponentObject] = [:]
    
    // A source of elevation data, if we're in that mode
    private var elevSource: NSObject?
    
    // The view we're using to track a selected object
    //    MaplyViewTracker *selectedViewTrack;
    
    private var screenLabelDesc: [NSObject: AnyObject]?
    private var labelDesc: [NSObject: AnyObject]?
    private var vectorDesc: [NSObject: AnyObject]?

    // If we're in 3D mode, how far the elevation goes
    private var zoomLimit: Int32 = 0
    private var requireElev: Bool = false
    private var imageWaitLoad: Bool = false
    private var maxLayerTiles: Int32 = 256
    
    // Label test
    private var _labelAnimationTimer: NSTimer?
    private var trafficLabels: [Int: MaplyComponentObject] = [:]
    
    // Dashed lines used in wide vector test
    private var dashedLineTex: MaplyTexture?
    private var filledLineTex: MaplyTexture?
    
    private var perfMode: PerformanceMode = .Low
    
    private var startupMapType: MapType = .Globe
    
    init(mapType: MapType) {

        startupMapType = mapType
        
        super.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String!, bundle: NSBundle!) {

        super.init(nibName: nibNameOrNil, bundle: bundle)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        
        // This should release the globe view
        if let viewC = baseViewC {
            viewC.view.removeFromSuperview()
            viewC.removeFromParentViewController()

            baseViewC = nil
            mapViewC = nil
            globeViewC = nil
        }
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        // What sort of hardware are we on?
        if (UIScreen.mainScreen().scale > 1.0) {
            // Retina devices tend to be better, except for
            perfMode = .High
        }
        
        #if arch(i386) && os(iOS)
            perfMode = .High
        #endif
    
        // Configuration controller for turning features on and off
        configViewC = ConfigViewController(nibName: "ConfigViewController", bundle: nil)
    
        // Create an empty globe or map controller
        switch startupMapType {
        case .Globe, .GlobeWithElevation:
            globeViewC = WhirlyGlobeViewController()
            globeViewC!.delegate = self
            baseViewC = globeViewC
            maxLayerTiles = 128

        case .Map3D:
            mapViewC = MaplyViewController()
            mapViewC!.doubleTapZoomGesture = true
            mapViewC!.twoFingerTapGesture = true
            mapViewC!.viewWrap = true
            mapViewC!.delegate = self
            baseViewC = mapViewC

        case .Map2D:
            mapViewC = MaplyViewController(asFlatMap: ())
            configViewC.configOptions = .Flat
            mapViewC!.doubleTapZoomGesture = true
            mapViewC!.twoFingerTapGesture = true
            mapViewC!.viewWrap = true
            mapViewC!.delegate = self
            baseViewC = mapViewC

    //        case MaplyScrollViewMap:
    //            break;
        default:
            true
        }

        view.addSubview(baseViewC.view)
        baseViewC.view.frame = view.bounds
        addChildViewController(baseViewC)
    
        // Note: Debugging
        //    labelExercise()
    
        if (perfMode == .Low) {
            baseViewC.frameInterval = 3 // 20fps
            baseViewC.threadPerLayer = false
        } else {
            baseViewC.frameInterval = 2 // 30fps
            baseViewC.threadPerLayer = true
        }
    
        // Set the background color for the globe
        if (globeViewC != nil) {
            baseViewC.clearColor = UIColor.blackColor()
        } else {
            baseViewC.clearColor = UIColor.whiteColor()
        }

        if (globeViewC != nil) {
            // Start up over San Francisco
            globeViewC!.height = 0.8
            globeViewC!.animateToPosition(MaplyCoordinateMakeWithDegrees(-122.4192, 37.7793), time:1.0)
        } else {
            mapViewC!.height = 1.0
            mapViewC!.animateToPosition(MaplyCoordinateMakeWithDegrees(-122.4192, 37.7793), time:1.0)
        }
    
        // For elevation mode, we need to do some other stuff
        if (startupMapType == .GlobeWithElevation) {
            // Tilt, so we can see it
            if (globeViewC != nil) {
                globeViewC!.setTiltMinHeight(0.001, maxHeight:0.04, minTilt:1.21771169, maxTilt:0.0)
            }
            globeViewC!.frameInterval = 2  // 30fps
    
            // An elevation source.  This one just makes up sine waves to get some data in there
            elevSource = MaplyElevationDatabase(name: "world_web_mercator")
            zoomLimit = (elevSource as MaplyElevationSourceDelegate).maxZoom()
            requireElev = true
            baseViewC.elevDelegate = elevSource
    
            // Don't forget to turn on the z buffer permanently
            baseViewC.setHints([ kMaplyRenderHintZBuffer: true ])
    
            // Turn off most of the options for globe mode
            configViewC.configOptions = .Terrain
        }
    
        // Force the view to load so we can get the default switch values
        var loadedView = configViewC.view
    
        // Maximum number of objects for the layout engine to display
        //    [baseViewC setMaxLayoutObjects:1000]
    
        // Bring up things based on what's turned on
        dispatch_after(1, dispatch_get_main_queue()) {
            self.changeMapContents()
        }
    
        // Settings panel
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.Edit, target:self, action:"showConfig")
    }
    
    // Create a bunch of labels periodically
    func labelExercise() {
    
        if (mapViewC != nil) {
            trafficLabels = [:]
    
            _labelAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(1.25, target:self, selector:"labelAnimationCallback", userInfo:nil, repeats:false)
        }
    }
    
    func labelAnimationCallback() {
        NSLog("anim callback")
        var trafficLabelCompObj: MaplyComponentObject?
    
        for (key, trafficLabelObj) in trafficLabels {
            mapViewC!.removeObject(trafficLabelObj)
            trafficLabels[key] = nil
        }
    
        labelDesc = [ kMaplyMinVis: 0.0, kMaplyMaxVis: 1.0, kMaplyFade: 0.3, kMaplyJustify: "left", kMaplyDrawPriority: 50 ]

        for i in 0..<50 {
            var label: MaplyScreenLabel = MaplyScreenLabel()
    
            label.loc = MaplyCoordinateMakeWithDegrees(
                    -100.0 + 0.25 * (Float(arc4random())/0x100000000),
                    40.0 + 0.25 * (Float(arc4random())/0x100000000))
            label.rotation = 0.0
            label.layoutImportance = 1.0
            label.text = "ABCDE"
            label.layoutPlacement = kMaplyLayoutRight
            label.userObject = nil
            label.color = UIColor.whiteColor()
    
            trafficLabelCompObj = mapViewC!.addScreenLabels([label], desc:labelDesc)
            trafficLabels[i] = trafficLabelCompObj
        }
    
        _labelAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(1.25, target: self, selector:"labelAnimationCallback", userInfo:nil, repeats:false)
    }
    
    // Try to fetch the given WMS layer
    func fetchWMSLayer(baseURL: String, layerName: String, styleName: String?, cacheDir: String, overlayName: String) {
        
        var capabilitiesURL = MaplyWMSCapabilities.CapabilitiesURLFor(baseURL)
        if let url = NSURL(string:capabilitiesURL) {
            var operation = AFHTTPRequestOperation(request:NSURLRequest(URL:url))
            
            operation.responseSerializer = AFXMLParserResponseSerializer.sharedSerializer()
            
            operation.setCompletionBlockWithSuccess(
                { (op: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    self.startWMSLayer(baseURL, xml:responseObject as DDXMLDocument, layerName:layerName, styleName:styleName, cacheDir:cacheDir, overlayName:overlayName)
                    return
                }, failure:{ (operation: AFHTTPRequestOperation!, error: NSError!) in
                    // Sometimes this works anyway
                    //        if (![self startWMSLayerBaseURL:baseURL xml:XMLDocument layer:layerName style:styleName cacheDir:thisCacheDir ovlName:ovlName])
                    //            NSLog("Failed to get capabilities from WMS server: %",capabilitiesURL);
            })
            
            operation.start()
        }
    }
    
    // Try to start the layer, given the capabilities
    func startWMSLayer(baseURL: String, xml: DDXMLDocument, layerName:String, styleName:String?, cacheDir: String, overlayName: String?) -> Bool {

        // See what the service can provide
        var cap: MaplyWMSCapabilities = MaplyWMSCapabilities(XML: xml)
        var layer: MaplyWMSLayer? = cap.findLayer(layerName)
        var coordSys: MaplyCoordinateSystem? = layer!.buildCoordSystem()
        var style: MaplyWMSStyle? = layer!.findStyle(styleName)

        if (layer == nil) {
            NSLog("Couldn't find layer %@ in WMS response.",layerName)
            return false
        } else if (coordSys == nil) {
            NSLog("No coordinate system we recognize in WMS response.")
            return false
        } else if (styleName != nil && style == nil) {
            NSLog("No style named %@ in WMS response.",styleName!)
            return false
        }
    
        if (layer != nil && coordSys != nil) {
            var tileSource: MaplyWMSTileSource = MaplyWMSTileSource(baseURL: baseURL, capabilities: cap, layer: layer, style:style, coordSys:coordSys, minZoom:0, maxZoom:16, tileSize:256)
            
            tileSource.cacheDir = cacheDir
            tileSource.transparent = true

            var imageLayer: MaplyQuadImageTilesLayer = MaplyQuadImageTilesLayer(coordSystem:coordSys, tileSource:tileSource)

            imageLayer.coverPoles = false
            imageLayer.handleEdges = true
            imageLayer.requireElev = requireElev
            imageLayer.waitLoad = imageWaitLoad
            baseViewC.addLayer(imageLayer)
    
            if (overlayName != nil) {
                ovlLayers[overlayName!] = imageLayer
            }
        }
    
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // This should release the globe view
        if let viewC = baseViewC {
            viewC.view.removeFromSuperview()
            viewC.removeFromParentViewController()
            baseViewC = nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // This tests heading
        //    [self performSelector:@selector(changeHeading:) withObject:@(0.0) afterDelay:1.0];
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector:"changeHeading:", object:nil)
    }
    
//    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//    {
//        return YES;
//    }
    
    // MARK: Data Display
    
    // Change the heading every so often
    func changeHeading(heading: Float) {
        if (globeViewC != nil) {
            globeViewC!.heading = heading
        } else if (mapViewC != nil) {
            mapViewC!.heading = heading
        }

        dispatch_after(1, dispatch_get_main_queue()) {
            self.changeHeading(heading + 1.0/180.0*Float(M_PI))
        }
    }
    
    // Add screen (2D) markers at all our locations
    func addScreenMarkers(locations: [LocationInfo], len: Int, stride: Int, offset: Int) {
        var size: CGSize = CGSize(width: 40, height: 40)
        let pinImage = UIImage(named: "map_pin")!
        var markers: [MaplyScreenMarker] = []

        for var ii = offset; ii < len; ii += stride {
            var location: LocationInfo = locations[ii]
            var marker: MaplyScreenMarker = MaplyScreenMarker()
            marker.image = pinImage
            marker.loc = MaplyCoordinateMakeWithDegrees(location.lon,location.lat)
            marker.size = size
            marker.userObject = location.name
            marker.layoutImportance = MAXFLOAT
            markers.append(marker)
        }
    
        screenMarkersObj = baseViewC.addScreenMarkers(markers, desc:[kMaplyMinVis: 0.0, kMaplyMaxVis: 1.0, kMaplyFade: 1.0])
    }
    
    // Add 3D markers
    func addMarkers(locations: [LocationInfo], len: Int, stride: Int, offset: Int) {
        let size: CGSize = CGSize(width:0.05, height:0.05)
        let startImage = UIImage(named:"Star")!
        var markers: [MaplyScreenMarker] = []

        for var ii = offset; ii < len; ii += stride {
            var location: LocationInfo = locations[ii]
            var marker: MaplyScreenMarker = MaplyScreenMarker()
            marker.image = startImage
            marker.loc = MaplyCoordinateMakeWithDegrees(location.lon,location.lat)
            marker.size = size
            marker.userObject = location.name
            markers.append(marker)
        }
    
        markersObj = baseViewC.addMarkers(markers, desc:nil)
    }
    
    // Add screen (2D) labels
    func addScreenLabels(locations:[LocationInfo], len:Int, stride:Int, offset:Int) {
        var screenLabels: [MaplyScreenLabel] = []

        for var ii = offset; ii < len; ii += stride {
            var location: LocationInfo = locations[ii]
            var label: MaplyScreenLabel = MaplyScreenLabel()
            label.loc = MaplyCoordinateMakeWithDegrees(location.lon,location.lat)
            label.text = location.name
            label.layoutImportance = 2.0
            label.userObject = location.name
            screenLabels.append(label)
        }
        
        screenLabelsObj = baseViewC.addScreenLabels(screenLabels, desc:screenLabelDesc)
    }
    
    // Add 3D labels
    func addLabels(locations:[LocationInfo], len:Int, stride:Int, offset:Int) {
        var size: CGSize = CGSize(width:0, height:0.05)
        var labels: [MaplyLabel] = []

        for var ii = offset; ii < len; ii += stride {
            var location: LocationInfo = locations[ii]
            var label: MaplyLabel = MaplyLabel()
            label.loc = MaplyCoordinateMakeWithDegrees(location.lon,location.lat)
            label.size = size
            label.text = location.name
            label.userObject = location.name
            labels.append(label)
        }
        
        labelsObj = baseViewC.addLabels(labels, desc:labelDesc)
    }
    
    // Add cylinders
    func addShapeCylinders(locations:[LocationInfo], len:Int, stride:Int, offset:Int, desc:[String: AnyObject]) {
        var cyls: [MaplyShapeCylinder] = []

        for var ii = offset; ii < len; ii += stride {
            var location: LocationInfo = locations[ii]
            var cyl: MaplyShapeCylinder = MaplyShapeCylinder()
            cyl.baseCenter = MaplyCoordinateMakeWithDegrees(location.lon, location.lat)
            cyl.radius = 0.01
            cyl.height = 0.06
            cyl.selectable = true
            cyls.append(cyl)
        }
        
        shapeCylObj = baseViewC.addShapes(cyls, desc:desc)
    }
    
    // Add spheres
    func addShapeSpheres(locations:[LocationInfo], len:Int, stride:Int, offset:Int, desc:[String: AnyObject]) {
        var spheres: [MaplyShapeSphere] = []

        for var ii = offset; ii < len; ii += stride {
            var location: LocationInfo = locations[ii]
            var sphere: MaplyShapeSphere = MaplyShapeSphere()
            sphere.center = MaplyCoordinateMakeWithDegrees(location.lon, location.lat)
            sphere.radius = 0.04
            sphere.selectable = true
            spheres.append(sphere)
        }
        
        shapeSphereObj = baseViewC.addShapes(spheres, desc:desc)
    }
    
    // Add spheres
    func addGreatCircles(locations:[LocationInfo], len:Int, stride:Int, offset:Int, desc:[String: AnyObject]) {
        var circles: [MaplyShapeGreatCircle] = []

        for var ii = offset; ii < len; ii += stride {
            var loc0: LocationInfo = locations[ii]
            var loc1: LocationInfo = locations[(ii+1)%len]
            var greatCircle: MaplyShapeGreatCircle = MaplyShapeGreatCircle()

            greatCircle.startPt = MaplyCoordinateMakeWithDegrees(loc0.lon, loc0.lat)
            greatCircle.endPt = MaplyCoordinateMakeWithDegrees(loc1.lon, loc1.lat)
            greatCircle.lineWidth = 6.0

            // This limits the height based on the length of the great circle
            var angle: Float = greatCircle.calcAngleBetween()
            greatCircle.height = Float(0.3 * Double(angle) / M_PI)
            circles.append(greatCircle)
        }
        
        greatCircleObj = baseViewC.addShapes(circles, desc:desc)
    }
    
    func addLines(lonDelta:Float, latDelta:Float, color:UIColor) {
        let desc = [ kMaplyColor:color, kMaplySubdivType:kMaplySubdivSimple, kMaplySubdivEpsilon:0.001, kMaplyVecWidth:4.0 ]
        var vectors: [MaplyVectorObject] = []

        // Longitude lines
        for var lon: Float = -180; lon < 180;lon += lonDelta {
            var coords = [ MaplyCoordinateMakeWithDegrees(lon, -90),
                           MaplyCoordinateMakeWithDegrees(lon, 0),
                           MaplyCoordinateMakeWithDegrees(lon, +90) ]
            
            var vec = MaplyVectorObject(lineString:&coords, numCoords:3, attributes:nil)
            vectors.append(vec)
        }
        // Latitude lines
        for var lat: Float = -90;lat < 90;lat += latDelta {
            var coords = [ MaplyCoordinateMakeWithDegrees(-180, lat),
                           MaplyCoordinateMakeWithDegrees(-90, lat),
                           MaplyCoordinateMakeWithDegrees(0, lat),
                           MaplyCoordinateMakeWithDegrees(90, lat),
                           MaplyCoordinateMakeWithDegrees(+180, lat) ]
            var vec: MaplyVectorObject = MaplyVectorObject(lineString:&coords, numCoords:5, attributes:nil)
            vectors.append(vec)
        }
        
        latLonObj = baseViewC.addVectors(vectors, desc:desc)
    }
    
    func addWideVectors(vecObj:MaplyVectorObject) -> [MaplyComponentObject] {
        let color: UIColor = UIColor.blueColor()
        let fade: Float = 0.25
        
        var lines: MaplyComponentObject = baseViewC.addVectors([vecObj], desc:[ kMaplyColor: color,
            kMaplyVecWidth: 4.0,
            kMaplyFade: fade,
            kMaplyVecCentered: true,
            kMaplyMaxVis: 10.0,
            kMaplyMinVis: 0.00032424763776361942 ] )
        
        var screenLines: MaplyComponentObject = baseViewC.addWideVectors([vecObj], desc:[ kMaplyColor: UIColor.redColor(),
            kMaplyFade: fade,
            kMaplyVecWidth: 4.0,
            kMaplyVecTexture: dashedLineTex!,
            kMaplyWideVecCoordType: kMaplyWideVecCoordTypeScreen,
            kMaplyWideVecJoinType: kMaplyWideVecMiterJoin,
            kMaplyWideVecMiterLimit: 1.01,
            kMaplyWideVecTexRepeatLen: 8,
            kMaplyMaxVis: 0.00032424763776361942,
            kMaplyMinVis: 0.00011049506429117173 ] )
        
        var realLines: MaplyComponentObject = baseViewC.addWideVectors([vecObj], desc:[ kMaplyColor: color,
            kMaplyFade: fade,
            kMaplyVecTexture: dashedLineTex!,
            // 8m in display coordinates
            kMaplyVecWidth: 10.0/6371000,
            kMaplyWideVecCoordType: kMaplyWideVecCoordTypeReal,
            kMaplyWideVecJoinType: kMaplyWideVecMiterJoin,
            kMaplyWideVecMiterLimit: 1.01,
            // Repeat every 10m
            kMaplyWideVecTexRepeatLen: 10/6371000,
            kMaplyMaxVis: 0.00011049506429117173,
            kMaplyMinVis: 0.0 ] )
        
        // Look for some labels
        var labels: [MaplyScreenLabel] = []
        for road in vecObj.splitVectors() as [MaplyVectorObject] {
            var middle = MaplyCoordinate(x: 0.0, y: 0.0)
            var rot: Double = 0.0

            // Note: We should get this from the view controller
            let coordSys: MaplyCoordinateSystem = MaplySphericalMercator(webStandard:())
            road.linearMiddle(&middle, rot:&rot, displayCoordSys:coordSys)
            
            var roadAttributes = road.attributes
            var name = roadAttributes["FULLNAME"] as String?
            
            if (name != nil) {
                var label: MaplyScreenLabel = MaplyScreenLabel()
                label.loc = middle
                label.text = name
                label.layoutImportance = 1.0
                label.rotation = Float(rot + M_PI/2.0)
                label.keepUpright = true
                label.layoutImportance = Float(kMaplyLayoutBelow)
                labels.append(label)
            }
        }

        var labelObj = baseViewC.addScreenLabels(labels, desc:
                                    [ kMaplyTextOutlineSize: 1.0,
                                        kMaplyTextOutlineColor: UIColor.blackColor(),
                                        kMaplyFont: UIFont.systemFontOfSize(18.0) ] )
        
        return [lines, screenLines, realLines, labelObj]
    }
    
    func addShapeFile(shapeFileName: String) {
        // Make the dashed line if it isn't already there
        if (dashedLineTex == nil) {
            var lineTexBuilder = MaplyLinearTextureBuilder(size:CGSize(width:4, height:8))
            lineTexBuilder.setPattern([4, 4])
            lineTexBuilder.opacityFunc = MaplyOpacitySin2
            var dashedLineImage = lineTexBuilder.makeImage()
            dashedLineTex = baseViewC.addTexture(dashedLineImage, imageFormat:MaplyImageIntRGBA, wrapFlags:MaplyImageWrapY, mode:MaplyThreadAny)
        }
        if (filledLineTex == nil) {
            var lineTexBuilder = MaplyLinearTextureBuilder(size:CGSize(width:8, height:32))
            lineTexBuilder.setPattern([32])
            lineTexBuilder.opacityFunc = MaplyOpacitySin2
            var lineImage = lineTexBuilder.makeImage()
            filledLineTex = baseViewC.addTexture(lineImage, imageFormat:MaplyImageIntRGBA, wrapFlags:MaplyImageWrapY, mode:MaplyThreadAny)
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // Add the vectors at three different levels
            var vecDb: MaplyVectorDatabase? = MaplyVectorDatabase(shape:shapeFileName)
            if (vecDb != nil) {
                var vecObj = vecDb!.fetchAllVectors()
                if (vecObj != nil) {
                    self.sfRoadsObjArray = self.addWideVectors(vecObj!)
                }
            }
        }
    }
    
    func addStickers(locations:[LocationInfo], len:Int, stride:Int, offset:Int, desc:[String: AnyObject]) {
        let startImage = UIImage(named:"Smiley_Face_Avatar_by_PixelTwist")!
        
        var stickers: [MaplySticker] = []
        for var ii=offset; ii<len; ii+=stride {
            var location: LocationInfo = locations[ii]
             var sticker: MaplySticker = MaplySticker()

            // Stickers are sized in geographic (because they're for KML ground overlays).  Bleah.
            sticker.ll = MaplyCoordinateMakeWithDegrees(location.lon, location.lat)
            sticker.ur = MaplyCoordinateMakeWithDegrees(location.lon+10.0, location.lat+10.0)
            sticker.image = startImage
            // And a random rotation
            //        sticker.rotation = 2*M_PI * drand48();
            stickers.append(sticker)
        }
        
        stickersObj = baseViewC.addStickers(stickers, desc:desc)
    }
    
    // Add country outlines.  Pass in the names of the geoJSON files
    func addCountries(names:[String], stride:Int) {
        // Parsing the JSON can take a while, so let's hand that over to another queue
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)) {
            var locVecObjects: [MaplyComponentObject] = []
            var locAutoLabels: [MaplyScreenLabel] = []
            
            var ii = 0
            for name in names {
                if (ii % stride == 0) {
                    if let fileName = NSBundle.mainBundle().pathForResource(name, ofType:"geojson") {
                        var jsonData: NSData? = NSData(contentsOfFile:fileName)
                        if (jsonData != nil) {
                            var wgVecObj = MaplyVectorObject(fromGeoJSON:jsonData!)
                            var compObj: MaplyComponentObject? = nil

                            if let vecAttrs = wgVecObj.attributes {
                                var vecName: AnyObject? = vecAttrs["ADMIN"]
                                wgVecObj.userObject = vecName as NSObject
                                compObj = self.baseViewC.addVectors([wgVecObj], desc:self.vectorDesc)
                                var screenLabel = MaplyScreenLabel()
                                
                                // Add a label right in the middle
                                var center: MaplyCoordinate = MaplyCoordinate(x: 0.0, y:0.0)
                                if (wgVecObj.centroid(&center)) {
                                    screenLabel.loc = center
                                    screenLabel.layoutImportance = 1.0
                                    screenLabel.text = vecName as String
                                    screenLabel.userObject = screenLabel.text
                                    screenLabel.selectable = true
                                    if (screenLabel.text != nil) {
                                        locAutoLabels.append(screenLabel)
                                    }
                                }
                            }
                            if (compObj != nil) {
                                locVecObjects.append(compObj!)
                            }
                        }
                    }
                }
                ii++
            }
            
            // Keep track of the created objects
            // Note: You could lose track of the objects if you turn the countries on/off quickly
            dispatch_async(dispatch_get_main_queue()) {
                // Toss in all the labels at once, more efficient
                var autoLabelObj = self.baseViewC.addScreenLabels(locAutoLabels, desc:
                [ kMaplyTextColor: UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0),
                kMaplyFont: UIFont.systemFontOfSize(24.0),
                kMaplyTextOutlineColor: UIColor.blackColor(),
                kMaplyTextOutlineSize: 1.0
                // kMaplyShadowSize: 1.0
                ],
                 mode:MaplyThreadAny)
                
                self.vecObjects = locVecObjects
                self.autoLabels = autoLabelObj
            }
        }
    }
    
    // Number of markers to whip up for the large test case
    let NumMegaMarkers: Int = 40000
    
    // Make up a large number of markers and add them
    func addMegaMarkers() {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let image = UIImage(named:"map_pin.png")!
            
            var markers: [MaplyScreenMarker] = []
            for ii in 0..<self.NumMegaMarkers {
                var marker: MaplyScreenMarker = MaplyScreenMarker()
                marker.image = image
                marker.size = CGSize(width:40, height:40)
                marker.loc = MaplyCoordinateMakeWithDegrees(Float(drand48())*360.0-180.0, Float(drand48())*140.0-70.0)
                marker.layoutImportance = Float(drand48())
                markers.append(marker)
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.megaMarkersObj = self.baseViewC.addScreenMarkers(markers, desc:nil)
            }
        }
    }
    
    // Create an animated sphere
    func addAnimatedSphere() {
        var animSphere = AnimatedSphere(period:20.0, radius:0.01, color:UIColor.orangeColor(), viewC:baseViewC)
        baseViewC.addActiveObject(animSphere)
    }
    
    // Set this to reload the base layer ever so often.  Purely for testing
    //#define RELOADTEST 1
    
    // Set up the base layer depending on what they've picked.
    // Also tear down an old one
    func setupBaseLayer(baseSettings: [NSObject: AnyObject]) {
        // Figure out which one we're supposed to display
        var newBaseLayerName: String? = nil
        for (key, value) in baseSettings {
            if (value as Bool)
            {
                newBaseLayerName = key as? String
                break
            }
        }
        
        // Didn't change
        if (newBaseLayerName == baseLayerName) {
            return
        }
        
        // Tear down the old layer
        if (baseLayer != nil) {
            baseLayerName = nil
            baseViewC.removeLayer(baseLayer)
            baseLayer = nil
        }

        baseLayerName = newBaseLayerName
        
        // For network paging layers, where we'll store temp files
        let cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String
        
        // We'll pick default colors for the labels
        var screenLabelColor = UIColor.whiteColor()
        var screenLabelBackColor = UIColor.clearColor()
        var labelColor = UIColor.whiteColor()
        var labelBackColor = UIColor.clearColor()
        // And for the vectors to stand out
        var vecColor = UIColor.whiteColor()
        var vecWidth = 4.0
        
        var jsonTileSpec: String? = nil
        var thisCacheDir: String? = nil
        
//        #ifdef RELOADTEST
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadLayer:) object:nil];
//        #endif
        
        switch baseLayerName {
    
        case kMaplyTestGeographyClass:
            title = "Geography Class - MBTiles Local"
            // This is the Geography Class MBTiles data set from MapBox
            var tileSource = MaplyMBTileSource(MBTiles:"geography-class_medres")
            var layer = MaplyQuadImageTilesLayer(coordSystem:tileSource.coordSys, tileSource:tileSource)
            baseLayer = layer
            layer.handleEdges = (globeViewC != nil)
            layer.coverPoles = (globeViewC != nil)
            layer.requireElev = requireElev
            layer.waitLoad = imageWaitLoad
            layer.drawPriority = 0
            layer.singleLevelLoading = (startupMapType == .Map2D)
            baseViewC.addLayer(layer)
            
            labelColor = UIColor.blackColor()
            labelBackColor = UIColor.whiteColor()
            vecColor = UIColor(red:0.4, green:0.4, blue:0.4, alpha:1.0)
            
//            #ifdef RELOADTEST
//            [self performSelector:@selector(reloadLayer:) withObject:nil afterDelay:10.0];
//            #endif

        case kMaplyTestBlueMarble:
            title = "Blue Marble Single Res"
            if (globeViewC != nil) {
                // This is the static image set, included with the app, built with ImageChopper
                var layer = globeViewC!.addSphericalEarthLayerWithImageSetName("lowres_wtb_info")
                baseLayer = layer
                layer.drawPriority = 0
                screenLabelColor = UIColor.whiteColor()
                screenLabelBackColor = UIColor.whiteColor()
                labelColor = UIColor.blackColor()
                labelBackColor = UIColor.whiteColor()
                vecColor = UIColor.whiteColor()
                vecWidth = 4.0
            }

        case kMaplyTestStamenWatercolor:
            title = "Stamen Water Color - Remote"
            // These are the Stamen Watercolor tiles.
            // They're beautiful, but the server isn't so great.
            var thisCacheDir = "\(cacheDir)/stamentiles/"
            var maxZoom: Int32 = 10
            if (zoomLimit != 0 && zoomLimit < maxZoom) {
                maxZoom = zoomLimit
            }
            var tileSource = MaplyRemoteTileSource(baseURL:"http://tile.stamen.com/watercolor/", ext:"png", minZoom:0, maxZoom:maxZoom)
            tileSource.cacheDir = thisCacheDir
            var layer = MaplyQuadImageTilesLayer(coordSystem:tileSource.coordSys, tileSource:tileSource)
            layer.handleEdges = true
            layer.requireElev = requireElev
            baseViewC.addLayer(layer)
            layer.drawPriority = 0
            layer.waitLoad = imageWaitLoad
            layer.singleLevelLoading = (startupMapType == .Map2D)
            baseLayer = layer
            screenLabelColor = UIColor.whiteColor()
            screenLabelBackColor = UIColor.whiteColor()
            labelColor = UIColor.blackColor()
            labelBackColor = UIColor.blackColor()
            vecColor = UIColor.grayColor()
            vecWidth = 4.0

        case kMaplyTestOSM:
            title = "OpenStreetMap - Remote"
            // This points to the OpenStreetMap tile set hosted by MapQuest (I think)
            var thisCacheDir = "\(cacheDir)/osmtiles/"
            var maxZoom: Int32 = 18
            if (zoomLimit != 0 && zoomLimit < maxZoom) {
                maxZoom = zoomLimit
            }

            var tileSource = MaplyRemoteTileSource(baseURL:"http://otile1.mqcdn.com/tiles/1.0.0/osm/", ext:"png", minZoom:0, maxZoom:maxZoom)
            tileSource.cacheDir = thisCacheDir
            var layer = MaplyQuadImageTilesLayer(coordSystem:tileSource.coordSys, tileSource:tileSource)
            layer.drawPriority = 0
            layer.handleEdges = true
            layer.requireElev = requireElev
            layer.waitLoad = imageWaitLoad
            layer.maxTiles = maxLayerTiles
            layer.singleLevelLoading = (startupMapType == .Map2D)
            baseViewC.addLayer(layer)
            layer.drawPriority = 0
            baseLayer = layer
            screenLabelColor = UIColor.whiteColor()
            screenLabelBackColor = UIColor.whiteColor()
            labelColor = UIColor.blackColor()
            labelBackColor = UIColor.whiteColor()
            vecColor = UIColor.blackColor()
            vecWidth = 4.0

        case kMaplyTestMapBoxSat:
            title = "MapBox Tiles Satellite - Remote"
            jsonTileSpec = "http://a.tiles.mapbox.com/v3/examples.map-zyt2v9k2.json"
            thisCacheDir = "\(cacheDir)/mbtilessat1/"
            screenLabelColor = UIColor.whiteColor()
            screenLabelBackColor = UIColor.whiteColor()
            labelColor = UIColor.blackColor()
            labelBackColor = UIColor.whiteColor()
            vecColor = UIColor.whiteColor()
            vecWidth = 4.0

        case kMaplyTestMapBoxTerrain:
            title = "MapBox Tiles Terrain - Remote"
            jsonTileSpec = "http://a.tiles.mapbox.com/v3/examples.map-zq0f1vuc.json"
            thisCacheDir = "\(cacheDir)/mbtilesterrain1/"
            screenLabelColor = UIColor.whiteColor()
            screenLabelBackColor = UIColor.whiteColor()
            labelColor = UIColor.blackColor()
            labelBackColor = UIColor.whiteColor()
            vecColor = UIColor.blackColor()
            vecWidth = 4.0

        case kMaplyTestMapBoxRegular:
            title = "MapBox Tiles Regular - Remote"
            jsonTileSpec = "http://a.tiles.mapbox.com/v3/examples.map-zswgei2n.json"
            thisCacheDir = "\(cacheDir)/mbtilesregular1/"
            screenLabelColor = UIColor.whiteColor()
            screenLabelBackColor = UIColor.whiteColor()
            labelColor = UIColor.blackColor()
            labelBackColor = UIColor.whiteColor()
            vecColor = UIColor.blackColor()
            vecWidth = 4.0

        case kMaplyTestQuadTest:
            title = "Quad Paging Test Layer"
            screenLabelColor = UIColor.whiteColor()
            screenLabelBackColor = UIColor.whiteColor()
            labelColor = UIColor.blackColor()
            labelBackColor = UIColor.whiteColor()
            vecColor = UIColor.blackColor()
            vecWidth = 4.0
            var tileSource = MaplyAnimationTestTileSource(coordSys:MaplySphericalMercator(webStandard:()), minZoom:0, maxZoom:21, depth:1)
            tileSource.pixelsPerSide = 128
            var layer = MaplyQuadImageTilesLayer(coordSystem:tileSource.coordSys, tileSource:tileSource)
            layer.waitLoad = imageWaitLoad
            layer.requireElev = requireElev
            layer.maxTiles = 512
            layer.singleLevelLoading = (startupMapType == .Map2D)
            layer.color = UIColor(white:1.0, alpha:0.75)
            baseViewC.addLayer(layer)
            layer.drawPriority = 0
            baseLayer = layer

        case kMaplyTestQuadVectorTest:
            title = "Quad Paging Test Layer"
            screenLabelColor = UIColor.whiteColor()
            screenLabelBackColor = UIColor.whiteColor()
            labelColor = UIColor.blackColor()
            labelBackColor = UIColor.whiteColor()
            vecColor = UIColor.blackColor()
            vecWidth = 4.0
            var tileSource = MaplyPagingVectorTestTileSource(coordSys:MaplySphericalMercator(webStandard:()), minZoom:0, maxZoom:10)
            var layer = MaplyQuadPagingLayer(coordSystem:tileSource.coordSys, delegate:tileSource)
            layer.importance = 128*128
            layer.singleLevelLoading = (startupMapType == .Map2D)
            baseViewC.addLayer(layer)
            layer.drawPriority = 0
            baseLayer = layer

        case kMaplyTestQuadTestAnimate:
            title = "Quad Paging Test Layer (animated)"
            screenLabelColor = UIColor.whiteColor()
            screenLabelBackColor = UIColor.whiteColor()
            labelColor = UIColor.blackColor()
            labelBackColor = UIColor.whiteColor()
            vecColor = UIColor.blackColor()
            vecWidth = 4.0
            var tileSource = MaplyAnimationTestTileSource(coordSys:MaplySphericalMercator(webStandard:()), minZoom:0, maxZoom:17, depth:4)
            tileSource.pixelsPerSide = 128
            var layer = MaplyQuadImageTilesLayer(coordSystem:tileSource.coordSys, tileSource:tileSource)
            layer.waitLoad = imageWaitLoad
            layer.requireElev = requireElev
            layer.imageDepth = 4
            // We'll cycle through at 1s per layer
            layer.animationPeriod = 4.0
            layer.singleLevelLoading = (startupMapType == .Map2D)
            baseViewC.addLayer(layer)
            layer.drawPriority = 0
            baseLayer = layer

            // Nothing to see here
            default:
                true
        }
        
        // If we're fetching one of the JSON tile specs, kick that off
        if (jsonTileSpec != nil) {
            if let url = NSURL(string:jsonTileSpec!) {
                var request = NSURLRequest(URL:url)
                
                var operation = AFHTTPRequestOperation(request:request)
                operation.responseSerializer = AFJSONResponseSerializer.sharedSerializer()
                
                operation.setCompletionBlockWithSuccess(
                    { ( op: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                        // Add a quad earth paging layer based on the tile spec we just fetched
                        var tileSource = MaplyRemoteTileSource(tilespec:responseObject as Dictionary)
                        tileSource.cacheDir = thisCacheDir
                        if (self.zoomLimit != 0 && self.zoomLimit < tileSource.maxZoom()) {
                            tileSource.tileInfo.maxZoom = self.zoomLimit
                        }
                        var layer = MaplyQuadImageTilesLayer(coordSystem:tileSource.coordSys, tileSource:tileSource)
                        layer.handleEdges = true
                        layer.waitLoad = self.imageWaitLoad
                        layer.requireElev = self.requireElev
                        layer.maxTiles = self.maxLayerTiles
                        if (self.startupMapType == .Map2D) {
                            layer.singleLevelLoading = true
                            layer.multilLevelLoads = [-4, -2]
                        }
                        self.baseViewC.addLayer(layer)
                        layer.drawPriority = 0
                        self.baseLayer = layer
                        
                        //                #ifdef RELOADTEST
                        //                [self performSelector:@selector(reloadLayer:) withObject:nil afterDelay:10.0];
                        //                #endif
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        NSLog("Failed to reach JSON tile spec at: %@", jsonTileSpec!)
                })
                
                operation.start()
            }
        }
        
        // Set up some defaults for display
        screenLabelDesc = [ kMaplyTextColor: screenLabelColor,
//                          kMaplyBackgroundColor: screenLabelBackColor,
                            kMaplyFade: 1.0,
                            kMaplyTextOutlineSize: 1.5,
                            kMaplyTextOutlineColor: UIColor.blackColor() ]
                            labelDesc = [ kMaplyTextColor: labelColor,
                            kMaplyBackgroundColor: labelBackColor,
                            kMaplyFade: 1.0 ]
                            vectorDesc = [ kMaplyColor: vecColor,
                            kMaplyVecWidth: vecWidth,
                            kMaplyFade: 1.0,
                            kMaplySelectable: true ]
    }
    
    // Reload testing
    func reloadLayer(layer:MaplyQuadImageTilesLayer?) {
        if (baseLayer != nil && (baseLayer is MaplyQuadImageTilesLayer)) {
            var layer: MaplyQuadImageTilesLayer = baseLayer as MaplyQuadImageTilesLayer
            NSLog("Reloading layer")
            layer.reload()
            
            dispatch_after(10, dispatch_get_main_queue(), {
                self.reloadLayer(nil)
            })
        }
    }
    
    // Run through the overlays the user wants turned on
    func setupOverlays(baseSettings:[NSObject: AnyObject]) {
        // For network paging layers, where we'll store temp files
        var cacheDir = (NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String)
        var thisCacheDir: String? = nil
        
        for (layerNameObj, isOnObj) in baseSettings {
            var layerName = layerNameObj as String
            var isOn = isOnObj as Bool
            var layer = ovlLayers[layerName]
            // Need to create the layer
            if (isOn && layer == nil) {
                switch layerName {

                case kMaplyTestUSGSOrtho:
                    thisCacheDir = "\(cacheDir)/usgs_naip/"
                    fetchWMSLayer("http://raster.nationalmap.gov/ArcGIS/services/Orthoimagery/USGS_EDC_Ortho_NAIP/ImageServer/WMSServer", layerName:"0", styleName:nil, cacheDir:thisCacheDir!, overlayName:layerName)

                case kMaplyTestOWM:
                    var tileSource = MaplyRemoteTileSource(baseURL:"http://tile.openweathermap.org/map/precipitation/", ext:"png", minZoom:0, maxZoom:6)
                    tileSource.cacheDir = "\(cacheDir)/openweathermap_precipitation/"
                    tileSource.tileInfo.cachedFileLifetime = 3 * 60 * 60 // invalidate OWM data after three hours
                    var weatherLayer = MaplyQuadImageTilesLayer(coordSystem:tileSource.coordSys, tileSource:tileSource)
                    weatherLayer.coverPoles = false
                    layer = weatherLayer
                    weatherLayer.handleEdges = false
                    baseViewC.addLayer(weatherLayer)
                    ovlLayers[layerName] = layer

                case kMaplyTestForecastIO:
                    // Collect up the various precipitation sources
                    var tileSources: [MaplyRemoteTileInfo] = []
                    for ii in 0...4 {
                        var theURL: String = "http://a.tiles.mapbox.com/v3/mousebird.precip-example-layer\(ii)/"
                        var precipTileSource = MaplyRemoteTileInfo(baseURL:theURL, ext:"png", minZoom:0, maxZoom:6)
                        precipTileSource.cacheDir = "\(cacheDir)/forecast_io_weather_layer\(ii)/"
                        tileSources.append(precipTileSource)
                    }
                    var precipTileSource = MaplyMultiplexTileSource(sources:tileSources)
                    // Create a precipitation layer that animates
                    var precipLayer = MaplyQuadImageTilesLayer(coordSystem:precipTileSource.coordSys, tileSource:precipTileSource)
                    precipLayer.imageDepth = UInt32(tileSources.count)
                    precipLayer.animationPeriod = 6.0
                    precipLayer.imageFormat = MaplyImageUByteRed
                    //                precipLayer.texturAtlasSize = 512
                    precipLayer.numSimultaneousFetches = 4
                    precipLayer.handleEdges = false
                    precipLayer.coverPoles = false
                    precipLayer.shaderProgramName = WeatherShader.setupWeatherShader(baseViewC)
                    baseViewC.addLayer(precipLayer)
                    layer = precipLayer
                    ovlLayers[layerName] = layer

                case kMaplyTestMapboxStreets:
                    title = "Mapbox Vector Streets"
                    thisCacheDir = "\(cacheDir)/mapbox-streets-vectiles"
                    MaplyMapnikVectorTiles.StartRemoteVectorTilesWithTileSpec("http://a.tiles.mapbox.com/v3/mapbox.mapbox-streets-v4.json",
                        style:NSBundle.mainBundle().pathForResource("osm-bright", ofType:"xml"),
                        cacheDir:thisCacheDir,
                        viewC:baseViewC,
                        success: { ( vecTiles: MaplyMapnikVectorTiles!) in
                                // Don't load the lowest levels for the globe
                                if (self.globeViewC != nil) {
                                    vecTiles.minZoom = 5
                                }

                                // Note: These are set after the MapnikStyleSet has already been initialized
                                var styleSet = vecTiles.styleDelegate as MapnikStyleSet
                                styleSet.tileStyleSettings.markerImportance = 10.0
                                styleSet.tileStyleSettings.fontName = "Gill Sans"
                                
                                // Now for the paging layer itself
                                var pageLayer = MaplyQuadPagingLayer(coordSystem:MaplySphericalMercator(webStandard:()), delegate:vecTiles)
                                pageLayer.numSimultaneousFetches = 6
                                pageLayer.flipY = false
                                pageLayer.importance = 1024*1024*2
                                pageLayer.useTargetZoomLevel = true
                                pageLayer.singleLevelLoading = true
                                self.baseViewC.addLayer(pageLayer)
                                self.ovlLayers[layerName] = pageLayer
                            },
                        failure:
                            { ( error: NSError!) in
                                NSLog("Failed to load Mapnik vector tiles because: %@",error)
                            }
                    )

                case kMaplyMapzenVectors:
                    var thisCacheDir = "\(cacheDir)/mapzen-vectiles"

                    MaplyMapnikVectorTiles.StartRemoteVectorTilesWithURL("http://vector.mapzen.com/osm/all/",
                        ext:"mapbox",
                        minZoom:8,
                        maxZoom:14,
                        style:NSBundle.mainBundle().pathForResource("MapzenStyles", ofType:"json"),
                        cacheDir:thisCacheDir,
                        viewC:baseViewC,
                        success: { (vecTiles: MaplyMapnikVectorTiles!) in
                            // Now for the paging layer itself
                            var pageLayer = MaplyQuadPagingLayer(coordSystem:MaplySphericalMercator(webStandard:()), delegate:vecTiles)
                            pageLayer.numSimultaneousFetches = 4
                            pageLayer.flipY = false
                            pageLayer.importance = 1024*1024
                            pageLayer.useTargetZoomLevel = true
                            pageLayer.singleLevelLoading = true
                            self.baseViewC.addLayer(pageLayer)
                            self.ovlLayers[layerName] = pageLayer
                        },
                        failure: { ( error: NSError!) in
                            NSLog("Failed to load Mapnik vector tiles because: %@",error)
                        }
                    )

                default:
                    true
                }
            } else if (!isOn && layer != nil) {
                // Get rid of the layer
                baseViewC.removeLayer(layer)
                ovlLayers[layerName] = nil
            }
        }
        
        // Fill out the cache dir if there is one
        if (thisCacheDir != nil) {
            var error: NSError? = nil
            NSFileManager.defaultManager().createDirectoryAtPath(thisCacheDir!, withIntermediateDirectories:true, attributes:nil, error:&error)
        }
    }
    
    // Look at the configuration controller and decide what to turn off or on
    func changeMapContents() {

        imageWaitLoad = configViewC.valueForSection(kMaplyTestCategoryInternal, row:kMaplyTestWaitLoad)
        
        var baseSection = configViewC.values[0] as ConfigViewController.ConfigSection
        setupBaseLayer(baseSection.rows)
        if (configViewC.values.count > 1) {
            var setupSection = configViewC.values[1] as ConfigViewController.ConfigSection
            setupOverlays(setupSection.rows)
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestLabel2D)) {
            if (screenLabelsObj == nil) {
                addScreenLabels(locations, len:locations.count, stride:4, offset:0)
            }
        } else {
            if (screenLabelsObj != nil) {
                baseViewC.removeObject(screenLabelsObj)
                screenLabelsObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestLabel3D)) {
            if (labelsObj == nil) {
                addLabels(locations, len:locations.count, stride:4, offset:1)
            }
        } else {
            if (labelsObj != nil) {
                baseViewC.removeObject(labelsObj)
                labelsObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestMarker2D)) {
            if (screenMarkersObj == nil) {
                addScreenMarkers(locations, len:locations.count, stride:4, offset:2)
            }
        } else {
            if (screenMarkersObj != nil) {
                baseViewC.removeObject(screenMarkersObj)
                screenMarkersObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestMarker3D)) {
            if (markersObj == nil) {
                addMarkers(locations, len:locations.count, stride:4, offset:3)
            }
        } else {
            if (markersObj != nil) {
                baseViewC.removeObject(markersObj)
                markersObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestSticker)) {
            if (stickersObj == nil) {
                addStickers(locations, len:locations.count, stride:4, offset:2, desc:[ kMaplyFade: 1.0 ])
            }
        } else {
            if (stickersObj != nil) {
                baseViewC.removeObject(stickersObj)
                stickersObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestShapeCylinder)) {
            if (shapeCylObj == nil) {
                addShapeCylinders(locations, len:locations.count, stride:4, offset:0, desc:[ kMaplyColor: UIColor(red:0.0, green:0.0, blue:1.0, alpha:0.8), kMaplyFade: 1.0 ])
            }
        } else {
            if (shapeCylObj != nil) {
                baseViewC.removeObject(shapeCylObj)
                shapeCylObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestShapeSphere))
        {
            if (shapeSphereObj == nil) {
                addShapeSpheres(locations, len:locations.count, stride:4, offset:1, desc:[ kMaplyColor: UIColor(red:1.0, green:0.0, blue:0.0, alpha:0.8), kMaplyFade: 1.0 ])
            }
        } else {
            if (shapeSphereObj != nil) {
                baseViewC.removeObject(shapeSphereObj)
                shapeSphereObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestShapeGreatCircle)) {
            if (greatCircleObj == nil) {
                addGreatCircles(locations, len:locations.count, stride:4, offset:2, desc:[ kMaplyColor: UIColor(red:1.0, green:0.1, blue:0.0, alpha:1.0), kMaplyFade: 1.0 ])
            }
        } else {
            if (greatCircleObj != nil) {
                baseViewC.removeObject(greatCircleObj)
                greatCircleObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestLatLon)) {
            if (latLonObj == nil) {
                addLines(20, latDelta:10, color:UIColor.blueColor())
            }
        } else {
            if (latLonObj != nil) {
                baseViewC.removeObject(latLonObj)
                latLonObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestRoads))
        {
            if (sfRoadsObjArray == nil)
            {
                addShapeFile("tl_2013_06075_roads")
                //            MaplyCoordinate coords[5];
                //            coords[0] = MaplyCoordinateMakeWithDegrees(-122.3, 37.7);
                //            coords[1] = MaplyCoordinateMakeWithDegrees(-122.3, 37.783333);
                //            coords[2] = MaplyCoordinateMakeWithDegrees(-122.3, 37.783333);
                //            coords[3] = MaplyCoordinateMakeWithDegrees(-122.416667, 37.8333);
                //            MaplyVectorObject *vecObj = [[MaplyVectorObject alloc] initWithLineString:coords numCoords:4 attributes:nil];
                //            sfRoadsObjArray = [self addWideVectors:vecObj];
            }
        } else {
            if (sfRoadsObjArray != nil) {
                baseViewC.removeObjects(sfRoadsObjArray)
                sfRoadsObjArray = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestCountry)) {
            // Countries we have geoJSON for
            let countryArray = [
                "ABW", "AFG", "AGO", "AIA", "ALA", "ALB", "AND", "ARE", "ARG", "ARM", "ASM", "ATA", "ATF", "ATG", "AUS", "AUT",
                "AZE", "BDI", "BEL", "BEN", "BES", "BFA", "BGD", "BGR", "BHR", "BHS", "BIH", "BLM", "BLR", "BLZ", "BMU", "BOL",
                "BRA", "BRB", "BRN", "BTN", "BVT", "BWA", "CAF", "CAN", "CCK", "CHE", "CHL", "CHN", "CIV", "CMR", "COD", "COG",
                "COK", "COL", "COM", "CPV", "CRI", "CUB", "CUW", "CXR", "CYM", "CYP", "CZE", "DEU", "DJI", "DMA", "DNK", "DOM",
                "DZA", "ECU", "EGY", "ERI", "ESH", "ESP", "EST", "ETH", "FIN", "FJI", "FLK", "FRA", "FRO", "FSM", "GAB", "GBR",
                "GEO", "GGY", "GHA", "GIB", "GIN", "GLP", "GMB", "GNB", "GNQ", "GRC", "GRD", "GRL", "GTM", "GUF", "GUM", "GUY",
                "HKG", "HMD", "HND", "HRV", "HTI", "HUN", "IDN", "IMN", "IND", "IOT", "IRL", "IRN", "IRQ", "ISL", "ISR", "ITA",
                "JAM", "JEY", "JOR", "JPN", "KAZ", "KEN", "KGZ", "KHM", "KIR", "KNA", "KOR", "KWT", "LAO", "LBN", "LBR", "LBY",
                "LCA", "LIE", "LKA", "LSO", "LTU", "LUX", "LVA", "MAC", "MAF", "MAR", "MCO", "MDA", "MDG", "MDV", "MEX", "MHL",
                "MKD", "MLI", "MLT", "MMR", "MNE", "MNG", "MNP", "MOZ", "MRT", "MSR", "MTQ", "MUS", "MWI", "MYS", "MYT", "NAM",
                "NCL", "NER", "NFK", "NGA", "NIC", "NIU", "NLD", "NOR", "NPL", "NRU", "NZL", "OMN", "PAK", "PAN", "PCN", "PER",
                "PHL", "PLW", "PNG", "POL", "PRI", "PRK", "PRT", "PRY", "PSE", "PYF", "QAT", "REU", "ROU", "RUS", "RWA", "SAU",
                "SDN", "SEN", "SGP", "SGS", "SHN", "SJM", "SLB", "SLE", "SLV", "SMR", "SOM", "SPM", "SRB", "SSD", "STP", "SUR",
                "SVK", "SVN", "SWE", "SWZ", "SXM", "SYC", "SYR", "TCA", "TCD", "TGO", "THA", "TJK", "TKL", "TKM", "TLS", "TON",
                "TTO", "TUN", "TUR", "TUV", "TWN", "TZA", "UGA", "UKR", "UMI", "URY", "USA", "UZB", "VAT", "VCT", "VEN", "VGB",
                "VIR", "VNM", "VUT", "WLF", "WSM", "YEM", "ZAF", "ZMB", "ZWE" ]
            
            if (vecObjects == nil) {
                addCountries(countryArray, stride:1)
            }
        } else {
            if (vecObjects != nil) {
                baseViewC.removeObjects(vecObjects)
                vecObjects = nil
            }
            if (autoLabels != nil) {
                baseViewC.removeObject(autoLabels)
                autoLabels = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestLoftedPoly)) {
        } else {
            if (loftPolyDict.count > 0) {
                for value in loftPolyDict.values {
                    baseViewC.removeObject(value)
                }
                loftPolyDict = [:]
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestMegaMarkers)) {
            if (megaMarkersObj == nil) {
                addMegaMarkers()
            }
        } else {
            if (megaMarkersObj != nil) {
                baseViewC.removeObject(megaMarkersObj)
                megaMarkersObj = nil
            }
        }
        
        if (configViewC.valueForSection(kMaplyTestCategoryAnimation, row:kMaplyTestAnimateSphere)) {
            if (animSphere == nil) {
                addAnimatedSphere()
            }
        } else {
            if (animSphere != nil) {
                baseViewC.removeActiveObject(animSphere)
                animSphere = nil
            }
        }
        
        baseViewC.performanceOutput = configViewC.valueForSection(kMaplyTestCategoryInternal, row:kMaplyTestPerf)
        
        if let viewC = globeViewC {
            viewC.keepNorthUp = configViewC.valueForSection(kMaplyTestCategoryGestures, row:kMaplyTestNorthUp)
            viewC.pinchGesture = configViewC.valueForSection(kMaplyTestCategoryGestures, row:kMaplyTestPinch)
            viewC.rotateGesture = configViewC.valueForSection(kMaplyTestCategoryGestures, row:kMaplyTestRotate)
        } else {
            if(configViewC.valueForSection(kMaplyTestCategoryGestures, row:kMaplyTestNorthUp)) {
                mapViewC!.heading = 0.0
            }
            mapViewC!.pinchGesture = configViewC.valueForSection(kMaplyTestCategoryGestures, row:kMaplyTestPinch)
            mapViewC!.rotateGesture = configViewC.valueForSection(kMaplyTestCategoryGestures, row:kMaplyTestRotate)
        }
        
        // Update rendering hints
        baseViewC.setHints([ kMaplyRenderHintCulling: configViewC.valueForSection(kMaplyTestCategoryInternal, row:kMaplyTestCulling) ])
    }
    
    func showConfig() {
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            popControl = UIPopoverController(contentViewController:configViewC)
            popControl!.delegate = self
            popControl!.setPopoverContentSize(CGSize(width:400.0, height:4.0/5.0*view.bounds.size.height), animated:false)
            popControl!.presentPopoverFromRect(CGRect(x:0, y:0, width:10, height:10), inView:view, permittedArrowDirections:.Up, animated:true)
        } else {
            configViewC.navigationItem.hidesBackButton = true
            configViewC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.Done, target:self, action:"editDone")
            navigationController!.pushViewController(configViewC, animated:true)
        }
    }
    
    func editDone() {
        navigationController!.popToViewController(self, animated: true)
        changeMapContents()
    }
    
    // MARK: Whirly Globe Delegate
    
    // Build a simple selection view to draw over top of the globe
    func makeSelection(viewName: String) -> UIView {
        var fontSize: CGFloat = 32.0
        var marginX: CGFloat = 32.0
        
        // Make a label and stick it in as a view to track
        // We put it in a top level view so we can center it
        var topView = UIView(frame:CGRectZero)
        // Start out hidden before the first placement.  The tracker will turn it on.
        topView.hidden = true
        topView.alpha = 0.8
        var backView = UIView(frame:CGRectZero)
        topView.addSubview(backView)
        topView.clipsToBounds = false
        let testLabel = UILabel(frame:CGRectZero)
        backView.addSubview(testLabel)
        testLabel.font = UIFont.systemFontOfSize(fontSize)
        testLabel.textColor = UIColor.whiteColor()
        testLabel.backgroundColor = UIColor.clearColor()
        testLabel.text = viewName
        var textSize: CGSize = testLabel.text!.sizeWithAttributes([NSFontAttributeName: testLabel.font])
        testLabel.frame = CGRect(x:CGFloat(marginX/2.0), y:0.0, width:(textSize.width), height:(textSize.height))
        testLabel.opaque = false
        backView.layer.cornerRadius = 5.0
        backView.backgroundColor = UIColor(red:0.0, green:102/255.0, blue:204/255.0, alpha:1.0)
        backView.frame = CGRect(x:-(textSize.width)/2.0, y:-(textSize.height)/2.0, width:(textSize.width+marginX), height:textSize.height)
        
        return topView
    }
    
    func handleSelection(selectedObject: AnyObject) {

        // If we've currently got a selected view, get rid of it
        //    if (selectedViewTrack)
        //    {
        //        [baseViewC removeViewTrackForView:selectedViewTrack.view];
        //        selectedViewTrack = nil;
        //    }
        baseViewC.clearAnnotations()
        
        var loc = MaplyCoordinate(x: 0.0, y: 0.0)
        var title: String?
        var subTitle: String?
        var offset = CGPointZero
        
        switch selectedObject {

        case let marker as MaplyMarker:
            loc = marker.loc
            title = (marker.userObject as String)
            subTitle = "Marker"

        case let screenMarker as MaplyScreenMarker:
            loc = screenMarker.loc
            title = (screenMarker.userObject as String)
            subTitle = "Screen Marker"
            offset = CGPoint(x:0.0, y:-8.0)

        case let label as MaplyLabel:
            loc = label.loc
            title = (label.userObject as String)
            subTitle = "Label"

        case let screenLabel as MaplyScreenLabel:
            loc = screenLabel.loc
            title = (screenLabel.userObject as String)  // crash when userObject nil?
            subTitle = "Screen Label"
            offset = CGPoint(x:0.0, y:-6.0)

        case let vecObj as MaplyVectorObject:
            if (vecObj.centroid(&loc)) {
                var name: String = (vecObj.userObject as String)
                title = name
                subTitle = "Vector"
                if (configViewC.valueForSection(kMaplyTestCategoryObjects, row:kMaplyTestLoftedPoly)) {
                    // See if there already is one
                    if (loftPolyDict[name] == nil) {
                        var compObj = baseViewC.addLoftedPolys([vecObj], key:nil, cache:nil, desc:[ kMaplyColor: UIColor(red:1.0, green:0.0, blue:0.0, alpha:0.25), kMaplyLoftedPolyHeight: 0.05, kMaplyFade: 0.5 ])
                        if (compObj != nil) {
                            loftPolyDict[name] = compObj
                        }
                    }
                }
            }

        case let sphere as MaplyShapeSphere:
            loc = sphere.center
            title = "Shape"
            subTitle = "Sphere"

        case let cyl as MaplyShapeCylinder:
            loc = cyl.baseCenter
            title = "Shape"
            subTitle = "Cylinder"

        default:
            // Don't know what it is
            return
        }
        
        // Build the selection view and hand it over to the globe to track
        //    selectedViewTrack = [[MaplyViewTracker alloc] init];
        //    selectedViewTrack.loc = loc;
        //    selectedViewTrack.view = [self makeSelectionView:msg];
        //    [baseViewC addViewTracker:selectedViewTrack];
        if (title != nil) {
            var annotate = MaplyAnnotation()
            annotate.title = title
            annotate.subTitle = subTitle
            baseViewC.clearAnnotations()
            baseViewC.addAnnotation(annotate, forPoint:loc, offset:offset)
        }
    }
    
    // User selected something
    func globeViewController(viewC: WhirlyGlobeViewController, didSelect selectedObj: AnyObject) {
        handleSelection(selectedObj)
    }
    
    // User didn't select anything, but did tap
    func globeViewController(viewC: WhirlyGlobeViewController, didTapAt coord: MaplyCoordinate) {
        // Just clear the selection
        baseViewC.clearAnnotations()
        
        if (globeViewC != nil)
        {
        //        MaplyCoordinate geoCoord;
        //        if ([globeViewC geoPointFromScreen:CGPointMake(0, 0) geoCoord:&geoCoord])
        //            NSLog("GeoCoord (upper left): %f, %f",geoCoord.x,geoCoord.y);
        //        else
        //            NSLog("GeoCoord not on globe");
        //        MaplyCoordinate geoCoord = MaplyCoordinateMakeWithDegrees(0, 0);
        //        CGPoint screenPt;
        //        if ([globeViewC screenPointFromGeo:geoCoord screenPt:&screenPt])
        //            NSLog("Origin at: %f,%f",screenPt.x,screenPt.y);
        //        else
        //            NSLog("Origin not on screen");
        }
        
        // Screen shot
        //    UIImage *image = [baseViewC snapshot];
        
        //    if (selectedViewTrack)
        //    {
        //        [baseViewC removeViewTrackForView:selectedViewTrack.view];
        //        selectedViewTrack = nil;
        //    }
    }
    
    // Bring up the config view when the user taps outside
    func globeViewControllerDidTapOutside(viewC: WhirlyGlobeViewController) {
        //    showPopControl()
    }
    
    func globeViewController(viewC: WhirlyGlobeViewController, layerDidLoad layer: MaplyViewControllerLayer) {
        NSLog("Spherical Earth Layer loaded.")
    }
    
    func globeViewControllerDidStartMoving(viewC: WhirlyGlobeViewController, userMotion: Bool) {
        //    NSLog("Started moving")
    }
    
    func globeViewController(viewC: WhirlyGlobeViewController, didStopMoving corners: UnsafeMutablePointer<MaplyCoordinate>, userMotion: Bool) {
        //    NSLog("Stopped moving")
    }
    
    // MARK: Maply delegate
    
    func maplyViewController(viewC: MaplyViewController, didSelect selectedObj: NSObject!) {
        handleSelection(selectedObj)
    }
    
    func maplyViewController(viewC: MaplyViewController, didTapAt coord: MaplyCoordinate) {
        // Just clear the selection
        baseViewC.clearAnnotations()
        //    if (selectedViewTrack)
        //    {
        //        [baseViewC removeViewTrackForView:selectedViewTrack.view];
        //        selectedViewTrack = nil;
        //    }
    }
    
    func maplyViewControllerDidStartMoving(viewC: MaplyViewController!, userMotion: Bool) {
        //    NSLog("Started moving")
    }
    
    func maplyViewController(viewC: MaplyViewController, didStopMoving corners: UnsafeMutablePointer<MaplyCoordinate>, userMotion: Bool) {
        //    NSLog("Stopped moving")
    }
    
    // MARK: Popover Delegate
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController!) {
        changeMapContents()
    }

}
