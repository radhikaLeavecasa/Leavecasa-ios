//
//  ImagePreview.swift
//  LeaveCasa
//
//  Created by acme on 04/10/22.
//

import UIKit
import SDWebImage

class WithURLsViewController:UIViewController {
    
    // load a lower resolution images
    var images:[URL] = [URL]()
    lazy var layout = GalleryFlowLayout()
    
    lazy var collectionView:UICollectionView = {
        // Flow layout setup
        let cv = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        cv.register(
            ThumbCell.self,
            forCellWithReuseIdentifier: ThumbCell.reuseIdentifier)
        cv.dataSource = self
        return cv
    }()
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        collectionView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
            .isActive = true
        collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
            .isActive = true
        collectionView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gallery"
        SDImageCache.shared.clear(with: .all, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayout(view.frame.size)
    }
    
    private func updateLayout(_ size:CGSize) {
        if size.width > size.height {
            layout.columns = 4
        } else {
            layout.columns = 3
        }
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
            updateLayout(size)
        }
}

extension WithURLsViewController:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return images.count
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell:ThumbCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ThumbCell.reuseIdentifier,
                                     for: indexPath) as! ThumbCell
            cell.imageView.sd_setImage(with: self.images[indexPath.item], placeholderImage: .hotelplaceHolder())
            return cell
        }
}


class ThumbCell:UICollectionViewCell {
    
    static let reuseIdentifier: String = "ThumbCell"
    var imageView:UIImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                UIView.animate(
                    withDuration: 0.1,
                    animations: {
                        self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                    })
            } else {
                UIView.animate(
                    withDuration: 0.1,
                    animations: {
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
            }
        }
    }
}



class GalleryFlowLayout:UICollectionViewFlowLayout {
    
    var columns:Int = 3 {
        didSet {
            if columns != oldValue {
                invalidateLayout()
            }
        }
    }
    
    var horizontalCellSpacing:CGFloat = 1
    var verticalCellSpacing:CGFloat = 1
    var cache = [UICollectionViewLayoutAttributes]()
    
    
    var width:CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    /// Getting the item width: itemWith = width - ((col+1)* spacing)/col
    var cellContentWidth:CGFloat {
        return (width - (horizontalCellSpacing * CGFloat(columns - 1)))/CGFloat(columns)
    }
    
    var cellContentHeight:CGFloat {
        return cellContentWidth
    }
    
    public var contentHeight:CGFloat {
        let numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        let rows = numberOfItems/columns + (numberOfItems%columns==0 ? 0:1)
        return (CGFloat(rows) * verticalCellSpacing) + (CGFloat(rows) * cellContentHeight)
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override public func prepare() {
        
        if !cache.isEmpty {
            return
        }
        
        let numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        for item in 0..<numberOfItems {
            
            let indexPath:IndexPath = IndexPath(item: item, section: 0)
            
            let columnIndex = indexPath.row % columns
            let rowIndex = indexPath.row / columns
            
            // create a frame for the item
            let x = CGFloat(columnIndex) * horizontalCellSpacing + (cellContentWidth * CGFloat(columnIndex))
            let y = CGFloat(rowIndex) * verticalCellSpacing + (cellContentHeight * CGFloat(rowIndex))
            
            let itemRect = CGRect(
                x: x,
                y: y,
                width: cellContentWidth,
                height: cellContentHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = itemRect
            cache.append(attributes)
        }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cache[indexPath.row]
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.size != collectionView?.bounds.size
    }
    
    public override func invalidateLayout() {
        cache.removeAll()
        super.invalidateLayout()
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func scale(by scale: CGFloat) -> UIImage? {
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return resize(targetSize: scaledSize)
    }
}

extension CGSize {
    static let thumbnail:CGSize = CGSize(width: 50, height:50)
}
