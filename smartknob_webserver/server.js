const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 8080;

app.use(cors());
app.use(bodyParser.json());

let timerData = { time: 0 };

app.post('/set-timer', (req, res) => {
    const { time } = req.body;
    if (!time || isNaN(time)) {
        return res.status(400).json({ error: 'Invalid time value' });
    }
    timerData.time = time;
    console.log(`Timer set to ${time} seconds`);
    res.json({ message: 'Timer received', time });
});

app.get('/get-timer', (req, res) => {
    res.json(timerData);
});

app.listen(PORT, () => {
    console.log(`Server running on http://192.168.1.4:${PORT}`);
});

// Function to get local IP for LAN devices (like your phone)
function getLocalIP() {
    const os = require('os');
    const interfaces = os.networkInterfaces();
    for (let iface in interfaces) {
        for (let details of interfaces[iface]) {
            if (details.family === 'IPv4' && !details.internal) {
                return details.address;
            }
        }
    }
    return '127.0.0.1';
}
