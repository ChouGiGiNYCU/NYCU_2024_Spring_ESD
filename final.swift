//  ViewController.swift

//  iiibeacon

//

//  Created by ESD12 on 2024/5/16.

//



import UIKit

import CoreLocation

import Foundation

struct Point {

    let x: Double

    let y: Double

}

class ViewController: UIViewController, CLLocationManagerDelegate {



    //@IBOutlet weak var monitorResultTextView: UITextView!

    //@IBOutlet weak var rangingResultTextView: UITextView!

    

    @IBOutlet weak var y_ans: UILabel!

    @IBOutlet weak var x_ans: UILabel!

    @IBOutlet weak var RSSI_value8: UILabel!

    @IBOutlet weak var RSSI_value7: UILabel!

    @IBOutlet weak var RSSI_value6: UILabel!

    @IBOutlet weak var RSSI_value5: UILabel!

    @IBOutlet weak var dis_test: UILabel!

    @IBOutlet weak var mode_test: UILabel!

    @IBOutlet weak var rssi2_rssi: UILabel!

    @IBOutlet weak var triangle3: UILabel!

    @IBOutlet weak var triangle2: UILabel!

    @IBOutlet weak var triangle1: UILabel!

    @IBOutlet weak var Distance_value4: UILabel!

    @IBOutlet weak var RSSI_value4: UILabel!

    @IBOutlet weak var Distance_value3: UILabel!

    @IBOutlet weak var RSSI_value3: UILabel!

    @IBOutlet weak var Distance_value2: UILabel!

    @IBOutlet weak var RSSI_value2: UILabel!

    @IBOutlet weak var C_Upper: UITextView!

    @IBOutlet weak var C_Low: UITextView!

    @IBOutlet weak var B_Upper: UITextView!

    @IBOutlet weak var B_Low: UITextView!

    @IBOutlet weak var A_Upper: UITextView!

    @IBOutlet weak var A_Low: UITextView!

    @IBOutlet weak var test: UILabel!

    @IBOutlet weak var Answer_value: UILabel!

    @IBOutlet weak var threshold: UITextView!

    @IBOutlet weak var rssi_measue_test: UILabel!

    @IBOutlet weak var rssin_test: UILabel!

    @IBOutlet weak var monitorResultTextView: UITextView!

    @IBOutlet weak var rangingResultTextView: UITextView!

    @IBOutlet weak var Distance_value: UILabel!

    @IBOutlet weak var RSSI_value: UILabel!

    @IBOutlet weak var show: UILabel!

    @IBOutlet weak var RSSI_n: UITextView!

    @IBOutlet weak var RSSI_measure: UITextView!

    @IBOutlet weak var greedy_test: UILabel!

    @IBOutlet weak var Distance_value8: UILabel!

    @IBOutlet weak var Distance_value7: UILabel!

    @IBOutlet weak var Distance_value6: UILabel!

    @IBOutlet weak var Distance_value5: UILabel!

    var locationManager: CLLocationManager = CLLocationManager()

    var show_rssi = ""

    var save = false

    var mode = true; // mode1:true mode2:false

    let uuid = "A3E1C063-9235-4B25-AA84-D249950AADC4"

    let identifier = "esd region"

    let limit = 10

    var RSSIn = 2.0

    var RSSImeasure = -50

    var threshold_value = 100.0

    var Distance_records1: [[Double]] = Array(repeating: [], count: 5)

    var Distance_records2: [[Double]] = Array(repeating: [], count: 9)

    var RSSI_records: [[Double]] = Array(repeating: [], count: 5)

    var RSSI_records2: [[Double]] = Array(repeating: [], count: 9)

    var Most_f = 0

    

    var RSSI_Test : Double = -60.0

    var Most_idx = 0

    var Second_f = 0

    var Second_idx = 0

    var filteredRssi : [Double] = Array()

    var x : [Double] = Array()

    var y  : [Double] = Array()

    var freq_first_idx = [Int](repeating: 0, count: 5)

    var freq_second_idx = [Int](repeating: 0, count: 5)

    var distances : [[Double]] = Array(repeating: [], count: 5)

    var mean_distances = [Double](repeating: 0.0, count: 5)

