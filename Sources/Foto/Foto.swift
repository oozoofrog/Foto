import Photos
import Combine

@available(iOS 13.0, *)
open class Foto: NSObject, ObservableObject {
    
    @Published private(set) open var isAuthorized: Bool = PHPhotoLibrary.authorizationStatus() == .authorized
    
    private let library = PHPhotoLibrary.shared()
    
    public override init() {
        super.init()
        
        library.register(self as PHPhotoLibraryAvailabilityObserver)
    }
    
    open func requestAuthorize() {
        PHPhotoLibrary.requestAuthorization { (status) in
            self.isAuthorized = status == .authorized
        }
    }
}

extension Foto: PHPhotoLibraryAvailabilityObserver {
    
    open func photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary) {
        isAuthorized = false
    }
    
}
