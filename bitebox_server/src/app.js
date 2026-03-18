const express = require('express');
const cors= require('cors');
require('dotenv').config();

//import database connection
const db=require ('./config/db');

//import menu routes
const menuRoutes= require('./routes/menuRoutes');

const app=express();

//create the middle ware
app.use(cors()); //allows flutter app to talk
app.use(express.json()); //allows server to prase the json file

//routes for the menu
console.log('Checking menuRoutes:', menuRoutes);
app.use('/api/menu', menuRoutes);

// api get request
app.get('/',(req,res)=>{
    res.send('api running');
})

const PORT= process.env.PORT || 3000;

app.listen(PORT, ()=>{
    console.log(`\n Server is sprinting on http://localhost:${PORT}`);
    console.log(`📂 Menu API: http://localhost:${PORT}/api/menu\n`);
})




