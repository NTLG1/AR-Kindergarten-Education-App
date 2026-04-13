const connection = require('../helpers/mysql_pools');
import { MysqlError, OkPacket } from "mysql";

const saveData = async function saveData(email: string, data: string): Promise<null> {
    return new Promise<null>(((resolve, reject) => {
        const query = "INSERT INTO Data SET ?";
        const insertData = {
            email: email,
            data: data
        }

        connection.query(query, insertData, (err: MysqlError | null, result: OkPacket | null) => {
            if (err != null) {
                reject(err.message);
                return;
            }

            if (result != null) {
                if (result.affectedRows == 1) {
                    resolve(null);
                    return;
                } else {
                    reject('Unknown error 1 saving data to database.');
                }
            } else {
                reject('Unknown error 2 saving data to database.');
                return;
            }

        })
    }));
    
};

const getData = async function saveData(email: string, data: string): Promise<string[]> {
    return new Promise<string[]>(((resolve, reject) => {
        const query = "SELECT * FROM Data WHERE email=" + connection.escape(email);

        connection.query(query, (err: MysqlError | null, results: any[]) => {
            if (err != null) {
                reject(err.message);
                return;
            }
            console.log('results:', results);

            const dataArray: string[] = []

            for (let result of results) {
                console.log('results:', result);

                if (result?.data) {
                    dataArray.push(result.data)
                }
            }
            resolve(dataArray);
            return;
        });
    }));
    
};

module.exports = {
    saveData: saveData, 
    getData: getData,
}

// const connection = require('../helpers/mysql_pools');
// import { MysqlError, OkPacket } from "mysql";

// // Function to save user progress
// const saveProgress = async function saveProgress(email: string, entity_type: string, entity_id: number, progress: number, completed: boolean): Promise<null> {
//     return new Promise<null>((resolve, reject) => {
//         const query = `
//             INSERT INTO ProgressTracking (email, entity_type, entity_id, progress, completed, last_updated) 
//             VALUES (?, ?, ?, ?, ?, NOW())
//             ON DUPLICATE KEY UPDATE progress = ?, completed = ?, last_updated = NOW()
//         `;
//         const values = [email, entity_type, entity_id, progress, completed, progress, completed];

//         connection.query(query, values, (err: MysqlError | null, result: OkPacket | null) => {
//             if (err) {
//                 reject(err.message);
//                 return;
//             }
//             if (result && result.affectedRows > 0) {
//                 resolve(null);
//             } else {
//                 reject('Error saving progress to database.');
//             }
//         });
//     });
// };

// // Function to get progress
// const getProgress = async function getProgress(email: string): Promise<any[]> {
//     return new Promise<any[]>((resolve, reject) => {
//         const query = `
//             SELECT pt.entity_type, pt.entity_id, pt.progress, pt.completed, pt.last_updated, 
//                    u.username,
//                    CASE 
//                         WHEN pt.entity_type = 'object' THEN o.name
//                         WHEN pt.entity_type = 'video' THEN v.title
//                         WHEN pt.entity_type = 'book' THEN b.title
//                    END AS entity_name,
//                    CASE 
//                         WHEN pt.entity_type = 'object' THEN o.description
//                         WHEN pt.entity_type = 'video' THEN v.duration
//                         WHEN pt.entity_type = 'book' THEN b.author
//                    END AS entity_detail,
//                    CASE 
//                         WHEN pt.entity_type = 'object' THEN o.category
//                         WHEN pt.entity_type = 'video' THEN v.category
//                         WHEN pt.entity_type = 'book' THEN b.pages
//                    END AS unique_field
//             FROM ProgressTracking pt
//             JOIN Users u ON pt.email = u.email
//             LEFT JOIN Objects o ON pt.entity_type = 'object' AND pt.entity_id = o.object_id
//             LEFT JOIN Videos v ON pt.entity_type = 'video' AND pt.entity_id = v.video_id
//             LEFT JOIN Books b ON pt.entity_type = 'book' AND pt.entity_id = b.book_id
//             WHERE pt.email = ?
//         `;

//         connection.query(query, [email], (err: MysqlError | null, results: any[]) => {
//             if (err) {
//                 reject(err.message);
//                 return;
//             }

//             const progressData: any[] = results.map(result => ({
//                 entity_type: result.entity_type,
//                 entity_id: result.entity_id,
//                 progress: result.progress,
//                 completed: result.completed,
//                 last_updated: result.last_updated,
//                 username: result.username,
//                 entity_name: result.entity_name,
//                 entity_detail: result.entity_detail,
//                 unique_field: result.unique_field
//             }));

//             resolve(progressData);
//         });
//     });
// };

// // Function to fetch all data from Objects, Videos, and Books tables
// const getAllData = async function getAllData(): Promise<any> {
//     return new Promise<any>((resolve, reject) => {
//         const query = `
//             SELECT 'object' AS entity_type, o.object_id AS entity_id, o.name AS entity_name, o.description AS entity_detail, o.category AS unique_field
//             FROM Objects o
//             UNION ALL
//             SELECT 'video' AS entity_type, v.video_id AS entity_id, v.title AS entity_name, v.duration AS entity_detail, v.category AS unique_field
//             FROM Videos v
//             UNION ALL
//             SELECT 'book' AS entity_type, b.book_id AS entity_id, b.title AS entity_name, b.author AS entity_detail, b.pages AS unique_field
//             FROM Books b
//         `;

//         connection.query(query, (err: MysqlError | null, results: any[]) => {
//             if (err) {
//                 reject(err.message);
//                 return;
//             }

//             const allData = results.map(result => ({
//                 entity_type: result.entity_type,
//                 entity_id: result.entity_id,
//                 entity_name: result.entity_name,
//                 entity_detail: result.entity_detail,
//                 unique_field: result.unique_field
//             }));

//             resolve(allData);
//         });
//     });
// };

// module.exports = {
//     saveProgress,
//     getProgress,
//     getAllData,
// };
