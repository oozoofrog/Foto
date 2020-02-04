import Photos
import Combine

@available(iOS 13.0, *)
open final class Foto: NSObject, ObservableObject {
    
    @Published private(set) open var isAuthorized: Bool = PHPhotoLibrary.authorizationStatus() == .authorized
    
    private let library = PHPhotoLibrary.shared()
    
    open override init() {
        super.init()
        
        library.register(self as PHPhotoLibraryAvailabilityObserver)
    }
    
    open func requestAuthorize() {
        PHPhotoLibrary.requestAuthorization { (status) in
            self.isAuthorized = status == .authorized
        }
    }
}

open extension Foto: PHPhotoLibraryAvailabilityObserver {
    
    func photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary) {
        isAuthorized = false
    }
    
}
