// search.js

const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

// Initialize the app
const app = express();
app.use(bodyParser.json());
app.use(cors());

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/jobDatabase', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const db = mongoose.connection;
db.on('error', console.error.bind(console, 'Connection error:'));
db.once('open', () => {
  console.log('Connected to MongoDB');
});

// Define the Job Schema
const jobSchema = new mongoose.Schema({
  Job_ID: String,
  Provider: String,
  Status: String,
  Slug: String,
  Title: String,
  Position: String,
  Company: String,
  City: String,
  State_Name: String,
  State_Code: String,
});

// Create the Job Model
const Job = mongoose.model('Job', jobSchema, 'Combined_Jobs_Final');

// Search API Endpoint
app.get('/api/search', async (req, res) => {
  try {
    const { title, company, city, state } = req.query;

    // Build query dynamically based on available parameters
    let query = {};
    if (title) query.Title = new RegExp(title, 'i'); // Case-insensitive regex match
    if (company) query.Company = new RegExp(company, 'i');
    if (city) query.City = new RegExp(city, 'i');
    if (state) query.State_Name = new RegExp(state, 'i');

    // Perform the search
    const jobs = await Job.find(query);
    res.json(jobs);
  } catch (error) {
    console.error('Error fetching jobs:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
