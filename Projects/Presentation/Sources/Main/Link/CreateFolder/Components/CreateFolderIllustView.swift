import UIKit

// MARK: - CreateFolderIllustView

class CreateFolderIllustView: UIView, UICollectionViewDelegateFlowLayout {
  // MARK: UI

  private lazy var scrollView = UIScrollView()

  private lazy var titleLabel = {
    let label = UILabel()
    label.text = "일러스트"
    label.font = .subTitleSemiBold
    return label
  }()

  private var illustGrid: UICollectionView!

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    setCollection()
    setView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setCollection() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 106, height: 106)
    layout.minimumInteritemSpacing = 8
    layout.minimumLineSpacing = 8

    illustGrid = UICollectionView(frame: bounds, collectionViewLayout: layout)
    illustGrid.backgroundColor = .clear
    illustGrid.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    illustGrid.dataSource = self
    illustGrid.delegate = self
  }

  private func setView() {
    addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }

    scrollView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.top.equalToSuperview().offset(16)
    }

    scrollView.addSubview(illustGrid)
    illustGrid.snp.makeConstraints { make in
      make.width.equalToSuperview().offset(-40)
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
      make.height.equalTo(500)
      make.bottom.equalToSuperview().offset(-12)
    }
  }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension CreateFolderIllustView: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 12
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    cell.backgroundColor = .systemGreen
    cell.layer.cornerRadius = 10
    return cell
  }
}
