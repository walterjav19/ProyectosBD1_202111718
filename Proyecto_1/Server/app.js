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




const indexRoutes = require("./routes/index.routes.js")


//request
app.use("/",indexRoutes)
app.use("/crearmodelo", indexRoutes);


//Default route
app.use((req,res,next)=>{
    res.status(404).json({
        message:'Request Not found'
});
})






module.exports=app;