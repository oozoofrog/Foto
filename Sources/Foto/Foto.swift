import Photos

@available(iOS 13.0, *)
open class Foto: NSObject {
    
    weak var delegate: FotoDelegate?
    
    private(set) open var isAuthorized: Bool = PHPhotoLibrary.authorizationStatus() == .authorized
    
    private let library = PHPhotoLibrary.shared()
    
    private(set) var fetched: PHFetchResult<PHAsset> = .init()
    open var count: Int { fetched.count }
    
    public override init() {
        super.init()
        
        library.register(self as PHPhotoLibraryAvailabilityObserver)
        library.register(self as PHPhotoLibraryChangeObserver)
    }
    
    open func requestAuthorize() {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isAuthorized = status == .authorized
                self.delegate?.fotoUpdated(self)
            }
        }
    }
    
    open func requestPhotos(with option: Option) {
        self.fetched = option.fetchAssets()
        self.delegate?.fotoUpdated(self)
    }
    
    open func asset(at index: Int) -> PHAsset {
        fetched.object(at: index)
    }
    
    public struct Option {
        public static let all: Option = .init()
        
        func fetchAssets() -> PHFetchResult<PHAsset> {
            PHAsset.fetchAssets(with: nil)
        }
    }
}

extension Foto: PHPhotoLibraryAvailabilityObserver, PHPhotoLibraryChangeObserver {
    
    open func photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary) {
        isAuthorized = false
        self.delegate?.fotoUpdated(self)
    }
    
    open func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let fetched = changeInstance.changeDetails(for: self.fetched)?.fetchResultAfterChanges else { return }
        self.fetched = fetched
        self.delegate?.fotoUpdated(self)
    }
    
}

public protocol FotoDelegate: class {
    
    func fotoUpdated(_ foto: Foto)
    
}
