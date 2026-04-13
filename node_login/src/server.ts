import http from 'http';

const app = require('./app');
require('dotenv').config();

const port = process.env.PORT || 3000;
const server = http.createServer(app);

server.listen(port, () => console.log(`Running on port ${port} ${process.env.DOMAIN_NAME}`))