    var beacons_value = [

          (center: Point(x: 2.21, y: 0), d: 0.0,rssi : 0.0, idx:1),

          (center: Point(x: 4.3, y: 5.7), d: 0.0, rssi : 0.0,idx:2),

          (center: Point(x: 4.3, y: 7.8), d: 0.0,rssi : 0.0,idx:3),

          (center: Point(x: 2.64, y: 11.75), d: 0.0,rssi : 0.0,idx:4)

      ]

    var beacons_value2 = [

      (center: Point(x: 0, y: 0), d: 0.0,rssi : 0.0, idx:1),

          (center: Point(x: 2.6, y: 2.67), d: 0.0, rssi : 0.0,idx:2),

          (center: Point(x: 5.71, y: 2.67), d: 0.0,rssi : 0.0,idx:3),

          (center: Point(x: 9.7, y: 2.67), d: 0.0,rssi : 0.0,idx:4),

          (center: Point(x: 13.5, y: 2.67), d: 0.0,rssi : 0.0,idx:5),

          (center: Point(x: 15.1, y: 0), d: 0.0,rssi : 0.0,idx:6),

          (center: Point(x: 17.5, y: 0), d: 0.0,rssi : 0.0,idx:7),

          (center: Point(x: 16.9, y: 3.9), d: 0.0,rssi : 0.0,idx:8)

      ]

      var distance_1_check = false , distance_2_check = false , distance_3_check = false , distance_4_check = false ,distance_5_check = false , distance_6_check = false , distance_7_check = false , distance_8_check = false

    class RSSISmoothing {

        var rssiValues: [Double] = []

        // 计算平均值

        var mean: Double {

            guard !rssiValues.isEmpty else { return 0.0 }

            return rssiValues.reduce(0, +) / Double(rssiValues.count)

        }

        // 计算标准差

        var standardDeviation: Double {

            let meanValue = self.mean

            guard !rssiValues.isEmpty else { return 0.0 }

            let sumOfSquaredDifferences = rssiValues.reduce(0) { $0 + ($1 - meanValue) * ($1 - meanValue) }

            return sqrt(sumOfSquaredDifferences / Double(rssiValues.count))

        }

        // 添加RSSI值

        func addRSSI(_ rssi: Double) {

            rssiValues.append(rssi)

            // Optionally limit the size of the array to keep a moving window of the last N measurements

            if rssiValues.count > 5 { // Example window size

                rssiValues.removeFirst()

            }

        }

        // 返回平滑后的RSSI值

        func smoothedRSSI() -> Double {

            // Assuming a Gaussian distribution, return the mean as the most probable value

            return self.mean

        }

        // 清空RSSI数值

        func clear() {

            rssiValues.removeAll()

        }

    }

    let RSSI_Method2 : [RSSISmoothing] = Array(repeating: RSSISmoothing(), count: 9)

    override func viewDidLoad() {

        super.viewDidLoad()

        

        let region = CLBeaconRegion(uuid:UUID.init(uuidString: uuid)!, identifier: identifier)

        

        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){

            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{

                locationManager.requestAlwaysAuthorization()

            }

        }

        

        locationManager.delegate = self

        

        region.notifyEntryStateOnDisplay = true

        region.notifyOnEntry = true

        region.notifyOnExit = true

        

        locationManager.startMonitoring(for: region)

        var Dis_test = pow(10.0, (Double(RSSImeasure) - RSSI_Test) / (10.0 * RSSIn))

        var Dis_test1 = pow(10.0, (abs(RSSI_Test) - Double(abs(RSSImeasure))) / (10.0 * RSSIn))

        dis_test.text = "\(Dis_test) | \(Dis_test1)"

