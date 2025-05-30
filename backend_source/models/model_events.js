const mongoose=require('mongoose');
const{Schema}=mongoose;
//Defining events schema with properties
const eventSchema=new Schema({
    title:String,
    description:String,
    location:String,
    creator:String,
    eventLink:String,
    date:{type:Date,default:Date.now}
},{collection:'eventsModel'});
//Defining and exporting the events model
const eventsModel=mongoose.model('eventsModel',eventSchema);
module.exports=eventsModel;