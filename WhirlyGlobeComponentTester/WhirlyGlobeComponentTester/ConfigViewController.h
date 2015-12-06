/*
 *  ConfigViewController.h
 *  WhirlyGlobeComponentTester
 *
 *  Created by Steve Gifford on 7/23/12.
 *  Copyright 2011-2013 mousebird consulting
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

// Base image layers
#define kMaplyTestBlank @"Blank"
#define kMaplyTestGeographyClass @"Geography Class - Local"
#define kMaplyTestBlueMarble @"NASA Blue Marble - Local"
#define kMaplyTestStamenWatercolor @"Stamen Watercolor - Remote"
#define kMaplyTestOSM @"OpenStreetMap (Mapquest) - Remote"
#define kMaplyTestMapBoxSat @"MapBox Satellite - Remote"
#define kMaplyTestMapBoxTerrain @"MapBox Terrain - Remote"
#define kMaplyTestMapBoxRegular @"MapBox Regular - Remote"
#define kMaplyTestQuadTest @"Quad Test Layer"
#define kMaplyTestQuadTestAnimate @"Quad Test Layer - Animated"
#define kMaplyTestQuadVectorTest @"Quad Vector Test Layer"

// Overlay image layers
#define kMaplyTestUSGSOrtho @"USGS Ortho (WMS) - Remote"
#define kMaplyTestOWM @"OpenWeatherMap - Remote"
#define kMaplyTestForecastIO @"Forecast.IO Snapshot - Remote"
#define kMaplyTestMapboxStreets @"MapBox Streets Vectors - Remote"
#define kMaplyMapzenVectors @"Mapzen Vectors - Remote"

// Objects we can display
#define kMaplyTestLabel2D @"Labels - 2D"
#define kMaplyTestLabel3D @"Labels - 3D"
#define kMaplyTestMarker2D @"Markers - 2D"
#define kMaplyTestMarker3D @"Markers - 3D"
#define kMaplyTestSticker @"Stickers"
#define kMaplyTestShapeCylinder @"Shapes: Cylinders"
#define kMaplyTestShapeSphere @"Shapes: Spheres"
#define kMaplyTestShapeGreatCircle @"Shapes: Great Circles"
#define kMaplyTestCountry @"Countries"
#define kMaplyTestLoftedPoly @"Lofted Polygons"
#define kMaplyTestMegaMarkers @"Mega Markers"
#define kMaplyTestLatLon @"Lon/Lat lines"
#define kMaplyTestRoads @"SF Roads"

// Animation
#define kMaplyTestAnimateSphere @"Animated Sphere"

// Gestures
#define kMaplyTestNorthUp @"Keep North Up"
#define kMaplyTestPinch @"Pinch Gesture"
#define kMaplyTestRotate @"Rotate Gesture"

// Low level Internal
#define kMaplyTestCulling @"Culling Optimization"
#define kMaplyTestPerf @"Performance Output"
#define kMaplyTestWaitLoad @"Image waitLoad"
