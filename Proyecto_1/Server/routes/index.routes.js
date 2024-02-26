const express = require('express');
const router = express.Router();


//Imports controller
const indexController = require('../controller/index.controller.js')

router.get("/",indexController.index)
router.get("/crearmodelo", indexController.CreateModel)
router.get("/eliminarmodelo", indexController.DeleteModel)
router.get("/cargarmodelo",indexController.CargaDatos)
router.get("/borrarinfodb",indexController.BorrarInfo)
router.get("/consulta1",indexController.Consulta1)

module.exports=router;