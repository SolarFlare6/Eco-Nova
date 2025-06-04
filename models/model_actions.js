//Actions model
const mongoose=require('mongoose');
const{Schema}=mongoose;
const actionSchema=new Schema({
    actionName:{type:String,required:true},
    actionPoints:{type:Number,required:true}
});
const actionModel=mongoose.model('actionModel',actionSchema);
module.exports=actionModel;