import Photos
import Combine

@available(iOS 13.0, *)
open class Foto: NSObject, ObservableObject {
    
    @Published private(set) open var isAuthorized: Bool = PHPhotoLibrary.authorizationStatus() == .authorized
    
    private let library = PHPhotoLibrary.shared()
    
    private(set) open var fetched: PHFetchResult<PHAsset> = .init()
    
    public override init() {
        super.init()
        
        library.register(self as PHPhotoLibraryAvailabilityObserver)
    }
    
    open func requestAuthorize() {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async { [weak self] in
                self?.isAuthorized = status == .authorized
            }
        }
    }
    
    open func requestPhotos(with option: Option) {
        self.fetched = option.fetchAssets()
    }
    
    public struct Option {
        public static let all: Option = .init()
        
        func fetchAssets() -> PHFetchResult<PHAsset> {
            PHAsset.fetchAssets(with: nil)
        }
    }
}

extension Foto: PHPhotoLibraryAvailabilityObserver {
    
    open func photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary) {
        isAuthorized = false
    }
    
}
