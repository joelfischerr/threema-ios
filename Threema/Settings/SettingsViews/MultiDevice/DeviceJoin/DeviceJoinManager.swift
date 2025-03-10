//  _____ _
// |_   _| |_  _ _ ___ ___ _ __  __ _
//   | | | ' \| '_/ -_) -_) '  \/ _` |_
//   |_| |_||_|_| \___\___|_|_|_\__,_(_)
//
// Threema iOS Client
// Copyright (c) 2023-2025 Threema GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License, version 3,
// as published by the Free Software Foundation.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import CocoaLumberjackSwift
import Foundation

class DeviceJoinManager: ObservableObject {
    
    enum ViewState: Equatable {
        case scanQRCode
        case establishRendezvousConnection
        case verifyRendezvousConnection(rendezvousPathHash: Data)
        case sendJoinData
        case completed
    }
    
    enum Error: Swift.Error {
        case wrongNextState
    }
    
    @Published var viewState = ViewState.scanQRCode
    
    let deviceJoin = DeviceJoin(role: .existingDevice)
    
    deinit {
        DDLogVerbose("DeviceJoinManager deallocated")
    }
    
    @MainActor
    func advance(to nextViewState: ViewState) throws {
        guard viewState != nextViewState else {
            // Nothing to do
            return
        }
        
        // TODO: Verify switching to the next state is valid
        
        viewState = nextViewState
    }
    
    // MARK: Localization helper
    
    static var downloadURL: String {
        switch ThreemaApp.current {
        case .threema, .green:
            "https://three.ma/md"
        case .work, .onPrem, .blue:
            "https://three.ma/mdw"
        }
    }
}
