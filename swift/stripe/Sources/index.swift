import Foundation

func main(context: RuntimeContext) async throws -> RuntimeOutput {
    // Why not try the Appwrite SDK?
    //
    // let client = Client()
    //    .setEndpoint("https://cloud.appwrite.io/v1")
    //    .setProject(ProcessInfo.processInfo.environment["APPWRITE_FUNCTION_PROJECT_ID"])
    //    .setKey(ProcessInfo.processInfo.environment["APPWRITE_API_KEY"]);

    try throwIfMissing(
        ProcessInfo.processInfo.environment,
        [
            "STRIPE_SECRET_KEY",
            "STRIPE_WEBHOOK_SECRET",
            "APPWRITE_API_KEY",
        ])

    // You can log messages to the console
    context.log("Hello, Logs!")

    // If something goes wrong, log an error
    context.error("Hello, Errors!")

    let appwriteService = AppwriteService()
    let stripeService = StripeService()

    // The `context.req` object contains the request data
    if context.req.method == "GET" {
        // Send a response with the res object helpers
        // `res.send()` dispatches a string back to the client
        return try context.res.send("Hello, World!")
    }

    // `context.res.json()` is a handy helper for sending JSON
    return try context.res.json([
        "motto": "Build like a team of hundreds_",
        "learn": "https://appwrite.io/docs",
        "connect": "https://appwrite.io/discord",
        "getInspired": "https://builtwith.appwrite.io",
    ])
}