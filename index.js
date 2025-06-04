const app=require('./app');
const dbase=require('./config/dbase');
const userModel=require('./models/model_user');
const port=process.env.PORT;
//Default route
app.get('/',(request,response)=>{
    response.send('Response sent successfully');
});
//Server start
app.listen(port,()=>{
console.log(`Listening on port`);}
);