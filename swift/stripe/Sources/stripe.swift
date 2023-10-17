import Foundation
import AsyncHTTPClient
import NIOCore
import StripeKit

class StripeService {
    private let client: StripeClient

    init() {
        client = StripeClient(
            httpClient: HTTPClient(eventLoopGroupProvider: .singleton), apiKey: ProcessInfo.processInfo.environment["STRIPE_SECRET_KEY"]!)
    }

    func checkoutSubscription(context: RuntimeContext, userId: String, successUrl: String, failureUrl: String) async throws -> Session? {
        let lineItem: [String: Any] = [
            "price_data": [
                "unit_amount": 1000, // $10.00
                "currency": "usd",
                "recurring": [
                    "interval": "month"
                ],
                "product_data": [
                    "name": "Premium Subscription"
                ]
            ],
            "quantity": 1
        ]

        do {
            return try await client.sessions.create(
                lineItems: [lineItem],
                mode: .subscription
                successUrl: successUrl,
                cancelUrl: failureUrl,
                clientReferenceID: userId,
                paymentMethodTypes: ["card"],
                subscriptionData: [
                    "metadata": [
                        "userId": userId,
                    ],
                ],
            )
        } catch {
            context.error(error)
            return nil
        }
    }
}
