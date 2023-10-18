import Foundation
import AsyncHTTPClient
import NIOCore
import StripeKit

class StripeService {
    private let client: StripeClient

    init() {
        client = StripeClient(
            httpClient: HTTPClient(eventLoopGroupProvider: .createNew), apiKey: ProcessInfo.processInfo.environment["STRIPE_SECRET_KEY"]!)
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
                mode: .subscription,
                successUrl: successUrl,
                cancelUrl: failureUrl,
                clientReferenceId: userId,
                currency: nil,
                customer: nil,
                customerEmail: nil,
                metadata: nil,
                afterExpiration: nil,
                allowPromotionCodes: nil,
                automaticTax: nil,
                billingAddressCollection: nil,
                consentCollection: nil,
                customFields: nil,
                customText: nil,
                customerCreation: nil,
                customerUpdate: nil,
                discounts: nil,
                expiresAt: nil,
                invoiceCreation: nil,
                locale: nil,
                paymentIntentData: nil,
                paymentMethodCollection: nil,
                paymentMethodOptions: nil,
                paymentMethodTypes: ["card"],
                phoneNumberCollection: nil,
                setupIntentData: nil,
                shippingAddressCollection: nil,
                shippingOptions: nil,
                submitType: nil,
                subscriptionData: [
                    "metadata": [
                        "userId": userId,
                    ],
                ],
                taxIdCollection: nil,
                expand: nil
            )
        } catch {
            context.error(error)
            return nil
        }
    }
}
