//  _____ _
// |_   _| |_  _ _ ___ ___ _ __  __ _
//   | | | ' \| '_/ -_) -_) '  \/ _` |_
//   |_| |_||_|_| \___\___|_|_|_\__,_(_)
//
// Threema iOS Client
// Copyright (c) 2020-2025 Threema GmbH
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

import Foundation

final class TaskDefinitionSendGroupLeaveMessage: TaskDefinitionSendMessage {
    override func create(
        frameworkInjector: FrameworkInjectorProtocol,
        taskContext: TaskContextProtocol
    ) -> TaskExecutionProtocol {
        TaskExecutionSendGroupLeaveMessage(
            taskContext: taskContext,
            taskDefinition: self,
            backgroundFrameworkInjector: frameworkInjector
        )
    }

    override func create(frameworkInjector: FrameworkInjectorProtocol) -> TaskExecutionProtocol {
        create(
            frameworkInjector: frameworkInjector,
            taskContext: TaskContext(
                logReflectMessageToMediator: .reflectOutgoingMessageToMediator,
                logReceiveMessageAckFromMediator: .receiveOutgoingMessageAckFromMediator,
                logSendMessageToChat: .sendOutgoingMessageToChat,
                logReceiveMessageAckFromChat: .receiveOutgoingMessageAckFromChat
            )
        )
    }
    
    override var description: String {
        "<\(Swift.type(of: self))>"
    }

    var fromMember: String!
    var toMembers: [String]!
    var hiddenContacts = [String]()

    private enum CodingKeys: String, CodingKey {
        case fromMember, toMembers, hiddenContacts
    }
    
    override init(sendContactProfilePicture: Bool) {
        super.init(sendContactProfilePicture: sendContactProfilePicture)
    }

    init(group: Group, sendContactProfilePicture: Bool) {
        super.init(receiverIdentity: nil, group: group, sendContactProfilePicture: sendContactProfilePicture)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let superdecoder = try container.superDecoder()
        try super.init(from: superdecoder)

        self.fromMember = try container.decode(String.self, forKey: .fromMember)
        self.toMembers = try container.decode([String].self, forKey: .toMembers)
        self.hiddenContacts = try container.decode([String].self, forKey: .hiddenContacts)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fromMember, forKey: .fromMember)
        try container.encode(toMembers, forKey: .toMembers)
        try container.encode(hiddenContacts, forKey: .hiddenContacts)

        let superencoder = container.superEncoder()
        try super.encode(to: superencoder)
    }
}
