import UIKit

class ListViewController: UIViewController, ListViewProtocol {
    
    func update() {
        controlButton.setTitle(viewModel.isActiveTimer ? "Stop".uppercased() : "Start".uppercased(), for: .normal)
        controlButton.backgroundColor = viewModel.isActiveTimer ? .customOrange : .customGreen
        collectionView.reloadData()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var controlButton: UIButton!
    
    private var highlightedCell: Int? = nil
    
    // MARK: Old timer implementation
    // var viewModel = ListViewModel(decisionProvider: RandomDecisionProvider())
    var viewModel = ListViewModelCombine()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.delegate = self
        setupControlButton()
        setupCollectionView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.collectionView.reloadData()
    }
    
    @IBAction func onTappedControlButton(_ sender: UIButton) {
        viewModel.manageTimer()
    }
    
    private func setupControlButton() {
        controlButton.layer.cornerRadius = 5
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
    }
    
    private func uiColorForElement(elementColor: ElementColor) -> UIColor? {
        switch elementColor {
        case .blue:
            return .customBlue
        case .orange:
            return .customOrange
        }
    }
}

extension ListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.elementsTuples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListCollectionViewCell
        
        let tuples = viewModel.elementsTuples
        
        let element = tuples[indexPath.row]
        
        cell.backgroundColor = indexPath.row == highlightedCell ? .lightBlue : .clear
        
        cell.separatorView.isHidden = indexPath.row == tuples.count - 1 ? true : false
        cell.circleImage.tintColor = uiColorForElement(elementColor: element.color)
        cell.numberLabel.text = String(element.number).uppercased()
        
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        highlightedCell = indexPath.row
        viewModel.onTimerCounting()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            if self?.highlightedCell == indexPath.row {
                self?.highlightedCell = nil
                self?.collectionView.reloadData()
            }
        }
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.collectionView.frame.width, height: 96)
    }
}




