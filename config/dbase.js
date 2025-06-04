//Defining and exporting the connection
const mongoose=require('mongoose');
const connection=mongoose.connect(`${process.env.DB_URL}`);
connection.then(()=>{
    console.log('Connected to database successfully');
}).catch((error)=>{
    console.log(`Failed to connect to database ${error}`);
});
module.exports=connection;