const mongoose=require('mongoose');
const{Schema}=mongoose;
//Defining news schema with properties
const newsSchema=new Schema({
title:String,
source:String,
description:String,
country:String,
date:{type:Date,default:Date.now}
},{collection:'newsModel'});
//Defining and exporting the news model
const newsModel=mongoose.model('newsModel',newsSchema);
module.exports=newsModel;