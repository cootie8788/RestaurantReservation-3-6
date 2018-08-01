
import UIKit

extension UIImageView{
    
    
    static var currentTask = [String:URLSessionDataTask]()  //用String 來區別Task
    
    func showImage(urlString:String, id:Int) {
        
        guard let url = URL(string: urlString) else {
            assertionFailure("url nil")
            return
        }
        
//        print("self.description:\(self.description) ")
        
        //Ckeck if we should canecl exist download task.
        if let existTask = UIImageView.currentTask[self.description] {//
            
            existTask.cancel()
            UIImageView.currentTask.removeValue(forKey: self.description)
            print("A exist task is canceled.")
        }
        
        let filename = String(format: "Cache_%ld", url.hashValue)//hashValue會拿出int （唯一的數字當檔名）
//        print("想看 \(filename)\n" )
        
        guard let cashesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first// urls是陣列 取得第一個（因該也只有一個）
            else {//for 這邊指會搜尋
                return
        }

        let fullFileURL = cashesURL.appendingPathComponent(self.description) //（完整路徑）硬碟某個檔案的路徑
//                print("\n Cashes:  \(fullFileURL)\n" )

        if let image = UIImage(contentsOfFile: fullFileURL.path){

            self.image=image
            return
        }//有圖上面載入   沒圖下方產生
        
        
        
        
        let loadingView = perpareLoadingView()
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        var request = URLRequest(url: url)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject:
            ["action":"getImage","id":id,"imageSize":"200"], options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //這邊會 URLsession 會開始執行背景程式
        let task = session.dataTask(with: request) { (data, response , error) in
            
            defer{//英文延後的意思
                DispatchQueue.main.async { //只要是 一對大括號{}執行後結束就會執行defer ex:  if func
                    loadingView.stopAnimating()
                }//
            }//可以把多個defer 想成堆疊 (由上至下執行)
            
            if let error = error{//下載失敗
                print("Down fail:  \(error)")
                return
                //Maybe show a default image
            }
            
            guard let data = data else{//有資料 才做下面的事情
                assertionFailure("data is nil")     //邏輯上是 不該來到這的 會閃退
                return
            }
  
            
            let image = UIImage(data: data) //raw data
            //Very very Important
            DispatchQueue.main.async {//切回main thread
            
                self.image = image
            }
           
            //Save data as cashes file.
            try? data.write(to: fullFileURL)  //只想知道 成功或失敗 失敗會回傳nil
            
            
            
            //Remove task from currentTask.
            if let existTask1 = UIImageView.currentTask[self.description] {//
                
                UIImageView.currentTask.removeValue(forKey: self.description)  //結束任務時 清除字典
            }
            
            
            
        }//這邊有bug
        
        task.resume() // Important  開始任務
        //Keep the running task.
        UIImageView.currentTask[self.description] = task  //description 不會重複
        
        
        loadingView.startAnimating()
        //轉轉轉開始跑
        
//        task.cancel()//任務取消
//        task.suspend()//掛起

    }
    
    
    
    private func perpareLoadingView() -> UIActivityIndicatorView{//不該重複叫轉轉轉 降低效能
        //Find out exist loadingView.
//        for view in self.subviews{   //只要addview 加入的 都會到self.subviews
//            if view is UIActivityIndicatorView{
//                return view as! UIActivityIndicatorView
//            }//找到veiw 在做處理
//        }
        
        let tag = 98765
        if let view = self.viewWithTag(tag) as? UIActivityIndicatorView{  //tag 會在sub的所以階層往下找
            return view
        }//這段是使用 veiw中的tag id找到對應的view
        
        
        let frame = CGRect(origin: .zero, size: self.frame.size) //auto layout前身
        //frame 很大   整個frame蓋住 元件特性 會保持原樣 不會跟者放大
//        result.autoresizingMask = [.flexibleHeight ,.flexibleWidth ]
        //上面這行可以讓轉轉轉 可以至中
        let result = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)//這邊是style
        
        result.frame = frame
        result.color = .blue
        result.autoresizingMask = [.flexibleHeight ,.flexibleWidth ]
        
        result.hidesWhenStopped = true //若無再跑 會隱藏
        result.tag = tag
        
        self.addSubview(result)
        
        return result
        
    }
    
    
    
    
}

