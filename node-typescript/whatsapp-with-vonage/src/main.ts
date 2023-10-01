import { throwIfMissing } from './utils.js';
import jwt, { JwtPayload } from 'jsonwebtoken';
import sha256 from 'sha256';
import { fetch } from 'undici';

type Context = {
    req: any;
    res: any;
    log: (msg: any) => void;
    error: (msg: any) => void;
};

export default async ({ req, res, log, error }: Context) => {
    throwIfMissing(process.env, [
        'VONAGE_API_KEY',
        'VONAGE_ACCOUNT_SECRET',
        'VONAGE_SIGNATURE_SECRET',
        'VONAGE_WHATSAPP_NUMBER',
    ]);

    log(req);
    const token = (req.headers.authorization ?? '').split(' ')[1];
    const decoded = jwt.verify(token, process.env.VONAGE_SIGNATURE_SECRET, {
        algorithms: ['HS256'],
    });

    throwIfMissing(decoded, ['payload_hash']);

    if (sha256(req.bodyRaw) !== (decoded as JwtPayload).payload_hash) {
        return res.json({ ok: false, error: 'Payload hash mismatch.' }, 401);
    }

    try {
        throwIfMissing(req.body, ['from', 'text']);
    } catch (err) {
        if (err instanceof Error)
            return res.json({ ok: false, error: err.message }, 400);
    }

    const basicAuthToken = btoa(
        `${process.env.VONAGE_API_KEY}:${process.env.VONAGE_ACCOUNT_SECRET}`
    );
    await fetch(`https://messages-sandbox.nexmo.com/v1/messages`, {
        method: 'POST',
        body: JSON.stringify({
            from: process.env.VONAGE_WHATSAPP_NUMBER,
            to: req.body.from,
            message_type: 'text',
            text: `Hi there! You sent me: ${req.body.text}`,
            channel: 'whatsapp',
        }),
        headers: {
            'Content-Type': 'application/json',
            Authorization: `Basic ${basicAuthToken}`,
        },
    });

    return res.json({ ok: true });
};
