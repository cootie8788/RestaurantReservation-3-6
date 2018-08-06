

import UIKit

class Camera: NSObject, UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    
    var controler : UIViewController
    var imageView : UIImageView
    
    init(_ controler:UIViewController, _ imageView:UIImageView) {
        self.controler = controler
        self.imageView = imageView
    }
    
    
    
    //MASK: - UIImagePickerController && protpcol Methods
    func lauchPicker(forType: UIImagePickerControllerSourceType)  {
        
        //Check if this is a valid sourse type
        guard  UIImagePickerController.isSourceTypeAvailable(forType) else {
            return print("Invalid sourse type")
        }//有無可用的裝置
        
        let picker = UIImagePickerController()
        picker.mediaTypes = ["public.image","public.movie"]
        //        picker.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
        //要用上面的字串要import MobileCoreServices
        
        //CF String 是c語言的
        picker.sourceType = forType
        picker.delegate = controler as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        controler.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //會帶回來字典 跟使用者的內容
        //            print("didFinishPickingMediaWithInfo: \(info)")
        //info裡面儲存很多資訊、假如是拍照得到的照片->甚至可以得到亮度...等等攝影資訊
        guard let type = info[UIImagePickerControllerMediaType]as? String else {
            return assertionFailure("Invalid type") }
        
        if type == ("public.image") {
            guard let originalImage = info[UIImagePickerControllerOriginalImage]as? UIImage else{
                return assertionFailure("No Original image.")
            }
            //            print("Original image: \(originalImage.size)")
            //            let pngData = UIImagePNGRepresentation(originalImage)
            //            let jpgData = UIImageJPEGRepresentation(originalImage, 0.8)
            //            print("pngData: \(pngData!.count) bytes, jpgData: \(jpgData!.count) bytes.")
            //
            // Resize originalImage
            guard let resizedImage = originalImage.resize(maxWidthHeight: 200) else{
                return assertionFailure("Fail to resize.")
            }
            //                print("resized Image: \(resizedImage.size)")
            //                let pngData2 = UIImagePNGRepresentation(originalImage)
            
            guard let jpgData2 = UIImageJPEGRepresentation(resizedImage, 0.8) else{
                return assertionFailure("Fail to generate JPG file. ")
            }
            //                print("pngData: \(pngData2!.count) bytes, jpgData: \(jpgData2.count) bytes")
            
            
            imageView.image = UIImage(data: jpgData2)
            controler.reloadInputViews()
            controler.view.reloadInputViews()
            
        } else if type == ("public.movie"){
            //..
        }
        picker.dismiss(animated: true) //Important !  把picker 收起來
    }
    
}

