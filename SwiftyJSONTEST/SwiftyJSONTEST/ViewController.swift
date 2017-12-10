//
//  ViewController.swift
//  SwiftyJSONTEST
//
//  Created by Vineeth Xavier on 12/9/17.
//  Copyright © 2017 Vineeth Xavier. All rights reserved.
//

/*
 * used json
 * extracted json with
   * SwiftyJSON
   * JSONSerialization
   * Decodable
     * Used struct
     * used getSymbolForCurrencyCode() to conver USD to $ symbol
 
 */
import UIKit
import SwiftyJSON

// for StrutForDecodable //getValueByDecodable()

struct StrutForDecodable:Decodable{
    var time:time
    var chartName:String
    var bpi:bpi
}
struct time:Decodable {
    var updatedISO:String
}
struct bpi:Decodable {
    var USD:USD
    var EUR:EUR
}
struct USD:Decodable {
    var code:String
    var description:String
    var rate: String
}
struct EUR:Decodable {
    var code:String
    var description:String
    var rate:String
}
// for StrutForDecodable //getValueByDecodable()
//---------------

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getValueBySwiftyJSON()
        getValueByJSONSerialization()
        getValueByDecodable()
    }//viewDidLoad
//--------------- (1) ---------------
    func getValueBySwiftyJSON(){
        print("---getValueBySwiftyJSON----")
        let finalUrl = "https://api.coindesk.com/v1/bpi/currentprice.json"
        let url = URL.init(string: finalUrl)
        do{
            let response = try Data.init(contentsOf: url!)
            let json = JSON(data: response)
            
            let descriptionUSD = json["bpi"]["USD"]["description"].string
            let descriptionGBP = json["bpi"]["GBP"]["description"]
            let rateUSD = json["bpi"]["USD"]["rate"].string
            let rateGBP = json["bpi"]["GBP"]["rate"]
            print(" descriptionUSD = \(descriptionUSD)")
            print(" descriptionGBP = \(descriptionGBP)")
            print(" rateUSD = \(rateUSD)")
            print(" rateGBP = \(rateGBP)")

        } catch let error {
            print(error)
        }
        print("---getValueBySwiftyJSON----\n")
    }// func getValueBySwiftyJSON()
    //--------------- (2) ---------------
    func getValueByJSONSerialization(){
        print("---getValueByJSONSerialization---")
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else {
            print("Error with json file--------------- ")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                print("Error!!!")
            }
            if let content = data{
                do{
                    let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: Any]
                    
                    let bpiData = myJson["bpi"] as! [String: Any]
                    
                    let usd = bpiData["USD"] as! [String: Any]
                    let rateUSD = usd["rate_float"] as! Double
                    print(" rateUSD::" + "\(rateUSD)") // print
                    
                    let GBP = bpiData["GBP"] as! [String: Any]
                    let rateGBP = GBP["rate_float"] as! Double
                    print(" rateGBP::" + "\(rateGBP)") // print
                    
                    print("---getValueByJSONSerialization---\n")
                }
                catch
                {
                    print("catch called")
                }
            }
        }
        task.resume()
        
    }// func getValueByJSONSerialization()
    
    
    //--------------- (3) ---------------
    func getValueByDecodable(){
        
        let UrlString = "https://api.coindesk.com/v1/bpi/currentprice.json"
        let url = URL.init(string: UrlString )
        do{
            
            let data = try Data.init(contentsOf: url!)
            let decodedJSON = try JSONDecoder().decode(StrutForDecodable.self, from: data)
            print("---getValueByDecodable---")
            print(" func converts code \"GBP\" to £ --: \(getSymbolForCurrencyCode(code: "GBP")!)")
            print(" func converts code \"USD\" to $ --: \(getSymbolForCurrencyCode(code: "USD")!)")
            
            print(" chartName::: \(decodedJSON.chartName)")
            print(" updatedISO: \(decodedJSON.time.updatedISO)")
            print(" usd code: \(decodedJSON.bpi.USD.code)")
            print(" eur rate: \(decodedJSON.bpi.EUR.rate)")
            }
            catch{
                print("Catch called ")
            }
        print("---getValueByDecodable---\n")
    }//func getValueByDecodable()
    
    //function that converts USD to $ symbol
    func getSymbolForCurrencyCode(code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
            return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }//getSymbolForCurrencyCode
    //---------------
    
}//ViewController

