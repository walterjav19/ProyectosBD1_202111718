const express = require('express');
const router = express.Router();


//Imports controller
const indexController = require('../controller/index.controller.js')

router.get("/",indexController.index)
router.get("/crearmodelo", indexController.CreateModel)

module.exports=router;