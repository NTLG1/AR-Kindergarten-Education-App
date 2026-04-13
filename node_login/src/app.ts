import express, { Application, Router, Request, Response, NextFunction } from 'express';
const app: Application = express();
const cookieParser = require('cookie-parser');
const { checkUser, requireUser } = require('./middleware/auth_middleware');
   
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.set('views', './src/views');
app.set('view engine', 'ejs');

app.post('*', checkUser);
app.get('*', checkUser);

const authRoutes: Router = require('./routes/auth_routes');
const dataRoutes: Router = require('./routes/data_routes');

app.use('/auth', authRoutes);
app.use('/data', requireUser, dataRoutes);

// app.get('/', (req: Request, res: Response, next: NextFunction) => {
//     res.status(200).json({sucess: "Hello Server"});
// });

// // SELECT * FROM `Data`;
// const connection = require("./helpers/mysql_pools")
// app.get('/getData', (req: Request, res: Response, next: NextFunction) => {
//     const query = 'SELECT * FROM Data';
//     connection.query(query, (err: any, result: any) => {
//         if (err) {
//             res.status(500).json({err: err});
//             return
//         } else if (result) {
//             res.status(200).json({sucess: result});
//             return
//         }
//     })
// });

module.exports = app;