        // Do any additional setup after loading the view.

    }

    

    func locationManager(_ manager: CLLocationManager,  didStartMonitoringFor region: CLRegion){

        monitorResultTextView.text = "did start monitoring \(region.identifier)\n" + monitorResultTextView.text

        

    }

    

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

        monitorResultTextView.text = "did enter\n" + monitorResultTextView.text

    }

    

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {

        monitorResultTextView.text = "did exit\n" + monitorResultTextView.text

    }

    

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {

        switch state{

        case .inside:

            monitorResultTextView.text = "state inside\n" + monitorResultTextView.text

            manager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: UUID.init(uuidString:uuid)!))

            

        case .outside:

            monitorResultTextView.text = "state outside\n" + monitorResultTextView.text

            manager.stopMonitoring(for: region)

            

        default:

            break

        }

    }

    // 計算兩圓的交點，返回最接近第三點的交點

    func sidePointCalculation(x1: Double, y1: Double, r1: Double, x2: Double, y2: Double, r2: Double, x3: Double, y3: Double) -> Point {

        let AB = sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2))

        let rAB = r1 + r2

        if rAB >= AB && abs(r1 - r2) <= AB {

            let d = AB / 2 + (r1*r1 - r2*r2) / (2 * AB)

            let h = sqrt(r1*r1 - d*d)



            let x0 = x1 + d * (x2 - x1) / AB

            let y0 = y1 + d * (y2 - y1) / AB



            let ix1 = x0 + h * (y2 - y1) / AB

            let iy1 = y0 - h * (x2 - x1) / AB

            let ix2 = x0 - h * (y2 - y1) / AB

            let iy2 = y0 + h * (x2 - x1) / AB



            let dc1 = sqrt(pow(ix1 - x3, 2) + pow(iy1 - y3, 2))

            let dc2 = sqrt(pow(ix2 - x3, 2) + pow(iy2 - y3, 2))



            if dc1 < dc2 {

                return Point(x: ix1, y: iy1)

            } else {

                return Point(x: ix2, y: iy2)

            }

        } else {

            return Point(x: x1 + (x2 - x1) / 2, y: y1 + (y2 - y1) / 2)

        }

    }

    func triangulatePosition(circle1: Point, radius1: Double, circle2: Point, radius2: Double, circle3: Point, radius3: Double) -> Point {

        let point1 = sidePointCalculation(x1: circle1.x, y1: circle1.y, r1: radius1, x2: circle2.x, y2: circle2.y, r2: radius2, x3: circle3.x, y3: circle3.y)

        let point2 = sidePointCalculation(x1: circle2.x, y1: circle2.y, r1: radius2, x2: circle3.x, y2: circle3.y, r2: radius3, x3: circle1.x, y3: circle1.y)

        let point3 = sidePointCalculation(x1: circle3.x, y1: circle3.y, r1: radius3, x2: circle1.x, y2: circle1.y, r2: radius1, x3: circle2.x, y3: circle2.y)



        // 计算三个点的平均位置

        let centerX = (point1.x + point2.x + point3.x) / 3

        let centerY = (point1.y + point2.y + point3.y) / 3

        return Point(x: centerX, y: centerY)

    }



    func trilateration(beacons_value: [(center: Point, d: Double ,rssi:Double ,idx:Int)]) -> Point? {

        //guard beacons_value.count == 3 else { return nil }

       

        let x1 = beacons_value[0].center.x, y1 = beacons_value[0].center.y, r1 = beacons_value[0].d

        let x2 = beacons_value[1].center.x, y2 = beacons_value[1].center.y, r2 = beacons_value[1].d

        let x3 = beacons_value[2].center.x, y3 = beacons_value[2].center.y, r3 = beacons_value[2].d

        

        return triangulatePosition(circle1: Point(x: x1, y: y1), radius1: r1,

                                           circle2: Point(x: x2, y: y2), radius2: r2,

                                           circle3: Point(x: x3, y: y3), radius3: r3)

        /*

        let A = 2 * (x2 - x1)

        let B = 2 * (y2 - y1)

        let D = 2 * (x3 - x2)

        let E = 2 * (y3 - y2)

       

        let C = pow(r1, 2) - pow(r2, 2) - pow(x1, 2) + pow(x2, 2) - pow(y1, 2) + pow(y2, 2)

        let F = pow(r2, 2) - pow(r3, 2) - pow(x2, 2) + pow(x3, 2) - pow(y2, 2) + pow(y3, 2)

       

        let denominator = (A * E - B * D)

        if denominator == 0 { return nil }

       

        let x = (C * E - F * B) / denominator

        let y = (A * F - C * D) / denominator

       

        return Point(x: x, y: y)

         */

    }

    

    func standardDeviation(of array: [Double]) -> Double {

        let meanValue = mean(of: array)

        var sumOfSquaredDifferences: Double = 0.0

        for value in array {

            sumOfSquaredDifferences += pow(value - meanValue, 2)

        }

        let variance = sumOfSquaredDifferences / Double(array.count)

        return sqrt(variance)

    }

    func mean(of array: [Double]) -> Double {

        var sum: Double = 0.0

        for value in array {

            sum += value

        }

        return sum / Double(array.count)

    }

    

    

    func filterOutliers(from array: [Double], withMean mean: Double, standardDeviation std: Double, threshold: Double) -> [Double] {

        var filteredArray: [Double] = []

        for value in array {

            if abs((value - mean) / std) < threshold {

                filteredArray.append(value)

            }

        }

        return filteredArray

    }

    

    func decision(A_Low_value : Double , A_Upper_value : Double , B_Low_value : Double , B_Upper_value : Double , C_Low_value : Double , C_Upper_value : Double , mean_y : Double){

        if mean_y <= C_Upper_value {

            Answer_value.text = "C"

        }else if(mean_y >= B_Low_value && mean_y < B_Upper_value){

            Answer_value.text = "B"

        }else if(mean_y >= A_Low_value && mean_y <= A_Upper_value){

            Answer_value.text = "A"

        }

    }

    

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){

        rangingResultTextView.text = ""

        

        // set A B C bound

        guard let A_Low_value = Double(A_Low.text ?? ""),

              let A_Upper_value = Double(A_Upper.text ?? ""),

              let B_Low_value = Double(B_Low.text ?? ""),

              let B_Upper_value = Double(B_Upper.text ?? ""),

              let C_Low_value = Double(C_Low.text ?? ""),

              let C_Upper_value = Double(C_Upper.text ?? "") else {

            

            return

        }

        // RSSI init parameter

        if let rssInText = RSSI_n.text, let RSSIn = Double(rssInText) {

            rssin_test.text = "\(RSSIn)"

        } else {

            rssin_test.text = "n have no number!!!"

        }

        if let rssiMeasureText = RSSI_measure.text, let RSSImeasure = Double(rssiMeasureText) {

            rssi_measue_test.text = "\(RSSImeasure)"

        } else {

            rssi_measue_test.text = "RSSI_measure have no number!!!"

        }

        

        

        for beacon in beacons{

            var proximityString = ""

            switch beacon.proximity{

            case .far:

                proximityString = "far"

            case .near:

                proximityString = "near"

            case .immediate:

                proximityString = "immediate"

            default :

                proximityString = "unknow"

            }

            

            rangingResultTextView.text = rangingResultTextView.text + "Major: \(beacon.major)" + " Minor: \(beacon.minor)" + " RSSI: \(beacon.rssi) " + " Proximity: \(proximityString)" + " Accuracy: \(beacon.accuracy)" + "\n\n";

            let str = "\(beacon.minor)"

            let minor_index :Int = Int(str)!

            let major_index :Int = Int.init(truncating: beacon.major)

            var RSSI_Double = Double(beacon.rssi)

            if RSSI_Double==0.0 {

                RSSI_Double = -100.0

            }

            // step1 : RSSI to Distance

            let distance = pow(10.0, (Double(RSSImeasure) - RSSI_Double) / (10.0 * RSSIn))

            

            let distance_test = pow(10.0, (abs(RSSI_Double) - Double(abs(RSSImeasure)) ) / (10.0 * RSSIn))

            

            // if minor_index==2{

            //     rssi2_rssi.text = "RSSI2 : \(beacon.rssi)"

            // }

            if(save==true){

                //show_rssi = show_rssi + "Minor - \(minor_index) : " + "\(beacon.rssi) \n"

                monitorResultTextView.text  = show_rssi;

                //saveToICloudDrive( writeString: "\(beacon.rssi)", fileName: file_real_name.text!);

                show.text = "Write to file successive!!!";

            }

            

            

            // Mod 1

            if(mode==true && save==true && major_index==1){

                show_rssi = show_rssi + "Minor - \(minor_index) : " + "\(beacon.rssi) \n"

                if let tmp_str = threshold.text, let threshold_value = Double(tmp_str) {

                    rssi_measue_test.text = "\(RSSImeasure)"

                } else {

                    rssi_measue_test.text = "RSSI_measure have no number!!!"

                }

                switch minor_index{

                case 1: RSSI_value.text = "\(RSSI_Double)"

                case 2: RSSI_value2.text  = "\(RSSI_Double)"

                case 3: RSSI_value3 .text = "\(RSSI_Double)"

                case 4: RSSI_value4.text = "\(RSSI_Double)"

                default : print("Error")

                }

                switch minor_index{

                case 1: Distance_value.text = "\(distance) m"

                case 2: Distance_value2.text = "\(distance) m"

                case 3: Distance_value3.text = "\(distance) m"

                case 4: Distance_value4.text = "\(distance) m"

                default : print("Error")

                }

                

                // start  Algorithm

                // step2 : Append Distance to Array

                Distance_records1[minor_index].append(distance)

                RSSI_records[minor_index].append(RSSI_Double)

                // step3 : mean Distance

                if Distance_records1[minor_index].count == 3 {

                    let mean_Distance = mean(of : Distance_records1[minor_index])

                    let mean_RSSI = mean(of: RSSI_records[minor_index])

                    // let stdValue = standardDeviation(of: Distance_records1[minor_index])

                    // let filteredRssi = filterOutliers(from: Distance_records1[minor_index], withMean: mean_Distance, standardDeviation: stdValue, threshold: threshold_value)

                    Distance_records1[minor_index].removeAll()

                    beacons_value[minor_index-1].d = mean_Distance

                    beacons_value[minor_index-1].rssi = mean_RSSI

                    // check set true and  show mean distance

                    switch minor_index{

                    case 1: distance_1_check = true

                    case 2: distance_2_check = true

                    case 3: distance_3_check = true

                    case 4: distance_4_check = true

                    default : print("Error")

                    }

                    rssi2_rssi.text = ""

                }

                // step4 : do the trilateration

                if (distance_1_check && distance_2_check && distance_3_check && distance_4_check) {

                    let sortedBeacons = beacons_value.sorted(by: { (b1,b2) -> Bool in return b1.d < b2.d})

                    // C4取3 - (0,1,2)

                    if let position = triangulatePosition(circle1: sortedBeacons[0].center, radius1: sortedBeacons[0].d, circle2: sortedBeacons[1].center, radius2: sortedBeacons[1].d, circle3: sortedBeacons[2].center, radius3: sortedBeacons[2].d) as Point?{

                        x.append(position.x)

                        y.append(position.y)

                         let formatted_x = String(format: "%.3f", position.x)

                         let formatted_y = String(format: "%.3f", position.y)

                         test.text = "x : \(formatted_x) | y : \(formatted_y)  | \(x.count)"

                         triangle1.text = "Minor - \(sortedBeacons[0].idx) | Disance :  \(sortedBeacons[0].d)"

                         triangle2.text = "Minor - \(sortedBeacons[1].idx) | Disance :  \(sortedBeacons[1].d)"

                         triangle3.text = "Minor - \(sortedBeacons[2].idx) | Disance :  \(sortedBeacons[2].d)"

                         rssi2_rssi.text = "update true"

                    }

                    // C4取3 - (0,1,3)

//                    if let position = triangulatePosition(circle1: sortedBeacons[0].center, radius1: sortedBeacons[0].d, circle2: sortedBeacons[1].center, radius2: sortedBeacons[1].d, circle3: sortedBeacons[3].center, radius3: sortedBeacons[3].d) as Point? {

//                        x.append(position.x)

//                        y.append(position.y)

//                        let formatted_x = String(format: "%.2f", position.x)

//                        let formatted_y = String(format: "%.2f", position.y)

//                        test.text = "x : \(formatted_x) | y : \(formatted_y)  | \(x.count)"

//                         triangle1.text = "Minor - \(sortedBeacons[0].idx)"

//                         triangle2.text = "Minor - \(sortedBeacons[1].idx)"

//                         triangle3.text = "Minor - \(sortedBeacons[3].idx)"

//                    }

//                    // C4取3 - (0,2,3)

//                    if let position = triangulatePosition(circle1: sortedBeacons[0].center, radius1: sortedBeacons[0].d, circle2: sortedBeacons[2].center, radius2: sortedBeacons[2].d, circle3: sortedBeacons[3].center, radius3: sortedBeacons[3].d) as Point? {

//                        x.append(position.x)

//                        y.append(position.y)

//                        let formatted_x = String(format: "%.2f", position.x)

//                        let formatted_y = String(format: "%.2f", position.y)

//                        test.text = "x : \(formatted_x) | y : \(formatted_y)  | \(x.count)"

//                         triangle1.text = "Minor - \(sortedBeacons[0].idx)"

//                         triangle2.text = "Minor - \(sortedBeacons[2].idx)"

//                         triangle3.text = "Minor - \(sortedBeacons[3].idx)"

//                    }

//                    // C4取3 - (1,2,3)

//                    if let position = triangulatePosition(circle1: sortedBeacons[1].center, radius1: sortedBeacons[1].d, circle2: sortedBeacons[2].center, radius2: sortedBeacons[2].d, circle3: sortedBeacons[3].center, radius3: sortedBeacons[3].d) as Point? {

//                        x.append(position.x)

//                        y.append(position.y)

//                        let formatted_x = String(format: "%.2f", position.x)

//                        let formatted_y = String(format: "%.2f", position.y)

//                        test.text = "x : \(formatted_x) | y : \(formatted_y)  | \(x.count)"

//                         triangle1.text = "Minor - \(sortedBeacons[1].idx)"

//                         triangle2.text = "Minor - \(sortedBeacons[2].idx)"

//                         triangle3.text = "Minor - \(sortedBeacons[3].idx)"

//                    }

                    freq_first_idx[sortedBeacons[0].idx] += 1

                    freq_second_idx[sortedBeacons[1].idx] += 1

                    if freq_first_idx[Most_idx] < freq_first_idx[sortedBeacons[0].idx] {

                        Most_idx = sortedBeacons[0].idx

                    }

                    distance_1_check = false

                    distance_2_check = false

                    distance_3_check = false

                    distance_4_check = false

                }

                

                

                if x.count==limit && y.count==limit {

                    let mean_x = mean(of :x)

                    let mean_y = mean(of :y)

                    test.text = "mean_x : \(mean_x) | mean_y : \(mean_y)"

                    x.removeAll()

                    y.removeAll()

                    // -----Greedy Solution --------//

                    if freq_first_idx[Most_idx] > limit*3/5{

                        switch Most_idx {

                        case 0 : decision(A_Low_value : A_Low_value , A_Upper_value : A_Upper_value , B_Low_value : B_Low_value , B_Upper_value : B_Upper_value , C_Low_value : C_Low_value , C_Upper_value : C_Upper_value , mean_y : mean_y)

                        case 1 : Answer_value.text = "C"

                        case 2 : Answer_value.text = "B"

                        case 3 : Answer_value.text = "A"

                        case 4 : Answer_value.text = "A"

                        default : break

                        }

                        

                        greedy_test.text = "Greedy Solution" + "\n" + "Most_idx: \(Most_idx) with \(freq_first_idx[Most_idx])"

                    }else{

                        // ---- decision ------ //

                        decision(A_Low_value : A_Low_value , A_Upper_value : A_Upper_value , B_Low_value : B_Low_value , B_Upper_value : B_Upper_value , C_Low_value : C_Low_value , C_Upper_value : C_Upper_value , mean_y : mean_y)

                        greedy_test.text = "三角定位 ！！"

                    }

                    freq_first_idx = [Int](repeating: 0, count: 5)

                    x_ans.text = ""

                    y_ans.text = ""

                }

            }

            // Mod 2

            else if (mode==false && save==true && major_index==2){

                // step2 : Append Distance to Array

                //RSSI_Method2[minor_index].addRSSI(RSSI_Double)

                Distance_records2[minor_index].append(distance)

                RSSI_records2[minor_index].append(RSSI_Double)

                switch minor_index{

                case 1: RSSI_value.text = "\(RSSI_Double)"

                case 2: RSSI_value2.text  = "\(RSSI_Double)"

                case 3: RSSI_value3 .text = "\(RSSI_Double)"

                case 4: RSSI_value4.text = "\(RSSI_Double)"

                case 5: RSSI_value5.text = "\(RSSI_Double)"

                case 6: RSSI_value6.text = "\(RSSI_Double)"

                case 7: RSSI_value7.text = "\(RSSI_Double)"

                case 8: RSSI_value8.text = "\(RSSI_Double)"

                default : print("Error")

                }

                switch minor_index{

                case 1: Distance_value.text = "\(distance) m"

                case 2: Distance_value2.text = "\(distance) m"

                case 3: Distance_value3.text = "\(distance) m"

                case 4: Distance_value4.text = "\(distance) m"

                case 5: Distance_value5.text = "\(distance) m"

                case 6: Distance_value6.text = "\(distance) m"

                case 7: Distance_value7.text = "\(distance) m"

                case 8: Distance_value8.text = "\(distance) m"

                default : print("Error")

                }

                if Distance_records2[minor_index].count == 5 {

                    let mean_Distance = mean(of : Distance_records2[minor_index])

                    let mean_RSSI = mean(of: RSSI_records2[minor_index])

                    

                    Distance_records2[minor_index].removeAll()

                    beacons_value2[minor_index-1].d = mean_Distance

                    beacons_value2[minor_index-1].rssi = mean_RSSI

                    // check set true and  show mean distance

                    switch minor_index{

                    case 1: distance_1_check = true

                    case 2: distance_2_check = true

                    case 3: distance_3_check = true

                    case 4: distance_4_check = true

                    case 5: distance_5_check = true

                    case 6: distance_6_check = true

                    case 7: distance_7_check = true

                    case 8: distance_8_check = true

                    default : print("Error")

                    }

                }

                // step4 : do the trilateration

                if (distance_1_check && distance_2_check && distance_3_check && distance_4_check && distance_5_check && distance_6_check && distance_7_check && distance_8_check) {

                    let sortedBeacons = beacons_value2.sorted(by: { (b1,b2) -> Bool in return b1.d < b2.d})

                    if let position = triangulatePosition(circle1: sortedBeacons[0].center, radius1: sortedBeacons[0].d, circle2: sortedBeacons[1].center, radius2: sortedBeacons[1].d, circle3: sortedBeacons[2].center, radius3: sortedBeacons[2].d) as Point?{

                        x.append(position.x)

                        y.append(position.y)

                        let formatted_x = String(format: "%.2f", position.x)

                        let formatted_y = String(format: "%.2f", position.y)

                        test.text = "x : \(formatted_x) | y : \(formatted_y) | \(x.count)"

                        triangle1.text = "Minor - \(sortedBeacons[0].idx)"

                        triangle2.text = "Minor - \(sortedBeacons[1].idx)"

                        triangle3.text = "Minor - \(sortedBeacons[2].idx)"

                    }

                    

                    distance_1_check = false

                    distance_2_check = false

                    distance_3_check = false

                    distance_4_check = false

                    distance_5_check = false

                    distance_6_check = false

                    distance_7_check = false

                    distance_8_check = false

                }

                

                

                if x.count==limit && y.count==limit {

                    let mean_x = mean(of :x)

                    let mean_y = mean(of :y)

                    Answer_value.text = " "

                    let formatted_x = String(format: "%.2f", mean_x)

                    let formatted_y = String(format: "%.2f", mean_y)

                    x_ans.text = "x: \(formatted_x)"

                    y_ans.text = "y: \(formatted_y)"

                    x.removeAll()

                    y.removeAll()

                }

            }

        }

    }



    

    @IBAction func start_button(_ sender: Any) {

        save = true;

        show.text = "Start_button push!!!";

    }

    

    @IBAction func stop_button(_ sender: Any) {

        save = false;

        show.text = "Stop_button push!!!";

    }

    @IBAction func reset(_ sender: Any) {

        show_rssi = "";

        for i in 0..<5{

           RSSI_records[i].removeAll()

           Distance_records1[i].removeAll()

        }

        for i in 0..<9{

            RSSI_records2[i].removeAll()

            Distance_records1[i].removeAll()

        }

        freq_first_idx = [Int](repeating: 0, count: 5)

        Most_idx = 0

        filteredRssi.removeAll()

        monitorResultTextView.text  = show_rssi;

        x.removeAll()

        y.removeAll()

        Answer_value.text = "None"

        test.text=""

        Distance_value.text = "0 m"

        Distance_value2.text = "0 m"

        Distance_value3.text = "0 m"

        Distance_value4.text = "0 m"

        Distance_value5.text = "0 m"

        Distance_value6.text = "0 m"

        Distance_value7.text = "0 m"

        Distance_value8.text = "0 m"

        triangle1.text = "Minor - "

        triangle2.text = "Minor - "

        triangle3.text = "Minor - "

        distance_1_check = false

        distance_2_check = false

        distance_3_check = false

        distance_4_check = false

        distance_5_check = false

        distance_6_check = false

        distance_7_check = false

        distance_8_check = false

        greedy_test.text = ""

        rssi2_rssi.text = ""

        RSSI_value.text = ""

        RSSI_value2.text  = ""

        RSSI_value3 .text = ""

        RSSI_value4.text = ""

        RSSI_value5.text = ""

        RSSI_value6.text = ""

        RSSI_value7.text = ""

        RSSI_value8.text = ""

    }

    

    @IBAction func Mod1(_ sender: Any) {

        mode = true;

        mode_test.text = "<-"

    }

    

    @IBAction func Mod2(_ sender: Any) {

        mode = false;

        mode_test.text = "->"

    }

}