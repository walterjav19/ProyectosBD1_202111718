const index = (req, res) =>{
    res.status(200).json({message: 'Api Funcionando'});
}


//peticion 12
const CreateModel = (req, res) =>{
    res.status(200).json({message: 'Modelo Creado'});
}


module.exports={
    index,
    CreateModel
}