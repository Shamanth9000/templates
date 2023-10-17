import Foundation
import Appwrite

class AppwriteService {
    private let client: Client
    private let users: Users
    private let labelsSubscriber = "subscriber"

    init() {
        client = Client()
            .setEndpoint(ProcessInfo.processInfo.environment["APPWRITE_ENDPOINT"] ?? "https://cloud.appwrite.io/v1")
            .setProject(ProcessInfo.processInfo.environment["APPWRITE_FUNCTION_PROJECT_ID"]!)
            .setKey(ProcessInfo.processInfo.environment["APPWRITE_API_KEY"]!)

        users = Users(client)
    }

    func deleteSubscription(userId: String) async throws {
        let labels = try await users.get(userId: userId).labels.compactMap { $0 as? String }.filter { $0 != labelsSubscriber }
        try await users.updateLabels(userId: userId, labels: labels)
    }

    func createSubscription(userId: String) async throws {
        var labels = try await users.get(userId: userId).labels.compactMap { $0 as? String }
        labels.append(labelsSubscriber)
        try await users.updateLabels(userId: userId, labels: labels)
    }
}
