
import UIKit
import Photos
import Starscream

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var menuList = [[Menu]]()
    var cart = [Int:OrderMenu]()
    
    let socket = SocketClient.chatWebSocketClient
    
    private let cashesURL :URL =
    {
        //大概以後 會加入其他程式碼 先習慣吧   默認路徑一定拿得到 ！！！
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }()
    
    //通用型的 下載menuList task
    func downloadMenuList(_ tableViewContoler:UITableViewController?)  {
        
        Downloader.shared.test(tableViewContoler) { (controler, error, data) in
            
            //            print("data: \(String(describing: String(data: data, encoding: .utf8)))")
            guard let MenuArray = try? JSONDecoder().decode([[Menu]].self, from: data) else{
                assertionFailure("Fail decoder")
                return}
            
            self.menuList = MenuArray
            
            guard let tableviewcontrol = controler else{
                print("收到通知 介面更新\n\n")
//                assertionFailure("nil tableViewControl")
                return}
            
            DispatchQueue.main.async {
                
                let filemanager = FileManager.default
                
                if let results = try?filemanager.contentsOfDirectory(atPath: self.cashesURL.path){
                    
                    for item in results{
                        //                        let remove =  try? filemanager.removeItem(atPath:target)
                        let url = self.cashesURL.appendingPathComponent(item)
//                        print("item: \(url)")
                        _ =  try? filemanager.removeItem(at: url)
                    }
                }
                
                tableviewcontrol.tableView.reloadData()
            }
        }
    }
    
    
    
 
    
   
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 沒寫權限 會閃退
        // Ask user's permission to access photos library.
        PHPhotoLibrary.requestAuthorization { (status) in
            print("PHPhotoLibrary.requestAuthorization: \(status.rawValue)")
            
            
            if self.socket.socket.delegate == nil{
                print("socket 連線")
                self.socket.startLinkServer()
            }
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
        commonWebSocketClient?.stopWebSocket()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        commonWebSocketClient?.startWebSocket()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }


}

