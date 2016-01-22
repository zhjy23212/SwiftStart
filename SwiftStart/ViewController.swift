//
//  ViewController.swift
//  SwiftStart
//
//  Created by Jiyang on 15/6/5.
//  Copyright (c) 2015年 Jiyang. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{
    let locationmanager:CLLocationManager=CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationmanager.delegate=self
        
        locationmanager.desiredAccuracy=kCLLocationAccuracyBest
        
        locationmanager.requestAlwaysAuthorization()
        
        ifLocationAuthorized()
        
        locationmanager.startUpdatingLocation()
        
    }
    
    func ios9()->Bool{
            print("Current Version is \(UIDevice.currentDevice().systemVersion as NSString)")
        
         let ifLarger = floor((UIDevice.currentDevice().systemVersion as NSString).floatValue)
        return ifLarger>floor(8.0)
    }
    
    func ifLocationAuthorized(){
        switch CLLocationManager.authorizationStatus(){
        case .AuthorizedAlways:
            print("always authorized")
        case .AuthorizedWhenInUse:
            print("in use")
        case .Denied:
            print("denied")
        case .NotDetermined:
            print("not determined")
        case .Restricted:
            print("res")
        }
    }
    
    
    func weatherInfoByLocation(location:CLLocation){
        let  weatherUrl = "http://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=b75b7a96f7a6c5e8482251cb0881a2eb"
        let url:NSURL = NSURL(string: weatherUrl)!
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        let request:NSURLRequest = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request, completionHandler: <#T##(NSData?, NSURLResponse?, NSError?) -> Void#>)
            
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location:CLLocation = locations[locations.count-1] 
        
        if (location.horizontalAccuracy>0){
            print("Latitude  \(location.coordinate.latitude)")
            print("Longtitude  \(location.coordinate.longitude)")
        }
        locationmanager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Location Manager error occured")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

