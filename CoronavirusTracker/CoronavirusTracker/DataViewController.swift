//
//  DataViewController.swift
//  CoronavirusTracker
//
//  Created by codeplus on 3/29/20.
//  Copyright © 2020 Alamance. All rights reserved.
//

import UIKit
import Charts
import SystemConfiguration

class DataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //outlets
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var currentCountry: UILabel!
    @IBOutlet weak var confirmedTotalLabel: UILabel!
    @IBOutlet weak var recoveredTotalLabel: UILabel!
    @IBOutlet weak var deathsTotalLabel: UILabel!
    @IBOutlet weak var confirmedYesterdayLabel: UILabel!
    @IBOutlet weak var recoveredYesterdayLabel: UILabel!
    @IBOutlet weak var deathsYesterdayLabel: UILabel!
    
    //chart stuff
    @IBOutlet weak var chartView: LineChartView!
    var myCountry = Optional<[Day]>.none
    var myCountries = Optional<[Country]>.none
    var confirmedCases: [ChartDataEntry] = []
    var deaths: [ChartDataEntry] = []
    var xStrings: [String] = []
    
    let countries = ["Australia", "Austria", "Belgium", "Brazil", "Bulgaria", "Canada", "Chile", "China", "Denmark", "Ecuador", "France", "Germany", "India", "Iran", "Ireland", "Israel", "Italy", "Japan", "Kenya", "Malaysia", "Mexico", "Morocco", "Netherlands", "Norway", "Pakistan", "Peru", "Poland", "Portugal", "Romania", "Russia", "Sweden", "Saudi Arabia", "Singapore", "South Korea", "Spain", "Switzerland", "Turkey", "United Kingdom", "United States"]
    
    var shownMessage = false
    
    var pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAlert()
        getData()
        
        //CHART STUFF
        chartView.backgroundColor = .systemTeal
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        
        //PICKER STUFF
        pickerView.delegate = self
        pickerView.dataSource = self
        countryField.inputView = pickerView
        countryField.textAlignment = .center
        countryField.placeholder = "Select country"
        
        
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if (myCountries != nil){
            countryField.text = countries[row]
            countryField.resignFirstResponder()
        }
    
        
        switch countryField.text {
            case "Mexico":
                print("Mexico selected")
                myCountry = myCountries?[0].Mexico
            case "Belgium":
                print("Belgium selected")
                myCountry = myCountries?[0].Belgium
            case "Turkey":
                print("Turkey selected")
                myCountry = myCountries?[0].Turkey
            case "Brazil":
                print("Brazil selected")
                myCountry = myCountries?[0].Brazil
            case "Iran":
                print("Iran selected")
                myCountry = myCountries?[0].Iran
            case "United Kingdom":
                print("UK selected")
                myCountry = myCountries?[0].UK
            case "Germany":
                print("Germany selected")
                myCountry = myCountries?[0].Germany
            case "France":
                print("France selected")
                myCountry = myCountries?[0].France
            case "Japan":
                print("Japan selected")
                myCountry = myCountries?[0].Japan
            case "China":
                print("China selected")
                myCountry = myCountries?[0].China
            case "United States":
                print("US selected")
                myCountry = myCountries?[0].US
            case "Italy":
                print("Italy selected")
                myCountry = myCountries?[0].Italy
            case "South Korea":
                print("Korea selected")
                myCountry = myCountries?[0].SK
            case "Spain":
                print("Spain selected")
                myCountry = myCountries?[0].Spain
            case "Austria":
                print("Austria selected")
                myCountry = myCountries?[0].Austria
            case "Portugal":
                print("Portugal selected")
                myCountry = myCountries?[0].Portugal
            case "Israel":
                print("Israel selected")
                myCountry = myCountries?[0].Israel
            case "Denmark":
                print("Denmark selected")
                myCountry = myCountries?[0].Denmark
            case "Australia":
                print("Australia selected")
                myCountry = myCountries?[0].Australia
            case "Norway":
                print("Norway selected")
                myCountry = myCountries?[0].Norway
            case "Sweden":
                print("Sweden selected")
                myCountry = myCountries?[0].Sweden
            case "Ireland":
                print("Ireland selected")
                myCountry = myCountries?[0].Ireland
            case "Malaysia":
                print("Malaysia selected")
                myCountry = myCountries?[0].Malaysia
            case "Canada":
                print("Canada selected")
                myCountry = myCountries?[0].Canada
            case "Kenya":
                print("Kenya selected")
                myCountry = myCountries?[0].Kenya
            case "Morocco":
                print("Morocco selected")
                myCountry = myCountries?[0].Morocco
            case "Switzerland":
                print("Switzerland selected")
                myCountry = myCountries?[0].Switzerland
            case "Bulgaria":
                print("Bulgaria selected")
                myCountry = myCountries?[0].Bulgaria
            case "Russia":
                print("Russia selected")
                myCountry = myCountries?[0].Russia
            case "Netherlands":
                print("Netherlands selected")
                myCountry = myCountries?[0].Netherlands
            case "India":
                print("India selected")
                myCountry = myCountries?[0].India
            case "Peru":
                print("Peru selected")
                myCountry = myCountries?[0].Peru
            case "Saudi Arabia":
                print("Saudi Arabia selected")
                myCountry = myCountries?[0].SaudiArabia
            case "Chile":
                print("Chile selected")
                myCountry = myCountries?[0].Chile
            case "Poland":
                print("Poland selected")
                myCountry = myCountries?[0].Poland
            case "Ecuador":
                print("Ecuador selected")
                myCountry = myCountries?[0].Ecuador
            case "Pakistan":
                print("Pakistan selected")
                myCountry = myCountries?[0].Pakistan
            case "Romania":
                print("Romania selected")
                myCountry = myCountries?[0].Romania
            case "Singapore":
                print("Singapore selected")
                myCountry = myCountries?[0].Singapore
            
            default:
                print("Something went wrong.")
            }
        if (myCountries != nil){
            setChartData()
            setValues()
        }
        else {
            if (shownMessage == false){
                showAlert2()
                countryField.isUserInteractionEnabled = false
                shownMessage = true
            }
            
        }
    }
    
    //Getting data!
    struct Day: Codable {
        var date:String
        var confirmed:Double
        var deaths:Double
        var recovered:Double
    }
    
    struct Country: Codable {
        var Germany:[Day]
        var Mexico:[Day]
        var US:[Day]
        var Canada:[Day]
        var Italy:[Day]
        var Iran:[Day]
        var China:[Day]
        var Spain:[Day]
        var Japan:[Day]
        var SK:[Day]
        var Kenya:[Day]
        var Morocco:[Day]
        var France:[Day]
        var UK:[Day]
        var Switzerland:[Day]
        var Austria:[Day]
        var Portugal:[Day]
        var Israel:[Day]
        var Brazil:[Day]
        var Australia:[Day]
        var Norway:[Day]
        var Sweden:[Day]
        var Ireland:[Day]
        var Malaysia:[Day]
        var Denmark:[Day]
        var Turkey: [Day]
        var Belgium: [Day]
        var Bulgaria: [Day]
        var Russia: [Day]
        var Netherlands: [Day]
        var India: [Day]
        var Peru: [Day]
        var SaudiArabia: [Day]
        var Chile: [Day]
        var Poland: [Day]
        var Ecuador: [Day]
        var Pakistan: [Day]
        var Romania: [Day]
        var Singapore: [Day]
        
        private enum CodingKeys: String, CodingKey {
            case Austria
            case Portugal
            case Russia
            case Israel
            case Denmark
            case Singapore
            case Brazil
            case Chile
            case Pakistan
            case Peru
            case Ecuador
            case India
            case Bulgaria
            case Netherlands
            case Romania
            case Australia
            case Norway
            case Poland
            case Sweden
            case Belgium
            case Ireland
            case Malaysia
            case Spain
            case Germany
            case Mexico
            case US
            case Canada
            case Turkey
            case Italy
            case Iran
            case China
            case Japan
            case Kenya
            case Morocco
            case France
            case Switzerland
            case SK = "Korea, South"
            case UK = "United Kingdom"
            case SaudiArabia = "Saudi Arabia"
        }
    }
    

    
    
    //Code for getting data from API

    func getData() {
        // 2. BEGIN NETWORKING code
        
                let mySession = URLSession(configuration: URLSessionConfiguration.default)

                let url2 = URL(string: "https://pomber.github.io/covid19/timeseries.json")!

        // 3. MAKE THE HTTPS REQUEST task
        
                let task2 = mySession.dataTask(with: url2) { data, response, error in

                    // ensure there is no error for this HTTP response
                    guard error == nil else {
                        print ("error: \(error!)")
                        
                        return
                    }

                    // ensure there is data returned from this HTTP response
                    guard let jsonData2 = data else {
                        print("No data.")
                        return
                    }
                    
                    print("Got the data from network")
                    
        
                    
        // 4. DECODE THE RESULTING JSON
                    
                    let decoder2 = JSONDecoder()

                    do {
                        // decode the JSON into our array of countries
                        self.myCountries = [try decoder2.decode(Country.self, from: jsonData2)]
                        

                        DispatchQueue.main.async {
                            self.getLocale()
                            self.setValues()
                            self.setChartData()
                        }

                        
                        
                    } catch {
                        print("JSON Decode error.")
                    }
                }

                // actually make the http task run.
                task2.resume()

    }
    
    //SET DATA
    func setChartData(){
        
        print("setting up chart")
        confirmedCases.removeAll()
        deaths.removeAll()
        var counter = 0.0
        for day in myCountry!{
            //print("on day",counter,"which is",day.date,"there were",day.deaths,"deaths reported in",countryField.text!)
            confirmedCases.append(ChartDataEntry(x: counter, y: day.confirmed))
            deaths.append(ChartDataEntry(x: counter, y: day.deaths))
            xStrings.append(dateAdder(daysToAdd: Int(counter)))
            counter += 1
        }

        let confirmedSet = LineChartDataSet(entries: confirmedCases, label: "Confirmed cases")
        confirmedSet.drawCirclesEnabled = false
        confirmedSet.setColor(.blue)
        confirmedSet.lineWidth = 1.5
        
        let deathsSet = LineChartDataSet(entries: deaths, label: "Deaths")
        deathsSet.drawCirclesEnabled = false
        deathsSet.setColor(.white)
        deathsSet.lineWidth = 1.5

        let data = LineChartData(dataSet: confirmedSet)
        data.setDrawValues(false)
        self.chartView.xAxis.labelRotationAngle = -45
        chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return self.xStrings[Int(index)]
        })
        chartView.xAxis.setLabelCount(xStrings.count, force: true)
        chartView.data = data
    }
    
    func setValues(){
        
        print("setting values")
        
        let yesterday = myCountry![myCountry!.endIndex - 1]
        let anteayer = myCountry![myCountry!.endIndex - 2]
        
        let confirmedTotalNum = yesterday.confirmed
        confirmedTotalLabel.text = String(format: "%.0f", confirmedTotalNum)
        
        let recoveredTotalNum = yesterday.recovered
        recoveredTotalLabel.text = String(format: "%.0f", recoveredTotalNum)
        
         let deathsTotalNum = yesterday.deaths
        deathsTotalLabel.text = String(format: "%.0f", deathsTotalNum)
        
        let confirmedNew = yesterday.confirmed - anteayer.confirmed
        confirmedYesterdayLabel.text = String(format: "%.0f", confirmedNew)
        
        let recoveredNew = yesterday.recovered - anteayer.recovered
        recoveredYesterdayLabel.text = String(format: "%.0f", recoveredNew)
        
        let deathsNew = yesterday.deaths - anteayer.deaths
        deathsYesterdayLabel.text = String(format: "%.0f", deathsNew)
    
    }
    func getLocale(){
        
    let locale = Locale.current
    let userCountry = locale.regionCode
    
    switch userCountry {
        case "US":
            print("user is from the US")
            myCountry = myCountries?[0].US
            countryField.text = "United States"
        case "MX":
            print("user is from Mexico")
            myCountry = myCountries?[0].Mexico
            countryField.text = "Mexico"
        case "CN":
            print("user is from China")
            myCountry = myCountries?[0].China
            countryField.text = "China"
        case "BE":
            print("user is from Belgium")
            myCountry = myCountries?[0].Belgium
            countryField.text = "Belgium"
        case "IT":
            print("user is from Italy")
            myCountry = myCountries?[0].Italy
            countryField.text = "Italy"
        case "JP":
            print("user is from Japan")
            myCountry = myCountries?[0].Japan
            countryField.text = "Japan"
        case "KR":
            print("user is from South Korea")
            myCountry = myCountries?[0].SK
            countryField.text = "South Korea"
        case "DE":
            print("user is from Germany")
            myCountry = myCountries?[0].Germany
            countryField.text = "Germany"
        case "FR":
            print("user is from France")
            myCountry = myCountries?[0].France
            countryField.text = "France"
        case "ES":
            print("user is from Spain")
            myCountry = myCountries?[0].Spain
            countryField.text = "Spain"
        case "BR":
            print("user is from Brazil")
            myCountry = myCountries?[0].Brazil
            countryField.text = "Brazil"
        case "CA":
            print("user is from Canada")
            myCountry = myCountries?[0].Canada
            countryField.text = "Canada"
        case "IR":
            print("user is from Iran")
            myCountry = myCountries?[0].Iran
            countryField.text = "Iran"
        case "KE":
            print("user is from Kenya")
            myCountry = myCountries?[0].Kenya
            countryField.text = "Kenya"
        case "MA":
            print("user is from Morocco")
            myCountry = myCountries?[0].Morocco
            countryField.text = "Morocco"
        case "GB":
            print("user is from UK")
            myCountry = myCountries?[0].UK
            countryField.text = "United Kingdom"
        case "CH":
            print("user is from Switzerland")
            myCountry = myCountries?[0].Switzerland
            countryField.text = "Switzerland"
        case "AT":
            print("user is from Austria")
            myCountry = myCountries?[0].Austria
            countryField.text = "Austria"
        case "PT":
            print("user is from Portugal")
            myCountry = myCountries?[0].Portugal
            countryField.text = "Portugal"
        case "IL":
            print("user is from Israel")
            myCountry = myCountries?[0].Israel
            countryField.text = "Israel"
        case "AU":
            print("user is from Australia")
            myCountry = myCountries?[0].Australia
            countryField.text = "Australia"
        case "SE":
            print("user is from Sweden")
            myCountry = myCountries?[0].Sweden
            countryField.text = "Sweden"
        case "NO":
            print("user is from Norway")
            myCountry = myCountries?[0].Norway
            countryField.text = "Norway"
        case "IE":
            print("user is from Ireland")
            myCountry = myCountries?[0].Ireland
            countryField.text = "Ireland"
        case "MY":
            print("user is from Malaysia")
            myCountry = myCountries?[0].Malaysia
            countryField.text = "Malaysia"
        case "DK":
            print("user is from Denmark")
            myCountry = myCountries?[0].Denmark
            countryField.text = "Denmark"
        case "BG":
            print("user is from Bulgaria")
            myCountry = myCountries?[0].Bulgaria
            countryField.text = "Bulgaria"
        case "RU":
            print("user is from Russia")
            myCountry = myCountries?[0].Russia
            countryField.text = "Russia"
        case "NL":
            print("user is from the Netherlands")
            myCountry = myCountries?[0].Netherlands
            countryField.text = "Netherlands"
        case "IN":
            print("user is from India")
            myCountry = myCountries?[0].India
            countryField.text = "India"
        case "PE":
            print("user is from Peru")
            myCountry = myCountries?[0].Peru
            countryField.text = "Peru"
        case "SA":
            print("user is from Saudi Arabia")
            myCountry = myCountries?[0].SaudiArabia
            countryField.text = "Saudi Arabia"
        case "CL":
            print("user is from Chile")
            myCountry = myCountries?[0].Chile
            countryField.text = "Chile"
        case "Poland":
            print("user is from Poland")
            myCountry = myCountries?[0].Poland
            countryField.text = "Poland"
        case "EC":
            print("user is from Ecuador")
            myCountry = myCountries?[0].Ecuador
            countryField.text = "Ecuador"
        case "PK":
            print("user is from Pakistan")
            myCountry = myCountries?[0].Pakistan
            countryField.text = "Pakistan"
        case "RO":
            print("user is from Romania")
            myCountry = myCountries?[0].Romania
            countryField.text = "Romania"
        case "SG":
            print("user is from Singapore")
            myCountry = myCountries?[0].Singapore
            countryField.text = "Singapore"

        
        default:
            print("Region not supported. Use US data.")
            myCountry = myCountries?[0].US
    
        }
        
    }
  
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

    func showAlert() {
        if !isInternetAvailable() {
         let alert = UIAlertController(title: "You aren't connected to the internet.", message: "We are not able to get current data on COVID-19. Please connect to the internet, reload the app, and try again.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            countryField.isUserInteractionEnabled = false
        }
    }
    
    func showAlert2() {
         let alert = UIAlertController(title: "There was a problem.", message: "There was a problem accessing the data from the API. Please reload the app or try again later.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
    }
    
    func dateAdder(daysToAdd: Int) -> String{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let startDate = formatter.date(from: "2020/01/22 12:00")
            var dateComponent = DateComponents()
               
               dateComponent.month = 0
               dateComponent.day = daysToAdd
               dateComponent.year = 0
               
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: startDate!)
               
        //print(startDate as Any)
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "M-dd"
        let datenew = dateFormatter.string(from: futureDate!)

        return datenew
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
