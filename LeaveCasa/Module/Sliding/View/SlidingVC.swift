import UIKit

class SlidingVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var getStarted: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    //MARK: - Variables
    var slidingTitle = ["Plan a Trip", "Book a Flight", "Enjoy Your Trip"]
    var slidingDescription = ["You can select the date and also we can help you by suggesting you to set a good schedule", "Found a flight that matches your destination and schedule? Book it instantly in just a few taps", "Easy discovering new places and share these between your friends and travel together"]
    var sliderImages = [UIImage(named: "ic_onBorading1"), UIImage(named: "ic_onBoarding2"), UIImage(named: "ic_onBoarding3")]
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    //MARK: - Custom methods
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.ragisterNib(nibName: SlidingXIB().identifier)
    }
    
    // MARK: - @IBActions
    @IBAction func skipClicked(_ sender: UIButton) {
        Cookies.saveIntro(bool: true)
        let vc = ViewControllerHelper.getViewController(ofType: .PhoneLoginVC, StoryboardName: .Main) as! PhoneLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        let pageNumber = self.pageControl.currentPage
        let newPageNumber = pageNumber + 1
        
        self.pageControl.currentPage = newPageNumber
        self.collectionView.scrollToItem(at: IndexPath(item: newPageNumber, section: 0), at: .centeredHorizontally, animated: true)
        
        if newPageNumber == 2 {
            btnNext.isHidden = true
            btnSkip.isHidden = true
            pageControl.isHidden = true
            getStarted.isHidden = false
            collectionView.isUserInteractionEnabled = false
        }
        else {
            btnNext.isHidden = false
            btnSkip.isHidden = false
            pageControl.isHidden = false
            getStarted.isHidden = true
        }
    }
    
    @IBAction func getStartedClicked(_ sender: UIButton) {
        Cookies.saveIntro(bool: true)
        let vc = ViewControllerHelper.getViewController(ofType: .PhoneLoginVC, StoryboardName: .Main) as! PhoneLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension SlidingVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slidingTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlidingXIB().identifier, for: indexPath) as! SlidingXIB
        
        cell.lblSlidingTitle.text = slidingTitle[indexPath.row]
        cell.lblSlidingDescription.text = slidingDescription[indexPath.row]
        cell.imgBackground.image = sliderImages[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UISCROLLVIEW DELEGATE
extension SlidingVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        self.pageControl.currentPage = pageNumber
        
        if pageNumber == 2 {
            btnNext.isHidden = true
            btnSkip.isHidden = true
            pageControl.isHidden = true
            getStarted.isHidden = false
            collectionView.isUserInteractionEnabled = false
        }
        else {
            btnNext.isHidden = false
            btnSkip.isHidden = false
            pageControl.isHidden = false
            getStarted.isHidden = true
        }
    }
}
