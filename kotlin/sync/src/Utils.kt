package io.openruntimes.kotlin.src

fun throwIfMissing(obj: Map<String, String>, keys: List<String>) {
    val missing: List<String> = keys.filter { key -> !obj.containsKey(key) || obj[key] == null }
    if (missing.isNotEmpty()) {
        throw Error("Missing required fields: ${missing.joinToString(", ")}")
    }
}