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
app.use("/eliminarmodelo", indexRoutes);
app.use("/cargarmodelo",indexRoutes);
app.use("/borrarinfodb",indexRoutes);
app.use("/consulta1",indexRoutes);
app.use("/consulta2",indexRoutes);
app.use("/consulta3",indexRoutes);
app.use("/consulta4",indexRoutes)
app.use("/consulta5",indexRoutes)
app.use("/consulta6",indexRoutes)
app.use("/consulta7",indexRoutes)

//Default route
app.use((req,res,next)=>{
    res.status(404).json({
        message:'Request Not found'
});
})






module.exports=app;