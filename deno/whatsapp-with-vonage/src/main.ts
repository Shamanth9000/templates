// This is your Appwrite function
// It's executed each time we get a request
export default async ({ req, res, log, error }: any) => {
    // Why not try the Appwrite SDK?
    //
    // const client = new Client()
    //    .setEndpoint('https://cloud.appwrite.io/v1')
    //    .setProject(Deno.env.get("APPWRITE_FUNCTION_PROJECT_ID"))
    //    .setKey(Deno.env.get("APPWRITE_API_KEY"));

    const s = Deno.env.toObject();
    log(s);

    // You can log messages to the console
    log("Hello, Logs!");

    // If something goes wrong, log an error
    error("Hello, Errors!");

    // The `req` object contains the request data
    if (req.method === "GET") {
        // Send a response with the res object helpers
        // `res.send()` dispatches a string back to the client
        return res.send("Hello, World!");
    }

    // `res.json()` is a handy helper for sending JSON
    return res.json({
        motto: "Build Fast. Scale Big. All in One Place.",
        learn: "https://appwrite.io/docs",
        connect: "https://appwrite.io/discord",
        getInspired: "https://builtwith.appwrite.io",
    });
};
