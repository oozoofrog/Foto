import Photos
import Combine

@available(iOS 13.0, *)
final class Foto: NSObject, ObservableObject {
    
    @Published private(set) var isAuthorized: Bool = PHPhotoLibrary.authorizationStatus() == .authorized
    
    private let library = PHPhotoLibrary.shared()
    
    override init() {
        super.init()
        
        library.register(self as PHPhotoLibraryAvailabilityObserver)
    }
    
}

extension Foto: PHPhotoLibraryAvailabilityObserver {
    
    func photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary) {
        isAuthorized = false
    }
    
}
