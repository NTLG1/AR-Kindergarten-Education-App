import express, {Router, Request, Response, NextFunction} from 'express';
const router: Router = express.Router();
const data_functions = require('../functions/data_functions')

router.post('/set-data', async (req: Request, res: Response, next: NextFunction) => {
    const data: string = req.body.data;
    const email: string | undefined = req.app.locals.user.email;

    if (typeof data !== 'string') {
        res.status(500).json({error: 'The data must be a string.'});
        return;
    }

    if (email === undefined) {
        res.status(500).json({error: 'You must sign in to do that'});
        return;
    }

    try {
        await data_functions.saveData(email, data);
        res.status(200).json({success: 'The data was submitted.'});
    } catch(err) {
        res.status(500).json({error: err});
        return;
    }
});

router.get('/get-data', async (req: Request, res: Response, next: NextFunction) => {
    const email: string | undefined = req.app.locals.user.email;

    if (email === undefined) {
        res.status(500).json({error: 'You must sign in to do that'});
        return;
    }

    try {
        const dataArray = await data_functions.getData(email);
        res.status(200).json({data: dataArray});
    } catch(err) {
        res.status(500).json({error: err});
        return;
    }
})
module.exports = router;

// import express, { Router, Request, Response, NextFunction } from 'express';
// const router: Router = express.Router();
// const data_functions = require('../functions/data_functions')

// // Route to save progress data
// router.post('/set-progress', async (req: Request, res: Response, next: NextFunction) => {
//     const { entity_type, entity_id, progress, completed } = req.body;
//     const email: string | undefined = req.app.locals.user.email;

//     if (!entity_type || !entity_id || progress === undefined || completed === undefined) {
//         res.status(400).json({ error: 'Missing required fields.' });
//         return;
//     }

//     if (email === undefined) {
//         res.status(401).json({ error: 'You must sign in to track progress.' });
//         return;
//     }

//     try {
//         await data_functions.saveProgress(email, entity_type, entity_id, progress, completed);
//         res.status(200).json({ success: 'Progress saved successfully.' });
//     } catch (err) {
//         res.status(500).json({ error: err });
//     }
// });

// // Route to get progress data for a user
// router.get('/get-progress', async (req: Request, res: Response, next: NextFunction) => {
//     const email: string | undefined = req.app.locals.user.email;

//     if (email === undefined) {
//         res.status(401).json({ error: 'You must sign in to view progress.' });
//         return;
//     }

//     try {
//         const progressData = await data_functions.getProgress(email);
//         res.status(200).json({ data: progressData });
//     } catch (err) {
//         res.status(500).json({ error: err });
//     }
// });

// // Route to get all data from Objects, Videos, and Books tables
// router.get('/get-data', async (req: Request, res: Response, next: NextFunction) => {
//     // Check if the user is logged in by checking for the user's email in app locals
//     const email: string | undefined = req.app.locals.user?.email;

//     // If no email is found, return an error
//     if (!email) {
//         res.status(401).json({ error: 'You must sign in to do that' });
//         return;
//     }

//     try {
//         // Fetch all data (Objects, Videos, Books) from the database
//         const data = await data_functions.getAllData();
//         res.status(200).json({ data });
//     } catch (err) {
//         // Handle any errors that occur during data fetching
//         res.status(500).json({ error: err });
//     }
// });

// module.exports = router;
