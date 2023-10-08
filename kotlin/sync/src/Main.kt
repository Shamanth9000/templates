throwIfMissing(process.env, [
    'APPWRITE_API_KEY',
    'APPWRITE_DATABASE_ID',
    'APPWRITE_COLLECTION_ID',
    'MEILISEARCH_ENDPOINT',
    'MEILISEARCH_INDEX_NAME',
    'MEILISEARCH_ADMIN_API_KEY',
    'MEILISEARCH_SEARCH_API_KEY',
  ]);

  if (req.method === 'GET') {
    const html = interpolate(getStaticFile('index.html'), {
      MEILISEARCH_ENDPOINT: process.env.MEILISEARCH_ENDPOINT,
      MEILISEARCH_INDEX_NAME: process.env.MEILISEARCH_INDEX_NAME,
      MEILISEARCH_SEARCH_API_KEY: process.env.MEILISEARCH_SEARCH_API_KEY,
    });

    return res.send(html, 200, { 'Content-Type': 'text/html; charset=utf-8' });
  }

  const client = new Client()
    .setEndpoint(
      process.env.APPWRITE_ENDPOINT ?? 'https://cloud.appwrite.io/v1'
    )
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

  const databases = new Databases(client);

  const meilisearch = new MeiliSearch({
    host: process.env.MEILISEARCH_ENDPOINT,
    apiKey: process.env.MEILISEARCH_ADMIN_API_KEY,
  });

  const index = meilisearch.index(process.env.MEILISEARCH_INDEX_NAME);

  let cursor = null;

  do {
    const queries = [Query.limit(100)];

    if (cursor) {
      queries.push(Query.cursorAfter(cursor));
    }

    const { documents } = await databases.listDocuments(
      process.env.APPWRITE_DATABASE_ID,
      process.env.APPWRITE_COLLECTION_ID,
      queries
    );

    if (documents.length > 0) {
      cursor = documents[documents.length - 1].$id;
    } else {
      log(`No more documents found.`);
      cursor = null;
      break;
    }

    log(`Syncing chunk of ${documents.length} documents ...`);
    await index.addDocuments(documents, { primaryKey: '$id' });
  } while (cursor !== null);

  log('Sync finished.');

  return res.send('Sync finished.', 200);

  package io.openruntimes.kotlin.src

import io.openruntimes.kotlin.RuntimeContext
import io.openruntimes.kotlin.RuntimeOutput
import io.appwrite.Client
import java.util.HashMap

class Main {
    // This is your Appwrite function
    // It's executed each time we get a request
    fun main(context: RuntimeContext): RuntimeOutput {
        // Why not try the Appwrite SDK?
        // val client = Client().apply {
        //    setEndpoint("https://cloud.appwrite.io/v1")
        //    setProject(System.getenv("APPWRITE_FUNCTION_PROJECT_ID"))
        //    setKey(System.getenv("APPWRITE_API_KEY"))
        // }

        // You can log messages to the console
        context.log("Hello, Logs!")

        // If something goes wrong, log an error
        context.error("Hello, Errors!")

        // The `context.req` object contains the request data
        if (context.req.method == "GET") {
            // Send a response with the res object helpers
            // `context.res.send()` dispatches a string back to the client
            return context.res.send("Hello, World!")
        }

        // `context.res.json()` is a handy helper for sending JSON
        return context.res.json(mutableMapOf(
            "motto" to "Build Fast. Scale Big. All in One Place.",
            "learn" to "https://appwrite.io/docs",
            "connect" to "https://appwrite.io/discord",
            "getInspired" to "https://builtwith.appwrite.io"
        ))
    }
}
