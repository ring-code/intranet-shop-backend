import https from 'https';
import fs from 'fs';
import { app } from './index.js';
import 'dotenv/config';

// load self-signed certificate and key
const privateKey = fs.readFileSync('/etc/ssl/private/myserver.key', 'utf8');
const certificate = fs.readFileSync('/etc/ssl/certs/myserver.crt', 'utf8');
const credentials = { key: privateKey, cert: certificate };


// start https server
https.createServer(credentials, app).listen(process.env.PORT, () => {
    console.log(`HTTPS server running on https://fi.mshome.net:${process.env.PORT}`);
});