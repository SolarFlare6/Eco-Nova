//Defining the app, using needed:routes,modules; and exporting the app
require('dotenv').config();
const express=require('express');
const userRoute=require('./routes/route_user');
const airRoute=require('./routes/route_airInfo');
const eventsRoute=require('./routes/route_events');
const app=express();
app.use(express.json());
app.use('/',userRoute);
app.use('/',airRoute);
app.use('/',eventsRoute);
module.exports=app;