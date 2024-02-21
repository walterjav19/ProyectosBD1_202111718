const express=require('express');
const cors=require('cors');
const morgan=require('morgan');

const app=express();


var corsOptions={
    origin:'*',
}

//middlewares
app.use(morgan('dev'));
app.use(express.json());
app.use(cors(corsOptions));


//Default route
app.use((req,res,next)=>{
    res.status(404).json({
        message:'Not found'
});
})






module.exports=app;