import UIKit
import YandexMapsMobile
import Foundation
import CoreData

class MainViewController: UIViewController {

    var viewModel = MainViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        observeDataChanges()
    }
    
    private func setupViews() {
        title = "Notes"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondVC = mainStoryBoard.instantiateViewController(withIdentifier: "AddNote") as? AddNote else { return }
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()

    }
    
    private func registerCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func observeDataChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanges), name: .notesDidChange, object: nil)
    }
    
    @objc private func handleDataChanges() {
        tableView.reloadData()
    }
    var selectedTitle: String?
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let notes = StorageManager.shared.fetchNotes() {
                if indexPath.row < notes.count {
                    let note = notes[indexPath.row]
                    StorageManager.shared.deleteNote(with: note.title)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let yourNoteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YourNote") as? YourNote else { return }
        if let cell = tableView.cellForRow(at: indexPath) {
                selectedTitle = cell.textLabel?.text
            }
        yourNoteVC.selectedTitle = selectedTitle
                navigationController?.pushViewController(yourNoteVC, animated: true)
        
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let notes = StorageManager.shared.fetchNotes() {
            if indexPath.row < notes.count {
                let note = notes[indexPath.row]
                cell.textLabel?.text = note.title
            }
        }
        return cell
    }
}







