const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 8080;
const SERVER_IP = '0.0.0.0';

// Update CORS configuration
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST'],
    allowedHeaders: ['Content-Type']
}));

app.use(bodyParser.json());
app.use(express.static('public'));

let timerData = { 
    time: 0,
    timeRemaining: 0,
    isRunning: false 
};

app.get('/', (req, res) => {
    res.sendFile('index.html', { root: './public' });
});

app.get('/timer-stream', (req, res) => {
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    const sendTimer = () => {
        res.write(`data: ${JSON.stringify({ timeRemaining: `${timerData.time} seconds` })}\n\n`);
    };

    sendTimer();
    const intervalId = setInterval(sendTimer, 1000);

    req.on('close', () => {
        clearInterval(intervalId);
    });
});

app.post('/set-timer', async (req, res) => {
    try {
        const { time } = req.body;
        if (!time || isNaN(time) || time < 0) {
            return res.status(400).json({ error: 'Invalid time value' });
        }
        
        if (timerInterval) {
            clearInterval(timerInterval);
        }
        
        timerData.time = parseInt(time);
        timerData.timeRemaining = parseInt(time);
        timerData.isRunning = true;
        
        console.log(`\nTimer Started: ${time} seconds`);
        startCountdown();
        
        res.json({ 
            message: 'ok', 
            time: timerData.time,
            timeRemaining: timerData.timeRemaining 
        });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

function startCountdown() {
    timerInterval = setInterval(() => {
        if (timerData.timeRemaining > 0) {
            timerData.timeRemaining--;
            console.clear();
            console.log(`Time Remaining: ${timerData.timeRemaining} seconds`);
            
            // Send update to any connected clients
            if (timerData.timeRemaining === 0) {
                timerData.isRunning = false;
                clearInterval(timerInterval);
                console.log('Timer Complete!');
            }
        }
    }, 1000);
}

// Add endpoint to get current timer status
app.get('/timer-status', (req, res) => {
    res.json({
        initialTime: timerData.time,
        timeRemaining: timerData.timeRemaining,
        isRunning: timerData.isRunning
    });
});

app.get('/get-timer', (req, res) => {
    res.json(timerData);
});

app.listen(PORT, SERVER_IP, () => {
    console.log(`Server running on port ${PORT}`);
});
