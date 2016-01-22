//
//  ViewController.swift
//  SwiftStart
//
//  Created by Jiyang on 15/6/5.
//  Copyright (c) 2015年 Jiyang. All rights reserved.
//

import UIKit
import CoreLocation

import SwiftyJSON


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
        
        let task = session.dataTaskWithRequest(request) { (data, respond, netWorkError) -> Void in
            if netWorkError != nil {
                print("An error occured in request ")
                return
            }
            
            guard let unwrappedData = data else {
                print("Error: \(netWorkError!.domain)")
                return
            }
            
            var json = JSON(data:unwrappedData)
            print(json)
            
            guard let tempDegrees = json["list"][0]["main"]["temp"].double,
                country = json["city"]["country"].string,
                city = json["city"]["name"].string,
                weatherCondition = json["list"][0]["weather"][0]["id"].int,
                iconString = json["list"][0]["weather"][0]["icon"].string else {
                    print("Error: \(netWorkError!.domain)")
                    return
            }
            
        }
        
            task.resume()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location:CLLocation = locations[locations.count-1] 
        
        if (location.horizontalAccuracy>0){
            print("Latitude  \(location.coordinate.latitude)")
            print("Longtitude  \(location.coordinate.longitude)")
        }
        locationmanager.stopUpdatingLocation()
        
        self.weatherInfoByLocation(location)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Location Manager error occured")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

