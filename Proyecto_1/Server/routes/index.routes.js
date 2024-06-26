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
router.get("/consulta2",indexController.Consulta2)
router.get("/consulta3",indexController.Consulta3)
router.get("/consulta4",indexController.Consulta4)
router.get("/consulta5",indexController.Consulta5)
router.get("/consulta6",indexController.Consulta6)
router.get("/consulta7",indexController.Consulta7)
router.get("/consulta8",indexController.Consulta8)
router.get("/consulta9",indexController.Consulta9)
router.get("/consulta10",indexController.Consulta10)
module.exports=router;