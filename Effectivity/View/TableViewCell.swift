//
//  TableViewCell.swift
//  Effectivity
//
//  Created by Владимир on 24.06.2023.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.HelveticaNeueMedium.rawValue, size: 18)
        return label
    }()
    
    let text: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.HelveticaNeueLightItalic.rawValue, size: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.HelveticaNeue.rawValue, size: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let priorityCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    var viewModel: TableViewCellViewModelType? {
        didSet {
            self.title.text = viewModel?.task?.title
            self.text.text = viewModel?.task?.text
            self.priorityCircle.backgroundColor = viewModel?.task?.priorityColor()
            self.date.text = viewModel?.task?.deadline.format()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(priorityCircle)
        self.contentView.addSubview(title)
        self.contentView.addSubview(text)
        self.contentView.addSubview(date)
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = UIColor(red: 255/255, green: 228/255, blue: 167/255, alpha: 1.0) //255,228,167
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLayout () {
        priorityCircle.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
                
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(text.snp.top).offset(-5)
            make.right.equalTo(priorityCircle.snp.left).offset(-10)
        }
        
        text.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.right.equalTo(priorityCircle.snp.left).offset(-10)
        }
        
        date.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(text.snp.bottom).offset(5)
            make.right.equalTo(priorityCircle.snp.left).offset(-10)
        }
        

    }

}
