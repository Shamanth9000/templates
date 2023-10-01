import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

export function throwIfMissing(obj: any, keys: string[]) {
    const missing: string[] = [];
    for (let key of keys) {
        if (!(key in obj) || !obj[key]) {
            missing.push(key);
        }
    }
    if (missing.length > 0) {
        throw new Error(`Missing required fields: ${missing.join(', ')}`);
    }
}

const __filename: string = fileURLToPath(import.meta.url);
const __dirname: string = path.dirname(__filename);
const staticFolder: string = path.join(__dirname, '../static');

export function getStaticFile(fileName: string): string {
    return fs.readFileSync(path.join(staticFolder, fileName)).toString();
}
